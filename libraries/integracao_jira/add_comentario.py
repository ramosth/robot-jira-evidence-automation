"""
ETAPA 2 da publicação de evidências: envia ao Jira o resultado de cada cenário.

Para cada print gerado pelo extrair_print.py (prints_tests/sucessos|falhas/QA-308.png):
1. Anexa ao card QA-308 o recorte do cenário no relatório (log.html).
2. Procura o screenshot da tela no momento final do teste, salvo pelo
   teardown do Robot em results/screenshots/screenshots DD-MM-AAAA/<pasta>/,
   e anexa o MAIS RECENTE cujo nome contém o ID (o cenário pode ter rodado
   várias vezes no dia).
3. Publica um comentário com um painel colorido:
       verde    -> "TESTE AUTOMAÇÃO APROVADO"
       vermelho -> "TESTE AUTOMAÇÃO REPROVADO"
   com as duas imagens embutidas logo abaixo.
4. Se o card estiver na coluna de automação, move-o no workflow:
       aprovado  -> transição de conclusão (ex.: "Ending")
       reprovado -> transição de bloqueio (ex.: "Blocked")
5. Ao final, imprime um relatório com totais, taxa de sucesso e erros.

Uso (na raiz do projeto, depois do extrair_print.py):
    python libraries/integracao_jira/add_comentario.py
"""

import os
from datetime import datetime

import requests
from dotenv import load_dotenv
from requests.auth import HTTPBasicAuth

load_dotenv()

# ============================================================================
# CONFIGURAÇÕES (.env)
# ============================================================================
JIRA_URL = os.getenv("JIRA_URL", "").rstrip("/")
AUTH = HTTPBasicAuth(os.getenv("JIRA_EMAIL", ""), os.getenv("JIRA_API_TOKEN", ""))
PROJECT_KEY = os.getenv("PROJECT_KEY", "QA")

# Workflow: só movemos cards que estão no status de automação, para não
# interferir em cards que o time já tratou manualmente.
STATUS_AUTOMACAO = os.getenv("STATUS_AUTOMACAO", "Automation")
TRANSICAO_APROVADO = os.getenv("TRANSICAO_APROVADO", "Ending")
TRANSICAO_REPROVADO = os.getenv("TRANSICAO_REPROVADO", "Blocked")

TIMEOUT = 60  # segundos; uploads de imagem podem demorar

# Pastas: prints do relatório (etapa 1) e screenshots salvos pelo Robot
PRINTS_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), os.getenv("OUTPUT_DIR_NAME", "prints_tests")
)
RAIZ_PROJETO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SCREENSHOTS_BASE_DIR = os.path.join(RAIZ_PROJETO, "results", "screenshots")


def _texto_negrito(texto):
    """Trecho de texto em negrito no formato ADF (Atlassian Document Format)."""
    return {"type": "text", "text": texto, "marks": [{"type": "strong"}]}


# Para cada pasta de prints: mensagem do comentário e cor do painel do Jira
# (panelType "success" = verde, "error" = vermelho).
RESULTADOS = {
    os.getenv("FAILURE_DIR_NAME", "falhas"): {
        "mensagem": [_texto_negrito("TESTE AUTOMAÇÃO "), _texto_negrito("REPROVADO")],
        "tipo": "error",
    },
    os.getenv("SUCCESS_DIR_NAME", "sucessos"): {
        "mensagem": [_texto_negrito("TESTE AUTOMAÇÃO "), _texto_negrito("APROVADO")],
        "tipo": "success",
    },
}


# ============================================================================
# ESTATÍSTICAS DA EXECUÇÃO
# ============================================================================

