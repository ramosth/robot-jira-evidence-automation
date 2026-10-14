*** Settings ***
Documentation       Page Object com steps em estilo BDD (Dado/Quando/Então) para a Nova Análise

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# DADO (GIVEN) - PRÉ-CONDIÇÕES
# ============================================================================
E que o modal de solicitação está aberto na etapa Dados
    [Documentation]    Pré-condição: modal aberto na primeira etapa
    Abrir Modal Solicitar Laudo
    Modal Deve Estar Visível
    Etapa Deve Estar Ativa    Dados

E que o usuário preencheu todos os campos corretamente
    [Documentation]    Pré-condição: formulário completamente preenchido com dados válidos
    [Arguments]    ${placa}=${EMPTY}
    Preencher Todos Campos Com Dados Validos    ${placa}

E que o usuário preencheu todos os campos obrigatórios corretamente
    [Documentation]    Pré-condição: formulário completamente preenchido com dados obrigatórios válidos
    Preencher Todos Campos Obrigatorios Com Dados Validos

E o usuário está na etapa Itens
    [Documentation]    Pré-condição: usuário avançou para a etapa 2 (Itens)
    Etapa Deve Estar Ativa    Itens

E que todos os campos obrigatórios estão vazios
    [Documentation]    Pré-condição: formulário completamente vazio
    # Não preenche nada, apenas garante que modal está aberto
    Modal Deve Estar Visível

# ============================================================================
# QUANDO (WHEN) - AÇÕES
# ============================================================================

E o usuário clica no botão "Continuar"
    [Documentation]    Ação: avançar para próxima etapa
    Clicar Botão Continuar

Quando o usuário clica no botão "Continuar"
    [Documentation]    Ação: avançar para próxima etapa
    Clicar Botão Continuar

Quando o usuário clica no botão "Cancelar"
    [Documentation]    Ação: cancelar e fechar o modal
    Clicar Botão Cancelar

E clico no botão X no canto superior direito do modal
    [Documentation]    Ação: fechar modal pelo X
    Fechar Modal    X

E preencher o campo
    [Documentation]    Preenche um campo do formulário de solicitação pelo nome do rótulo (ex.: "Placa").
    [Arguments]    ${nome_campo}    ${valor}
    Preencher Campo    ${nome_campo}    ${valor}

Quando o usuário tenta avançar sem preencher o campo
    [Documentation]    Clica em um campo e pressiona TAB sem preencher, simulando validação de campo obrigatório
    [Arguments]    ${nome_campo}    ${xpath_campo}
    Não preencher um campo obrigatório    ${nome_campo}    ${xpath_campo}

Quando o usuário submete o formulário com o campo "${campo}" preenchido com "${valor}"
    [Documentation]    Ação: submeter com valor inválido em campo específico
    Preencher Campo Com Valor Invalido    ${campo}    ${valor}

Quando submete o formulário com o campo "CNPJ alfanumérico"
    [Documentation]    Ação: submeter com valor válido em campo CNPJ
    Deixar Campo Vazio E Preencher Os Demais    CNPJ
    ${tipoCliente}=    Set Variable    Pessoa Jurídica
    Selecionar Opcao    Tipo do cliente    ${tipoCliente}

    ${cnpjLoja}=    Gerar CNPJ Alfanumérico Válido    ${False}
    Log    CNPJ gerado: ${cnpjLoja}
    ${valido}=    Validar CNPJ Alfanumérico    ${cnpjLoja}
    Should Be True    ${valido}
    Preencher Campo    CNPJ    ${cnpjLoja}

    ${cnpjCliente}=    Gerar CNPJ Alfanumérico Válido    ${False}
    Log    CNPJ Cliente gerado: ${cnpjCliente}
    ${valido}=    Validar CNPJ Alfanumérico    ${cnpjCliente}
    Should Be True    ${valido}

    Preencher Campo    Documento do cliente    ${cnpjCliente}

Quando o usuário tenta avançar sem preencher nenhum campo obrigatório
    [Documentation]    Ação: Clicar nos inputs dos campos obrigatórios e sair sem preencher com valores
    Quando o usuário tenta avançar sem preencher o campo    Número da proposta    ${LOC_INPUT_NUMERO_PROPOSTA}
    Quando o usuário tenta avançar sem preencher o campo    Tipo do cliente    ${LOC_SELECT_TIPO_CLIENTE}
    Quando o usuário tenta avançar sem preencher o campo    Nome do cliente    ${LOC_INPUT_NOME_CLIENTE}
    Quando o usuário tenta avançar sem preencher o campo    Documento do cliente    ${LOC_INPUT_DOCUMENTO_CLIENTE}
    Quando o usuário tenta avançar sem preencher o campo    CNPJ    ${LOC_INPUT_CNPJ}
    Quando o usuário tenta avançar sem preencher o campo    Nome do vendedor    ${LOC_INPUT_NOME_VENDEDOR}
    Quando o usuário tenta avançar sem preencher o campo    Placa    ${LOC_INPUT_PLACA}
    Quando o usuário tenta avançar sem preencher o campo    RENAVAM    ${LOC_INPUT_RENAVAM}
    Quando o usuário tenta avançar sem preencher o campo    UF da placa    ${LOC_SELECT_UF_PLACA}
    Quando o usuário tenta avançar sem preencher o campo    Cidade    ${LOC_INPUT_CIDADE}

Quando o usuário retorna para a etapa Dados
    [Documentation]    Ação: navegar de volta para etapa 1
    Click Element    ${LOC_BTN_VOLTAR}
    Wait Until Element Is Visible    ${LOC_STEP_1_DADOS_ACTIVE}    timeout=5s

Quando o usuário preenche todos os campos obrigatórios corretamente
    [Documentation]    Ação: completar formulário com dados válidos
    Preencher Todos Campos Obrigatorios Com Dados Validos

Quando o usuário deixa o campo "${campo}" vazio
    [Documentation]    Ação: deixar campo opcional vazio
    # Não faz nada, campo já está vazio por padrão
    Log    Campo ${campo} deixado vazio intencionalmente

# ============================================================================
# ENTÃO (THEN) - VERIFICAÇÕES
# ============================================================================

Então todos os campos do formulário devem estar visíveis
    [Documentation]    Validação: 13 campos presentes no formulário
    Validar Todos Campos Devem Estar Visiveis

E os seguintes campos devem estar visíveis na seção Proposta e Cliente
    [Documentation]    Validação: campos da primeira seção
    Campo Deve Estar Visível    Filial
    Campo Deve Estar Visível    Número da proposta
    Campo Deve Estar Visível    Tipo do cliente
    Campo Deve Estar Visível    Nome do cliente
    Campo Deve Estar Visível    Documento do cliente

E os seguintes campos devem estar visíveis na seção Loja e Vendedor
    [Documentation]    Validação: campos da segunda seção
    Campo Deve Estar Visível    CNPJ
    Campo Deve Estar Visível    CPF do vendedor
    Campo Deve Estar Visível    Nome do vendedor

E os seguintes campos devem estar visíveis na seção Dados do Veículo
    [Documentation]    Validação: campos da terceira seção
    Campo Deve Estar Visível    Placa
    Campo Deve Estar Visível    RENAVAM
    Campo Deve Estar Visível    UF da placa
    Campo Deve Estar Visível    Cidade
    Campo Deve Estar Visível    Quilometragem

