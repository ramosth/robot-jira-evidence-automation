*** Settings ***
Documentation       Arquivo centralizador de imports e configurações do projeto
...                 Importa todas as bibliotecas, resources, variáveis e keywords necessárias
...                 para execução dos testes automatizados do front-end do VeriCar.
...                 Todos os arquivos de teste importam apenas este arquivo.

# ====================================================================================================
# BIBLIOTECAS EXTERNAS
# ====================================================================================================
Library             SeleniumLibrary    # Automação web com Selenium
Library             DateTime    # Manipulação de datas
Library             String    # Manipulação de strings
Library             Collections    # Manipulação de listas e dicionários
Library             OperatingSystem    # Operações do sistema operacional
Library             BuiltIn    # Keywords built-in do Robot Framework
Library             yaml    # Leitura de arquivos YAML
Library             pypdf    # Leitura do conteúdo dos laudos em PDF baixados
# ====================================================================================================
# BIBLIOTECAS CUSTOMIZADAS (PYTHON)
# ====================================================================================================
Library             ../libraries/CPFGenerator.py    # Gerador de CPF válido
Library             ../libraries/CNPJGenerator.py    # Gerador de CNPJ válido
Library             ../libraries/CNPJAlfanumericoGenerator.py    # Gerador de CNPJ alfanumérico válido
Library             ../libraries/LaudoPDF.py    # Leitura e validação do texto dos laudos em PDF
# ====================================================================================================
# VARIÁVEIS GLOBAIS (DATA)
# ====================================================================================================
Variables           ../resources/data/setup.yaml    # Configurações gerais (URLs, timeouts)
Variables           ../resources/data/login_data.yaml    # Dados de login
Variables           ../resources/data/solicitacao_laudo.yaml    # Dados da solicitação de laudo
Variables           ../resources/data/listagem_laudo.yaml    # Textos da lista de laudos e do laudo em PDF
# ====================================================================================================
# LOCATORS (MAPEAMENTO DE ELEMENTOS)
# ====================================================================================================
Resource            ../resources/locators/common_locators.robot    # Locators comuns (header, footer, etc)
Resource            ../resources/locators/login_locators.robot    # Locators da página de login
Resource            ../resources/locators/portal_locators.robot    # Locators do portal principal
Resource            ../resources/locators/solicitacao_locators.robot    # Locators da solicitacao
Resource            ../resources/locators/listagem_locators.robot    # Locators da lista de laudos (tabela, menu, paginação)
# ====================================================================================================
# PAGES (PAGE OBJECTS)
# ====================================================================================================
Resource            ../resources/pages/portal_page.robot    # Page Object do portal
Resource            ../resources/pages/login_page.robot    # Page Object do login
Resource            ../resources/pages/nova_analise_page.robot    # Page Object da Nova Análise (solicitação de laudo)
Resource            ../resources/pages/listagem_page.robot    # Page Object da Lista de laudos (menu de ações e download)
Resource            ../resources/pages/laudo_pdf_page.robot    # Page Object do laudo em PDF (validação do conteúdo)
# ====================================================================================================
# KEYWORDS (AÇÕES REUTILIZÁVEIS)
# ====================================================================================================
Resource            ../resources/keywords/common_keywords.robot    # Keywords comuns a todos os testes
Resource            ../resources/keywords/portal_keywords.robot    # Keywords do portal
Resource            ../resources/keywords/modal_keywords.robot    # keywords do componente de modais
Resource            ../resources/keywords/paginacao_keywords.robot    # keywords do componente de paginação
Resource            ../resources/keywords/tabela_keywords.robot    # keywords do componente de tabelas
Resource            ../resources/keywords/listagem_keywords.robot    # keywords de listagem
Resource            ../resources/keywords/solicitacao_keywords.robot    # keywords de solicitação
# ====================================================================================================
# CONFIGURAÇÕES DO FRAMEWORK
# ====================================================================================================
Resource            hooks.robot    # Setup e Teardown global dos testes
# ====================================================================================================
