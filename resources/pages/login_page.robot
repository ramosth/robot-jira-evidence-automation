*** Settings ***
Documentation       Keywords referentes aos cenários de Login

Resource            ../../config/package.robot


*** Keywords ***
Dado que acesse o Portal com o usuário
    [Documentation]    Faz login no portal com e-mail e senha do usuário informado.
    ...    Recebe um dicionário de resources/data/login_data.yaml (ex.: &{LOGIN_SUPER}).
    [Arguments]    &{dados_autenticação}
    Set Test Variable    &{dados_autenticacao_teste}    &{dados_autenticação}
    # Acessar o portal pelo método sem SSO
    Wait Until Element Is Visible    ${login_input_login}
    Input Text    ${login_input_login}    ${dados_autenticação.EMAIL}
    Wait Until Element Is Visible    ${login_input_senha}
    Input Text    ${login_input_senha}    ${dados_autenticação.SENHA}
    Clicar no elemento    ${login_button_login}

Acessar o portal pelo método sem SSO
    [Documentation]    Fluxo alternativo de login corporativo: informa o código da conta antes do login.
    Clicar no elemento    ${login_button_login_corporativo}
    Wait Until Element Is Visible    ${login_input_login_corporativo}
    Input Text    ${login_input_login_corporativo}    98765
    Clicar no elemento    ${login_button_continuar_login_corporativo}
