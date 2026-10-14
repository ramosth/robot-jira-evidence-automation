*** Settings ***
Documentation       Elementos referente a tela de login


*** Variables ***
${LOGIN_PAGE_LOGIN}                             //*[@alt='Logo VeriCar']
${LOGIN_INPUT_LOGIN}                            //input[@data-testid='email']
${LOGIN_INPUT_SENHA}                            //*[@type='password']
${LOGIN_BUTTON_LOGIN}                           //*[@class='btn-login']
${LOGIN_BUTTON_LOGIN_CORPORATIVO}               //a[contains(normalize-space(text()),"Login corporativo")]
${LOGIN_INPUT_LOGIN_CORPORATIVO}                //input[@data-testid='account']
${LOGIN_BUTTON_CONTINUAR_LOGIN_CORPORATIVO}     //button[@data-testid='btn-login']