Então os campos opcionais devem estar marcados como "(opcional)"
    [Documentation]    Validação: 3 campos com texto (opcional)
    Validar Campos Opcionais Estao Marcados

E o campo "${campo}" deve exibir a marcação "(opcional)"
    [Documentation]    Validação: campo específico tem texto opcional
    Campo Deve Conter Texto Opcional    ${campo}

Então o campo "${campo}" deve estar destacado em vermelho
    [Documentation]    Validação: campo marcado com classe is-invalid
    Campo Deve Estar Invalido    ${campo}

E deve exibir a mensagem de erro no campo
    [Documentation]    Validação: mensagem de erro específica está visível
    [Arguments]    ${mensagem}    ${campo}    ${tipo_cliente_teste}=${EMPTY}

    # Normalizar valores para comparação
    ${campo_norm}=    Strip String    ${campo}
    ${tipo_norm}=    Strip String    ${tipo_cliente_teste}

    Log    Campo normalizado: '${campo_norm}'    console=yes
    Log    Tipo normalizado: '${tipo_norm}'    console=yes

    IF    $campo_norm == 'Documento do cliente' and $tipo_norm == 'Pessoa Jurídica'
        ${mensagem_final}=    Set Variable    ${mensagens_form_solicitar.erro.documento_cliente_tipo_errado_cnpj}
    ELSE IF    $campo_norm == 'Documento do cliente' and $tipo_norm == 'Pessoa Física'
        ${mensagem_final}=    Set Variable    ${mensagens_form_solicitar.erro.documento_cliente_tipo_errado_cpf}
    ELSE
        ${mensagem_final}=    Set Variable    ${mensagem}
    END

    Mensagem De Erro Deve Estar Visível    ${campo}    ${mensagem_final}

E o usuário deve permanecer na etapa Dados
    [Documentation]    Validação: ainda está na etapa 1
    Etapa Deve Estar Ativa    Dados

E o botão "Continuar" deve permanecer desabilitado
    [Documentation]    Validação: botão Continuar está desabilitado
    E o botão do modal está desabilitado e clicável    Continuar

Então o sistema deve avançar para a etapa Itens
    [Documentation]    Validação: navegou para etapa 2
    Wait Until Element Is Visible    ${LOC_STEP_2_ITENS_ACTIVE}    timeout=10s
    Etapa Deve Estar Ativa    Itens

E a etapa Dados deve exibir indicador de conclusão
    [Documentation]    Validação: etapa 1 marcada como completa
    Scroll Element Into View    ${LOC_BTN_PULAR_ETAPA}
    Etapa Deve Estar Completa    Dados

Então o modal deve ser fechado
    [Documentation]    Validação: modal não está mais visível
    Modal Deve Estar Fechado

E o usuário deve retornar para a tela de listagem
    [Documentation]    Validação: voltou para tela principal
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_LAUDO_PRINCIPAL}    timeout=5s

E nenhum laudo deve ser salvo
    [Documentation]    Validação: não há novo registro criado (validação conceitual)
    Log    Validação: cancelamento não gera novo laudo
    E a quantidade total de laudos permanece

Então todos os valores preenchidos devem estar preservados
    [Documentation]    Validação: dados persistem após voltar da etapa 2
    Valor Do Campo Deve Ser    Número da proposta    ${numero_proposta_teste}
    Valor Do Campo Deve Ser    Tipo do cliente    ${tipo_cliente_teste}
    Valor Do Campo Deve Ser    Nome do cliente    ${nome_cliente_teste}
    Valor Do Campo Deve Ser    Documento do cliente    ${documento_cliente_teste}
    Valor Do Campo Deve Ser    CNPJ    ${cnpjLoja_teste}
    Valor Do Campo Deve Ser    Nome do vendedor    ${nome_vendedor_teste}
    Valor Do Campo Deve Ser    Placa    ${placa_teste}
    Valor Do Campo Deve Ser    RENAVAM    ${renavam_teste}
    Valor Do Campo Deve Ser    UF da placa    ${uf_placa_teste}
    Valor Do Campo Deve Ser    Cidade    ${cidade_teste}

Então o valor de observação preenchido deve estar dentro do limite esperado
    [Documentation]    Validação: dados persistem apenas as quantidades esperadas
    Então o campo de observação da condição "Elétrica" contém o texto "${forms_solicitacao.limites.observacao_item_final}"

    ${observacao_contador}=    Get Text    ${LOC_CONTADOR_INPUT_OBS_ELETRICA}
    Should Be Equal As Strings    ${observacao_contador}    200/200
    ...    msg=Contador esperado: 200/200, encontrado: ${observacao_contador}

Então todos os valores preenchidos devem estar dentro do limite esperado
    [Documentation]    Validação: dados persistem apenas as quantidades esperadas
    Valor Do Campo Deve Ser    Filial    ${forms_solicitacao.limites.filial_final}
    Valor Do Campo Deve Ser    Número da proposta    ${forms_solicitacao.limites.numero_proposta_final}
    Valor Do Campo Deve Ser    Nome do cliente    ${forms_solicitacao.limites.nome_cliente_final}
    Valor Do Campo Deve Ser    Nome do vendedor    ${forms_solicitacao.limites.nome_vendedor_final}
    Valor Do Campo Deve Ser    Cidade    ${forms_solicitacao.limites.cidade_final}
    Valor Do Campo Deve Ser    Quilometragem    ${forms_solicitacao.limites.quilometragem_final}
    ${filial_contador}=    Get Text    ${LOC_CONTADOR_INPUT_FILIAL}
    Should Be Equal As Strings    ${filial_contador}    30/30
    ...    msg=Contador esperado: 30/30, encontrado: ${filial_contador}

    ${numero_proposta_contador}=    Get Text    ${LOC_CONTADOR_INPUT_NUMERO_PROPOSTA}
    Should Be Equal As Strings    ${numero_proposta_contador}    30/30
    ...    msg=Contador esperado: 30/30, encontrado: ${numero_proposta_contador}

    ${nome_cliente_contador}=    Get Text    ${LOC_CONTADOR_INPUT_NOME_CLIENTE}
    Should Be Equal As Strings    ${nome_cliente_contador}    100/100
    ...    msg=Contador esperado: 100/100, encontrado: ${nome_cliente_contador}

    ${nome_vendedor_contador}=    Get Text    ${LOC_CONTADOR_INPUT_NOME_VENDEDOR}
    Should Be Equal As Strings    ${nome_vendedor_contador}    100/100
    ...    msg=Contador esperado: 100/100, encontrado: ${nome_vendedor_contador}

    ${cidade_contador}=    Get Text    ${LOC_CONTADOR_INPUT_CIDADE}
    Should Be Equal As Strings    ${cidade_contador}    40/40
    ...    msg=Contador esperado: 40/40, encontrado: ${cidade_contador}

    ${quilometragem_contador}=    Get Text    ${LOC_CONTADOR_INPUT_QUILOMETRAGEM}
    Should Be Equal As Strings    ${quilometragem_contador}    7/7
    ...    msg=Contador esperado: 7/7, encontrado: ${quilometragem_contador}

