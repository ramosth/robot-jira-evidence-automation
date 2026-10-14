"""
ETAPA 1 da publicação de evidências: recorta, do relatório do Robot Framework
(log.html), a imagem de cada cenário executado.

Como funciona:
1. Abre o log.html em um Chrome headless (sem janela).
2. Percorre cada cenário do relatório e identifica:
   - o ID do Jira no nome do cenário (ex.: "Cenário: QA-308 ..." -> QA-308);
   - o resultado (PASS ou FAIL) pela classe CSS do rótulo.
3. Expande os cenários aprovados (o Robot mostra os reprovados já abertos)
   para que o print mostre os passos executados.
4. Tira um screenshot só do bloco daquele cenário e salva em:
       prints_tests/sucessos/QA-308.png
       prints_tests/falhas/QA-311.png

Se o mesmo ID aparecer mais de uma vez (ex.: reexecução), a FALHA tem
prioridade: um cenário que falhou nunca é reportado como aprovado.

Depois desta etapa, rode add_comentario.py para publicar os prints no Jira.

Uso (na raiz do projeto, após executar os testes):
    python libraries/integracao_jira/extrair_print.py
"""

import os
import re
import shutil
import sys
import time

from dotenv import load_dotenv
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By

load_dotenv()

# ============================================================================
# CONFIGURAÇÕES (.env), todas com valor padrão
# ============================================================================
PROJECT_KEY = os.getenv("PROJECT_KEY", "QA")                  # prefixo dos IDs dos cenários
LOG_FILE_NAME = os.getenv("LOG_FILE_NAME", "log.html")        # relatório gerado pelo Robot
WINDOW_SIZE = os.getenv("WINDOW_SIZE", "1920,3000")           # janela alta: cabe o cenário inteiro
EXPAND_DELAY = float(os.getenv("EXPAND_DELAY", "0.5"))        # espera após expandir um cenário (s)
SCROLL_DELAY = float(os.getenv("SCROLL_DELAY", "0.3"))        # espera após rolar até o cenário (s)
PAGE_LOAD_DELAY = float(os.getenv("PAGE_LOAD_DELAY", "2"))    # espera o log.html renderizar (s)
OUTPUT_DIR_NAME = os.getenv("OUTPUT_DIR_NAME", "prints_tests")
SUCCESS_DIR_NAME = os.getenv("SUCCESS_DIR_NAME", "sucessos")
FAILURE_DIR_NAME = os.getenv("FAILURE_DIR_NAME", "falhas")

# Caminhos: o log.html fica na raiz do projeto; os prints, ao lado deste script
RAIZ_PROJETO = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
LOG_PATH = os.path.join(RAIZ_PROJETO, LOG_FILE_NAME)
PRINTS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), OUTPUT_DIR_NAME)

# Estrutura do log.html do Robot: cada cenário é um <div class="test">
SELETOR_CENARIOS = ".children.populated > div.test"


def criar_navegador():
    """Cria um Chrome headless com a janela no tamanho configurado."""
    options = Options()
    options.add_argument("--headless=new")
    options.add_argument(f"--window-size={WINDOW_SIZE}")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    return webdriver.Chrome(options=options)


def preparar_pastas_saida():
    """
    Recria as pastas de saída do zero, para que prints de uma execução
    anterior não sejam publicados por engano.

    Returns:
        tuple[str, str]: (pasta de sucessos, pasta de falhas)
    """
    if os.path.exists(PRINTS_DIR):
        print(f"🧹 Removendo prints da execução anterior: {PRINTS_DIR}")
        shutil.rmtree(PRINTS_DIR, ignore_errors=True)

    sucessos_dir = os.path.join(PRINTS_DIR, SUCCESS_DIR_NAME)
    falhas_dir = os.path.join(PRINTS_DIR, FAILURE_DIR_NAME)
    os.makedirs(sucessos_dir, exist_ok=True)
    os.makedirs(falhas_dir, exist_ok=True)
    return sucessos_dir, falhas_dir


def identificar_cenario(nome_cenario):
    """
    Extrai o ID do Jira do nome do cenário.
    Ex.: "Cenário: QA-308 (FRONT) Abrir modal" -> "QA-308".
    Sem ID, usa o próprio nome (limpo) para não perder a evidência.
    """
    encontrado = re.search(rf"{PROJECT_KEY}-\d+", nome_cenario)
    if encontrado:
        return encontrado.group(0)
    return re.sub(r"[^\w\-]", "_", nome_cenario[:50])


