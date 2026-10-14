*** Settings ***
Documentation       Keywords para interação com a tabela de listagem de laudos

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# KEYWORDS AUXILIARES PARA LOCATORS DINÂMICOS
# ============================================================================

Obter Locator Celula ID Por Linha
    [Documentation]    Retorna o locator da célula ID para uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Set Variable    //tbody//tr[${numero_linha}]//td[1]
    RETURN    ${locator}

Obter Locator Celula Responsavel Por Linha
    [Documentation]    Retorna o locator da célula Responsável para uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Set Variable    //tbody//tr[${numero_linha}]//td[2]
    RETURN    ${locator}

Obter Locator Celula Status Por Linha
    [Documentation]    Retorna o locator da célula Status para uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Set Variable    //tbody//tr[${numero_linha}]//td[4]
    RETURN    ${locator}

Obter Locator Celula Data Por Linha
    [Documentation]    Retorna o locator da célula Data para uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Set Variable    //tbody//tr[${numero_linha}]//td[3]
    RETURN    ${locator}

Obter Locator Botao Menu Por Linha
    [Documentation]    Retorna o locator do botão de menu (três pontos) para uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Set Variable    //tbody//tr[${numero_linha}]//button//*[@data-testid='MoreVertIcon']
    RETURN    ${locator}

Obter Locator Linha Por ID
    [Documentation]    Retorna o locator de uma linha específica baseado no ID do laudo
    [Arguments]    ${id_laudo}
    ${locator}=    Set Variable    //tbody//tr[.//td[1][text()='${id_laudo}']]
    RETURN    ${locator}

Obter Locator Botao Pagina
    [Documentation]    Retorna o locator do botão de número de página
    [Arguments]    ${numero_pagina}
    ${locator}=    Set Variable    //button[contains(@class, 'MuiButton-text') and text()='${numero_pagina}']
    RETURN    ${locator}

# ============================================================================
# VALIDAÇÕES DA ESTRUTURA DA TABELA
# ============================================================================

Validar Estrutura Da Tabela Com Colunas
    [Documentation]    Valida que a estrutura da tabela está presente com as colunas obrigatórias
    Wait Until Element Is Visible    ${LOC_TABELA}
    Element Should Be Visible    ${LOC_TABELA_THEAD}
    Element Should Be Visible    ${LOC_TH_ID_LAUDO}
    Element Should Be Visible    ${LOC_TH_RESPONSAVEL}
    Element Should Be Visible    ${LOC_TH_ULTIMA_ATUALIZACAO}
    Element Should Be Visible    ${LOC_TH_STATUS}
    Element Should Be Visible    ${LOC_TH_ACOES}

Validar Estrutura Da Tabela Não Presente
    [Documentation]    Valida que a estrutura da tabela está presente com as colunas obrigatórias
    Wait Until Element Is Not Visible    ${LOC_TABELA}
    Element Should Not Be Visible    ${LOC_TABELA_THEAD}

Validar Ordem Das Colunas
    [Documentation]    Valida que as colunas estão na ordem correta

    @{colunas}=    Get WebElements    xpath=//th[contains(@class, 'MuiTableCell-head')]

    # Obter texto de cada coluna
    ${texto_col1}=    Get Text    ${colunas}[0]
    ${texto_col2}=    Get Text    ${colunas}[1]
    ${texto_col3}=    Get Text    ${colunas}[2]
    ${texto_col4}=    Get Text    ${colunas}[3]
    ${texto_col5}=    Get Text    ${colunas}[4]

    # Validar textos
    Should Contain    ${texto_col1}    ID do Laudo
    Should Contain    ${texto_col2}    Responsável
    Should Contain    ${texto_col3}    Última atualização
    Should Contain    ${texto_col4}    Status
    Should Contain    ${texto_col5}    Ações

    Log    ✅ Todas as colunas estão na ordem correta

# ========================================
# VALIDAÇÕES DA TABELA COM DADOS
# ========================================

Validar Que Tabela Possui Laudos
    [Documentation]    Valida que a tabela contém laudos (linhas visíveis)
    Wait Until Element Is Visible    ${LOC_TABELA_LINHAS}    timeout=10s
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    Should Be True    ${count} > 0    msg=Tabela deveria conter laudos mas está vazia

Validar Numero De Laudos Na Pagina
    [Documentation]    Valida o número exato de laudos exibidos na página
    [Arguments]    ${numero_esperado}
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    Should Be Equal As Integers
    ...    ${count}
    ...    ${numero_esperado}
    ...    msg=Esperado ${numero_esperado} laudos, mas encontrou ${count}