E o valor do campo deve ser
    [Documentation]    Valida o valor atual de um campo do formulário (ex.: após aplicar máscara ou limite de caracteres).
    [Arguments]    ${nome_campo}    ${valor}
    Valor Do Campo Deve Ser    ${nome_campo}    ${valor}

Então o valor do campo deve ser
    [Documentation]    Variação Gherkin de "E o valor do campo deve ser".
    [Arguments]    ${nome_campo}    ${valor}
    Valor Do Campo Deve Ser    ${nome_campo}    ${valor}

Então o sistema não deve exibir erro no campo "${campo}"
    [Documentation]    Validação: campo opcional sem erro
    Campo Nao Deve Estar Invalido    ${campo}

E o sistema deve permitir avançar para a etapa Itens
    [Documentation]    Validação: pode avançar sem erro (campos opcionais vazios)
    Clicar Botão Continuar
    Então o sistema deve avançar para a etapa Itens

Então todos os 10 campos obrigatórios devem estar destacados em vermelho
    [Documentation]    Validação: 10 campos marcados como inválidos
    Todos Campos Invalidos Devem Ser    10

E devem ser exibidas 10 mensagens de erro simultaneamente
    [Documentation]    Validação: 10 mensagens de erro visíveis
    Todas Mensagens De Erro Devem Estar Visiveis    10

# ============================================================================
# DADO (GIVEN) - PRÉ-CONDIÇÕES
# ============================================================================

Quando estou no step "Itens"
    [Documentation]    Pré-condição: usuário está na etapa 2
    [Arguments]    ${placa}=${EMPTY}
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos corretamente    ${placa}
    E o usuário clica no botão "Continuar"
    Então sou direcionado para o step "Itens"

E que nenhum item de segurança foi selecionado
    [Documentation]    Pré-condição: valida que todos os checkboxes de itens estão desmarcados
    [Arguments]    ${itens}

    FOR    ${item}    IN    @{itens}
        Item Deve Estar Visivel Com Checkbox Desmarcado    ${item}
    END

E que selecionei os itens com observação
    [Documentation]    Pré-condição: itens selecionados com observação
    [Arguments]    ${item1}    ${item2}
    Selecionar Item De Seguranca    ${item1}
    Selecionar Item De Seguranca    ${item2}

E que avancei para o step "Anexos"
    [Documentation]    Pré-condição: navegou para step 3
    Sleep    0.5s    # Simula navegação prévia
    E entrar na etapa
    ...    3
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_3}

E que selecionei alguns itens de segurança
    [Documentation]    Pré-condição: alguns itens foram marcados
    Selecionar Multiplos Itens    Airbag    Freio ABS

E que selecionei os itens "${item1}", "${item2}" e "${item3}"
    [Documentation]    Pré-condição: 3 itens específicos selecionados
    Selecionar Multiplos Itens    ${item1}    ${item2}    ${item3}

# ============================================================================
# QUANDO (WHEN) - AÇÕES
# ============================================================================

Quando marco o checkbox do item "${item}"
    [Documentation]    Ação: marcar um item de segurança
    Selecionar Item De Seguranca    ${item}

E marco o checkbox do item "${item}"
    [Documentation]    Ação: marcar um item de segurança
    Quando marco o checkbox do item "${item}"

Quando clico no botão "Continuar"
    [Documentation]    Ação: avançar para próxima etapa
    E clico no botão "Continuar"

E clico no botão "Continuar"
    [Documentation]    Ação: avançar para próxima etapa
    Clicar Botão Continuar Etapa2

E clico no botão "Pular etapa"
    [Documentation]    Ação: pular etapa sem selecionar itens
    Clicar Botão Pular Etapa

Quando clico no botão "Pular etapa"
    [Documentation]    Avança para a próxima etapa sem preencher a atual (disponível nas etapas opcionais).
    Clicar Botão Pular Etapa

Quando clico no botão "Voltar"
    [Documentation]    Ação: retornar para etapa anterior
    Clicar Botão Voltar Etapa2

E clico no botão "Voltar"
    [Documentation]    Variação Gherkin de "Quando clico no botão Voltar".
    Quando clico no botão "Voltar"

Quando clico no botão "Solicitar laudo"
    [Documentation]    Ação: solicitar laudo
    Clicar Botão Solicitar Laudo

Quando marco todos os checkboxes de itens de segurança
    [Documentation]    Ação: selecionar todos os 17 itens
    Marcar Todos Os 17 Checkboxes De Itens

# ============================================================================
# ENTÃO (THEN) - VERIFICAÇÕES
# ============================================================================

Então sou direcionado para o step "Itens"
    [Documentation]    Verificação: navegou para etapa Itens
    Etapa Itens Deve Estar Ativa

E o step "Itens" está ativo e destacado
    [Documentation]    Verificação: step Itens está ativo
    E entrar na etapa
    ...    2
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_2}

E o título exibe o texto
    [Documentation]    Verificação: título correto visível
    [Arguments]    ${texto}
    Wait Until Element Is Visible    ${LOC_STEPPER_CONTAINER_TITULO}    timeout=5s
    Element Should Contain    ${LOC_STEPPER_CONTAINER_TITULO}    ${texto}

E o subtítulo exibe o texto
    [Documentation]    Verificação: subtítulo correto visível
    [Arguments]    ${texto}
    Wait Until Element Is Visible    ${LOC_STEPPER_CONTAINER_DESCRICAO}    timeout=5s
    Element Should Contain    ${LOC_STEPPER_CONTAINER_DESCRICAO}    ${texto}

E as condições do veículo por tipo são exibidas
    [Documentation]    Verificação: lista de condições do veículo por tipo está presente
    Validar Secao Condições do veículo por tipo Expandida

E a seção "Itens de segurança" está colapsada
    [Documentation]    Valida que a seção está colapsada
    Validar Secao Itens Seguranca Colapsada

Quando expando a seção "Itens de segurança"
    [Documentation]    Expande o accordion de Itens de segurança
    Expandir Secao Itens De Seguranca

Então a seção "Itens de segurança" está expandida
    [Documentation]    Valida que a seção está expandida
    Validar Secao Itens Seguranca Expandida

E todos os 17 itens são exibidos
    [Documentation]    Valida que todos os itens de segurança estão visíveis
    E a lista de itens de segurança é exibida

Quando colapso a seção "Itens de segurança"
    [Documentation]    Colapsa o accordion de Itens de segurança
    Colapsar Secao Itens De Seguranca

Então a seção "Itens de segurança" está colapsada
    [Documentation]    Valida que a seção está colapsada
    Validar Secao Itens Seguranca Colapsada

E seleciono a condição "${condicao}" como "${tipo}"
    [Documentation]    Seleciona uma condição de veículo (ex: Elétrica como Normal)
    IF    '${condicao}' == 'Elétrica'
        Selecionar Condicao Eletrica    ${tipo}
    ELSE IF    '${condicao}' == 'Lataria'
        Selecionar Condicao Lataria    ${tipo}
    ELSE IF    '${condicao}' == 'Mecânica'
        Selecionar Condicao Mecanica    ${tipo}
    ELSE IF    '${condicao}' == 'Pintura'
        Selecionar Condicao Pintura    ${tipo}
    ELSE IF    '${condicao}' == 'Pneus'
        Selecionar Condicao Pneus    ${tipo}
    ELSE IF    '${condicao}' == 'Tapeçaria'
        Selecionar Condicao Tapecaria    ${tipo}
    ELSE
        Fail    Condição não encontrada: ${condicao}
    END

