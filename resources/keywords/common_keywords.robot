*** Settings ***
Documentation       Keywords comuns e genéricas usadas em toda a automação

Resource            ../../config/package.robot


*** Keywords ***
Clicar no elemento
    [Documentation]    Aguarda o elemento ficar visível e clica. As pausas curtas evitam cliques
    ...    durante animações dos componentes (modais e menus do Material UI).
    [Arguments]    ${botao}
    Sleep    1
    Wait Until Element Is Visible    ${botao}
    Click Element    ${botao}
    Sleep    1

E o sistema exibe um snackbar com a mensagem
    [Documentation]    Verifica se o snackbar é exibido com a mensagem esperada
    [Arguments]    ${status_da_mensagem}    ${snackbar_mensagem}
    Wait Until Element Is Visible    ${snackbar_inferior}    timeout=60s
    Element Should Be Visible    ${snackbar_inferior}
    Element Should Contain    ${snackbar_inferior}    ${snackbar_mensagem}
    Sleep    1s

# ============================================================================
# NAVEGAÇÃO E ACESSO À PÁGINA
# ============================================================================

Abrir Nova Aba E Acessar URL
    [Documentation]    Abre uma nova aba no navegador e acessa a URL especificada
    [Arguments]    ${url}
    Execute Javascript    window.open('${url}', '_blank');
    Switch Window    NEW
    Wait Until Location Is    ${url}    timeout=10s

Acessar Pagina Listagem De Laudos Em Nova Aba
    [Documentation]    Abre nova aba do navegador e acessa a página de listagem de laudos
    [Arguments]    ${url}
    Abrir Nova Aba E Acessar URL    ${url}

Validar Pagina Listagem Carregada
    [Documentation]    Valida que a página de listagem carregou corretamente
    Wait Until Element Is Visible    ${LOC_TITULO_PAGINA}
    Element Text Should Be    ${LOC_TITULO_PAGINA}    Lista de laudos

Obter Quantidade De Laudos Da Página
    [Documentation]    Retorna a quantidade de laudos exibida no contador da página
    ...    Exemplo de texto esperado: "Total de registros: 15"
    ...    Retorna: 15 (como string)

    Wait Until Element Is Visible    ${LOC_CONTADOR_REGISTROS}    timeout=10s

    ${texto_completo}=    Get Text    ${LOC_CONTADOR_REGISTROS}
    Log    Texto do contador: ${texto_completo}

    ${partes}=    Split String    ${texto_completo}    separator=de${SPACE}
    ${quantidade}=    Get From List    ${partes}    1
    ${quantidade}=    Strip String    ${quantidade}
    ${partes}=    Split String    ${quantidade}    separator=${SPACE}
    ${quantidade}=    Get From List    ${partes}    0
    ${quantidade}=    Strip String    ${quantidade}

    # Converte para inteiro antes de retornar
    ${quantidade}=    Convert To Integer    ${quantidade}

    Log    Quantidade de laudos encontrada: ${quantidade}

    RETURN    ${quantidade}

# ============================================================================
# CABEÇALHO E ELEMENTOS GERAIS
# ============================================================================

Validar Usuario Logado
    [Documentation]    Valida que o usuário está logado (botão de perfil visível)
    [Arguments]    ${nome_usuario}
    Element Should Be Visible    ${LOC_BTN_USUARIO}
    ${texto}=    Get Text    ${LOC_BTN_USUARIO}
    Should Contain    ${texto}    ${nome_usuario}
    Set Test Variable    ${nome_usuario_logado}    ${nome_usuario}

# ============================================================================
# HELPERS E UTILITÁRIOS
# ============================================================================

Validar Formato Data BR
    [Documentation]    Valida se uma string está no formato DD/MM/YYYY às HH:MM:SS
    [Arguments]    ${data}
    Should Match Regexp    ${data}    ^\\d{2}/\\d{2}/\\d{4} às \\d{2}:\\d{2}:\\d{2}$
    ...    msg=Data ${data} não está no formato DD/MM/YYYY às HH:MM:SS
