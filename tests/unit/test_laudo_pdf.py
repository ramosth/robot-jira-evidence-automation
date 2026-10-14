"""
Testes da biblioteca LaudoPDF com um laudo FICTÍCIO gerado na hora
(reportlab), sem depender da aplicação.

Rodar com:  pytest tests/unit -v
"""

import os
import sys
from datetime import datetime, timedelta

import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "libraries")))
from LaudoPDF import LaudoPDF  # noqa: E402

reportlab = pytest.importorskip("reportlab.pdfgen.canvas")

BASES = ["Base Nacional", "Base Estadual", "Base Nacional R/F", "SNG", "Base de Leilões"]


def gerar_laudo(caminho, emissao, gravame="Não", bloqueio="[ ] Administrativa [x] Tributária [ ] Judicial [ ] Nada consta"):
    """Gera um PDF de 2 páginas no mesmo formato de texto do laudo real."""
    data, hora = emissao.strftime("%d/%m/%Y"), emissao.strftime("%H:%M:%S")
    rodape = "Consultas: " + " | ".join(f"{b} {data} {hora}" for b in BASES)
    paginas = [
        ["TERMO DE AVALIAÇÃO DE VEÍCULO", "Proposta/Contrato: 123456",
         "Dados do Cliente", "Nome/Razão Social: Cliente Exemplo",
         "Dados do Veículo", "Placa: TST2B01 | UF Placa: SP",
         "Avaliação",
         "Multas Vencidas: 3.33 | IPVAs vencidos: R$ 1.234,56",
         "DPVATs vencidos: 0 | Licenciamentos vencidos: Nada consta",
         "Restrição por roubo/furto: Nada consta",
         f"Bloqueio por restrição: {bloqueio}",
         "RENAJUD: N", f"Gravame ativo: {gravame}",
         "Agente financeiro: Banco Exemplo | CNPJ: 00.000.000/0001-00" if gravame == "Sim" else "Agente financeiro: | CNPJ:",
         f"Data da inclusão: {data}" if gravame == "Sim" else "Data da inclusão:",
         rodape],
        ["TERMO DE AVALIAÇÃO DE VEÍCULO", "Proposta/Contrato: 123456",
         "Estado do Veículo", "Lataria: Conservado",
         f"Data | Hora Emissão: {data} | {hora}", rodape],
    ]
    c = reportlab.Canvas(str(caminho))
    for linhas in paginas:
        y = 800
        for linha in linhas:
            c.drawString(30, y, linha)
            y -= 18
        c.showPage()
    c.save()
    return caminho


@pytest.fixture
def lib():
    return LaudoPDF()


@pytest.fixture
def texto(tmp_path, lib):
    return lib.extrair_texto(gerar_laudo(tmp_path / "laudo.pdf", datetime.now()))


def test_secoes_na_ordem(lib, texto):
    lib.secoes_em_ordem(texto, "Dados do Cliente", "Dados do Veículo", "Avaliação", "Estado do Veículo")


def test_secoes_fora_de_ordem_falham(lib, texto):
    with pytest.raises(AssertionError, match="fora de ordem"):
        lib.secoes_em_ordem(texto, "Avaliação", "Dados do Cliente")


def test_valor_de_campo_com_dois_campos_na_linha(lib, texto):
    assert lib.obter_valor_campo(texto, "Placa") == "TST2B01"
    assert lib.obter_valor_campo(texto, "UF Placa") == "SP"


def test_campo_com_complemento_no_rotulo(lib, texto):
    assert lib.obter_valor_campo(texto, "Restrição por roubo") == "Nada consta"


@pytest.mark.parametrize("campo", ["Multas Vencidas", "IPVAs vencidos", "DPVATs vencidos",
                                   "Licenciamentos vencidos", "RENAJUD", "Restrição por roubo",
                                   "Bloqueio por restrição", "Gravame ativo"])
def test_campos_de_debitos_consistentes(lib, texto, campo):
    lib.validar_campo_debito(texto, campo)


def test_gravame_esperado_booleano(lib, texto):
    lib.validar_campo_debito(texto, "Gravame ativo", False)
    with pytest.raises(AssertionError, match="esperado 'Sim'"):
        lib.validar_campo_debito(texto, "Gravame ativo", True)


def test_gravame_sim_exige_agente_financeiro(tmp_path, lib):
    pdf = gerar_laudo(tmp_path / "g.pdf", datetime.now(), gravame="Sim")
    lib.validar_campo_debito(lib.extrair_texto(pdf), "Gravame ativo", True)


def test_bloqueio_nada_consta_com_outra_opcao_falha(tmp_path, lib):
    pdf = gerar_laudo(tmp_path / "b.pdf", datetime.now(),
                      bloqueio="[ ] Administrativa [x] Tributária [ ] Judicial [x] Nada consta")
    with pytest.raises(AssertionError, match="Nada consta"):
        lib.validar_campo_debito(lib.extrair_texto(pdf), "Bloqueio por restrição")


def test_carimbo_recente_e_valido(lib, texto):
    assert lib.validar_carimbo(texto) <= datetime.now()


def test_carimbo_antigo_falha(tmp_path, lib):
    pdf = gerar_laudo(tmp_path / "a.pdf", datetime.now() - timedelta(days=2))
    with pytest.raises(AssertionError, match="fora da tolerância"):
        lib.validar_carimbo(lib.extrair_texto(pdf))


def test_bases_consultadas_no_rodape_de_todas_as_paginas(tmp_path, lib):
    pdf = gerar_laudo(tmp_path / "r.pdf", datetime.now())
    for pagina in lib.extrair_paginas(pdf):
        bases = lib.obter_bases_consultadas(pagina, *BASES)
        assert set(bases) == set(BASES)