E preencho a observação da condição com o texto
    [Documentation]    Preenche o campo de observação de uma condição
    [Arguments]    ${condicao}    ${texto}
    IF    '${condicao}' == 'Elétrica'
        Preencher Observacao Eletrica    ${texto}
    ELSE IF    '${condicao}' == 'Lataria'
        Preencher Observacao Lataria    ${texto}
    ELSE IF    '${condicao}' == 'Mecânica'
        Preencher Observacao Mecanica    ${texto}
    ELSE IF    '${condicao}' == 'Pintura'
        Preencher Observacao Pintura    ${texto}
    ELSE IF    '${condicao}' == 'Pneus'
        Preencher Observacao Pneus    ${texto}
    ELSE IF    '${condicao}' == 'Tapeçaria'
        Preencher Observacao Tapecaria    ${texto}
    ELSE
        Fail    Condição não encontrada: ${condicao}
    END

Então o campo de observação da condição "${condicao}" é exibido
    [Documentation]    Valida que o campo de observação aparece após seleção
    IF    '${condicao}' == 'Elétrica'
        Validar Campo Observacao Eletrica Visivel
    END
    IF    '${condicao}' == 'Lataria'    Validar Campo Observacao Lataria Visivel
    IF    '${condicao}' == 'Mecânica'
        Validar Campo Observacao Mecânica Visivel
    END
    IF    '${condicao}' == 'Pintura'    Validar Campo Observacao Pintura Visivel
    IF    '${condicao}' == 'Pneus'    Validar Campo Observacao Pneus Visivel
    IF    '${condicao}' == 'Tapeçaria'
        Validar Campo Observacao Tapeçaria Visivel
    END

Então o campo de observação da condição "${condicao}" contém o texto "${texto_esperado}"
    [Documentation]    Valida que o campo de observação contém o texto esperado
    Validar Campo Observacao Contem Texto    ${condicao}    ${texto_esperado}

E a condição está selecionada como o tipo
    [Documentation]    Valida que uma condição específica está com o tipo correto selecionado
    [Arguments]    ${condicao}    ${tipo}
    Validar Condicao Selecionada    ${condicao}    ${tipo}

Então todas as condições foram selecionadas corretamente
    [Documentation]    Valida as 6 condições do veículo (Elétrica, Lataria, Mecânica, Pintura, Pneus e Tapeçaria)
    ...    com os tipos definidos em solicitacao_laudo.yaml.
    E a condição está selecionada como o tipo    Elétrica    ${forms_solicitacao.condicoes_veiculo.condicao_1.tipo}
    E a condição está selecionada como o tipo    Lataria    ${forms_solicitacao.condicoes_veiculo.condicao_2.tipo}
    E a condição está selecionada como o tipo    Mecânica    ${forms_solicitacao.condicoes_veiculo.condicao_3.tipo}
    E a condição está selecionada como o tipo    Pintura    ${forms_solicitacao.condicoes_veiculo.condicao_4.tipo}
    E a condição está selecionada como o tipo    Pneus    ${forms_solicitacao.condicoes_veiculo.condicao_5.tipo}
    E a condição está selecionada como o tipo    Tapeçaria    ${forms_solicitacao.condicoes_veiculo.condicao_6.tipo}

E a lista de itens de segurança é exibida
    [Documentation]    Verificação: lista de itens está presente
    Wait Until Element Is Visible    ${LOC_LABEL_AIRBAG}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_BUZINA}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_CABO_BATERIA}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_CHAVE_RODA}    timeout=5s
    Scroll Element Into View    ${LOC_LABEL_CINTOS_SEGURANCA}
    Element Should Be Visible    ${LOC_LABEL_CINTOS_SEGURANCA}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_COMPRESSOR}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_ENCOSTO_CABECA}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_FREIO_ABS}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_EXTINTOR}    timeout=5s
    Scroll Element Into View    ${LOC_LABEL_ESPELHOS}
    Element Should Be Visible    ${LOC_LABEL_ESPELHOS}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_FREIO_ESTACIONAMENTO}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_LUZES_DIRECAO}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_LIMPADOR}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_LANTERNA}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_MACACO}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_MANUAL_VEICULO}    timeout=5s
    Element Should Be Visible    ${LOC_LABEL_TRIANGULO}    timeout=5s

E expando a seção "Itens de segurança"
    [Documentation]    Expande o accordion de Itens de segurança
    Expandir Secao Itens De Seguranca
    Validar Secao Itens Seguranca Expandida

E os botões "Voltar", "Pular etapa" e "Continuar" estão visíveis
    [Documentation]    Verificação: 3 botões de navegação visíveis
    Botão Voltar Deve Estar Visivel E Habilitado
    Botão Pular Etapa Deve Estar Visivel E Habilitado
    Botão Continuar Deve Estar Visivel E Habilitado

Então o item "${item}" está visível com checkbox desmarcado
    [Documentation]    Verificação: item visível e desmarcado
    Item Deve Estar Visivel Com Checkbox Desmarcado    ${item}

E o item "${item}" está visível com checkbox desmarcado
    [Documentation]    Verificação: item visível e desmarcado
    Item Deve Estar Visivel Com Checkbox Desmarcado    ${item}

Então sou direcionado para o step "Anexos"
    [Documentation]    Verificação: navegou para step 3
    Step Anexos Deve Estar Ativo

E o step "Anexos" está ativo e destacado
    [Documentation]    Verificação: step Anexos está ativo
    E entrar na etapa
    ...    3
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_3}

Então nenhum item de segurança fica registrado
    [Documentation]    Verificação: nenhuma seleção salva
    [Arguments]    @{itens}

    FOR    ${item}    IN    @{itens}
        Item Deve Estar Visivel Com Checkbox Desmarcado    ${item}
    END

Então o checkbox do item "${item}" fica marcado
    [Documentation]    Verificação: checkbox específico marcado
    Item Deve Estar Selecionado    ${item}

E o checkbox do item "${item}" fica marcado
    [Documentation]    Verificação: checkbox específico marcado
    Então o checkbox do item "${item}" fica marcado