class ProcessingStats:
    """Acumula os números do processamento para o relatório final."""

    def __init__(self):
        self.total_processados = 0
        self.sucessos = 0
        self.falhas = 0
        self.anexos_enviados = 0
        self.comentarios_adicionados = 0
        self.transicoes_realizadas = 0
        self.screenshots_encontrados = 0
        self.screenshots_nao_encontrados = 0
        self.erros = {"anexo": 0, "comentario": 0, "transicao": 0}

    def adicionar_card(self, resultado, anexos, comentario_ok, transicao_ok, screenshot_ok):
        """Registra o resultado do processamento de um card."""
        self.total_processados += 1
        if resultado == "success":
            self.sucessos += 1
        else:
            self.falhas += 1
        self.anexos_enviados += anexos
        self.comentarios_adicionados += int(comentario_ok)
        self.transicoes_realizadas += int(transicao_ok)
        if screenshot_ok:
            self.screenshots_encontrados += 1
        else:
            self.screenshots_nao_encontrados += 1

    def adicionar_erro(self, tipo):
        """tipo: 'anexo', 'comentario' ou 'transicao'."""
        self.erros[tipo] += 1

    def imprimir_relatorio(self):
        print("\n" + "=" * 80)
        print("📊 RELATÓRIO FINAL DE PROCESSAMENTO")
        print("=" * 80)
        print(f"   📋 Cards processados: {self.total_processados}")
        print(f"   ✅ Aprovados: {self.sucessos}  |  ❌ Reprovados: {self.falhas}")
        if self.total_processados:
            print(f"   📈 Taxa de sucesso: {self.sucessos / self.total_processados * 100:.1f}%")
        print(f"   📎 Anexos enviados: {self.anexos_enviados}")
        print(f"   💬 Comentários publicados: {self.comentarios_adicionados}")
        print(f"   🔄 Transições realizadas: {self.transicoes_realizadas}")
        print(f"   📸 Screenshots encontrados: {self.screenshots_encontrados} "
              f"| não encontrados: {self.screenshots_nao_encontrados}")
        print(f"   ⚠️ Erros → anexo: {self.erros['anexo']} | comentário: {self.erros['comentario']} "
              f"| transição: {self.erros['transicao']}")
        print("=" * 80)


stats = ProcessingStats()


# ============================================================================
# BUSCA DO SCREENSHOT DA TELA
# ============================================================================

def buscar_screenshot_mais_recente(issue_key, data=None):
    """
    Procura, na pasta de screenshots do dia, o arquivo mais recente cujo nome
    contém o ID do card. O teardown do Robot nomeia os arquivos assim:
        "QA-308 (FRONT) Abrir modal ... [ SUCESSO ] 15_42_11.png"

    Args:
        issue_key (str): ID do card (ex.: "QA-308").
        data (str): data no formato DD-MM-AAAA (padrão: hoje).

    Returns:
        str | None: caminho do screenshot ou None se não houver.
    """
    data = data or datetime.now().strftime("%d-%m-%Y")
    pasta_do_dia = os.path.join(SCREENSHOTS_BASE_DIR, f"screenshots {data}")
    if not os.path.isdir(pasta_do_dia):
        print(f"[INFO] 📁 Pasta de screenshots do dia não encontrada: {pasta_do_dia}")
        return None

    # Busca recursiva: dentro da pasta do dia há uma subpasta por feature
    candidatos = [
        os.path.join(raiz, arquivo)
        for raiz, _, arquivos in os.walk(pasta_do_dia)
        for arquivo in arquivos
        if arquivo.endswith(".png") and issue_key in arquivo
    ]
    if not candidatos:
        print(f"[INFO] 🔍 Nenhum screenshot encontrado para {issue_key}")
        return None

    # A data de modificação mais recente corresponde à última execução
    return max(candidatos, key=os.path.getmtime)


# ============================================================================
# CHAMADAS À API DO JIRA
# ============================================================================