Validar Que Linha Contem Campos Obrigatorios
    [Documentation]    Valida que uma linha específica contém todos os campos obrigatórios
    [Arguments]    ${numero_linha}
    ${loc_id}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[1]
    ${loc_resp}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[2]
    ${loc_data}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[3]
    ${loc_status}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[4]
    ${loc_acoes}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[5]

    Element Should Be Visible    ${loc_id}
    Element Should Be Visible    ${loc_resp}
    Element Should Be Visible    ${loc_data}
    Element Should Be Visible    ${loc_status}
    Element Should Be Visible    ${loc_acoes}

Validar Campo ID Do Laudo Na Linha
    [Documentation]    Valida que o campo ID do Laudo contém um número
    [Arguments]    ${numero_linha}
    ${loc_id}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[1]
    ${texto_id}=    Get Text    ${loc_id}
    Should Not Be Empty    ${texto_id}
    # Validar que é um número
    ${is_number}=    Run Keyword And Return Status    Should Match Regexp    ${texto_id}    ^\\d+$
    Should Be True    ${is_number}    msg=ID do Laudo deveria ser numérico: ${texto_id}

Validar Campo Responsavel Na Linha
    [Documentation]    Valida que o campo Responsável contém um nome
    [Arguments]    ${numero_linha}
    ${loc_resp}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[2]
    ${texto_resp}=    Get Text    ${loc_resp}
    Should Not Be Empty    ${texto_resp}

Validar Campo Status Na Linha
    [Documentation]    Valida que o campo Status contém um nome
    [Arguments]    ${numero_linha}
    ${loc_resp}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[4]
    ${texto_resp}=    Get Text    ${loc_resp}
    Should Not Be Empty    ${texto_resp}

Validar Campo Data Na Linha
    [Documentation]    Valida que o campo Data está no formato DD/MM/AAAA às HH:MM:SS
    [Arguments]    ${numero_linha}
    ${loc_data}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[3]
    ${texto_data}=    Get Text    ${loc_data}
    Should Not Be Empty    ${texto_data}

    # Validar formato DD/MM/AAAA às HH:MM:SS
    ${is_datetime}=    Run Keyword And Return Status
    ...    Should Match Regexp    ${texto_data}    ^\\d{2}/\\d{2}/\\d{4} às \\d{2}:\\d{2}:\\d{2}$
    Should Be True    ${is_datetime}
    ...    msg=Data deveria estar no formato DD/MM/AAAA às HH:MM:SS: ${texto_data}

Validar Campo Acoes Na Linha
    [Documentation]    Valida que o campo Ações contém o ícone de três pontos
    [Arguments]    ${numero_linha}
    ${loc_acoes}=    Set Variable    xpath=//tbody//tr[${numero_linha}]//td[5]//button//*[@data-testid='MoreVertIcon']
    Element Should Be Visible    ${loc_acoes}

Validar Todos Os Campos De Cada Linha
    [Documentation]    Valida que cada linha da tabela contém todos os campos obrigatórios
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    FOR    ${i}    IN RANGE    1    ${count + 1}
        Validar Que Linha Contem Campos Obrigatorios    ${i}
        Validar Campo ID Do Laudo Na Linha    ${i}
        Validar Campo Responsavel Na Linha    ${i}
        Validar Campo Status Na Linha    ${i}
        Validar Campo Data Na Linha    ${i}
        Validar Campo Acoes Na Linha    ${i}
    END

Validar Que Apenas Laudo Com ID Esta Visivel
    [Documentation]    Valida que apenas o laudo com ID especificado está visível
    [Arguments]    ${id}
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    Should Be True    ${count} > 0    msg=Nenhuma linha encontrada na tabela

    FOR    ${index}    IN RANGE    1    ${count + 1}
        ${locator_linha}=    Set Variable    xpath=(${LOC_TABELA_LINHAS})[${index}]//td[1]
        ${id_linha}=    Get Text    ${locator_linha}
        Should Be Equal As Strings    ${id_linha}    ${id}
        ...    msg=Linha ${index}: Esperado ID '${id}', encontrado '${id_linha}'
    END

Validar Link Limpar Filtros Visivel E Habilitado
    [Documentation]    Valida que link "Limpar filtros" está visível e habilitado
    Wait Until Element Is Visible    ${LOC_BOTAO_LIMPAR_FILTROS}    timeout=10s
    Element Should Be Enabled    ${LOC_BOTAO_LIMPAR_FILTROS}

Validar Laudo Com ID Visivel
    [Documentation]    Valida que laudo com ID específico está visível
    [Arguments]    ${id}
    ${locator}=    Set Variable    xpath=//tbody//tr[.//td[1][text()='${id}']]
    Element Should Be Visible    ${locator}