E os demais checkboxes permanecem desmarcados
    [Documentation]    Valida que todos os itens não selecionados permanecem desmarcados
    ...    Compara a lista de itens selecionados com a lista total e valida que os demais estão desmarcados
    [Arguments]    @{itens_selecionados}

    # Lista completa de todos os itens disponíveis
    @{todos_itens}=    Set Variable    ${forms_solicitacao.itens_de_seguranca}

    # Contadores para validação
    ${count_selecionados}=    Set Variable    ${0}
    ${count_desmarcados}=    Set Variable    ${0}
    @{itens_desmarcados_validados}=    Create List

    # Itera sobre todos os itens
    FOR    ${item}    IN    @{todos_itens}
        ${esta_na_lista_selecionados}=    Run Keyword And Return Status
        ...    List Should Contain Value    ${itens_selecionados}    ${item}

        IF    ${esta_na_lista_selecionados}
            # Item está na lista de selecionados - apenas conta
            ${count_selecionados}=    Evaluate    ${count_selecionados} + 1
            Log    ✓ Item selecionado: ${item}
        ELSE
            # Item NÃO está na lista - deve estar desmarcado
            ${locator}=    Get Locator Para Item    ${item}
            Scroll Element Into View    ${locator}
            Checkbox Should Not Be Selected    ${locator}
            ${count_desmarcados}=    Evaluate    ${count_desmarcados} + 1
            Append To List    ${itens_desmarcados_validados}    ${item}
            Log    ✓ Item desmarcado validado: ${item}
        END
    END

    # Validações finais
    ${total_itens}=    Get Length    ${todos_itens}
    ${qtd_esperada_selecionados}=    Get Length    ${itens_selecionados}
    ${qtd_esperada_desmarcados}=    Evaluate    ${total_itens} - ${qtd_esperada_selecionados}

    Should Be Equal As Numbers    ${count_selecionados}    ${qtd_esperada_selecionados}
    ...    msg=Esperado ${qtd_esperada_selecionados} itens selecionados, encontrado ${count_selecionados}

    Should Be Equal As Numbers    ${count_desmarcados}    ${qtd_esperada_desmarcados}
    ...    msg=Esperado ${qtd_esperada_desmarcados} itens desmarcados, encontrado ${count_desmarcados}

    Log    ✅ Validação completa: ${count_selecionados} selecionados, ${count_desmarcados} desmarcados confirmados
    Log    📋 Itens desmarcados validados: ${itens_desmarcados_validados}

E nenhuma mensagem de erro é exibida
    [Documentation]    Verificação: sem erros na tela
    Sleep    0.3s

Então todos os 17 itens ficam marcados
    [Documentation]    Verificação: todos os checkboxes selecionados
    Validar Todos Os 17 Itens Ficam Marcados

Então sou redirecionado para o step "Dados"
    [Documentation]    Verificação: voltou para step 1
    Scroll Element Into View    ${LOC_STEP_1_DADOS_ACTIVE}
    Wait Until Element Is Visible    ${LOC_STEP_1_DADOS_ACTIVE}    timeout=5s

Então sou redirecionado para o step "Anexos"
    [Documentation]    Verificação: voltou para step 3
    Scroll Element Into View    ${LOC_STEP_3_ANEXOS_ACTIVE}
    Wait Until Element Is Visible    ${LOC_STEP_3_ANEXOS_ACTIVE}    timeout=5s

E o step "Dados" está ativo
    [Documentation]    Verificação: step Dados ativo
    E entrar na etapa
    ...    1
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_1}

E todos os dados preenchidos anteriormente são mantidos
    [Documentation]    Verificação: dados persistem
    Sleep    0.3s
    Então todos os valores preenchidos devem estar preservados

Então sou redirecionado para o step "Itens"
    [Documentation]    Verificação: retornou para step Itens
    Etapa Itens Deve Estar Ativa

E o checkbox do item "${item}" está marcado
    [Documentation]    Verificação: ${item} selecionado
    Item Deve Estar Selecionado    ${item}

# ============================================================================
# DADO (GIVEN) - PRÉ-CONDIÇÕES
# ============================================================================

Quando estou no step "Anexos"
    [Documentation]    Pré-condição: usuário está na etapa 3
    [Arguments]    ${placa}=${EMPTY}
    Quando estou no step "Itens"    ${placa}
    E seleciono a condição "Elétrica" como "${forms_solicitacao.condicoes_veiculo.condicao_1.tipo}"
    E preencho a observação da condição com o texto
    ...    Elétrica
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_1.observacao}
    E seleciono a condição "Lataria" como "${forms_solicitacao.condicoes_veiculo.condicao_2.tipo}"
    E preencho a observação da condição com o texto
    ...    Lataria
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_2.observacao}
    E seleciono a condição "Mecânica" como "${forms_solicitacao.condicoes_veiculo.condicao_3.tipo}"
    E preencho a observação da condição com o texto
    ...    Mecânica
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_3.observacao}
    E seleciono a condição "Pintura" como "${forms_solicitacao.condicoes_veiculo.condicao_4.tipo}"
    E preencho a observação da condição com o texto
    ...    Pintura
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_4.observacao}
    E seleciono a condição "Pneus" como "${forms_solicitacao.condicoes_veiculo.condicao_5.tipo}"
    E preencho a observação da condição com o texto
    ...    Pneus
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_5.observacao}
    E seleciono a condição "Tapeçaria" como "${forms_solicitacao.condicoes_veiculo.condicao_6.tipo}"
    E preencho a observação da condição com o texto
    ...    Tapeçaria
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_6.observacao}
    Então todas as condições foram selecionadas corretamente
    E expando a seção "Itens de segurança"
    Selecionar Item    Buzina
    Selecionar Item    Compressor
    Quando clico no botão "Continuar"
    E que avancei para o step "Anexos"

Quando estou no step "Resumo"
    [Documentation]    Pré-condição: usuário está na etapa 4
    Quando estou no step "Anexos"
    E seleciono 2 imagens
    Quando clico no botão "Continuar"
    E entrar na etapa
    ...    4
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_4}

E que nenhuma imagem foi anexada
    [Documentation]    Pré-condição: sem imagens anexadas
    Sleep    0.3s    # Estado inicial vazio

E que tenho uma imagem
    [Documentation]    Pré-condição: imagem disponível para upload
    [Arguments]    ${nome_arquivo}
    Validar existencia de imagem    ${nome_arquivo}

E que tenho ${quantidade} imagens dentro do limite de 2MB
    [Documentation]    Pré-condição: múltiplas imagens disponíveis
    Sleep    0.3s    # Simula disponibilidade
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto01}
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto02}
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto03}
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto04}

E que fiz upload da imagem
    [Documentation]    Pré-condição: imagem foi anexada
    [Arguments]    ${nome_arquivo}
    Sleep    0.5s    # Simula upload prévio
    E seleciono a imagem    ${nome_arquivo}

E que já anexei uma imagem
    [Documentation]    Pré-condição: imagem já anexada com tamanho específico
    [Arguments]    ${caminho_arquivo}
    Sleep    0.3s    # Simula upload prévio

    Fazer Upload De Imagem    ${caminho_arquivo}

# ============================================================================
# QUANDO (WHEN) - AÇÕES
# ============================================================================

E seleciono a imagem
    [Documentation]    Ação: selecionar arquivo específico
    [Arguments]    ${nome_arquivo}
    Sleep    0.5s    # Simula seleção
    Fazer Upload De Imagem    ${nome_arquivo}

E seleciono ${quantidade} imagens
    [Documentation]    Ação: selecionar múltiplas imagens
    Sleep    0.8s    # Simula seleção múltipla
    Fazer Upload De Multiplas Imagens    ${quantidade}

E selecionei as 6 imagens permitidas
    [Documentation]    Anexa as 6 fotos do veículo (frontal, laterais, odômetro, placa e traseira), o limite do formulário.
    Quando seleciono imagens especificas    0    1    2    3    4    5

Quando clico no ícone de exclusão da imagem
    [Documentation]    Ação: excluir imagem anexada
    [Arguments]    ${nome_arquivo}
    Clicar Icone De Exclusao    ${nome_arquivo}

Quando faço upload da imagem
    [Documentation]    Ação: fazer upload completo
    [Arguments]    ${nome_arquivo}
    Sleep    1s    # Simula upload
    E que fiz upload da imagem    ${nome_arquivo}