def deve_capturar(codigo, falhou, processados, sucessos_dir):
    """
    Decide se o cenário deve ser capturado, aplicando a regra
    "falha tem prioridade" para IDs repetidos.
    """
    anterior = processados.get(codigo)
    if anterior is None:
        return True
    if anterior == "pass" and falhou:
        # Já havia um print de sucesso, mas uma execução posterior falhou:
        # remove o print de sucesso e captura o de falha.
        print(f"⚠️  {codigo}: atualizando de SUCESSO para FALHA")
        caminho_sucesso = os.path.join(sucessos_dir, f"{codigo}.png")
        if os.path.exists(caminho_sucesso):
            os.remove(caminho_sucesso)
        return True
    print(f"⏭️  {codigo}: já capturado como {'falha' if anterior == 'fail' else 'sucesso'}, ignorando.")
    return False


def capturar_cenarios(driver, sucessos_dir, falhas_dir):
    """Percorre todos os cenários do log.html e salva um print de cada um."""
    cenarios = driver.find_elements(By.CSS_SELECTOR, SELETOR_CENARIOS)
    print(f"🧪 Cenários encontrados no relatório: {len(cenarios)}")

    processados = {}  # codigo -> "pass" | "fail"
    for i, cenario in enumerate(cenarios, start=1):
        id_html = cenario.get_attribute("id")
        try:
            cabecalho = cenario.find_element(By.CSS_SELECTOR, ".element-header")

            # O rótulo do cenário tem a classe "pass" ou "fail"
            rotulo = cabecalho.find_element(By.CSS_SELECTOR, ".label")
            falhou = "fail" in rotulo.get_attribute("class").lower()

            nome = cabecalho.find_element(By.CSS_SELECTOR, ".name").text.strip()
            codigo = identificar_cenario(nome)

            if not deve_capturar(codigo, falhou, processados, sucessos_dir):
                continue
            processados[codigo] = "fail" if falhou else "pass"

            # Cenários aprovados vêm recolhidos no log.html: expande para
            # que o print mostre os passos (Dado / Quando / Então) executados.
            if not falhou and "closed" in cabecalho.get_attribute("class"):
                ActionChains(driver).move_to_element(cabecalho).click().perform()
                time.sleep(EXPAND_DELAY)

            # Rola até o cenário e tira o print apenas daquele bloco
            driver.execute_script(
                "arguments[0].scrollIntoView({behavior: 'smooth', block: 'start'});", cenario
            )
            time.sleep(SCROLL_DELAY)

            pasta = falhas_dir if falhou else sucessos_dir
            cenario.screenshot(os.path.join(pasta, f"{codigo}.png"))
            print(f"{'❌' if falhou else '✅'} {i}/{len(cenarios)} {codigo} → {os.path.basename(pasta)}/")

        except NoSuchElementException as erro:
            print(f"❌ Estrutura inesperada no cenário {i} ({id_html}): {erro}")
        except Exception as erro:  # noqa: BLE001  (um cenário com erro não interrompe os demais)
            print(f"❌ Erro ao capturar o cenário {i} ({id_html}): {erro}")

    return len(cenarios)


def main():
    if not os.path.exists(LOG_PATH):
        print(f"❌ Relatório não encontrado: {LOG_PATH}. Execute os testes antes.")
        sys.exit(1)

    sucessos_dir, falhas_dir = preparar_pastas_saida()
    driver = criar_navegador()
    try:
        print(f"📁 Abrindo relatório: {LOG_PATH}")
        driver.get(f"file://{LOG_PATH}")
        time.sleep(PAGE_LOAD_DELAY)

        total = capturar_cenarios(driver, sucessos_dir, falhas_dir)

        contar = lambda pasta: len([f for f in os.listdir(pasta) if f.endswith(".png")])
        print("\n" + "=" * 60)
        print("✨ EXTRAÇÃO CONCLUÍDA")
        print(f"📊 Cenários no relatório: {total}")
        print(f"✅ Sucessos: {contar(sucessos_dir)}  |  ❌ Falhas: {contar(falhas_dir)}")
        print(f"📁 Prints em: {PRINTS_DIR}")
        print("=" * 60)
    finally:
        driver.quit()


if __name__ == "__main__":
    main()