Validar Conteudo Em Todas As Linhas Da Tabela
    [Documentation]    Valida que todas as linhas da tabela contêm o conteúdo esperado na coluna especificada
    [Arguments]    ${conteudo_esperado}    ${coluna}    ${validacao_tipo}=CONTAINS
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    Should Be True    ${count} > 0    msg=Nenhuma linha encontrada na tabela

    FOR    ${index}    IN RANGE    1    ${count + 1}
        ${locator_celula}=    Set Variable    xpath=(${LOC_TABELA_LINHAS})[${index}]//td[${coluna}]
        ${conteudo_linha}=    Get Text    ${locator_celula}

        # Se for coluna 3, extrair apenas a data (antes de "às")
        IF    ${coluna} == 3
            @{partes}=    Split String    ${conteudo_linha}    ${SPACE}às${SPACE}
            ${conteudo_validacao}=    Set Variable    ${partes}[0]
        ELSE
            ${conteudo_validacao}=    Set Variable    ${conteudo_linha}
        END

        IF    '${validacao_tipo}' == 'EQUAL'
            Should Be Equal As Strings
            ...    ${conteudo_validacao}
            ...    ${conteudo_esperado}
            ...    msg=Linha ${index}, Coluna ${coluna}: Esperado '${conteudo_esperado}', encontrado '${conteudo_validacao}'
        ELSE IF    '${validacao_tipo}' == 'CONTAINS'
            Should Contain
            ...    ${conteudo_validacao}
            ...    ${conteudo_esperado}
            ...    msg=Linha ${index}, Coluna ${coluna}: Esperado conter '${conteudo_esperado}', encontrado '${conteudo_validacao}'
        ELSE
            Fail    Tipo de validação inválido: ${validacao_tipo}. Use 'EQUAL' ou 'CONTAINS'
        END
    END

Validar Laudos Do Responsavel Visiveis
    [Documentation]    Valida que laudos do responsável estão visíveis
    [Arguments]    ${responsavel}
    ${locator}=    Set Variable    xpath=//tbody//tr[.//td[2][contains(text(),'${responsavel}')]]
    Element Should Be Visible    ${locator}

# ============================================================================
# CONTADORES E VERIFICAÇÕES
# ============================================================================

Contar Linhas Da Tabela
    [Documentation]    Retorna a quantidade de linhas visíveis na tabela
    Wait Until Element Is Visible    ${LOC_TABELA_TBODY}    timeout=10s
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    RETURN    ${count}

Validar Quantidade De Registros
    [Documentation]    Valida que a tabela exibe a quantidade esperada de registros
    [Arguments]    ${quantidade_esperada}
    ${quantidade_real}=    Contar Linhas Da Tabela
    Should Be Equal As Numbers    ${quantidade_real}    ${quantidade_esperada}
    ...    msg=Esperado ${quantidade_esperada} registros, mas encontrado ${quantidade_real}

# ============================================================================
# EXTRAÇÃO DE DADOS
# ============================================================================

Obter Numero Aleatorio De Linha Da Tabela
    [Documentation]    Obtém o total de linhas da tabela e retorna um número aleatório entre 1 e o total
    ${count}=    Get Element Count    ${LOC_TABELA_LINHAS}
    Should Be True    ${count} > 0    msg=Nenhuma linha encontrada na tabela

    ${numero_aleatorio}=    Evaluate    random.randint(1, ${count})    modules=random
    Log    Total de linhas: ${count}, Linha aleatória selecionada: ${numero_aleatorio}

    RETURN    ${numero_aleatorio}

Obter ID Do Laudo Da Linha
    [Documentation]    Retorna o ID do laudo de uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Obter Locator Celula ID Por Linha    ${numero_linha}
    ${id}=    Get Text    ${locator}
    Set Test Variable    ${id_teste}    ${id}
    RETURN    ${id}

Obter Responsavel Da Linha
    [Documentation]    Retorna o nome do responsável de uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Obter Locator Celula Responsavel Por Linha    ${numero_linha}
    ${responsavel}=    Get Text    ${locator}
    Set Test Variable    ${responsavel_teste}    ${responsavel}
    RETURN    ${responsavel}

Obter Status Da Linha
    [Documentation]    Retorna o nome do status de uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Obter Locator Celula Status Por Linha    ${numero_linha}
    ${status}=    Get Text    ${locator}
    Set Test Variable    ${status_teste}    ${status}
    RETURN    ${status}

Obter Data Da Linha
    [Documentation]    Retorna a data de atualização de uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Obter Locator Celula Data Por Linha    ${numero_linha}
    ${data}=    Get Text    ${locator}
    Set Test Variable    ${data_teste}    ${data}
    RETURN    ${data}

Obter Todos Dados Da Linha
    [Documentation]    Retorna um dicionário com todos os dados de uma linha
    [Arguments]    ${numero_linha}
    ${id}=    Obter ID Do Laudo Da Linha    ${numero_linha}
    ${responsavel}=    Obter Responsavel Da Linha    ${numero_linha}
    ${data}=    Obter Data Da Linha    ${numero_linha}
    &{dados}=    Create Dictionary    id=${id}    responsavel=${responsavel}    data=${data}
    RETURN    &{dados}