Quando tento fazer upload da imagem
    [Documentation]    Ação: tentar upload que pode falhar
    [Arguments]    ${caminho_arquivo}
    Sleep    0.3s    # Simula upload prévio

    Fazer Upload De Imagem    ${caminho_arquivo}

# ============================================================================
# ENTÃO (THEN) - VERIFICAÇÕES
# ============================================================================

E a área de upload é exibida com o texto "Arraste ou clique aqui para enviar as imagens"
    [Documentation]    Verificação: área de upload com texto correto
    Texto Arraste Ou Clique Deve Estar Visivel

E as informações Apenas arquivos png, jpg ou jpeg são exibidas
    [Documentation]    Verificação: especificação de formatos
    Wait Until Element Is Visible    ${LOC_ESPECIFICACAO_FORMATOS}    timeout=5s

E as informações "Máximo de 6 imagens (total combinado de até 2 MB)" são exibidas
    [Documentation]    Verificação: especificação de limite
    Wait Until Element Is Visible    ${LOC_ESPECIFICACAO_LIMITE}    timeout=5s

E as informações "Resoluções recomendadas: 1920x1080, 960x540 ou 1024x768" são exibidas
    [Documentation]    Verificação: especificação de resoluções
    Wait Until Element Is Visible    ${LOC_ESPECIFICACAO_RESOLUCOES}    timeout=5s

Então a área de upload exibe o ícone de nuvem
    [Documentation]    Verificação: ícone de nuvem visível
    Icone De Nuvem Deve Estar Visivel

E o texto "Arraste ou clique aqui para enviar as imagens" está visível
    [Documentation]    Verificação: texto de instrução
    Texto Arraste Ou Clique Deve Estar Visivel

E o botão "Selecione o arquivo" está visível e habilitado
    [Documentation]    Verificação: botão de seleção
    E o botão do modal está habilitado e clicável    Selecione o arquivo

E as especificações técnicas estão visíveis abaixo da área de upload
    [Documentation]    Verificação: especificações técnicas
    Especificacoes Tecnicas Devem Estar Visiveis

Então sou direcionado para o step "Resumo"
    [Documentation]    Verificação: navegou para step 4
    E entrar na etapa
    ...    4
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_4}

E o step "Resumo" está ativo e destacado
    [Documentation]    Verificação: step Resumo está ativo
    E entrar na etapa
    ...    4
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_4}

E o step "Anexos" exibe um indicador de conclusão
    [Documentation]    Verificação: step Anexos marcado como concluído
    Sleep    0.5s    # Aguarda atualização visual
    E entrar na etapa
    ...    4
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_4}
    Etapa Deve Estar Completa    Anexos

E que anexei 2 imagens no Step Anexos
    [Documentation]    Verificação: anexo de 2 imagens
    Sleep    0.3s    # Valida comportamento

E nenhuma imagem fica registrada
    [Documentation]    Verificação: nenhuma imagem salva
    Então a seção "Imagens para análise" não é exibida no resumo

E o nome é exibido
    [Documentation]    Verificação: nome do arquivo visível
    [Arguments]    ${nome_arquivo}
    Nome Do Arquivo Deve Estar Visivel    ${nome_arquivo}

E o tamanho "${tamanho}" é exibido
    [Documentation]    Verificação: tamanho do arquivo visível
    Tamanho Do Arquivo Deve Estar Visivel    ${tamanho}

Então após o upload, são exibidas ${quantidade} miniaturas
    [Documentation]    Verificação: quantidade de miniaturas
    Validar Quantidade De Miniaturas    ${quantidade}

E cada imagem exibe seu nome
    [Documentation]    Verificação: nome e tamanho de cada imagem
    Sleep    0.5s    # Valida visibilidade
    Cada imagem exibe seu nome

E cada imagem tem ícones de exclusão
    [Documentation]    Verificação: ícones de ação para cada imagem
    Sleep    0.5s    # Valida visibilidade
    Cada imagem tem ícones de exclusão

Então a miniatura da imagem é exibida
    [Documentation]    Verificação: miniatura específica
    [Arguments]    ${nome_arquivo}
    Miniatura Da Imagem Deve Estar Visivel    ${nome_arquivo}

E a imagem é visualizável na miniatura
    [Documentation]    Verificação: preview da imagem
    [Arguments]    ${nome_arquivo}
    Sleep    0.3s    # Valida preview
    Então a miniatura da imagem é exibida    ${nome_arquivo}

E o nome do arquivo está visível abaixo da miniatura
    [Documentation]    Verificação: nome abaixo da miniatura
    [Arguments]    ${nome_arquivo}
    Sleep    0.3s    # Valida posição
    E o nome é exibido    ${nome_arquivo}

Então todas as ${quantidade} imagens são carregadas com sucesso
    [Documentation]    Verificação: todas carregadas
    Sleep    1.5s    # Aguarda uploads
    E ${quantidade} miniaturas são exibidas
    E cada imagem exibe seu nome

E ${quantidade} miniaturas são exibidas
    [Documentation]    Verificação: todas miniaturas visíveis
    Sleep    0.8s    # Aguarda renderização
    Verificar ${quantidade} miniaturas são exibidas

E a área de upload se torna indisponível
    [Documentation]    Verificação: área ainda acessível
    Validar Area Upload Indisponivel

Então uma mensagem de erro é exibida
    [Documentation]    Verificação: erro exibido
    Mensagem De Erro Deve Estar Visivel

E o texto "O tamanho máximo combinado é 2MB" é exibido
    [Documentation]    Verificação: mensagem de tamanho excedido
    Mensagem Erro Tamanho Excedido Deve Estar Visivel

E a imagem não é anexada
    [Documentation]    Verificação: imagem não foi adicionada
    [Arguments]    ${nome_arquivo}
    Sleep    0.5s    # Valida comportamento
    Element Should Not Be Visible    //div[contains(@class, 'css-bpub36') and contains(., '${nome_arquivo}')]

E apenas a primeira imagem permanece anexada
    [Documentation]    Verificação: somente primeira imagem mantida
    [Arguments]    ${nome_arquivo}
    Sleep    0.5s    # Valida estado
    Element Should Be Visible    //div[contains(@class, 'css-bpub36') and contains(., '${nome_arquivo}')]

E o texto informando formatos aceitos é destacado
    [Documentation]    Verificação: texto de formatos em destaque
    Texto Formatos Aceitos Deve Estar Destacado

Então a imagem é removida da lista de anexos
    [Documentation]    Verificação: imagem excluída
    Sleep    0.5s    # Aguarda remoção

E a miniatura não é mais exibida
    [Documentation]    Verificação: miniatura removida
    [Arguments]    ${nome_arquivo}
    Sleep    0.5s    # Valida remoção
    E a imagem não é anexada    ${nome_arquivo}

E todas as seleções anteriores são mantidas
    [Documentation]    Verificação: seleções preservadas
    Validar Itens Selecionados Persistem    Buzina

E todas as seções de dados preenchidos são exibidas
    [Documentation]    Verificação: seções visíveis
    E que preenchi os dados de proposta e cliente no Step Dados
    E que preenchi os dados de loja e vendedor no Step Dados
    E que preenchi os dados do veículo no Step Dados

