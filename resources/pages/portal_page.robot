*** Settings ***
Documentation       Keywords referentes aos cenários do Portal

Resource            ../../config/package.robot


*** Keywords ***
E clicar na ferramenta VeriCar
    [Documentation]    Passo Gherkin: abre a ferramenta VeriCar a partir do portal.
    Clicar na ferramenta VeriCar

Então sistema apresentara a tela home com nome do usuario
    [Documentation]    Passo Gherkin: valida que o login foi concluído e a home exibe o nome do usuário.
    Usuário logado com sucesso

E trocar para conta
    [Documentation]    Passo Gherkin: troca a conta ativa no portal (ex.: E trocar para conta    1001).
    [Arguments]    ${conta}
    Troca de conta no Portal    ${conta}