Obter Todos IDs Da Tabela
    [Documentation]    Retorna uma lista com todos os IDs visíveis na tabela
    ${quantidade}=    Contar Linhas Da Tabela
    @{ids}=    Create List
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${id}=    Obter ID Do Laudo Da Linha    ${i}
        Append To List    ${ids}    ${id}
    END
    RETURN    @{ids}

Obter Todos Responsaveis Da Tabela
    [Documentation]    Retorna uma lista com todos os responsáveis visíveis na tabela
    ${quantidade}=    Contar Linhas Da Tabela
    @{responsaveis}=    Create List
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${responsavel}=    Obter Responsavel Da Linha    ${i}
        Append To List    ${responsaveis}    ${responsavel}
    END
    RETURN    @{responsaveis}

Obter Todos as Últimas Atualizações Da Tabela
    [Documentation]    Retorna uma lista com todos os responsáveis visíveis na tabela
    ${quantidade}=    Contar Linhas Da Tabela
    @{datas}=    Create List
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${data}=    Obter Data Da Linha    ${i}
        Append To List    ${datas}    ${data}
    END
    RETURN    @{datas}

Obter Todos Status Da Tabela
    [Documentation]    Retorna uma lista com todos os responsáveis visíveis na tabela
    ${quantidade}=    Contar Linhas Da Tabela
    @{status}=    Create List
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${sta}=    Obter Status Da Linha    ${i}
        Append To List    ${status}    ${sta}
    END
    RETURN    @{status}

# ============================================================================
# VALIDAÇÕES DE CONTEÚDO
# ============================================================================

Validar ID Na Tabela
    [Documentation]    Valida que um ID específico está presente na tabela
    [Arguments]    ${id_esperado}
    ${locator}=    Obter Locator Linha Por ID    ${id_esperado}
    Element Should Be Visible    ${locator}
    ...    msg=O ID ${id_esperado} não foi encontrado na tabela

Validar Responsavel Na Tabela
    [Documentation]    Valida que um responsável específico está presente na tabela
    [Arguments]    ${responsavel_esperado}
    ${locator}=    Set Variable    xpath=//tbody//tr[.//td[2][contains(text(), '${responsavel_esperado}')]]
    Element Should Be Visible    ${locator}
    ...    msg=O responsável ${responsavel_esperado} não foi encontrado na tabela

# ============================================================================
# ORDENAÇÃO
# ============================================================================

Validar Icones De Ordenacao Nas Colunas
    [Documentation]    Valida que todas as colunas têm ícone de ordenação
    Element Should Be Visible    ${LOC_ICON_ORDENAR_ID}//*[@data-testid='UnfoldMoreIcon']
    Element Should Be Visible    ${LOC_ICON_ORDENAR_RESPONSAVEL}//*[@data-testid='UnfoldMoreIcon']
    Element Should Be Visible    ${LOC_ICON_ORDENAR_DATA}//*[@data-testid='UnfoldMoreIcon']

Validar Icone de Ordenação na Coluna "${coluna}" exibe seta "${sentido}"
    [Documentation]    Valida se o ícone de ordenação da coluna está exibindo a seta no sentido correto
    ...    Sentido: "para cima" (crescente) ou "para baixo" (decrescente)

    # Validar sentido
    Should Be True    '${sentido}' in ['para cima', 'para baixo']
    ...    msg=Sentido inválido: ${sentido}. Use 'para cima' ou 'para baixo'

    # Mapeamento de colunas para locators de ordenação
    ${locators_crescente}=    Create Dictionary
    ...    ID do Laudo=LOC_ICON_ORDENAR_ID_CRESCENTE
    ...    Responsável=LOC_ICON_ORDENAR_RESPONSAVEL_CRESCENTE
    ...    Última atualização=LOC_ICON_ORDENAR_DATA_CRESCENTE
    ...    Status=LOC_ICON_ORDENAR_STATUS_CRESCENTE

    ${locators_decrescente}=    Create Dictionary
    ...    ID do Laudo=LOC_ICON_ORDENAR_ID_DECRESCENTE
    ...    Responsável=LOC_ICON_ORDENAR_RESPONSAVEL_DECRESCENTE
    ...    Última atualização=LOC_ICON_ORDENAR_DATA_DECRESCENTE
    ...    Status=LOC_ICON_ORDENAR_STATUS_DECRESCENTE

    # Validar se a coluna existe
    ${coluna_existe}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${locators_crescente}    ${coluna}
    Should Be True    ${coluna_existe}
    ...    msg=Coluna '${coluna}' não está mapeada. Colunas disponíveis: ${locators_crescente.keys()}

    # Determinar qual locator usar baseado no sentido
    IF    '${sentido}' == 'para cima'
        ${locator_var}=    Get From Dictionary    ${locators_crescente}    ${coluna}
        ${locator_oposto_var}=    Get From Dictionary    ${locators_decrescente}    ${coluna}
        ${tipo_ordem}=    Set Variable    crescente
    ELSE
        ${locator_var}=    Get From Dictionary    ${locators_decrescente}    ${coluna}
        ${tipo_ordem}=    Set Variable    decrescente
    END

    # Obter os locators reais
    ${locator}=    Get Variable Value    \${${locator_var}}

    # Validar que o ícone correto está visível
    Element Should Be Visible    ${locator}
    ...    msg=Ícone de ordenação ${tipo_ordem} não está visível na coluna '${coluna}'

    Log    ✅ Ícone de ordenação validado: coluna '${coluna}' com seta ${sentido}