def anexar_arquivo(issue_key, caminho):
    """
    Envia uma imagem como anexo do card.

    Returns:
        dict | None: {"id", "filename"} do anexo, usado para embutir a imagem
                     no comentário.
    """
    url = f"{JIRA_URL}/rest/api/3/issue/{issue_key}/attachments"
    # Header exigido pelo Jira em uploads (proteção contra CSRF)
    headers = {"X-Atlassian-Token": "no-check"}
    try:
        with open(caminho, "rb") as arquivo:
            files = {"file": (os.path.basename(caminho), arquivo, "image/png")}
            resposta = requests.post(url, headers=headers, files=files, auth=AUTH, timeout=TIMEOUT)

        if resposta.status_code in (200, 201):
            anexo = resposta.json()[0]
            print(f"[ANEXO] 📎 {issue_key}: {os.path.basename(caminho)}")
            return {"id": anexo["id"], "filename": anexo["filename"]}

        print(f"[ERRO] ❌ Anexo em {issue_key}: {resposta.status_code} - {resposta.text}")
    except Exception as erro:  # noqa: BLE001
        print(f"[ERRO] ❌ Exceção ao anexar em {issue_key}: {erro}")
    stats.adicionar_erro("anexo")
    return None


def comentar_com_imagens(issue_key, mensagem, tipo_painel, anexos):
    """
    Publica o comentário de resultado: um painel (verde/vermelho) com a
    mensagem, seguido das imagens anexadas, centralizadas.
    """
    conteudo = [{
        "type": "panel",
        "attrs": {"panelType": tipo_painel},
        "content": [{"type": "paragraph", "content": mensagem}],
    }]
    for anexo in anexos:
        conteudo.append({
            "type": "mediaSingle",
            "attrs": {"layout": "center"},
            "content": [{
                "type": "media",
                "attrs": {
                    "type": "external",
                    "url": f"{JIRA_URL}/rest/api/3/attachment/content/{anexo['id']}",
                },
            }],
        })

    corpo = {"body": {"type": "doc", "version": 1, "content": conteudo}}
    try:
        resposta = requests.post(
            f"{JIRA_URL}/rest/api/3/issue/{issue_key}/comment",
            json=corpo, auth=AUTH, timeout=TIMEOUT,
        )
        if resposta.status_code in (200, 201):
            print(f"[COMENTÁRIO] 🖼️ {issue_key}: publicado com {len(anexos)} imagem(ns)")
            return True
        print(f"[ERRO] ⚠️ Comentário em {issue_key}: {resposta.status_code} - {resposta.text}")
    except Exception as erro:  # noqa: BLE001
        print(f"[ERRO] ❌ Exceção ao comentar em {issue_key}: {erro}")
    stats.adicionar_erro("comentario")
    return False


def obter_status_atual(issue_key):
    """Retorna o nome do status atual do card (ex.: "Automation")."""
    try:
        resposta = requests.get(
            f"{JIRA_URL}/rest/api/3/issue/{issue_key}?fields=status", auth=AUTH, timeout=TIMEOUT
        )
        if resposta.status_code == 200:
            return resposta.json()["fields"]["status"]["name"]
        print(f"[ERRO] ❌ Status de {issue_key}: {resposta.status_code} - {resposta.text}")
    except Exception as erro:  # noqa: BLE001
        print(f"[ERRO] ❌ Exceção ao obter status de {issue_key}: {erro}")
    return None


def listar_transicoes(issue_key):
    """
    Lista as transições disponíveis para o card no status atual.

    Returns:
        dict: {"NOME DA TRANSIÇÃO": id}
    """
    try:
        resposta = requests.get(
            f"{JIRA_URL}/rest/api/3/issue/{issue_key}/transitions", auth=AUTH, timeout=TIMEOUT
        )
        if resposta.status_code == 200:
            return {t["name"].upper(): t["id"] for t in resposta.json()["transitions"]}
        print(f"[ERRO] ❌ Transições de {issue_key}: {resposta.status_code} - {resposta.text}")
    except Exception as erro:  # noqa: BLE001
        print(f"[ERRO] ❌ Exceção ao listar transições de {issue_key}: {erro}")
    return {}


