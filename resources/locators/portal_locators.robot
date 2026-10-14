*** Settings ***
Documentation       Elementos referente a tela do Portal


*** Variables ***
${PORTAL_USERNAME}                  //*[@data-testid='username']
${PORTAL_NOME_USUARIO}              //app-user-settings/a/span[@class="mat-button-wrapper"]
${PORTAL_H1_SAUDACAO}               //div[@class='box-welcome']//h1[contains(text(), 'Olá, ')]
${PORTAL_BOTAO_VERICAR}           //a[.='VeriCar']
${PORTAL_NOME_CONTA}                //label[contains(@class, 'label-select')]
${PORTAL_INPUT_BUSCA_CONTA}         //input[@placeholder="Digite aqui"]
${PORTAL_PRIMEIRA_OPCAO_LISTA}      //div[@class="content-options"]/p[1]