Clicar Em Ordenar ID
    [Documentation]    Clica no ícone de ordenação da coluna ID
    Wait Until Element Is Visible    ${LOC_ICON_ORDENAR_ID}    timeout=5s
    Click Element    ${LOC_ICON_ORDENAR_ID}
    Sleep    1s    # Aguarda ordenação ser aplicada

Clicar Em Ordenar Responsavel
    [Documentation]    Clica no ícone de ordenação da coluna Responsável
    Wait Until Element Is Visible    ${LOC_ICON_ORDENAR_RESPONSAVEL}    timeout=5s
    Click Element    ${LOC_ICON_ORDENAR_RESPONSAVEL}
    Sleep    1s

Clicar Em Ordenar Status
    [Documentation]    Clica no ícone de ordenação da coluna Status
    Wait Until Element Is Visible    ${LOC_ICON_ORDENAR_STATUS}    timeout=5s
    Click Element    ${LOC_ICON_ORDENAR_STATUS}
    Sleep    1s

Clicar Em Ordenar Data
    [Documentation]    Clica no ícone de ordenação da coluna Data
    Wait Until Element Is Visible    ${LOC_ICON_ORDENAR_DATA}    timeout=5s
    Click Element    ${LOC_ICON_ORDENAR_DATA}
    Sleep    1s

Validar IDs Em Ordem
    [Documentation]    Valida que TODOS os IDs estão na ordem especificada
    [Arguments]    ${ordem}=crescente

    @{ids}=    Obter Todos IDs Da Tabela
    ${total}=    Get Length    ${ids}
    Should Be True    ${total} > 0    msg=Nenhum ID encontrado na tabela

    # Converter todos para inteiros
    @{ids_numericos}=    Create List
    FOR    ${id}    IN    @{ids}
        ${id_int}=    Convert To Integer    ${id}
        Append To List    ${ids_numericos}    ${id_int}
    END

    # Determinar se deve inverter
    ${reverse}=    Set Variable If    '${ordem}' == 'decrescente'    ${TRUE}    ${FALSE}

    # Criar lista ordenada
    @{ids_ordenados}=    Evaluate    sorted(${ids_numericos}, reverse=${reverse})

    # Comparar listas
    Lists Should Be Equal    ${ids_numericos}    ${ids_ordenados}
    ...    msg=IDs não estão em ordem ${ordem}. Atual: ${ids_numericos}, Esperado: ${ids_ordenados}

    Log    ✅ Todos os ${total} IDs estão em ordem ${ordem}

Validar Responsaveis Em Ordem
    [Documentation]    Valida que TODOS os responsáveis estão na ordem especificada
    [Arguments]    ${ordem}=crescente

    @{responsaveis}=    Obter Todos Responsaveis Da Tabela
    ${total}=    Get Length    ${responsaveis}
    Should Be True    ${total} > 0    msg=Nenhum responsável encontrado na tabela

    # Determinar se deve inverter
    ${reverse}=    Set Variable If    '${ordem}' == 'decrescente'    ${TRUE}    ${FALSE}

    # Criar lista ordenada (ordem alfabética)
    @{responsaveis_ordenados}=    Evaluate    sorted(${responsaveis}, key=str.lower, reverse=${reverse})

    # Comparar listas
    Lists Should Be Equal    ${responsaveis}    ${responsaveis_ordenados}
    ...    msg=Responsáveis não estão em ordem ${ordem}. Atual: ${responsaveis}, Esperado: ${responsaveis_ordenados}

    Log    ✅ Todos os ${total} responsáveis estão em ordem alfabética ${ordem}

Validar Status Em Ordem
    [Documentation]    Valida que TODOS os status estão na ordem especificada
    [Arguments]    ${ordem}=crescente

    @{status}=    Obter Todos Status Da Tabela
    ${total}=    Get Length    ${status}
    Should Be True    ${total} > 0    msg=Nenhum status encontrado na tabela

    # Determinar se deve inverter
    ${reverse}=    Set Variable If    '${ordem}' == 'decrescente'    ${TRUE}    ${FALSE}

    # Criar lista ordenada (ordem alfabética)
    @{status_ordenados}=    Evaluate    sorted(${status}, key=str.lower, reverse=${reverse})

    # Comparar listas
    Lists Should Be Equal    ${status}    ${status_ordenados}
    ...    msg=Status não estão em ordem ${ordem}. Atual: ${status}, Esperado: ${status_ordenados}

    Log    ✅ Todos os ${total} status estão em ordem alfabética ${ordem}

