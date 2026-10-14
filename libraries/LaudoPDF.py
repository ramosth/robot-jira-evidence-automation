"""
Biblioteca Robot Framework para ler e validar o laudo em PDF
(Termo de Avaliação de Veículo) baixado pela aplicação.

O PDF é convertido em texto com o pypdf e as validações são feitas sobre esse
texto, por isso funcionam independente do layout visual. Cada linha do laudo
segue o padrão "Rótulo: valor", às vezes com dois campos na mesma linha
separados por "|":

    Placa: TST2B01        | UF Placa: SP
    Multas Vencidas: 3.33 | IPVAs vencidos: 1.11
    Bloqueio por restrição: [ ] Administrativa [x] Tributária [x] Judicial [ ] Nada consta

Biblioteca criada na versão de portfólio para completar os passos de validação
do PDF usados pela feature VC-16.
"""

import re
from datetime import datetime, timedelta

from pypdf import PdfReader
from robot.api.deco import keyword, library

FORMATO_DATA_HORA = "%d/%m/%Y %H:%M:%S"


@library(scope="GLOBAL", auto_keywords=False)
class LaudoPDF:
    """Keywords de leitura e validação do conteúdo dos laudos em PDF."""

    # ------------------------------------------------------------------ leitura

    @keyword("Extrair Texto Do Laudo")
    def extrair_texto(self, caminho_pdf):
        """
        Retorna o texto de todas as páginas do PDF, uma página após a outra.

        Example:
        | ${texto}= | Extrair Texto Do Laudo | ${EXECDIR}/results/downloads/laudo-123.pdf |
        """
        return "\n".join(self.extrair_paginas(caminho_pdf))

    @keyword("Extrair Paginas Do Laudo")
    def extrair_paginas(self, caminho_pdf):
        """Retorna uma lista com o texto de cada página (útil para validar cabeçalho e rodapé)."""
        leitor = PdfReader(str(caminho_pdf))
        return [pagina.extract_text() or "" for pagina in leitor.pages]

    @keyword("Obter Valor Do Campo No Laudo")
    def obter_valor_campo(self, texto, campo):
        """
        Retorna o valor de um campo no formato "Rótulo: valor".

        O rótulo pode ter complemento antes dos dois pontos: buscar
        "Restrição por roubo" encontra "Restrição por roubo/furto: ...".
        O valor termina no fim da linha ou no separador " | ".

        Falha se o campo não existir no laudo.
        """
        padrao = re.compile(rf"{re.escape(campo)}[^:\n]*:[ \t]*(.*?)[ \t]*(?:\s\|\s|\n|$)", re.IGNORECASE)
        encontrado = padrao.search(texto)
        if not encontrado:
            raise AssertionError(f"Campo '{campo}' não encontrado no laudo.")
        return encontrado.group(1).strip()

    # --------------------------------------------------------------- validações

    @keyword("Laudo Deve Conter Os Textos")
    def deve_conter_textos(self, texto, *esperados):
        """Falha listando todos os textos esperados que não estão no laudo."""
        ausentes = [e for e in esperados if str(e).lower() not in texto.lower()]
        if ausentes:
            raise AssertionError(f"Textos ausentes no laudo: {', '.join(map(str, ausentes))}")

    @keyword("Secoes Do Laudo Devem Estar Na Ordem")
    def secoes_em_ordem(self, texto, *secoes):
        """
        Valida que as seções existem e aparecem na ordem informada.

        O título da seção precisa ocupar a linha inteira: assim "Avaliação"
        não é confundido com o cabeçalho "TERMO DE AVALIAÇÃO DE VEÍCULO".
        """
        posicoes, ausentes = [], []
        for secao in secoes:
            linha = re.search(rf"^[ \t]*{re.escape(secao)}[ \t]*$", texto, re.IGNORECASE | re.MULTILINE)
            if linha:
                posicoes.append(linha.start())
            else:
                ausentes.append(secao)
        if ausentes:
            raise AssertionError(f"Seções ausentes no laudo: {', '.join(ausentes)}")
        if posicoes != sorted(posicoes):
            raise AssertionError(f"Seções fora de ordem. Esperado: {' > '.join(secoes)}")

    @keyword("Validar Carimbo De Data E Hora Do Laudo")
    def validar_carimbo(self, texto, tolerancia_minutos=60):
        """
        Valida o carimbo "Data | Hora Emissão: DD/MM/AAAA | HH:MM:SS":
        - a data e a hora são válidas;
        - a emissão não está no futuro;
        - a emissão ocorreu nos últimos `tolerancia_minutos` (o laudo acabou de ser gerado).

        Retorna a data e hora da emissão (datetime).
        """
        encontrado = re.search(r"Emiss[ãa]o:\s*(\d{2}/\d{2}/\d{4})\s*\|\s*(\d{2}:\d{2}:\d{2})", texto)
        if not encontrado:
            raise AssertionError("Carimbo 'Data | Hora Emissão' não encontrado no laudo.")
        emissao = datetime.strptime(f"{encontrado.group(1)} {encontrado.group(2)}", FORMATO_DATA_HORA)

        agora = datetime.now()
        if emissao > agora + timedelta(minutes=1):
            raise AssertionError(f"Data de emissão no futuro: {emissao:%d/%m/%Y %H:%M:%S}")
        if agora - emissao > timedelta(minutes=int(tolerancia_minutos)):
            raise AssertionError(
                f"Emissão ({emissao:%d/%m/%Y %H:%M:%S}) fora da tolerância de {tolerancia_minutos} min."
            )
        return emissao

    @keyword("Obter Bases Consultadas Do Laudo")
    def obter_bases_consultadas(self, texto, *bases):
        """
        Lê o rodapé "Consultas: Base Nacional 22/08/2025 17:04:37 | Base Estadual ..."
        e retorna um dicionário {base: datetime da consulta}.
        Falha se alguma base esperada não tiver data e hora válidas.
        """
        texto_unico = re.sub(r"\s+", " ", texto)
        resultado, ausentes = {}, []
        # Ordena da maior para a menor para "Base Nacional R/F" não ser lida como "Base Nacional"
        for base in sorted(bases, key=len, reverse=True):
            padrao = rf"{re.escape(base)}\s+(\d{{2}}/\d{{2}}/\d{{4}} \d{{2}}:\d{{2}}:\d{{2}})"
            encontrado = re.search(padrao, texto_unico)
            if encontrado:
                resultado[base] = datetime.strptime(encontrado.group(1), FORMATO_DATA_HORA)
            else:
                ausentes.append(base)
        if ausentes:
            raise AssertionError(f"Bases sem data/hora de consulta no rodapé: {', '.join(ausentes)}")
        return resultado

    @keyword("Validar Campo De Debitos E Restricoes")
    def validar_campo_debito(self, texto, campo, esperado=None):
        """
        Valida a consistência de um campo da seção "Avaliação"
        (débitos pendentes e restrições). A regra depende do campo:

        | Campo | Regra |
        | Multas / IPVAs / DPVATs / Licenciamentos vencidos | valor numérico >= 0 |
        | RENAJUD | S ou N |
        | Gravame ativo | Sim ou Não. Com "Sim", Agente financeiro e Data da inclusão são obrigatórios |
        | Bloqueio por restrição | ao menos uma opção marcada; "Nada consta" não combina com outras |
        | Restrição por roubo | valor preenchido |

        `esperado` (opcional) compara o valor lido com o esperado. Para o
        Gravame, aceita ${True}/${False}.

        Retorna o valor lido.
        """
        valor = self.obter_valor_campo(texto, campo)
        nome = campo.lower()

        if "vencid" in nome:
            # Aceita "3.33", "R$ 1.234,56" ou "Nada consta"
            if valor.lower() != "nada consta":
                numero = valor.replace("R$", "").strip()
                if "," in numero:  # formato brasileiro: 1.234,56 -> 1234.56
                    numero = numero.replace(".", "").replace(",", ".")
                try:
                    convertido = float(numero)
                except ValueError as erro:
                    raise AssertionError(f"{campo} deveria ser numérico, mas é '{valor}'") from erro
                if convertido < 0:
                    raise AssertionError(f"{campo} negativo: {valor}")

        elif nome == "renajud":
            if valor.upper() not in ("S", "N"):
                raise AssertionError(f"RENAJUD deveria ser S ou N, mas é '{valor}'")

        elif nome.startswith("gravame"):
            if valor.lower() not in ("sim", "não", "nao"):
                raise AssertionError(f"Gravame ativo deveria ser Sim ou Não, mas é '{valor}'")
            if valor.lower() == "sim":
                for dependente in ("Agente financeiro", "Data da inclusão"):
                    if not self.obter_valor_campo(texto, dependente):
                        raise AssertionError(f"Gravame ativo = Sim, mas '{dependente}' está vazio.")
            if isinstance(esperado, bool):
                esperado = "Sim" if esperado else "Não"

        elif nome.startswith("bloqueio"):
            marcadas = re.findall(r"\[\s*[xX]\s*\]\s*([^\[]+)", valor)
            marcadas = [m.strip() for m in marcadas]
            if not marcadas:
                raise AssertionError("Bloqueio por restrição sem nenhuma opção marcada.")
            if "Nada consta" in marcadas and len(marcadas) > 1:
                raise AssertionError(f"'Nada consta' marcado junto com restrições: {marcadas}")

        elif not valor:
            raise AssertionError(f"Campo '{campo}' está vazio no laudo.")

        if esperado is not None and str(valor).lower() != str(esperado).lower():
            raise AssertionError(f"{campo}: esperado '{esperado}', encontrado '{valor}'")
        return valor
