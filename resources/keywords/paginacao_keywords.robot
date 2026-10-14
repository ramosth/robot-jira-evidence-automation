*** Settings ***
Documentation       Keywords para paginação da listagem de laudos

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# VALIDAÇÕES DE PAGINAÇÃO
# ============================================================================

Validar Pagina Ativa
    [Documentation]    Valida qual é a página atualmente ativa
    [Arguments]    ${numero_pagina_esperado}
    ${texto_pagina}=    Get Text    ${LOC_BTN_PAGINA_ATIVA}
    Should Be Equal As Strings    ${texto_pagina}    ${numero_pagina_esperado}
    ...    msg=Página ativa esperada: ${numero_pagina_esperado}, encontrada: ${texto_pagina}

# ============================================================================
# CONTADOR DE REGISTROS
# ============================================================================

Obter Contador De Registros
    [Documentation]    Retorna o texto do contador de registros
    ...    Formato esperado: "1 - 10 de 49 registros"
    ${texto}=    Get Text    ${LOC_CONTADOR_REGISTROS}
    RETURN    ${texto}

Validar Contador De Registros
    [Documentation]    Valida o texto completo do contador. Se ${total} não for informado, aceita qualquer dígito numérico.
    [Arguments]    ${inicio}    ${fim}    ${total}=${EMPTY}
    ${contador}=    Obter Contador De Registros

    IF    '${total}' != '${EMPTY}'
        ${esperado}=    Set Variable    ${inicio} - ${fim} de ${total} registros
        Should Be Equal As Strings    ${contador}    ${esperado}
        ...    msg=Contador esperado: ${esperado}, encontrado: ${contador}
    ELSE
        ${esperado_regex}=    Set Variable    ^${inicio} - ${fim} de \\d+ registros$
        Should Match Regexp    ${contador}    ${esperado_regex}
        ...    msg=Contador deve seguir o padrão: ${inicio} - ${fim} de [número] registros, encontrado: ${contador}
    END

Validar Controles De Paginacao Visiveis
    [Documentation]    Valida que os controles de paginação estão visíveis
    Wait Until Element Is Visible    ${LOC_BTN_PAGINA_ATIVA}/parent::div    timeout=10s
    Element Should Be Visible    ${LOC_BTN_PAGINA_ATIVA}/parent::div