Validar Datas Em Ordem
    [Documentation]    Valida que TODAS as datas estão na ordem especificada
    [Arguments]    ${ordem}=crescente

    @{datas}=    Obter Todos as Últimas Atualizações Da Tabela
    ${total}=    Get Length    ${datas}
    Should Be True    ${total} > 0    msg=Nenhuma data encontrada na tabela

    # Converter datas para formato comparável (YYYYMMDDHHMMSS)
    @{datas_convertidas}=    Create List
    FOR    ${data_hora}    IN    @{datas}
        # Extrair data e hora do formato "22/01/2026 às 14:25:38"
        ${data_hora_limpa}=    Replace String    ${data_hora}    ${SPACE}às${SPACE}    ${SPACE}

        # Converter DD/MM/YYYY HH:MM:SS para YYYY-MM-DD HH:MM:SS
        ${data_obj}=    Convert Date
        ...    ${data_hora_limpa}
        ...    date_format=%d/%m/%Y %H:%M:%S
        ...    result_format=%Y-%m-%d %H:%M:%S
        Append To List    ${datas_convertidas}    ${data_obj}
    END

    # Determinar se deve inverter
    ${reverse}=    Set Variable If    '${ordem}' == 'decrescente'    ${TRUE}    ${FALSE}

    # Criar lista ordenada
    @{datas_ordenadas}=    Evaluate    sorted(${datas_convertidas}, reverse=${reverse})

    # Comparar listas
    Lists Should Be Equal    ${datas_convertidas}    ${datas_ordenadas}
    ...    msg=Datas não estão em ordem ${ordem}

    Log    ✅ Todas as ${total} datas estão em ordem ${ordem}

# ============================================================================
# INTERAÇÕES COM MENU DE AÇÕES
# ============================================================================

Abrir Menu De Acoes Da Linha
    [Documentation]    Abre o menu de ações (três pontos) de uma linha específica
    [Arguments]    ${numero_linha}
    ${locator}=    Obter Locator Botao Menu Por Linha    ${numero_linha}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Click Element    ${locator}
    Wait Until Element Is Visible    ${LOC_MENU_DROPDOWN}    timeout=5s

Validar Menu Acoes Visivel
    [Documentation]    Valida que o menu de ações está aberto e visível
    Element Should Be Visible    ${LOC_MENU_DROPDOWN}
    Element Should Be Visible    ${LOC_MENU_ITEM_REEMITIR}
    Element Should Be Visible    ${LOC_MENU_ITEM_CORRIGIR}
    Element Should Be Visible    ${LOC_MENU_ITEM_DOWNLOAD}

Fechar Menu De Acoes
    [Documentation]    Fecha o menu de ações clicando fora dele
    Press Keys    None    ESC

Validar Menu Acoes Expandido
    [Documentation]    Valida que o menu de ações está aberto com todas as opções
    Wait Until Element Is Visible    ${LOC_MENU_DROPDOWN}    timeout=5s
    Element Should Be Visible    ${LOC_MENU_ITEM_REEMITIR}
    Element Should Be Visible    ${LOC_MENU_ITEM_CORRIGIR}
    Element Should Be Visible    ${LOC_MENU_ITEM_DOWNLOAD}