def realizar_transicao(issue_key, nome_transicao):
    """Move o card pela transição informada (busca o ID pelo nome)."""
    transicoes = listar_transicoes(issue_key)
    transicao_id = transicoes.get(nome_transicao.upper())
    if not transicao_id:
        print(f"[ERRO] ❌ Transição '{nome_transicao}' indisponível para {issue_key}")
        stats.adicionar_erro("transicao")
        return False

    try:
        resposta = requests.post(
            f"{JIRA_URL}/rest/api/3/issue/{issue_key}/transitions",
            json={"transition": {"id": transicao_id}}, auth=AUTH, timeout=TIMEOUT,
        )
        if resposta.status_code == 204:
            print(f"[TRANSIÇÃO] ✅ {issue_key} → {nome_transicao}")
            return True
        print(f"[ERRO] ❌ Transição de {issue_key}: {resposta.status_code} - {resposta.text}")
    except Exception as erro:  # noqa: BLE001
        print(f"[ERRO] ❌ Exceção na transição de {issue_key}: {erro}")
    stats.adicionar_erro("transicao")
    return False


def decidir_transicao(status_atual, resultado):
    """
    Regra do workflow, isolada para ser fácil de entender e testar:
    só move cards que estão no status de automação.

    Returns:
        str | None: nome da transição a aplicar ou None.
    """
    if (status_atual or "").upper() != STATUS_AUTOMACAO.upper():
        return None
    return TRANSICAO_APROVADO if resultado == "success" else TRANSICAO_REPROVADO


# ============================================================================
# FLUXO PRINCIPAL
# ============================================================================

def processar_card(issue_key, caminho_print, config_resultado):
    """Executa as etapas 1 a 4 (anexos, comentário, transição) para um card."""
    print(f"\n[INFO] 📌 Processando: {issue_key}")
    anexos = []

    # 1. Recorte do cenário no log.html
    anexo = anexar_arquivo(issue_key, caminho_print)
    if anexo:
        anexos.append(anexo)

    # 2. Screenshot da tela ao final do teste
    screenshot = buscar_screenshot_mais_recente(issue_key)
    screenshot_ok = False
    if screenshot:
        anexo = anexar_arquivo(issue_key, screenshot)
        if anexo:
            anexos.append(anexo)
            screenshot_ok = True

    comentario_ok = transicao_ok = False
    if anexos:
        # 3. Comentário com o resultado e as imagens
        comentario_ok = comentar_com_imagens(
            issue_key, config_resultado["mensagem"], config_resultado["tipo"], anexos
        )
        # 4. Transição conforme o resultado
        status = obter_status_atual(issue_key)
        transicao = decidir_transicao(status, config_resultado["tipo"])
        if transicao:
            transicao_ok = realizar_transicao(issue_key, transicao)
        else:
            print(f"[INFO] ⏩ {issue_key} está em '{status}', não em '{STATUS_AUTOMACAO}': sem transição.")
    else:
        print(f"[AVISO] ⚠️ Nenhuma imagem anexada para {issue_key}; comentário não publicado.")

    stats.adicionar_card(config_resultado["tipo"], len(anexos), comentario_ok, transicao_ok, screenshot_ok)


def processar_diretorio():
    """Percorre as pastas de prints (sucessos e falhas) e processa cada card."""
    print(f"🚀 Publicando evidências do projeto {PROJECT_KEY} em {JIRA_URL}")
    for pasta, config_resultado in RESULTADOS.items():
        caminho_pasta = os.path.join(PRINTS_DIR, pasta)
        if not os.path.isdir(caminho_pasta):
            print(f"[AVISO] ⚠️ Pasta não encontrada: {caminho_pasta} (rodou o extrair_print.py?)")
            continue

        for arquivo in sorted(os.listdir(caminho_pasta)):
            # O nome do print é o próprio ID do card: QA-308.png
            if arquivo.endswith(".png") and arquivo.startswith(f"{PROJECT_KEY}-"):
                issue_key = arquivo[:-len(".png")]
                processar_card(issue_key, os.path.join(caminho_pasta, arquivo), config_resultado)

    stats.imprimir_relatorio()


if __name__ == "__main__":
    if not JIRA_URL:
        raise SystemExit("❌ JIRA_URL não definida. Copie o .env.example para .env e preencha.")
    processar_diretorio()