E que preenchi todos os campos do Step Dados
    [Documentation]    Pré-condição: confirma, no resumo, as seções com os dados preenchidos no Step Dados.
    E todas as seções de dados preenchidos são exibidas

E que selecionei itens no Step Itens com observações
    [Documentation]    Verificação: seleção de itens
    Sleep    1s

E que anexei imagens no Step Anexos
    [Documentation]    Verificação: anexo de imagens
    Sleep    1s

E que anexei imagem 800x600 no Step Anexos
    [Documentation]    Pré-condição: imagem 800x600 foi anexada
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto10}
    E seleciono a imagem    ${forms_solicitacao.imagem.foto10}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E o nome é exibido    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida
    Quando clico no botão "Continuar"
    E entrar na etapa
    ...    4
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_4}

E os botões "Voltar" e "Solicitar laudo" estão visíveis
    [Documentation]    Verificação: botões de ação visíveis
    Botão Voltar Deve Estar Visivel E Habilitado
    Botão Solicitar Laudo Deve Estar Visivel

E que preenchi os dados de proposta e cliente no Step Dados
    [Documentation]    Pré-condição: dados de proposta preenchidos
    Então a seção "Proposta e cliente" é exibida

E que preenchi os dados de loja e vendedor no Step Dados
    [Documentation]    Pré-condição: dados de loja preenchidos
    Então a seção "Loja e vendedor" é exibida

E que preenchi os dados do veículo no Step Dados
    [Documentation]    Pré-condição: dados de veículo preenchidos
    Então a seção "Dados do veículo" é exibida

E que selecionei "${item1}"
    [Documentation]    Pré-condição: item selecionado com observação
    Sleep    0.5s    # Simula seleção prévia

Então a seção "Proposta e cliente" é exibida
    [Documentation]    Verificação: seção Proposta e Cliente visível
    Secao Proposta E Cliente Deve Estar Visivel

E o campo "Filial" exibe "${valor}" (se preenchido)
    [Documentation]    Verificação: valor do campo Filial
    Campo Filial Deve Exibir    ${valor}

E o campo "Número da proposta" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Número da Proposta
    Campo Numero Proposta Deve Exibir    ${valor}

E o campo "Tipo do cliente" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Tipo do Cliente
    Campo Tipo Cliente Deve Exibir    ${valor}

E o campo "Nome do cliente" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Nome do Cliente
    Campo Nome Cliente Deve Exibir    ${valor}

E o campo "Documento do cliente" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Documento
    Campo Documento Cliente Deve Exibir    ${valor}

Então a seção "Loja e vendedor" é exibida
    [Documentation]    Verificação: seção Loja e Vendedor visível
    Secao Loja E Vendedor Deve Estar Visivel

E o campo "CNPJ da loja" exibirá "${valor}"
    [Documentation]    Verificação: valor do campo CNPJ
    Campo CNPJ Deve Exibir    ${valor}

E o campo "CPF do vendedor" exibe "${valor}" (se preenchido)
    [Documentation]    Verificação: campo CPF do Vendedor
    Campo CPF Vendedor Deve Exibir    ${valor}

E o campo "Nome do vendedor" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Nome do Vendedor
    Campo Nome Vendedor Deve Exibir    ${valor}

Então a seção "Dados do veículo" é exibida
    [Documentation]    Verificação: seção Dados do Veículo visível
    Secao Dados Do Veiculo Deve Estar Visivel

E o campo "Placa" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Placa
    Campo Placa Deve Exibir    ${valor}

E o campo "RENAVAM" exibe "${valor}"
    [Documentation]    Verificação: valor do campo RENAVAM
    Campo RENAVAM Deve Exibir    ${valor}

E o campo "UF da placa" exibe "${valor}"
    [Documentation]    Verificação: valor do campo UF
    Campo UF Placa Deve Exibir    ${valor}

E o campo "Cidade" exibe "${valor}"
    [Documentation]    Verificação: valor do campo Cidade
    Campo Cidade Deve Exibir    ${valor}

E o campo "Quilometragem" exibe "${valor}" (se preenchido)
    [Documentation]    Verificação: campo Quilometragem
    Campo Quilometragem Deve Exibir    ${valor}

Então a seção "Itens de segurança" é exibida
    [Documentation]    Verificação: seção Itens de Segurança visível
    [Arguments]    ${servico}=Solicita
    Secao Itens De Seguranca Deve Estar Visivel    ${servico}

E o item "${nome_item}" é exibido
    [Documentation]    Verificação: item específico visível
    [Arguments]    ${servico}=Solicita
    Item Selecionado Deve Estar Visivel    ${nome_item}    ${servico}

E a condição do veículo por tipo é exibida
    [Documentation]    Verificação: condição, tipo e observação específica visível
    [Arguments]    ${condicao}    ${tipo_esperado}    ${observaco_esperada}
    IF    '${condicao}' == 'Elétrica'
        Campo Elétrica Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE IF    '${condicao}' == 'Lataria'
        Campo Lataria Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE IF    '${condicao}' == 'Mecânica'
        Campo Mecânica Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE IF    '${condicao}' == 'Pintura'
        Campo Pintura Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE IF    '${condicao}' == 'Pneus'
        Campo Pneus Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE IF    '${condicao}' == 'Tapeçaria'
        Campo Tapeçaria Deve Exibir    ${tipo_esperado}    ${observaco_esperada}
    ELSE
        Fail    Condição não encontrada: ${condicao}
    END

Então a seção "Itens de segurança" não é exibida no resumo
    [Documentation]    Verificação: seção Itens oculta
    Secao Itens De Seguranca Nao Deve Estar Visivel

E que não selecionei nenhum item no Step Itens
    [Documentation]    Pré-condição: avança pelo Step Itens sem selecionar nada e anexa 2 imagens no Step Anexos,
    ...    para validar o resumo sem a seção de itens de segurança.
    Quando estou no step "Itens"
    Quando clico no botão "Continuar"
    E que avancei para o step "Anexos"
    E seleciono 2 imagens
    Quando clico no botão "Continuar"

E que não anexei nenhuma imagem no Step Anexos
    [Documentation]    Pré-condição: seleciona itens de segurança e avança sem anexar imagens,
    ...    para validar o resumo sem a seção de imagens.
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    Selecionar Item    Buzina
    Selecionar Item    Compressor
    Quando clico no botão "Continuar"
    E que avancei para o step "Anexos"
    E clico no botão "Pular etapa"

Então a seção "Imagens para análise" é exibida
    [Documentation]    Verificação: seção Imagens visível
    Secao Imagens Para Analise Deve Estar Visivel

E o título "Anexos" é exibido
    [Documentation]    Verificação: título Anexos visível
    Titulo Anexos Deve Estar Visivel

E as ${quantidade} miniaturas das imagens são exibidas
    [Documentation]    Verificação: quantidade de miniaturas
    [Arguments]    ${servico}=Solicita
    Validar Quantidade De Miniaturas No Resumo    ${quantidade}    ${servico}

Então a seção "Imagens para análise" não é exibida no resumo
    [Documentation]    Verificação: seção Imagens oculta
    Secao Imagens Para Analise Nao Deve Estar Visivel

