"""
Testes unitários das regras da integração com o Jira, sem acessar a rede
nem abrir navegador.

Rodar com:  pytest tests/unit -v
"""

import os
import time

import pytest

import add_comentario
import extrair_print


# ---------------------------------------------------------------- extrair_print

@pytest.mark.parametrize("nome, esperado", [
    ("Cenário: QA-308 (FRONT) Abrir modal", "QA-308"),
    ("QA-12 Login", "QA-12"),
    ("Cenário sem id", "Cenário_sem_id"),
])
def test_identificar_cenario(nome, esperado, monkeypatch):
    monkeypatch.setattr(extrair_print, "PROJECT_KEY", "QA")
    assert extrair_print.identificar_cenario(nome) == esperado


def test_falha_tem_prioridade_sobre_sucesso(tmp_path):
    """Se o mesmo ID passou e depois falhou, o print de sucesso é descartado."""
    print_sucesso = tmp_path / "QA-1.png"
    print_sucesso.write_bytes(b"png")
    processados = {"QA-1": "pass"}

    assert extrair_print.deve_capturar("QA-1", True, processados, str(tmp_path))
    assert not print_sucesso.exists()


def test_cenario_ja_reprovado_nao_e_recapturado(tmp_path):
    assert not extrair_print.deve_capturar("QA-1", False, {"QA-1": "fail"}, str(tmp_path))


# --------------------------------------------------------------- add_comentario

@pytest.mark.parametrize("status, resultado, esperado", [
    ("Automation", "success", "Ending"),
    ("AUTOMATION", "error", "Blocked"),
    ("In Progress", "success", None),   # fora da coluna de automação: não mexe
    (None, "error", None),
])
def test_decidir_transicao(status, resultado, esperado, monkeypatch):
    monkeypatch.setattr(add_comentario, "STATUS_AUTOMACAO", "Automation")
    monkeypatch.setattr(add_comentario, "TRANSICAO_APROVADO", "Ending")
    monkeypatch.setattr(add_comentario, "TRANSICAO_REPROVADO", "Blocked")
    assert add_comentario.decidir_transicao(status, resultado) == esperado


def test_busca_o_screenshot_mais_recente_do_card(tmp_path, monkeypatch):
    """Entre várias execuções no dia, a mais recente é a escolhida."""
    monkeypatch.setattr(add_comentario, "SCREENSHOTS_BASE_DIR", str(tmp_path))
    pasta = tmp_path / "screenshots 14-10-2026" / "VC-16"
    pasta.mkdir(parents=True)

    antigo = pasta / "QA-308 Abrir modal [ FALHA ] 10_00_00.png"
    recente = pasta / "QA-308 Abrir modal [ SUCESSO ] 11_00_00.png"
    outro = pasta / "QA-309 Outro cenário [ SUCESSO ] 12_00_00.png"
    for i, arquivo in enumerate([antigo, recente, outro]):
        arquivo.write_bytes(b"png")
        os.utime(arquivo, (time.time() + i, time.time() + i))

    encontrado = add_comentario.buscar_screenshot_mais_recente("QA-308", data="14-10-2026")
    assert encontrado == str(recente)


def test_sem_pasta_do_dia_retorna_none(tmp_path, monkeypatch):
    monkeypatch.setattr(add_comentario, "SCREENSHOTS_BASE_DIR", str(tmp_path))
    assert add_comentario.buscar_screenshot_mais_recente("QA-1", data="01-01-2000") is None