Validar Ordem Das Opcoes Menu
    [Documentation]    Valida que as opções aparecem na ordem correta
    # 1ª: Reemitir laudo
    ${locator_1}=    Set Variable    xpath=(//li[@role='menuitem'])[1]
    ${texto_1}=    Get Text    ${locator_1}
    Should Be Equal As Strings    ${texto_1}    Reemitir laudo

    # 2ª: Corrigir laudo
    ${locator_2}=    Set Variable    xpath=(//li[@role='menuitem'])[2]
    ${texto_2}=    Get Text    ${locator_2}
    Should Be Equal As Strings    ${texto_2}    Corrigir laudo

    # 3ª: Download do laudo
    ${locator_3}=    Set Variable    xpath=(//li[@role='menuitem'])[3]
    ${texto_3}=    Get Text    ${locator_3}
    Should Be Equal As Strings    ${texto_3}    Download do laudo

Validar Menu Acoes Fechado
    [Documentation]    Valida que o menu de ações não está visível
    Sleep    1s
    Element Should Not Be Visible    ${LOC_MENU_DROPDOWN}

Validar Icone Menu Em Todas Linhas
    [Documentation]    Valida que todas as linhas possuem o ícone de menu (três pontos)
    ${quantidade}=    Contar Linhas Da Tabela
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${locator}=    Obter Locator Botao Menu Por Linha    ${i}
        Element Should Be Visible    ${locator}
    END

Validar Apenas Um Menu Aberto
    [Documentation]    Valida que ao abrir novo menu, o anterior fecha
    # Abre primeiro menu
    Abrir Menu De Acoes Da Linha    1
    Validar Menu Acoes Expandido

    # Conta quantos menus estão abertos (deveria ser apenas 1)
    ${count}=    Get Element Count    ${LOC_MENU_DROPDOWN}
    Should Be Equal As Numbers    ${count}    1
    ...    msg=Deveria haver apenas 1 menu aberto, mas há ${count}

Validar Icone Menu Tres Pontos
    [Documentation]    Valida que o ícone de três pontos verticais está presente
    [Arguments]    ${numero_linha}=1
    ${locator}=    Obter Locator Botao Menu Por Linha    ${numero_linha}
    Element Should Be Visible    ${locator}

    # Valida que é o ícone correto (MoreVertIcon)
    ${svg_locator}=    Set Variable    ${locator}//parent::button//*[@data-testid='MoreVertIcon']
    Element Should Be Visible    ${svg_locator}

Clicar Menu Acoes Da Primeira Linha
    [Documentation]    Abre o menu de ações da primeira linha
    Abrir Menu De Acoes Da Linha    1
    ${id}=    Obter ID Do Laudo Da Linha    1

Clicar Menu Acoes Por ID
    [Documentation]    Abre o menu de ações de um laudo específico pelo ID
    [Arguments]    ${id_laudo}
    ${locator}=    Obter Locator Linha Por ID    ${id_laudo}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${botao}=    Set Variable    ${locator}//*[@data-testid='MoreVertIcon']
    Click Element    ${botao}
    Wait Until Element Is Visible    ${LOC_MENU_DROPDOWN}    timeout=5s

Validar Menu Exibe Opcao
    [Documentation]    Valida que o menu exibe uma opção específica
    [Arguments]    ${nome_opcao}
    ${locator}=    Set Variable    xpath=//li[@role='menuitem'][contains(text(), '${nome_opcao}')]
    Element Should Be Visible    ${locator}
    ...    msg=Opção '${nome_opcao}' não está visível no menu
    Log    ✅ Menu exibe a opção '${nome_opcao}'

Validar Opcao Esta Na Posicao
    [Documentation]    Valida que uma opção está em uma posição específica do menu
    [Arguments]    ${nome_opcao}    ${posicao}
    ${locator}=    Set Variable    xpath=(//li[@role='menuitem'])[${posicao}]
    ${texto}=    Get Text    ${locator}
    Should Be Equal As Strings    ${texto}    ${nome_opcao}
    ...    msg=Opção na posição ${posicao} deveria ser '${nome_opcao}', mas é '${texto}'
    Log    ✅ Opção '${nome_opcao}' está na posição ${posicao}

Validar Opcao Exibe Texto
    [Documentation]    Valida que uma opção exibe o texto esperado
    [Arguments]    ${nome_opcao}    ${texto_esperado}
    ${locator}=    Set Variable    xpath=//li[@role='menuitem'][contains(text(), '${nome_opcao}')]
    ${texto_real}=    Get Text    ${locator}
    Should Be Equal As Strings    ${texto_real}    ${texto_esperado}
    ...    msg=Texto esperado: '${texto_esperado}', texto encontrado: '${texto_real}'
    Log    ✅ Opção '${nome_opcao}' exibe o texto correto: '${texto_esperado}'

Validar Opcao Esta Habilitada E Clicavel
    [Documentation]    Valida que uma opção está habilitada e clicável
    [Arguments]    ${nome_opcao}
    ${locator}=    Set Variable    xpath=//li[@role='menuitem'][contains(text(), '${nome_opcao}')]

    # Verificar se está visível
    Element Should Be Visible    ${locator}
    ...    msg=Opção '${nome_opcao}' não está visível

    # Verificar se está habilitada
    Element Should Be Enabled    ${locator}

    # Verificar se não tem atributo disabled
    ${disabled}=    Run Keyword And Return Status
    ...    Element Attribute Value Should Be    ${locator}    aria-disabled    true
    Should Not Be True    ${disabled}
    ...    msg=Opção '${nome_opcao}' está desabilitada (aria-disabled=true)

    Log    ✅ Opção '${nome_opcao}' está habilitada e clicável

Validar Opcao Tem Efeito Hover
    [Documentation]    Valida que há mudança visual ao passar o mouse (hover)
    [Arguments]    ${nome_opcao}    ${xpath}=//li[@role='menuitem'][contains(text(), '${nome_opcao}')]
    ${locator}=    Set Variable    ${xpath}

    # Capturar background-color ANTES do hover
    ${bg_antes}=    Execute JavaScript
    ...    return window.getComputedStyle(document.evaluate("${locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).backgroundColor

    # Passar mouse sobre o elemento
    Mouse Over    ${locator}
    Sleep    0.5s

    # Capturar background-color DEPOIS do hover
    ${bg_depois}=    Execute JavaScript
    ...    return window.getComputedStyle(document.evaluate("${locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).backgroundColor

    # Validar que houve mudança
    Should Not Be Equal    ${bg_antes}    ${bg_depois}
    ...    msg=Opção '${nome_opcao}' não mudou o background-color no hover. Antes: ${bg_antes}, Depois: ${bg_depois}

    # Validar que o background ficou com opacidade (rgba)
    Should Contain    ${bg_depois}    rgba
    ...    msg=Background-color não está no formato rgba esperado: ${bg_depois}

    Log    ✅ Opção '${nome_opcao}' tem efeito hover (background mudou de ${bg_antes} para ${bg_depois})

Validar Botao Esta Habilitado E Clicavel
    [Documentation]    Valida que uma opção está habilitada e clicável
    [Arguments]    ${nome_botao}
    ${locator}=    Set Variable
    ...    xpath=//button[contains(@class, 'css-aiutyz') and text()='${nome_botao}']

    # Verificar se está visível
    Element Should Be Visible    ${locator}
    ...    msg=Opção '${nome_botao}' não está visível

    # Verificar se está habilitada
    Element Should Be Enabled    ${locator}

    # Verificar se não tem atributo disabled
    ${disabled}=    Run Keyword And Return Status
    ...    Element Attribute Value Should Be    ${locator}    aria-disabled    true
    Should Not Be True    ${disabled}
    ...    msg=Opção '${nome_botao}' está desabilitada (aria-disabled=true)

    Log    ✅ Opção '${nome_botao}' está habilitada e clicável

# ========================================
# DROPDOWN ITENS POR PÁGINA
# ========================================

Clicar No Dropdown Itens Por Pagina
    [Documentation]    Clica no dropdown de itens por página para abrir menu de opções
    Wait Until Element Is Visible    ${LOC_BTN_ITENS_POR_PAGINA}    timeout=10s
    Click Element    ${LOC_BTN_ITENS_POR_PAGINA}
    Sleep    0.5s

Validar Dropdown Itens Por Pagina Exibe
    [Documentation]    Valida que o dropdown exibe a quantidade especificada
    [Arguments]    ${quantidade}
    ${texto}=    Get Text    ${LOC_BTN_ITENS_POR_PAGINA}
    Should Contain    ${texto}    ${quantidade}

Validar Opcoes Menu Itens Por Pagina
    [Documentation]    Valida que menu exibe as 3 opções: 10, 20, 50
    [Arguments]    ${opcao1}    ${opcao2}    ${opcao3}
    Wait Until Element Is Visible    ${LOC_MENU_ITENS_DROPDOWN}    timeout=5s
    Element Should Be Visible    ${LOC_OPCAO_10_ITENS}
    Element Should Be Visible    ${LOC_OPCAO_20_ITENS}
    Element Should Be Visible    ${LOC_OPCAO_50_ITENS}

Selecionar Opcao Itens Por Pagina
    [Documentation]    Seleciona uma opção específica no menu de itens por página
    [Arguments]    ${quantidade}
    IF    '${quantidade}' == '10'    Click Element    ${LOC_OPCAO_10_ITENS}
    IF    '${quantidade}' == '15'    Click Element    ${LOC_OPCAO_20_ITENS}
    IF    '${quantidade}' == '20'    Click Element    ${LOC_OPCAO_50_ITENS}
    Sleep    0.5s

Aguardar Recarregamento Da Listagem
    [Documentation]    Aguarda o recarregamento da listagem após mudança de configuração
    Sleep    2s
    Wait Until Element Is Visible    ${LOC_TABELA}    timeout=10s

Validar Consistencia Dados Linha
    [Documentation]    Valida que todos os dados de uma linha são consistentes
    [Arguments]    ${numero_linha}
    # ID não deve estar vazio
    ${id}=    Obter ID Do Laudo Da Linha    ${numero_linha}
    Should Not Be Empty    ${id}
    Should Match Regexp    ${id}    ^\\d+$

    # Responsável não deve estar vazio
    ${responsavel}=    Obter Responsavel Da Linha    ${numero_linha}
    Should Not Be Empty    ${responsavel}

    # Status não deve estar vazio
    ${status}=    Obter Status Da Linha    ${numero_linha}
    Should Not Be Empty    ${status}

    # Data deve estar no formato correto
    ${data}=    Obter Data Da Linha    ${numero_linha}
    Validar Formato Data BR    ${data}
