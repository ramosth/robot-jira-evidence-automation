*** Settings ***
Documentation       Keywords referentes aos cenários do Portal

Resource            ../../config/package.robot


*** Keywords ***
Clicar na ferramenta VeriCar
    [Documentation]    No portal, abre a ferramenta VeriCar, que é carregada em uma nova aba, e muda o foco para ela.
    Sleep    1
    # Aguarda o loading desaparecer antes de tentar clicar
    # Wait Until Element Is Not Visible    ${loading_icone}
    Wait Until Element Is Visible    ${portal_botao_vericar}
    # Aguarda o elemento estar clicável (sem overlay)
    Wait Until Element Is Enabled    ${portal_botao_vericar}
    Click Element    ${portal_botao_vericar}
    Sleep    1
    Switch Window    NEW

Usuário logado com sucesso
    [Documentation]    Valida a saudação "Olá, <nome>" na home do portal e guarda o nome do usuário logado
    ...    na variável ${nome_usuario_teste} para validações posteriores.
    Wait Until Element Is Visible    ${portal_username}
    Element Should Be Visible    ${portal_h1_saudacao}
    ${nome_usuario}    Get Text    ${portal_username}
    ${nome_usuario_simples}    Split String    ${nome_usuario}    Olá,${SPACE}
    Set Test Variable    ${nome_usuario_teste}    ${nome_usuario_simples}[0]
    SeleniumLibrary.Element Text Should Be    ${portal_username}    ${nome_usuario}

Troca de conta no Portal
    [Documentation]    Troca a conta (cliente) ativa no portal pelo seletor de contas, buscando pelo número.
    ...    Usuários com acesso a várias contas precisam disso antes de solicitar laudos.
    [Arguments]    ${conta}
    ${sleep}    Set Browser Implicit Wait    5
    Wait Until Element Is Not Visible    ${loading_icone}    ${sleep}
    Wait Until Element Is Visible    ${portal_username}
    Click Element    ${portal_nome_conta}
    Wait Until Element Is Visible    ${portal_input_busca_conta}
    Input Text    ${portal_input_busca_conta}    ${conta}
    Wait Until Element Is Visible    ${portal_primeira_opcao_lista}
    Wait Until Element Contains
    ...    ${portal_primeira_opcao_lista}
    ...    ${conta}
    ...    timeout=${config.browser.implicit_wait}
    Click Element    ${portal_primeira_opcao_lista}
    Wait Until Element Contains
    ...    //label[@class='label-select force-uppercase']
    ...    ${conta}
    ...    timeout=${config.browser.implicit_wait}
    Sleep    1s