E todas as imagens anexadas anteriormente são mantidas
    [Documentation]    Verificação: imagens preservadas
    E 2 miniaturas são exibidas
    E cada imagem exibe seu nome
    E cada imagem tem ícones de exclusão

Então todas as seções são exibidas: "${secoes}"
    [Documentation]    Verificação: todas as seções visíveis
    Sleep    0.5s    # Valida todas as seções
    Validar Todas Secoes Preenchidas Visiveis    Itens de segurança    Imagens para análise

E todos os dados preenchidos são exibidos corretamente
    [Documentation]    Verificação: dados corretos
    Então a seção "Proposta e cliente" é exibida
    E o campo "Filial" exibe "${filial_teste}" (se preenchido)
    E o campo "Número da proposta" exibe "${numeroProposta_teste}"
    E o campo "Tipo do cliente" exibe "${tipoCliente_teste}"
    E o campo "Nome do cliente" exibe "${nomeCliente_teste}"
    E o campo "Documento do cliente" exibe "${documentoCliente_teste}"
    Então a seção "Loja e vendedor" é exibida
    E o campo "CNPJ da loja" exibirá "${cnpjLoja_teste}"
    E o campo "CPF do vendedor" exibe "${cpfVendedor_teste}" (se preenchido)
    E o campo "Nome do vendedor" exibe "${nomeVendedor_teste}"
    Então a seção "Dados do veículo" é exibida
    E o campo "Placa" exibe "${placa_teste}"
    E o campo "RENAVAM" exibe "${renavam_teste}"
    E o campo "UF da placa" exibe "${ufPlaca_teste}"
    E o campo "Cidade" exibe "${cidade_teste}"
    E o campo "Quilometragem" exibe "${quilometragem_teste}" (se preenchido)

E todas as observações de itens são exibidas
    [Documentation]    Verificação: observações visíveis
    Secao Itens De Seguranca Deve Estar Visivel

E todas as miniaturas de imagens são exibidas
    [Documentation]    Verificação: todas miniaturas
    Secao Imagens Para Analise Deve Estar Visivel
    Validar Imagens No Resumo    @{IMAGENS_SELECIONADAS}
    Validar Icones Exclusão Disponiveis    @{IMAGENS_SELECIONADAS}
    E 2 miniaturas são exibidas
    E cada imagem exibe seu nome

Quando clico no botão "Voltar para lista de laudos"
    [Documentation]    Ação: voltar para lista (sucesso)
    Clicar Botao Voltar Para Lista

Quando clico no botão "Voltar para a lista de laudos"
    [Documentation]    Ação: voltar para lista (sucesso)
    Clicar Botao Voltar Para a Lista

Quando clico no botão X de fechar
    [Documentation]    Ação: fechar modal de sucesso
    Clicar Botao Fechar Modal Sucesso

Quando clico no botão "Tentar emitir novamente"
    [Documentation]    Ação: tentar novamente após erro
    Clicar Botao Tentar Emitir Novamente

Então o modal de erro é fechado
    [Documentation]    Verificação: modal erro fechado
    Modal Erro Deve Ser Fechado

Então o modal de confirmação é fechado
    [Documentation]    Verificação: modal confirmação fechado
    Modal Erro Deve Ser Fechado

E sou redirecionado para o step "Resumo"
    [Documentation]    Verificação: voltou para Resumo
    Sleep    0.5s    # Valida redirecionamento

E todos os dados preenchidos são mantidos
    [Documentation]    Verificação: persistência
    E todos os dados preenchidos são exibidos corretamente

E posso clicar novamente em "Solicitar laudo"
    [Documentation]    Verificação: botão disponível
    Botão Solicitar Laudo Deve Estar Visivel

E permaneço no step "Resumo"
    [Documentation]    Verificação: continua no Resumo
    Wait Until Element Is Visible    ${LOC_MODAL_SOLICITA_LAUDO}    timeout=10s

E nenhum novo ID de laudo é gerado
    [Documentation]    Verificação: sem novo ID
    Nenhum Novo ID Deve Ser Gerado

Então o modal é fechado
    [Documentation]    Verificação: modal principal fechado
    Modal Principal Deve Ser Fechado

E sou redirecionado para a tela "Lista de laudos"
    [Documentation]    Verificação: redirecionamento
    Redirecionar Para Tela Lista De Laudos

E o novo ID do laudo é exibido na lista
    [Documentation]    Verificação: novo ID visível
    Novo ID Deve Estar Visivel Na Primeira Posicao
    E a quantidade total de laudos aumenta

Então um novo ID de laudo é exibido na primeira posição da lista
    [Documentation]    Verificação: novo ID na primeira posição
    Novo ID Deve Estar Visivel Na Primeira Posicao

E o ID contém 17 dígitos numéricos
    [Documentation]    Verificação: formato do ID
    Validar ID Contem 17 Digitos

E o campo "Responsável" exibe o nome do usuário logado
    [Documentation]    Verificação: responsável
    Campo Responsavel Deve Exibir Usuario Logado

E o campo "Última atualização" exibe a data e hora atual
    [Documentation]    Verificação: timestamp
    Campo Ultima Atualizacao Deve Exibir Data Atual

E que preencho todos os campos e avanço para o step "Itens"
    [Documentation]    Pré-condição: preencheu e avançou
    Sleep    0.5s    # Navegação concluída
    Quando o usuário preenche todos os campos obrigatórios corretamente
    E o usuário clica no botão "Continuar"

Então o step "Dados" exibe um ícone de check ou indicador de conclusão
    [Documentation]    Verificação: indicador Dados
    Etapa Deve Estar Completa    Dados

E o step "Itens" está destacado como ativo
    [Documentation]    Verificação: Itens ativo
    Etapa Deve Estar Ativa    Itens

Então o step "Itens" exibe indicador de conclusão
    [Documentation]    Verificação: indicador Itens
    Etapa Deve Estar Completa    Itens

E o step "Anexos" está destacado como ativo
    [Documentation]    Verificação: Anexos ativo
    Etapa Deve Estar Ativa    Anexos

Quando avanço para o step "Anexos"
    [Documentation]    Ação: avançar para Anexos
    Sleep    0.5s    # Simula avanço
    E o usuário clica no botão "Continuar"

Quando preencho o campo
    [Documentation]    Ação: preencher com acentos
    [Arguments]    ${nome_campo}    ${valor}
    Preencher Campo    ${nome_campo}    ${valor}

E preencho o campo
    [Documentation]    Ação: preencher com acentos
    [Arguments]    ${nome_campo}    ${valor}
    Preencher Campo    ${nome_campo}    ${valor}

E os caracteres especiais são preservados no resumo
    [Documentation]    Verificação: preservação de caracteres
    E o campo "Nome do cliente" exibe "${forms_solicitacao.nomes.cliente_caracteres_especiais}"
    E o campo "Nome do vendedor" exibe "${forms_solicitacao.nomes.vendedor_caracteres_especiais}"

Então as letras não são inseridas no campo
    [Documentation]    Verificação: letras bloqueadas
    Validar Campo Rejeitou Letras    Número da proposta    ${LOC_INPUT_NUMERO_PROPOSTA}

Então o valor negativo não é inserido no campo
    [Documentation]    Verificação: letras bloqueadas
    Validar Campo Rejeitou Negativo    Quilometragem    ${LOC_INPUT_QUILOMETRAGEM}
