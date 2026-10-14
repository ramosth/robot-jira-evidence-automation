*** Settings ***
Documentation       Keywords genéricas e específicas para Solicitação de Laudo

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# KEYWORDS GENÉRICAS - MODAL
# ============================================================================
Abrir Modal Solicitar Laudo
    [Documentation]    Abre o modal de solicitação de laudo clicando no botão principal
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_LAUDO_PRINCIPAL}    timeout=10s
    Click Element    ${LOC_BTN_SOLICITAR_LAUDO_PRINCIPAL}
    Wait Until Element Is Visible    ${LOC_MODAL_SOLICITA_LAUDO}    timeout=10s

Fechar Modal
    [Documentation]    Fecha o modal clicando no botão X ou Cancelar
    [Arguments]    ${metodo}=X
    IF    '${metodo}' == 'X'
        Click Element    ${LOC_BTN_FECHAR_MODAL}
    ELSE IF    '${metodo}' == 'Cancelar'
        Click Element    ${LOC_BTN_CANCELAR}
    END
    Wait Until Element Is Not Visible    ${LOC_MODAL_SOLICITA_LAUDO}    timeout=5s

Modal Deve Estar Visível
    [Documentation]    Valida que o modal está aberto e visível
    Wait Until Element Is Visible    ${LOC_MODAL_SOLICITA_LAUDO}    timeout=10s
    Element Should Be Visible    ${LOC_MODAL_TITLE}

Modal Deve Estar Fechado
    [Documentation]    Valida que o modal está fechado e não visível
    Wait Until Element Is Not Visible    ${LOC_MODAL_SOLICITA_LAUDO}    timeout=10s

# ============================================================================
# KEYWORDS GENÉRICAS - NAVEGAÇÃO ENTRE ETAPAS
# ============================================================================

Clicar Botão Continuar
    [Documentation]    Clica no botão Continuar para avançar para próxima etapa
    Wait Until Element Is Visible    ${LOC_BTN_CONTINUAR}    timeout=5s
    Click Element    ${LOC_BTN_CONTINUAR}

Clicar Botão Cancelar
    [Documentation]    Clica no botão Cancelar para fechar o modal
    Wait Until Element Is Visible    ${LOC_BTN_CANCELAR}    timeout=5s
    Click Element    ${LOC_BTN_CANCELAR}

# ============================================================================
# KEYWORDS GENÉRICAS - ETAPAS (STEPPER)
# ============================================================================

Etapa Deve Estar Ativa
    [Documentation]    Valida que uma etapa específica está ativa
    [Arguments]    ${etapa}
    IF    '${etapa}' == 'Dados'
        ${locator}=    Set Variable    ${LOC_STEP_1_DADOS_ACTIVE}
    ELSE IF    '${etapa}' == 'Itens'
        ${locator}=    Set Variable    ${LOC_STEP_2_ITENS_ACTIVE}
    ELSE IF    '${etapa}' == 'Anexos'
        ${locator}=    Set Variable    ${LOC_STEP_3_ANEXOS_ACTIVE}
    ELSE
        ${locator}=    Fail    Etapa inválida: ${etapa}
    END
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}

Etapa Deve Estar Completa
    [Documentation]    Valida que uma etapa foi completada (tem indicador de conclusão)
    [Arguments]    ${etapa}
    IF    '${etapa}' == 'Dados'
        ${locator}=    Set Variable    ${LOC_STEP_1_DADOS_COMPLETED}
    ELSE IF    '${etapa}' == 'Itens'
        ${locator}=    Set Variable    ${LOC_STEP_2_ITENS_COMPLETED}
    ELSE IF    '${etapa}' == 'Anexos'
        ${locator}=    Set Variable    ${LOC_STEP_3_ANEXOS_COMPLETED}
    ELSE
        ${locator}=    Fail    Etapa inválida: ${etapa}
    END
    Wait Until Element Is Visible    ${locator}    timeout=5s

# ============================================================================
# KEYWORDS GENÉRICAS - CAMPOS DE FORMULÁRIO
# ============================================================================

Preencher Campo
    [Documentation]    Preenche um campo de texto com valor fornecido
    [Arguments]    ${campo}    ${valor}
    ${locator}=    Get Locator Para Campo    ${campo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    # Seleciona todo o texto (Ctrl+A) e deleta
    Press Keys    ${locator}    CTRL+a    DELETE
    Input Text    ${locator}    ${valor}

Preencher Campo Observação
    [Documentation]    Preenche um campo de texto com valor fornecido
    [Arguments]    ${campo}    ${valor}
    Wait Until Element Is Visible    ${campo}    timeout=5s
    # Seleciona todo o texto (Ctrl+A) e deleta
    Press Keys    ${campo}    CTRL+a    DELETE
    Input Text    ${campo}    ${valor}

Selecionar Opcao
    [Documentation]    Seleciona uma opção em campo select
    [Arguments]    ${campo}    ${elemento_escolhido}

    ${locator}=    Get Locator Para Campo    ${campo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Click Element    ${locator}
    ${xpath}=    Set Variable    //ul/li[@role='option' and contains(text(), '${elemento_escolhido}')]
    Wait Until Element Is Enabled    ${xpath}    20s
    Scroll Element Into View    ${xpath}
    Sleep    2s
    Click Element    ${xpath}
    Sleep    2s

Campo Deve Estar Visível
    [Documentation]    Valida que um campo está visível na tela
    [Arguments]    ${campo}
    ${locator}=    Get Locator Para Campo    ${campo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Scroll Element Into View    ${locator}

Campo Deve Conter Texto Opcional
    [Documentation]    Valida que um campo tem marcação (opcional) no label
    [Arguments]    ${campo}
    ${locator}=    Get Locator Para Texto Opcional    ${campo}
    Element Should Be Visible    ${locator}

Campo Deve Estar Invalido
    [Documentation]    Valida que um campo está marcado como inválido (classe is-invalid)
    [Arguments]    ${campo}
    ${locator}=    Get Locator Para Campo Invalido    ${campo}
    Wait Until Element Is Visible    ${locator}    timeout=15s

Campo Nao Deve Estar Invalido
    [Documentation]    Valida que um campo NÃO está marcado como inválido
    [Arguments]    ${campo}
    ${locator}=    Get Locator Para Campo    ${campo}
    ${classes}=    Get Element Attribute    ${locator}    class
    Should Not Contain    ${classes}    is-invalid

Valor Do Campo Deve Ser
    [Documentation]    Valida que o valor de um campo é o esperado
    [Arguments]    ${campo}    ${valor_esperado}
    ${locator}=    Get Locator Para Campo    ${campo}
    IF    '${campo}' == 'Tipo do cliente' or '${campo}' == 'UF da placa'
        ${valor_atual}=    Get Text    ${locator}
    ELSE
        ${valor_atual}=    Get Value    ${locator}
    END
    Should Be Equal    ${valor_atual}    ${valor_esperado}

Obter Item Aleatorio Do Array
    [Documentation]    Retorna um item aleatório de uma lista/array
    [Arguments]    ${lista}

    ${item_aleatorio}=    Evaluate    random.choice(${lista})

    Set Test Variable    ${item_aleatorio_selecionado}    ${item_aleatorio}
    Log    Item aleatório selecionado: ${item_aleatorio}

    RETURN    ${item_aleatorio}

# ============================================================================
# KEYWORDS GENÉRICAS - MENSAGENS DE ERRO
# ============================================================================

Mensagem De Erro Deve Estar Visível
    [Documentation]    Valida que uma mensagem de erro específica está visível
    [Arguments]    ${campo}    ${mensagem_esperada}
    Log    campo: ${campo}
    Log    mensagem_esperada: ${mensagem_esperada}
    ${locator}=    Get Locator Para Mensagem Erro    ${campo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    ${mensagem_atual}=    Get Text    ${locator}
    Should Be Equal    ${mensagem_atual}    ${mensagem_esperada}

Todas Mensagens De Erro Devem Estar Visiveis
    [Documentation]    Valida que múltiplas mensagens de erro estão visíveis
    [Arguments]    ${quantidade_esperada}
    ${mensagens}=    Get WebElements    ${LOC_TODAS_MENSAGENS_ERRO}
    ${quantidade}=    Get Length    ${mensagens}
    Should Be Equal As Numbers    ${quantidade}    ${quantidade_esperada}

Todos Campos Invalidos Devem Ser
    [Documentation]    Valida quantidade de campos com classe is-invalid
    [Arguments]    ${quantidade_esperada}
    ${campos}=    Get WebElements    ${LOC_TODOS_CAMPOS_INVALIDOS}
    ${quantidade}=    Get Length    ${campos}
    Should Be Equal As Numbers    ${quantidade}    ${quantidade_esperada}

# ============================================================================
# KEYWORDS AUXILIARES - MAPEAMENTO DE LOCATORS
# ============================================================================

Get Locator Para Campo
    [Documentation]    Retorna o locator correto para um campo baseado em seu nome
    [Arguments]    ${campo}
    IF    '${campo}' == 'Filial'
        ${locator}=    Set Variable    ${LOC_INPUT_FILIAL}
    ELSE IF    '${campo}' == 'Número da proposta'
        ${locator}=    Set Variable    ${LOC_INPUT_NUMERO_PROPOSTA}
    ELSE IF    '${campo}' == 'Tipo do cliente'
        ${locator}=    Set Variable    ${LOC_SELECT_TIPO_CLIENTE}
    ELSE IF    '${campo}' == 'Nome do cliente'
        ${locator}=    Set Variable    ${LOC_INPUT_NOME_CLIENTE}
    ELSE IF    '${campo}' == 'Documento do cliente'
        ${locator}=    Set Variable    ${LOC_INPUT_DOCUMENTO_CLIENTE}
    ELSE IF    '${campo}' == 'CNPJ'
        ${locator}=    Set Variable    ${LOC_INPUT_CNPJ}
    ELSE IF    '${campo}' == 'CNPJ da loja'
        ${locator}=    Set Variable    ${LOC_INPUT_CNPJ_LOJA}
    ELSE IF    '${campo}' == 'CPF do vendedor'
        ${locator}=    Set Variable    ${LOC_INPUT_CPF_VENDEDOR}
    ELSE IF    '${campo}' == 'Nome do vendedor'
        ${locator}=    Set Variable    ${LOC_INPUT_NOME_VENDEDOR}
    ELSE IF    '${campo}' == 'Placa'
        ${locator}=    Set Variable    ${LOC_INPUT_PLACA}
    ELSE IF    '${campo}' == 'RENAVAM'
        ${locator}=    Set Variable    ${LOC_INPUT_RENAVAM}
    ELSE IF    '${campo}' == 'UF da placa'
        ${locator}=    Set Variable    ${LOC_SELECT_UF_PLACA}
    ELSE IF    '${campo}' == 'Cidade'
        ${locator}=    Set Variable    ${LOC_INPUT_CIDADE}
    ELSE IF    '${campo}' == 'Quilometragem'
        ${locator}=    Set Variable    ${LOC_INPUT_QUILOMETRAGEM}
    ELSE IF    '${campo}' == 'Quilometragem'
        ${locator}=    Set Variable    ${LOC_INPUT_QUILOMETRAGEM}
    ELSE
        ${locator}=    Fail    Campo não encontrado: ${campo}
    END
    RETURN    ${locator}

Get Locator Para Campo Invalido
    [Documentation]    Retorna o locator para campo marcado como inválido
    [Arguments]    ${campo}
    IF    '${campo}' == 'Número da proposta'
        ${locator}=    Set Variable    ${LOC_INPUT_NUMERO_PROPOSTA_INVALIDO}
    ELSE IF    '${campo}' == 'Tipo do cliente'
        ${locator}=    Set Variable    ${LOC_SELECT_TIPO_CLIENTE_INVALIDO}
    ELSE IF    '${campo}' == 'Nome do cliente'
        ${locator}=    Set Variable    ${LOC_INPUT_NOME_CLIENTE_INVALIDO}
    ELSE IF    '${campo}' == 'Documento do cliente'
        ${locator}=    Set Variable    ${LOC_INPUT_DOCUMENTO_CLIENTE_INVALIDO}
    ELSE IF    '${campo}' == 'CNPJ'
        ${locator}=    Set Variable    ${LOC_INPUT_CNPJ_INVALIDO}
    ELSE IF    '${campo}' == 'Nome do vendedor'
        ${locator}=    Set Variable    ${LOC_INPUT_NOME_VENDEDOR_INVALIDO}
    ELSE IF    '${campo}' == 'Placa'
        ${locator}=    Set Variable    ${LOC_INPUT_PLACA_INVALIDO}
    ELSE IF    '${campo}' == 'RENAVAM'
        ${locator}=    Set Variable    ${LOC_INPUT_RENAVAM_INVALIDO}
    ELSE IF    '${campo}' == 'UF da placa'
        ${locator}=    Set Variable    ${LOC_SELECT_UF_PLACA_INVALIDO}
    ELSE IF    '${campo}' == 'Cidade'
        ${locator}=    Set Variable    ${LOC_INPUT_CIDADE_INVALIDO}
    ELSE IF    '${campo}' == 'Quilometragem'
        ${locator}=    Set Variable    ${LOC_INPUT_QUILOMETRAGEM_INVALIDO}
    ELSE
        ${locator}=    Fail    Campo inválido não encontrado: ${campo}
    END
    RETURN    ${locator}

Get Locator Para Mensagem Erro
    [Documentation]    Retorna o locator para mensagem de erro de um campo
    [Arguments]    ${campo}
    IF    '${campo}' == 'Número da proposta'
        ${locator}=    Set Variable    ${LOC_ERRO_NUMERO_PROPOSTA}
    ELSE IF    '${campo}' == 'Tipo do cliente'
        ${locator}=    Set Variable    ${LOC_ERRO_TIPO_CLIENTE}
    ELSE IF    '${campo}' == 'Nome do cliente'
        ${locator}=    Set Variable    ${LOC_ERRO_NOME_CLIENTE}
    ELSE IF    '${campo}' == 'Documento do cliente'
        ${locator}=    Set Variable    ${LOC_ERRO_DOCUMENTO_CLIENTE}
    ELSE IF    '${campo}' == 'CNPJ'
        ${locator}=    Set Variable    ${LOC_ERRO_CNPJ}
    ELSE IF    '${campo}' == 'CNPJ da loja'
        ${locator}=    Set Variable    ${LOC_ERRO_CNPJ_LOJA}
    ELSE IF    '${campo}' == 'Nome do vendedor'
        ${locator}=    Set Variable    ${LOC_ERRO_NOME_VENDEDOR}
    ELSE IF    '${campo}' == 'Placa'
        ${locator}=    Set Variable    ${LOC_ERRO_PLACA}
    ELSE IF    '${campo}' == 'RENAVAM'
        ${locator}=    Set Variable    ${LOC_ERRO_RENAVAM}
    ELSE IF    '${campo}' == 'UF da placa'
        ${locator}=    Set Variable    ${LOC_ERRO_UF_PLACA}
    ELSE IF    '${campo}' == 'Cidade'
        ${locator}=    Set Variable    ${LOC_ERRO_CIDADE}
    ELSE
        ${locator}=    Fail    Mensagem de erro não encontrada: ${campo}
    END
    RETURN    ${locator}

Get Locator Para Texto Opcional
    [Documentation]    Retorna o locator para texto (opcional) de um campo
    [Arguments]    ${campo}
    IF    '${campo}' == 'Filial'
        ${locator}=    Set Variable    ${LOC_TEXTO_OPCIONAL_FILIAL}
    ELSE IF    '${campo}' == 'CPF do vendedor'
        ${locator}=    Set Variable    ${LOC_TEXTO_OPCIONAL_CPF_VENDEDOR}
    ELSE IF    '${campo}' == 'Quilometragem'
        ${locator}=    Set Variable    ${LOC_TEXTO_OPCIONAL_QUILOMETRAGEM}
    ELSE
        ${locator}=    Fail    Campo opcional não encontrado: ${campo}
    END
    RETURN    ${locator}

# ============================================================================
# KEYWORDS ESPECÍFICAS - VALIDAÇÕES COMPLEXAS
# ============================================================================

Gerar Dado De Nome
    [Documentation]    Preenche o campo "Nome" com nome baseado no tipo
    ...    - ${EMPTY} ou não informado: retorna vazio
    ...    - 'cliente': gera CLIENTE_AUTOM_FRONT
    ...    - 'vendedor': gera VENDEDOR_AUTOM_FRONT
    ...    - Qualquer outro valor: retorna o nome fornecido
    [Arguments]    ${nome}=${EMPTY}

    # Se vazio, retorna vazio
    IF    '${nome}' == '${EMPTY}'
        Log    📝 Nome vazio - campo não será preenchido
        RETURN    ${EMPTY}
    END

    # Se 'cliente', gera nome automático de cliente
    IF    '${nome}' == 'cliente'
        ${nome_gerado}=    Set Variable    CLIENTE AUTOM FRONT
        Log    📝 Nome de cliente gerado: ${nome_gerado}
        Set Test Variable    ${nome_cliente_teste}    ${nome_gerado}
        RETURN    ${nome_gerado}
    END

    # Se 'vendedor', gera nome automático de vendedor
    IF    '${nome}' == 'vendedor'
        ${nome_gerado}=    Set Variable    VENDEDOR AUTOM FRONT
        Log    📝 Nome de vendedor gerado: ${nome_gerado}
        Set Test Variable    ${nome_vendedor_teste}    ${nome_gerado}
        RETURN    ${nome_gerado}
    END

    # Qualquer outro valor, retorna o nome fornecido
    Log    📝 Usando nome fornecido: ${nome}
    Set Test Variable    ${nome_customizado_teste}    ${nome}
    RETURN    ${nome}

Gerar Dado De Filial
    [Documentation]    Preenche o campo "Filial"
    ...    - gera FILIAL_AUTOM_FRONT_DD_MM_AA_HH_MM_SS
    ...    - Qualquer outro valor: retorna o nome fornecido
    [Arguments]    ${filial}=${EMPTY}

    # Se 'cliente', gera nome automático de cliente
    IF    '${filial}' == '${EMPTY}'
        ${timestamp}=    Get Current Date    result_format=%d_%m_%y_%H_%M_%S
        ${filial}=    Set Variable    FILIAL_${timestamp}
        Log    📝 Nome de cliente gerado: ${filial}
    END

    # Qualquer outro valor, retorna a filial fornecida
    Log    📝 Usando nome fornecido: ${filial}
    Set Test Variable    ${filial_teste}    ${filial}
    RETURN    ${filial}

Gerar Dado De Numero Proposta
    [Documentation]    Gera um número aleatório para proposta com 10 a 30 dígitos
    [Arguments]    ${valor}=${None}
    IF    '${valor}' == '${None}'
        ${numeroProposta}=    Generate Random String    10-20    [NUMBERS]
        ${valor}=    Set Variable    ${numeroProposta}
    END

    Set Test Variable    ${numero_proposta_teste}    ${valor}
    RETURN    ${valor}

Gerar Dado De Quilometragem
    [Documentation]    Gera um número aleatório para quilometragem com 3 a 7 dígitos
    [Arguments]    ${valor}=${None}
    IF    '${valor}' == '${None}'
        ${quilometragem}=    Generate Random String    3-7    [NUMBERS]
        ${valor}=    Set Variable    ${quilometragem}
    END

    Set Test Variable    ${quilometragem_teste}    ${valor}
    RETURN    ${valor}

Gerar CPF
    [Documentation]    Gera CPF via python
    [Arguments]    ${cpf}=${None}
    IF    '${cpf}' == '${None}'
        ${cpf_numeros}=    Gerar CPF Válido    ${False}
        ${cpf}=    Set Variable    ${cpf_numeros}
    END

    Set Test Variable    ${cpf_teste}    ${cpf}
    RETURN    ${cpf}

Gerar CNPJ
    [Documentation]    Gera CNPJ via python
    [Arguments]    ${cnpj}=${None}
    IF    '${cnpj}' == '${None}'
        ${cnpj_numeros}=    Gerar CNPJ Válido    ${False}
        ${cnpj}=    Set Variable    ${cnpj_numeros}
    END

    Set Test Variable    ${cnpjLoja_teste}    ${cnpj}
    RETURN    ${cnpj}

Gerar Documento Por Tipo Cliente
    [Documentation]    Gera documento baseado no tipo de cliente: Física=CPF, Jurídica=CNPJ
    [Arguments]    ${tipo_cliente}

    IF    '${tipo_cliente}' == 'Pessoa Física'
        ${documentoCliente}=    Gerar CPF
        Log    Tipo Cliente 1: Gerando CPF para cliente
    ELSE IF    '${tipo_cliente}' == 'Pessoa Jurídica'
        ${documentoCliente}=    Gerar CNPJ
        Log    Tipo Cliente 2: Gerando CNPJ para cliente
    ELSE
        Fail    Tipo de cliente '${tipo_cliente}' inválido.
    END

    Set Test Variable    ${documento_cliente_teste}    ${documentoCliente}
    RETURN    ${documentoCliente}

Obter a placa específica
    [Documentation]    Obtém uma placa aleatória do array fornecido
    [Arguments]    ${placas}=${None}

    IF    '${placas}' == '${None}'
        ${placas}=    Obter Item Aleatorio Do Array    ${forms_solicitacao.placas}
        Log    Placa escolhida aleatoriamente: ${placas}
    END

    Set Test Variable    ${placa_teste}    ${placas}
    RETURN    ${placas}

Obter o renavam
    [Documentation]    Obtém um renavam aleatório do array fornecido
    [Arguments]    ${renavam}=${None}

    IF    '${renavam}' == '${None}'
        ${renavam}=    Obter Item Aleatorio Do Array    ${forms_solicitacao.renavam}
        Log    renavam escolhido aleatoriamente: ${renavam}
    END

    Set Test Variable    ${renavam_teste}    ${renavam}
    RETURN    ${renavam}

Obter a cidade
    [Documentation]    Obtém uma cidade aleatória do array fornecido
    [Arguments]    ${cidade}=${None}

    IF    '${cidade}' == '${None}'
        ${cidade}=    Obter Item Aleatorio Do Array    ${forms_solicitacao.cidades}
        Log    cidade escolhida aleatoriamente: ${cidade}
    END

    Set Test Variable    ${cidade_teste}    ${cidade}
    RETURN    ${cidade}

Gerar Dado De Tipo Cliente
    [Documentation]    Escolhe aleatoriamente entre tipo cliente Pessoa física ou jurídica
    [Arguments]    ${tipo_cliente}=${None}
    IF    '${tipo_cliente}' == '${None}'
        ${tipo_cliente}=    Obter Item Aleatorio Do Array    ${forms_solicitacao.select.tipo_cliente}
        Log    tipo_cliente escolhida aleatoriamente: ${tipo_cliente}
    END

    Set Test Variable    ${tipo_cliente_teste}    ${tipo_cliente}
    RETURN    ${tipo_cliente}

Gerar Dado De UF da Placa
    [Documentation]    Escolhe aleatoriamente uma das 27 UFs
    [Arguments]    ${ufPlaca}=${None}
    IF    '${ufPlaca}' == '${None}'
        ${ufPlaca}=    Obter Item Aleatorio Do Array    ${forms_solicitacao.select.estados}
        Log    ufPlaca escolhida aleatoriamente: ${ufPlaca}
    END

    Set Test Variable    ${uf_placa_teste}    ${ufPlaca}
    RETURN    ${ufPlaca}

Preencher Todos Campos Obrigatorios Com Dados Validos
    [Documentation]    Preenche todos os campos obrigatórios com dados válidos

    # Gerar dados obrigatórios
    ${numeroProposta}=    Gerar Dado De Numero Proposta
    ${tipoCliente}=    Gerar Dado De Tipo Cliente
    ${documentoCliente}=    Gerar Documento Por Tipo Cliente    ${tipo_cliente_teste}
    ${nomeCliente}=    Gerar Dado De Nome    cliente
    ${nomeVendedor}=    Gerar Dado De Nome    vendedor
    ${cpfVendedor}=    Gerar CPF
    ${cnpjLoja}=    Gerar CNPJ
    ${quilometragem}=    Gerar Dado De Quilometragem
    ${placa}=    Obter a placa específica
    ${renavam}=    Obter o renavam
    ${ufPlaca}=    Gerar Dado De UF da Placa
    ${cidade}=    Obter a cidade

    Preencher Campo    Número da proposta    ${numeroProposta}
    Selecionar Opcao    Tipo do cliente    ${tipoCliente}
    Preencher Campo    Nome do cliente    ${nomeCliente}
    Preencher Campo    Documento do cliente    ${documentoCliente}
    Preencher Campo    CNPJ    ${cnpjLoja}
    Preencher Campo    Nome do vendedor    ${nomeVendedor}
    Preencher Campo    Placa    ${placa}
    Preencher Campo    RENAVAM    ${renavam}
    Selecionar Opcao    UF da placa    ${ufPlaca}
    Preencher Campo    Cidade    ${cidade}

Preencher Todos Campos Com Dados Validos
    [Documentation]    Preenche todos os campos opcionais e obrigatórios com dados válidos
    [Arguments]    ${placa}=${EMPTY}

    # Gerar dados obrigatórios
    ${numeroProposta}=    Gerar Dado De Numero Proposta
    ${tipoCliente}=    Gerar Dado De Tipo Cliente
    ${documentoCliente}=    Gerar Documento Por Tipo Cliente    ${tipo_cliente_teste}
    ${nomeCliente}=    Gerar Dado De Nome    cliente
    ${nomeVendedor}=    Gerar Dado De Nome    vendedor
    ${cpfVendedor}=    Gerar CPF
    ${cnpjLoja}=    Gerar CNPJ Alfanumérico Válido    ${False}
    ${quilometragem}=    Gerar Dado De Quilometragem
    IF    '${placa}' == '${EMPTY}'
        ${placa}=    Obter a placa específica
    ELSE
        ${placa}=    Set Variable    ${placa}
    END
    ${renavam}=    Obter o renavam
    ${ufPlaca}=    Gerar Dado De UF da Placa
    ${cidade}=    Obter a cidade
    ${filial}=    Gerar Dado De Filial

    Preencher Campo    Filial    ${filial}
    Preencher Campo    Número da proposta    ${numeroProposta}
    Selecionar Opcao    Tipo do cliente    ${tipoCliente}
    Preencher Campo    Nome do cliente    ${nomeCliente}
    Preencher Campo    Documento do cliente    ${documentoCliente}
    Preencher Campo    CNPJ    ${cnpjLoja}
    Preencher Campo    CPF do vendedor    ${cpfVendedor}
    Preencher Campo    Nome do vendedor    ${nomeVendedor}
    Preencher Campo    Placa    ${placa}
    Preencher Campo    RENAVAM    ${renavam}
    Selecionar Opcao    UF da placa    ${ufPlaca}
    Preencher Campo    Cidade    ${cidade}
    Preencher Campo    Quilometragem    ${quilometragem}

    Set Test Variable    ${numeroProposta_teste}    ${numeroProposta}
    Set Test Variable    ${tipoCliente_teste}    ${tipoCliente}
    Set Test Variable    ${documentoCliente_teste}    ${documentoCliente}
    Set Test Variable    ${nomeCliente_teste}    ${nomeCliente}
    Set Test Variable    ${nomeVendedor_teste}    ${nomeVendedor}
    Set Test Variable    ${cpfVendedor_teste}    ${cpfVendedor}
    Set Test Variable    ${cnpjLoja_teste}    ${cnpjLoja}
    Set Test Variable    ${quilometragem_teste}    ${quilometragem}
    Set Test Variable    ${placa_teste}    ${placa}
    Set Test Variable    ${renavam_teste}    ${renavam}
    Set Test Variable    ${ufPlaca_teste}    ${ufPlaca}
    Set Test Variable    ${cidade_teste}    ${cidade}
    Set Test Variable    ${filial_teste}    ${filial}

Deixar Campo Vazio E Preencher Os Demais
    [Documentation]    Deixa um campo específico vazio, preenche os demais e clica Continuar
    [Arguments]    ${campo_vazio}
    IF    '${campo_vazio}' != 'Número da proposta'
        ${numeroProposta}=    Gerar Dado De Numero Proposta
        Preencher Campo    Número da proposta    ${numeroProposta}
    END
    IF    '${campo_vazio}' != 'Tipo do cliente'
        ${tipoCliente}=    Gerar Dado De Tipo Cliente
        Selecionar Opcao    Tipo do cliente    ${tipoCliente}
    END
    IF    '${campo_vazio}' != 'Nome do cliente'
        ${nomeCliente}=    Gerar Dado De Nome    cliente
        Preencher Campo    Nome do cliente    ${nomeCliente}
    END
    IF    '${campo_vazio}' != 'Documento do cliente'
        ${documentoCliente}=    Gerar Documento Por Tipo Cliente    ${tipo_cliente_teste}
        Preencher Campo    Documento do cliente    ${documentoCliente}
    END
    IF    '${campo_vazio}' != 'CNPJ'
        ${cnpjLoja}=    Gerar CNPJ
        Preencher Campo    CNPJ    ${cnpjLoja}
    END
    IF    '${campo_vazio}' != 'Nome do vendedor'
        ${nomeVendedor}=    Gerar Dado De Nome    vendedor
        Preencher Campo    Nome do vendedor    ${nomeVendedor}
    END
    IF    '${campo_vazio}' != 'Placa'
        ${placa}=    Obter a placa específica
        Preencher Campo    Placa    ${placa}
    END
    IF    '${campo_vazio}' != 'RENAVAM'
        ${renavam}=    Obter o renavam
        Preencher Campo    RENAVAM    ${renavam}
    END
    IF    '${campo_vazio}' != 'UF da placa'
        ${ufPlaca}=    Gerar Dado De UF da Placa
        Selecionar Opcao    UF da placa    ${ufPlaca}
    END
    IF    '${campo_vazio}' != 'Cidade'
        ${cidade}=    Obter a cidade
        Preencher Campo    Cidade    ${cidade}
    END
    # IF    '${campo_vazio}' != 'Quilometragem'
    #    ${quilometragem}=    Obter a cidade
    #    Preencher Campo    Quilometragem    ${quilometragem}
    # END

Preencher Campo Com Valor Invalido
    [Documentation]    Preenche um campo com valor inválido, e completa demais campos
    [Arguments]    ${campo}    ${valor_invalido}
    IF    '${campo}' == 'Número da proposta'
        Preencher Campo    Número da proposta    ${valor_invalido}
    ELSE
        ${numeroProposta}=    Gerar Dado De Numero Proposta
        Preencher Campo    Número da proposta    ${numeroProposta}
    END

    IF    '${campo}' != 'Tipo do cliente'
        ${tipoCliente}=    Gerar Dado De Tipo Cliente
        Selecionar Opcao    Tipo do cliente    ${tipoCliente}
    END

    IF    '${campo}' == 'Nome do cliente'
        Preencher Campo    Nome do cliente    ${valor_invalido}
    ELSE
        ${nomeCliente}=    Gerar Dado De Nome    cliente
        Preencher Campo    Nome do cliente    ${nomeCliente}
    END

    IF    '${campo}' == 'Documento do cliente'
        Preencher Campo    Documento do cliente    ${valor_invalido}
    ELSE
        ${documentoCliente}=    Gerar Documento Por Tipo Cliente    ${tipo_cliente_teste}
        Preencher Campo    Documento do cliente    ${documentoCliente}
    END

    IF    '${campo}' == 'CNPJ da loja'
        Preencher Campo    CNPJ da loja    ${valor_invalido}
    ELSE
        ${cnpjLoja}=    Gerar CNPJ
        Preencher Campo    CNPJ    ${cnpjLoja}
    END

    IF    '${campo}' == 'CNPJ'
        Preencher Campo    CNPJ    ${valor_invalido}
    ELSE
        ${cnpjLoja}=    Gerar CNPJ
        Preencher Campo    CNPJ    ${cnpjLoja}
    END

    IF    '${campo}' == 'Nome do vendedor'
        Preencher Campo    Nome do vendedor    ${valor_invalido}
    ELSE
        ${nomeVendedor}=    Gerar Dado De Nome    vendedor
        Preencher Campo    Nome do vendedor    ${nomeVendedor}
    END

    IF    '${campo}' == 'Placa'
        Preencher Campo    Placa    ${valor_invalido}
    ELSE
        ${placa}=    Obter a placa específica
        Preencher Campo    Placa    ${placa}
    END

    IF    '${campo}' == 'RENAVAM'
        Preencher Campo    RENAVAM    ${valor_invalido}
    ELSE
        ${renavam}=    Obter o renavam
        Preencher Campo    RENAVAM    ${renavam}
    END

    IF    '${campo}' != 'UF da placa'
        ${ufPlaca}=    Gerar Dado De UF da Placa
        Selecionar Opcao    UF da placa    ${ufPlaca}
    END

    IF    '${campo}' == 'Cidade'
        Preencher Campo    Cidade    ${valor_invalido}
    ELSE
        ${cidade}=    Obter a cidade
        Preencher Campo    Cidade    ${cidade}
    END

    IF    '${campo}' == 'Quilometragem'
        Preencher Campo    Quilometragem    ${valor_invalido}
    END

    IF    '${campo}' == 'Filial'
        Preencher Campo    Filial    ${valor_invalido}
    END

Validar Todos Campos Devem Estar Visiveis
    [Documentation]    Valida que todos os 13 campos estão visíveis no formulário
    Campo Deve Estar Visível    Filial
    Campo Deve Estar Visível    Número da proposta
    Campo Deve Estar Visível    Tipo do cliente
    Campo Deve Estar Visível    Nome do cliente
    Campo Deve Estar Visível    Documento do cliente
    Campo Deve Estar Visível    CNPJ
    Campo Deve Estar Visível    CPF do vendedor
    Campo Deve Estar Visível    Nome do vendedor
    Campo Deve Estar Visível    Placa
    Campo Deve Estar Visível    RENAVAM
    Campo Deve Estar Visível    UF da placa
    Campo Deve Estar Visível    Cidade
    Campo Deve Estar Visível    Quilometragem

Validar Campos Opcionais Estao Marcados
    [Documentation]    Valida que os 3 campos opcionais têm marcação (opcional)
    Campo Deve Conter Texto Opcional    Filial
    Campo Deve Conter Texto Opcional    CPF do vendedor
    Campo Deve Conter Texto Opcional    Quilometragem

Não preencher um campo obrigatório
    [Documentation]    Simula o usuário passar pelo campo sem preenchê-lo: clica no campo e sai com TAB,
    ...    o que dispara a validação de campo obrigatório do formulário.
    [Arguments]    ${nome_campo}    ${xpath_campo}

    Click Element    ${xpath_campo}
    Sleep    0.2s

    # Press Keys com None + TAB
    Press Keys    None    TAB

    IF    '${nome_campo}' == 'UF da placa'
        Click Element    ${LOC_INPUT_CIDADE}
    ELSE
        Sleep    0.5s
    END

    Log    ✅ Campo '${nome_campo}' validado (TAB sem preenchimento)

# ============================================================================
# KEYWORDS GENÉRICAS - NAVEGAÇÃO
# ============================================================================

Clicar Botão Voltar Etapa2
    [Documentation]    Clica no botão Voltar para retornar à etapa anterior
    Wait Until Element Is Visible    ${LOC_BTN_VOLTAR}    timeout=5s
    Click Element    ${LOC_BTN_VOLTAR}

Clicar Botão Pular Etapa
    [Documentation]    Clica no botão Pular Etapa para avançar sem selecionar itens
    Scroll Element Into View    ${LOC_BTN_PULAR_ETAPA}
    Wait Until Element Is Visible    ${LOC_BTN_PULAR_ETAPA}    timeout=5s
    Click Element    ${LOC_BTN_PULAR_ETAPA}

Clicar Botão Continuar Etapa2
    [Documentation]    Clica no botão Continuar para avançar para próxima etapa
    Wait Until Element Is Visible    ${LOC_BTN_CONTINUAR}    timeout=5s
    Click Element    ${LOC_BTN_CONTINUAR}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE BOTÕES
# ============================================================================

Botão Voltar Deve Estar Visivel E Habilitado
    [Documentation]    Valida que o botão Voltar está visível e habilitado
    Wait Until Element Is Visible    ${LOC_BTN_VOLTAR}    timeout=5s
    Element Should Be Visible    ${LOC_BTN_VOLTAR}
    Element Should Be Enabled    ${LOC_BTN_VOLTAR}

Botão Pular Etapa Deve Estar Visivel E Habilitado
    [Documentation]    Valida que o botão Pular Etapa está visível e habilitado
    Wait Until Element Is Visible    ${LOC_BTN_PULAR_ETAPA}    timeout=5s
    Element Should Be Visible    ${LOC_BTN_PULAR_ETAPA}
    Element Should Be Enabled    ${LOC_BTN_PULAR_ETAPA}

Botão Continuar Deve Estar Visivel E Habilitado
    [Documentation]    Valida que o botão Continuar está visível e habilitado
    Wait Until Element Is Visible    ${LOC_BTN_CONTINUAR}    timeout=5s
    Element Should Be Visible    ${LOC_BTN_CONTINUAR}
    Element Should Be Enabled    ${LOC_BTN_CONTINUAR}

# ============================================================================
# KEYWORDS GENÉRICAS - SELEÇÃO DE ITENS
# ============================================================================

Selecionar Item De Seguranca
    [Documentation]    Seleciona um checkbox de item de segurança pelo nome
    [Arguments]    ${item}
    ${locator}=    Get Locator Para Item    ${item}
    Scroll Element Into View    ${locator}
    ${selecionado}=    Run Keyword And Return Status    Checkbox Should Be Selected    ${locator}
    IF    not ${selecionado}    Click Element    ${locator}

Item Deve Estar Selecionado
    [Documentation]    Valida que um item de segurança está selecionado (marcado)
    [Arguments]    ${item}
    ${locator}=    Get Locator Para Item    ${item}
    Checkbox Should Be Selected    ${locator}

Item Deve Estar Visivel Com Checkbox Desmarcado
    [Documentation]    Valida que item está visível e desmarcado
    [Arguments]    ${item}
    ${locator}=    Get Locator Para Item    ${item}
    Scroll Element Into View    ${locator}
    Checkbox Should Not Be Selected    ${locator}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÕES VISUAIS
# ============================================================================

Etapa Itens Deve Estar Ativa
    [Documentation]    Valida que a etapa Itens está marcada como ativa
    Wait Until Element Is Visible    ${LOC_STEP_2_ITENS_ACTIVE}    timeout=5s
    Element Should Be Visible    ${LOC_STEP_2_ITENS_ACTIVE}

Step Anexos Deve Estar Ativo
    [Documentation]    Valida que step Anexos está ativo e destacado
    Wait Until Element Is Visible    ${LOC_STEP_3_ANEXOS_ACTIVE}    timeout=10s
    Element Should Be Visible    ${LOC_STEP_3_ANEXOS_ACTIVE}

# ============================================================================
# KEYWORDS AUXILIARES - MAPEAMENTO DE LOCATORS
# ============================================================================

Get Locator Para Item
    [Documentation]    Retorna o locator correto para um item de segurança
    [Arguments]    ${item}
    IF    '${item}' == 'Airbag'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_AIRBAG}
    ELSE IF    '${item}' == 'Buzina'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_BUZINA}
    ELSE IF    '${item}' == 'Cabo de bateria'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_CABO_BATERIA}
    ELSE IF    '${item}' == 'Chave de roda'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_CHAVE_RODA}
    ELSE IF    '${item}' == 'Cintos de segurança'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_CINTOS_SEGURANCA}
    ELSE IF    '${item}' == 'Compressor'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_COMPRESSOR}
    ELSE IF    '${item}' == 'Encosto de cabeça'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_ENCOSTO_CABECA}
    ELSE IF    '${item}' == 'Freio ABS'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_FREIO_ABS}
    ELSE IF    '${item}' == 'Extintor de incêndio na validade'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_EXTINTOR}
    ELSE IF    '${item}' == 'Espelhos (internos e retrovisores)'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_ESPELHOS}
    ELSE IF    '${item}' == 'Freio de estacionamento (freio de mão)'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_FREIO_ESTACIONAMENTO}
    ELSE IF    '${item}' == 'Luzes indicadoras de direção'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_LUZES_DIRECAO}
    ELSE IF    '${item}' == 'Limpador de para-brisas'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_LIMPADOR}
    ELSE IF    '${item}' == 'Lanterna'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_LANTERNA}
    ELSE IF    '${item}' == 'Macaco'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_MACACO}
    ELSE IF    '${item}' == 'Manual do veículo'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_MANUAL_VEICULO}
    ELSE IF    '${item}' == 'Triângulo de sinalização'
        ${locator}=    Set Variable    ${LOC_CHECKBOX_TRIANGULO}
    ELSE
        ${locator}=    Fail    Item não encontrado: ${item}
    END
    RETURN    ${locator}

# ============================================================================
# KEYWORDS ESPECÍFICAS - FLUXOS COMPLEXOS
# ============================================================================

Selecionar Multiplos Itens
    [Documentation]    Seleciona múltiplos itens de segurança de uma vez
    [Arguments]    @{itens}
    FOR    ${item}    IN    @{itens}
        Selecionar Item De Seguranca    ${item}
    END

Marcar Todos Os 17 Checkboxes De Itens
    [Documentation]    Marca todos os 17 itens de segurança disponíveis
    Selecionar Multiplos Itens
    ...    Airbag
    ...    Buzina
    ...    Cabo de bateria
    ...    Chave de roda
    ...    Cintos de segurança
    ...    Compressor
    ...    Encosto de cabeça
    ...    Freio ABS
    ...    Extintor de incêndio na validade
    ...    Espelhos (internos e retrovisores)
    ...    Freio de estacionamento (freio de mão)
    ...    Luzes indicadoras de direção
    ...    Limpador de para-brisas
    ...    Lanterna
    ...    Macaco
    ...    Manual do veículo
    ...    Triângulo de sinalização

Validar Todos Os 17 Itens Ficam Marcados
    [Documentation]    Valida que todos os 17 checkboxes estão marcados
    Item Deve Estar Selecionado    Airbag
    Item Deve Estar Selecionado    Buzina
    Item Deve Estar Selecionado    Cabo de bateria
    Item Deve Estar Selecionado    Chave de roda
    Item Deve Estar Selecionado    Cintos de segurança
    Item Deve Estar Selecionado    Compressor
    Item Deve Estar Selecionado    Encosto de cabeça
    Item Deve Estar Selecionado    Freio ABS
    Item Deve Estar Selecionado    Extintor de incêndio na validade
    Item Deve Estar Selecionado    Espelhos (internos e retrovisores)
    Item Deve Estar Selecionado    Freio de estacionamento (freio de mão)
    Item Deve Estar Selecionado    Luzes indicadoras de direção
    Item Deve Estar Selecionado    Limpador de para-brisas
    Item Deve Estar Selecionado    Lanterna
    Item Deve Estar Selecionado    Macaco
    Item Deve Estar Selecionado    Manual do veículo
    Item Deve Estar Selecionado    Triângulo de sinalização

Selecionar Item
    [Documentation]    Seleciona um item e preenche sua observação
    [Arguments]    ${item}
    Selecionar Item De Seguranca    ${item}

Validar Itens Selecionados Persistem
    [Documentation]    Valida que itens selecionados permanecem após navegação
    [Arguments]    @{itens}
    FOR    ${item}    IN    @{itens}
        Item Deve Estar Selecionado    ${item}
    END

# ============================================================================
# KEYWORDS GENÉRICAS - ÁREA DE UPLOAD - ETAPA 3
# ============================================================================

Area De Upload Deve Estar Desabilitada
    [Documentation]    Valida que a área de upload está visível
    Wait Until Element Is Visible    ${LOC_AREA_UPLOAD}    timeout=5s
    Validar Hover Simples E Direto

Validar Hover Simples E Direto
    [Documentation]    Versão mais simples e direta
    [Arguments]    ${locator}=${LOC_AREA_UPLOAD}

    Execute Javascript
    ...    document.evaluate("${locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null)
    ...    .singleNodeValue.dispatchEvent(new MouseEvent('mouseenter', {bubbles: true}));

    Sleep    5s

    ${cursor}=    Execute Javascript
    ...    return window.getComputedStyle(
    ...    document.evaluate("${locator}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue
    ...    ).cursor;

    Should Be Equal    ${cursor}    not-allowed
    Log    ✓ Cursor not-allowed validado

Icone De Nuvem Deve Estar Visivel
    [Documentation]    Valida que o ícone de nuvem está visível
    Wait Until Element Is Visible    ${LOC_ICONE_NUVEM}    timeout=5s
    Element Should Be Visible    ${LOC_ICONE_NUVEM}

Texto Arraste Ou Clique Deve Estar Visivel
    [Documentation]    Valida que o texto de instrução está visível
    Wait Until Element Is Visible    ${LOC_TEXTO_ARRASTE_CLIQUE}    timeout=5s
    Element Should Be Visible    ${LOC_TEXTO_ARRASTE_CLIQUE}
    Element Should Contain    ${LOC_TEXTO_ARRASTE_CLIQUE}    Arraste ou clique aqui

Especificacoes Tecnicas Devem Estar Visiveis
    [Documentation]    Valida que as especificações técnicas estão visíveis
    Wait Until Element Is Visible    ${LOC_ESPECIFICACAO_FORMATOS}    timeout=5s
    Element Should Be Visible    ${LOC_ESPECIFICACAO_FORMATOS}
    Element Should Be Visible    ${LOC_ESPECIFICACAO_LIMITE}
    Element Should Be Visible    ${LOC_ESPECIFICACAO_RESOLUCOES}

# ============================================================================
# KEYWORDS GENÉRICAS - UPLOAD DE IMAGENS
# ============================================================================

Fazer Upload De Imagem
    [Documentation]    Faz upload de uma imagem através do input file
    [Arguments]    ${caminho_arquivo}
    ${caminho_arquivo}=    Join Path    ${EXECDIR}    ${caminho_arquivo}
    ${size}=    Get File Size    ${caminho_arquivo}
    ${nome_arquivo}=    Evaluate    __import__('os').path.basename(r"${caminho_arquivo}")
    Set Test Variable    ${nome_arquivo_teste}    ${nome_arquivo}
    Choose File    ${LOC_INPUT_FILE}    ${caminho_arquivo}
    Sleep    1s    # Aguarda processamento do upload

Validar existencia de imagem
    [Documentation]    Pré-condição: imagem disponível para upload
    [Arguments]    ${caminho_imagem}

    ${arquivo_existe}=    Run Keyword And Return Status
    ...    File Should Exist    ${caminho_imagem}

    IF    not ${arquivo_existe}
        Fail    Arquivo de imagem não encontrado: ${caminho_imagem}
    END

    Log    Imagem encontrada: ${caminho_imagem}
    Set Test Variable    ${CAMINHO_IMAGEM_UPLOAD}    ${caminho_imagem}

    RETURN    ${caminho_imagem}

Fazer Upload De Multiplas Imagens
    [Documentation]    Ação: selecionar múltiplas imagens do YAML
    ...    Valida que quantidade não excede o limite de 6 imagens
    ...    Guarda os nomes das imagens selecionadas em ${IMAGENS_SELECIONADAS}
    ...    Exemplo: Quando seleciono 4 imagens
    [Arguments]    ${quantidade}

    # Validação: quantidade deve ser entre 1 e 6
    ${quantidade_int}=    Convert To Integer    ${quantidade}
    Should Be True    ${quantidade_int} >= 1    msg=Quantidade deve ser no mínimo 1
    Should Be True    ${quantidade_int} <= 6    msg=Quantidade não pode exceder o limite de 6 imagens

    # Verifica se a variável ${forms_solicitacao.imagem} existe e é uma lista
    Variable Should Exist    ${forms_solicitacao.imagem}    msg=Variável forms_solicitacao.imagem não encontrada

    # Verifica se há imagens suficientes no YAML
    ${total_imagens}=    Get Length    ${forms_solicitacao.imagem}
    Should Be True
    ...    ${total_imagens} >= ${quantidade_int}
    ...    msg=YAML possui apenas ${total_imagens} imagens, mas ${quantidade_int} foram solicitadas

    # Inicializa array para guardar nomes das imagens selecionadas
    @{IMAGENS_SELECIONADAS}=    Create List

    # Pega as chaves do dicionário e itera sobre elas
    @{chaves_imagens}=    Get Dictionary Keys    ${forms_solicitacao.imagem}

    # Seleciona as primeiras N imagens da lista
    FOR    ${index}    IN RANGE    ${quantidade_int}
        ${chave}=    Get From List    ${chaves_imagens}    ${index}
        ${nome_arquivo}=    Get From Dictionary    ${forms_solicitacao.imagem}    ${chave}
        ${nome_arquivo_final}=    Evaluate    __import__('os').path.basename(r"${nome_arquivo}")

        Log    Selecionando imagem ${index + 1} de ${quantidade_int}: ${nome_arquivo_final}

        # Adiciona nome ao array de selecionadas
        Append To List    ${IMAGENS_SELECIONADAS}    ${nome_arquivo_final}

        E seleciono a imagem    ${nome_arquivo}
        Sleep    0.2s    # Pequeno delay entre uploads
    END

    # Torna a variável disponível para toda a suite
    Set Suite Variable    @{IMAGENS_SELECIONADAS}

    Log    Total de ${quantidade_int} imagens selecionadas com sucesso
    Log    Imagens selecionadas: ${IMAGENS_SELECIONADAS}

    RETURN    @{IMAGENS_SELECIONADAS}

Quando seleciono imagens especificas
    [Documentation]    Seleciona imagens específicas por índice
    ...    Guarda os nomes em ${IMAGENS_SELECIONADAS}
    ...    Exemplo: Quando seleciono imagens especificas    0    2    5
    [Arguments]    @{indices}

    # Valida limite de 6 imagens
    ${total_selecionadas}=    Get Length    ${indices}
    Should Be True    ${total_selecionadas} <= 6    msg=Não é possível selecionar mais de 6 imagens

    # Inicializa array para guardar nomes das imagens selecionadas
    @{IMAGENS_SELECIONADAS}=    Create List

    # Pega as chaves do dicionário e itera sobre elas
    @{chaves_imagens}=    Get Dictionary Keys    ${forms_solicitacao.imagem}

    FOR    ${index}    IN    @{indices}
        ${chave}=    Get From List    ${chaves_imagens}    ${index}
        ${nome_arquivo}=    Get From Dictionary    ${forms_solicitacao.imagem}    ${chave}
        ${nome_arquivo_final}=    Evaluate    __import__('os').path.basename(r"${nome_arquivo}")
        Log    Selecionando imagem no índice ${index}: ${nome_arquivo_final}

        # Adiciona nome ao array de selecionadas
        Append To List    ${IMAGENS_SELECIONADAS}    ${nome_arquivo_final}

        E seleciono a imagem    ${nome_arquivo}
        Sleep    0.2s
    END

    # Torna a variável disponível para toda a suite
    Set Suite Variable    @{IMAGENS_SELECIONADAS}

    Log    Imagens selecionadas: ${IMAGENS_SELECIONADAS}

    RETURN    @{IMAGENS_SELECIONADAS}

Verificar ${quantidade} miniaturas são exibidas
    [Documentation]    Verificação: valida quantidade de miniaturas exibidas
    ...    Itera sobre @{IMAGENS_SELECIONADAS} e valida cada miniatura

    # Converte quantidade para inteiro
    ${quantidade_int}=    Convert To Integer    ${quantidade}

    # Obtém array de imagens selecionadas
    @{imagens}=    Obter Imagens Selecionadas

    # Valida que quantidade de selecionadas corresponde ao esperado
    ${total_selecionadas}=    Get Length    ${imagens}
    Should Be Equal As Numbers    ${total_selecionadas}    ${quantidade_int}
    ...    msg=Esperado ${quantidade_int} imagens selecionadas, mas há ${total_selecionadas}

    # Valida miniatura de cada imagem selecionada
    FOR    ${nome_arquivo}    IN    @{imagens}
        Log    Validando miniatura da imagem: ${nome_arquivo}
        Então a miniatura da imagem é exibida    ${nome_arquivo}
    END

    Log    ✓ Todas as ${quantidade_int} miniaturas foram validadas com sucesso

Cada imagem exibe seu nome
    [Documentation]    Verificação: valida que cada imagem do array exibe seu nome
    ...    Itera sobre @{IMAGENS_SELECIONADAS}

    # Obtém array de imagens selecionadas
    @{imagens}=    Obter Imagens Selecionadas
    ${total}=    Get Length    ${imagens}

    # Valida que há imagens selecionadas
    Should Be True    ${total} > 0    msg=Nenhuma imagem foi selecionada para validação

    # Valida nome de cada imagem selecionada
    FOR    ${nome_arquivo}    IN    @{imagens}
        Log    Validando nome da imagem: ${nome_arquivo}
        E o nome é exibido    ${nome_arquivo}
    END

    Log    ✓ Nomes de todas as ${total} imagens foram validados com sucesso

Cada imagem tem ícones de exclusão
    [Documentation]    Verificação: valida ícone de exclusão de cada imagem
    ...    Itera sobre @{IMAGENS_SELECIONADAS}

    # Obtém array de imagens selecionadas
    @{imagens}=    Obter Imagens Selecionadas
    ${total}=    Get Length    ${imagens}

    # Valida que há imagens selecionadas
    Should Be True    ${total} > 0    msg=Nenhuma imagem foi selecionada para validação

    # Valida ícones de cada imagem selecionada
    FOR    ${nome_arquivo}    IN    @{imagens}
        Log    Validando ícones da imagem: ${nome_arquivo}

        # Valida ícone de exclusão
        Icone De Exclusao Deve Estar Disponivel    ${nome_arquivo}
    END

    Log    ✓ Ícones de exclusão de todas as ${total} imagens foram validados

Obter Imagens Selecionadas
    [Documentation]    Retorna o array com nomes das imagens selecionadas
    ...    Retorna lista vazia se nenhuma imagem foi selecionada
    ${existe}=    Run Keyword And Return Status    Variable Should Exist    ${IMAGENS_SELECIONADAS}
    IF    ${existe}
        RETURN    @{IMAGENS_SELECIONADAS}
    ELSE
        @{lista_vazia}=    Create List
        RETURN    @{lista_vazia}
    END

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE MINIATURAS
# ============================================================================

Miniatura Da Imagem Deve Estar Visivel
    [Documentation]    Valida que a miniatura da imagem está visível
    [Arguments]    ${nome_arquivo}
    ${locator}=    Replace String    ${LOC_MINIATURA_POR_NOME}    {filename}    ${nome_arquivo}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Element Should Be Visible    ${locator}

Nome Do Arquivo Deve Estar Visivel
    [Documentation]    Valida que o nome do arquivo está visível
    [Arguments]    ${nome_arquivo}
    Wait Until Page Contains    ${nome_arquivo}    timeout=5s

Tamanho Do Arquivo Deve Estar Visivel
    [Documentation]    Valida que o tamanho do arquivo está visível
    [Arguments]    ${tamanho}
    Wait Until Page Contains    ${tamanho}    timeout=5s

Icone De Exclusao Deve Estar Disponivel
    [Documentation]    Valida que o ícone de exclusão está disponível
    [Arguments]    ${nome_arquivo}
    ${locator}=    Replace String    ${LOC_EXCLUSAO_POR_NOME}    {filename}    ${nome_arquivo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}

# ============================================================================
# KEYWORDS GENÉRICAS - AÇÕES EM ARQUIVOS
# ============================================================================

Clicar Icone De Exclusao
    [Documentation]    Clica no ícone de exclusão de um arquivo específico
    [Arguments]    ${nome_arquivo}
    ${locator}=    Replace String    ${LOC_EXCLUSAO_POR_NOME}    {filename}    ${nome_arquivo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Click Element    ${locator}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÕES DE ERRO
# ============================================================================

Mensagem De Erro Deve Estar Visivel
    [Documentation]    Valida que uma mensagem de erro está visível
    Wait Until Element Is Visible    ${LOC_MENSAGEM_ERRO}    timeout=5s
    Element Should Be Visible    ${LOC_MENSAGEM_ERRO}

Mensagem Erro Tamanho Excedido Deve Estar Visivel
    [Documentation]    Valida mensagem de erro de tamanho excedido
    Wait Until Element Is Visible    ${LOC_ERRO_TAMANHO_EXCEDIDO}    timeout=5s
    Element Should Be Visible    ${LOC_ERRO_TAMANHO_EXCEDIDO}

Texto Formatos Aceitos Deve Estar Destacado
    [Documentation]    Valida que o texto de formatos aceitos está destacado
    Element Should Be Visible    ${LOC_ERRO_FORMATO_INVALIDO}

# ============================================================================
# KEYWORDS ESPECÍFICAS - VALIDAÇÕES COMPLEXAS
# ============================================================================

Validar Quantidade De Miniaturas
    [Documentation]    Valida quantidade de miniaturas exibidas
    [Arguments]    ${quantidade_esperada}
    ${miniaturas}=    Get Element Count    ${LOC_MINIATURA_IMAGEM}
    Should Be Equal As Numbers    ${miniaturas}    ${quantidade_esperada}

Validar Area Upload Indisponivel
    [Documentation]    Valida que área de upload continua disponível
    Area De Upload Deve Estar Desabilitada

# ============================================================================
# KEYWORDS GENÉRICAS - NAVEGAÇÃO
# ============================================================================

Clicar Botão Solicitar Laudo
    [Documentation]    Clica no botão Solicitar Laudo para finalizar o processo
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_LAUDO_FOOTER}    timeout=5s
    Click Element    ${LOC_BTN_SOLICITAR_LAUDO_FOOTER}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE BOTÕES
# ============================================================================

Botão Solicitar Laudo Deve Estar Visivel
    [Documentation]    Valida que o botão Solicitar Laudo está visível
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_LAUDO}    timeout=5s
    Element Should Be Visible    ${LOC_BTN_SOLICITAR_LAUDO}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE SEÇÕES
# ============================================================================

Secao Deve Estar Visivel
    [Documentation]    Valida que uma seção específica está visível
    [Arguments]    ${nome_secao}    ${servico}=Solicita
    IF    '${servico}' == 'Solicita'
        ${element}=    Set Variable    ${LOC_SECAO_VISIVEL}
    ELSE IF    '${servico}' == 'Reemite' or '${servico}' == 'Corrige'
        ${element}=    Set Variable    ${LOC_SECAO_VISIVEL_REEMITE}
    ELSE
        ${element}=    Fail    servico inválido: ${servico}
    END
    ${locator}=    Replace String    ${element}    {section_name}    ${nome_secao}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Scroll Element Into View    ${locator}
    Element Should Be Visible    ${locator}

Secao Nao Deve Estar Visivel
    [Documentation]    Valida que uma seção específica não está visível
    [Arguments]    ${nome_secao}    ${servico}=Solicita
    IF    '${servico}' == 'Solicita'
        ${element}=    Set Variable    ${LOC_SECAO_NAO_VISIVEL}
    ELSE IF    '${servico}' == 'Reemite' or '${servico}' == 'Corrige'
        ${element}=    Set Variable    ${LOC_SECAO_NAO_VISIVEL_REEMITE}
    ELSE
        ${element}=    Fail    servico inválido: ${servico}
    END
    ${locator}=    Replace String    ${element}    {section_name}    ${nome_secao}
    Element Should Not Be Visible    ${locator}

Secao Proposta E Cliente Deve Estar Visivel
    [Documentation]    Valida que a seção Proposta e Cliente está visível
    Wait Until Element Is Visible    ${LOC_CAMPO_FILIAL_RESUMO}    timeout=5s
    Element Should Be Visible    ${LOC_CAMPO_FILIAL_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_NUMERO_PROPOSTA_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_TIPO_CLIENTE_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_NOME_CLIENTE_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_DOCUMENTO_CLIENTE_RESUMO}

Secao Loja E Vendedor Deve Estar Visivel
    [Documentation]    Valida que a seção Loja e Vendedor está visível
    Wait Until Element Is Visible    ${LOC_CAMPO_CNPJ_RESUMO}    timeout=5s
    Element Should Be Visible    ${LOC_CAMPO_CNPJ_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_CPF_VENDEDOR_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_NOME_VENDEDOR_RESUMO}

Secao Dados Do Veiculo Deve Estar Visivel
    [Documentation]    Valida que a seção Dados do Veículo está visível
    Wait Until Element Is Visible    ${LOC_CAMPO_PLACA_RESUMO}    timeout=5s
    Element Should Be Visible    ${LOC_CAMPO_PLACA_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_RENAVAM_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_UF_PLACA_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_CIDADE_RESUMO}
    Element Should Be Visible    ${LOC_CAMPO_QUILOMETRAGEM_RESUMO}

Secao Itens De Seguranca Deve Estar Visivel
    [Documentation]    Valida que a seção Itens de Segurança está visível
    [Arguments]    ${servico}=Solicita
    IF    '${servico}' == 'Solicita'
        ${locator}=    Set Variable    ${LOC_SECAO_ITENS_SEGURANCA}
    ELSE IF    '${servico}' == 'Reemite'
        ${locator}=    Set Variable    ${LOC_SECAO_VISIVEL_REEMITE}
    ELSE
        ${locator}=    Fail    servico inválido: ${servico}
    END
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Secao Deve Estar Visivel    Itens de segurança

Secao Itens De Seguranca Nao Deve Estar Visivel
    [Documentation]    Valida que a seção Itens de Segurança não está visível
    Secao Nao Deve Estar Visivel    Itens de segurança

Secao Imagens Para Analise Deve Estar Visivel
    [Documentation]    Valida que a seção Imagens para Análise está visível
    [Arguments]    ${servico}=Solicita
    Secao Deve Estar Visivel    Imagens para análise    ${servico}
    Element Should Be Visible    ${LOC_TITULO_ANEXOS}

Secao Imagens Para Analise Nao Deve Estar Visivel
    [Documentation]    Valida que a seção Imagens para Análise não está visível
    [Arguments]    ${servico}=Solicita
    Secao Nao Deve Estar Visivel    Imagens para análise    ${servico}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE CAMPOS
# ============================================================================

Campo Deve Exibir Valor
    [Documentation]    Versão recomendada: valida separadamente (mais confiável)
    [Arguments]    ${nome_campo}    ${valor_esperado}

    # 1. Localiza o parágrafo com o label
    ${xpath_label}=    Set Variable    //p[contains(text(), '${nome_campo}')]
    Wait Until Element Is Visible    ${xpath_label}    timeout=5s

    # 2. Pega o próximo parágrafo (valor)
    ${xpath_valor}=    Set Variable    ${xpath_label}/following-sibling::p[1]
    Wait Until Element Is Visible    ${xpath_valor}    timeout=5s

    # 3. Valida o texto
    ${texto_obtido}=    Get Text    ${xpath_valor}
    Should Be Equal    ${texto_obtido}    ${valor_esperado}
    ...    msg=Valor do campo "${nome_campo}" incorreto. Esperado: "${valor_esperado}", Obtido: "${texto_obtido}"

Campo Deve Exibir Valor Nas Condições
    [Documentation]    Versão recomendada: valida separadamente (mais confiável)
    [Arguments]    ${nome_campo}    ${valor_esperado_1}    ${valor_esperado_2}

    # 1. Localiza o parágrafo com o label (Condição)
    ${locator}=    Replace String    ${LOC_CONDICAO_POR_CONDICAO}    {item_name}    ${nome_campo}
    Scroll Element Into View    ${locator}
    Element Should Be Visible    ${locator}

    # 2. Pega o próximo parágrafo (Tipo)
    ${xpath_valor_1}=    Set Variable    ${locator}${LOC_TIPO_POR_CONDICAO}
    Wait Until Element Is Visible    ${xpath_valor_1}    timeout=5s

    # 3. Pega o próximo parágrafo (Observação)
    ${xpath_valor_2}=    Set Variable    ${locator}${LOC_OBSERVACAO_POR_CONDICAO}
    Wait Until Element Is Visible    ${xpath_valor_2}    timeout=5s

    # 4. Valida o texto (Tipo)
    ${texto_obtido_1}=    Get Text    ${xpath_valor_1}
    Should Be Equal    ${texto_obtido_1}    ${valor_esperado_1}
    ...    msg=Valor do campo "${nome_campo}" incorreto. Esperado: "${valor_esperado_1}", Obtido: "${texto_obtido_1}"

    # 5. Valida o texto (Observação)
    ${texto_obtido_2}=    Get Text    ${xpath_valor_2}
    Should Be Equal    ${texto_obtido_2}    ${valor_esperado_2}
    ...    msg=Valor do campo "${nome_campo}" incorreto. Esperado: "${valor_esperado_2}", Obtido: "${texto_obtido_2}"

Campo Filial Deve Exibir
    [Documentation]    Valida valor do campo Filial
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Filial    ${valor}

Campo Numero Proposta Deve Exibir
    [Documentation]    Valida valor do campo Número da Proposta
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Número da proposta    ${valor}

Campo Tipo Cliente Deve Exibir
    [Documentation]    Valida valor do campo Tipo do Cliente
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Tipo do cliente    ${valor}

Campo Nome Cliente Deve Exibir
    [Documentation]    Valida valor do campo Nome do Cliente
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Nome do cliente    ${valor}

Campo Documento Cliente Deve Exibir
    [Documentation]    Valida valor do campo Documento do Cliente
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Documento do cliente    ${valor}

Campo CNPJ Deve Exibir
    [Documentation]    Valida valor do campo CNPJ
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    CNPJ    ${valor}

Campo CPF Vendedor Deve Exibir
    [Documentation]    Valida valor do campo CPF do Vendedor
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    CPF do vendedor    ${valor}

Campo Nome Vendedor Deve Exibir
    [Documentation]    Valida valor do campo Nome do Vendedor
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Nome do vendedor    ${valor}

Campo Placa Deve Exibir
    [Documentation]    Valida valor do campo Placa
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Placa    ${valor}

Campo RENAVAM Deve Exibir
    [Documentation]    Valida valor do campo RENAVAM
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    RENAVAM    ${valor}

Campo UF Placa Deve Exibir
    [Documentation]    Valida valor do campo UF da Placa
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    UF da placa    ${valor}

Campo Cidade Deve Exibir
    [Documentation]    Valida valor do campo Cidade
    [Arguments]    ${valor}
    Campo Deve Exibir Valor    Cidade    ${valor}

Campo Quilometragem Deve Exibir
    [Documentation]    Valida valor do campo Quilometragem
    [Arguments]    ${valor}
    Wait Until Element Is Visible    ${LOC_CAMPO_QUILOMETRAGEM_RESUMO}    timeout=5s
    Element Should Contain    ${LOC_CAMPO_QUILOMETRAGEM_RESUMO}    ${valor}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE ITENS DE SEGURANÇA
# ============================================================================

Item Selecionado Deve Estar Visivel
    [Documentation]    Valida que um item selecionado está visível
    [Arguments]    ${nome_item}    ${servico}=Solicita

    IF    '${servico}' == 'Solicita'
        ${elemento}=    Set Variable    ${LOC_ITEM_SELECIONADO_POR_NOME}
    ELSE IF    '${servico}' == 'Reemite' or '${servico}' == 'Corrige'
        ${elemento}=    Set Variable    ${LOC_ITEM_SELECIONADO_POR_NOME_REEMITE}
    ELSE
        ${elemento}=    Fail    servico inválido: ${servico}
    END

    ${locator}=    Replace String    ${elemento}    {item_name}    ${nome_item}
    Scroll Element Into View    ${locator}
    Element Should Be Visible    ${locator}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE CONDIÇÕES DO VEÍCULO POR TIPO
# ============================================================================

Campo Elétrica Deve Exibir
    [Documentation]    Valida valor do campo Elétrica
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Elétrica    ${valor_1}    ${valor_2}

Campo Lataria Deve Exibir
    [Documentation]    Valida valor do campo Lataria
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Lataria    ${valor_1}    ${valor_2}

Campo Mecânica Deve Exibir
    [Documentation]    Valida valor do campo Mecânica
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Mecânica    ${valor_1}    ${valor_2}

Campo Pintura Deve Exibir
    [Documentation]    Valida valor do campo Pintura
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Pintura    ${valor_1}    ${valor_2}

Campo Pneus Deve Exibir
    [Documentation]    Valida valor do campo Pneus
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Pneus    ${valor_1}    ${valor_2}

Campo Tapeçaria Deve Exibir
    [Documentation]    Valida valor do campo Tapeçaria
    [Arguments]    ${valor_1}    ${valor_2}
    Campo Deve Exibir Valor Nas Condições    Tapeçaria    ${valor_1}    ${valor_2}

# ============================================================================
# KEYWORDS GENÉRICAS - VALIDAÇÃO DE IMAGENS
# ============================================================================

Miniatura Resumo Deve Estar Visivel
    [Documentation]    Valida que miniatura de imagem está visível no resumo
    [Arguments]    ${nome_arquivo}
    ${locator}=    Replace String    ${LOC_MINIATURA_RESUMO_POR_NOME}    {filename}    ${nome_arquivo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}

Icone Exclusão Resumo Deve Estar Disponivel
    [Documentation]    Valida que ícone de exclusão está disponível
    [Arguments]    ${nome_arquivo}
    ${locator}=    Replace String    ${LOC_EXCLUIR_RESUMO_POR_NOME}    {filename}    ${nome_arquivo}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}

Titulo Anexos Deve Estar Visivel
    [Documentation]    Valida que o título Anexos está visível
    Wait Until Element Is Visible    ${LOC_TITULO_ANEXOS}    timeout=5s
    Element Should Be Visible    ${LOC_TITULO_ANEXOS}

# ============================================================================
# KEYWORDS ESPECÍFICAS - VALIDAÇÕES COMPLEXAS
# ============================================================================

Validar Quantidade De Miniaturas No Resumo
    [Documentation]    Valida quantidade de miniaturas exibidas no resumo
    [Arguments]    ${quantidade_esperada}    ${servico}=Solicita
    IF    '${servico}' == 'Solicita'
        ${locator}=    Set Variable    ${LOC_MINIATURA_RESUMO}
    ELSE IF    '${servico}' == 'Reemite' or '${servico}' == 'Corrige'
        ${locator}=    Set Variable    ${LOC_MINIATURA_RESUMO_REEMITE}
    ELSE
        ${locator}=    Fail    servico inválido: ${servico}
    END
    Scroll Element Into View    ${locator}
    ${miniaturas}=    Get Element Count    ${locator}
    Should Be Equal As Numbers    ${miniaturas}    ${quantidade_esperada}

Validar Todas Secoes Preenchidas Visiveis
    [Documentation]    Valida que todas as seções com dados estão visíveis
    [Arguments]    @{secoes}
    FOR    ${secao}    IN    @{secoes}
        Secao Deve Estar Visivel    ${secao}
    END

Validar Imagens No Resumo
    [Documentation]    Valida imagens exibidas no resumo
    [Arguments]    @{nomes_arquivos}
    FOR    ${nome}    IN    @{nomes_arquivos}
        Miniatura Resumo Deve Estar Visivel    ${nome}
    END

Validar Icones Exclusão Disponiveis
    [Documentation]    Valida ícones de Exclusão de todas as imagens
    [Arguments]    @{nomes_arquivos}
    FOR    ${nome}    IN    @{nomes_arquivos}
        Icone Exclusão Resumo Deve Estar Disponivel    ${nome}
    END

Modal Erro Deve Ser Fechado
    [Documentation]    Valida que modal erro foi fechado
    Sleep    1s
    Element Should Not Be Visible    ${LOC_MODAL_AUXILIAR}

Clicar Botao Tentar Emitir Novamente
    [Documentation]    Clica no botão Tentar novamente
    Wait Until Element Is Visible    ${LOC_BTN_TENTAR_NOVAMENTE}    timeout=5s
    Click Element    ${LOC_BTN_TENTAR_NOVAMENTE}

Clicar Botao Voltar Para Lista
    [Documentation]    Clica no botão Voltar para lista (erro)
    Wait Until Element Is Visible    //button[contains(text(), 'Voltar para lista de laudos')]    timeout=5s
    Click Element    //button[contains(text(), 'Voltar para lista de laudos')]

Clicar Botao Voltar Para a Lista
    [Documentation]    Clica no botão Voltar para lista (erro)
    Wait Until Element Is Visible    ${LOC_BTN_VOLTAR_LISTA_ERRO}    timeout=5s
    Click Element    ${LOC_BTN_VOLTAR_LISTA_ERRO}

Clicar Botao Fechar Modal Sucesso
    [Documentation]    Clica no botão X
    Wait Until Element Is Visible    ${LOC_BOTAO_FECHAR_MODAL_AUXILIAR}    timeout=5s
    Click Element    ${LOC_BOTAO_FECHAR_MODAL_AUXILIAR}

Nenhum Novo ID Deve Ser Gerado
    [Documentation]    Valida que não houve criação de ID
    Sleep    0.5s    # Valida estado
    Log    Nenhum ID foi gerado após cancelamento
    E a quantidade total de laudos permanece

Novo ID Deve Estar Visivel Na Primeira Posicao
    [Documentation]    Valida novo ID na primeira posição
    Wait Until Element Is Visible    ${LOC_TABELA_PRIMEIRA_LINHA}//td[1]    timeout=5s

    ${dados_linha_1}=    Obter Todos Dados Da Linha    1
    Log    Id antes da nova solicitação: ${dados_linha_1_inicial.id}
    Log    Id depois da nova solicitação (atual/novo id): ${dados_linha_1.id}
    Should Not Be Equal    ${dados_linha_1.id}    ${dados_linha_1_inicial.id}
    Set Test Variable    ${novo_id_gerado}    ${dados_linha_1.id}

Modal Principal Deve Ser Fechado
    [Documentation]    Valida fechamento do modal principal
    Wait Until Element Is Not Visible    ${LOC_MODAL_TITULO}    timeout=5s
    Element Should Not Be Visible    ${LOC_MODAL_TITULO}

Redirecionar Para Tela Lista De Laudos
    [Documentation]    Redireciona para lista de laudos
    Sleep    1s    # Aguarda redirecionamento
    Wait Until Element Is Enabled    ${LOC_TABELA}    timeout=10s

E a quantidade total de laudos ${acao_quantidade}
    [Documentation]    Compara a quantidade de laudos na listagem com a contagem inicial.
    ...    ${acao_quantidade}: "permanece" (nenhum laudo criado) ou "aumenta" (um novo laudo na lista).
    Sleep    2s
    Wait Until Element Is Visible    ${LOC_TABELA}
    ${quantidade}=    Obter Quantidade De Laudos Da Página
    IF    '${acao_quantidade}' == 'permanece'
        Should Be Equal    ${quantidade_inicial}    ${quantidade}
    ELSE IF    '${acao_quantidade}' == 'aumenta'
        ${subtitulo_quantitativa}=    Evaluate    ${quantidade_inicial} + ${1}
        Should Be Equal    ${subtitulo_quantitativa}    ${quantidade}
        Set Test Variable    ${quantidade_inicial}    ${subtitulo_quantitativa}
    ELSE IF    '${acao_quantidade}' == 'diminui'
        ${subtitulo_quantitativa}=    Evaluate    ${quantidade_inicial} - ${1}
        Should Be Equal    ${subtitulo_quantitativa}    ${quantidade}
    END

Validar ID Contem 17 Digitos
    [Documentation]    Valida formato do ID (17 dígitos)
    ${id_texto}=    Get Text    ${LOC_TABELA_PRIMEIRA_LINHA}//td[1]
    ${digitos}=    Get Regexp Matches    ${id_texto}    \\d{17}
    Length Should Be    ${digitos}    1

Campo Responsavel Deve Exibir Usuario Logado
    [Documentation]    Valida campo Responsável
    ${locator}=    Set Variable    ${LOC_TABELA_PRIMEIRA_LINHA}//td[2]
    ${usuario_texto}=    Get Text    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}
    Should Be Equal    ${nome_usuario_logado}    ${usuario_texto}

Campo Ultima Atualizacao Deve Exibir Data Atual
    [Documentation]    Valida se o campo Última Atualização exibe a data/hora atual
    ...    Compara diretamente com o horário da máquina de testes (deve estar em BRT)
    ...
    ...    **Formato esperado na coluna:** DD/MM/YYYY às HH:MM:SS
    ...    **Exemplo:** 23/01/2026 às 16:45:32
    ...
    ...    **Pré-requisito:** Máquina de testes deve estar com timezone de Brasília
    [Arguments]    ${tolerancia_segundos}=30

    ${locator}=    Set Variable    ${LOC_TABELA_PRIMEIRA_LINHA}//td[3]

    Wait Until Element Is Visible    ${locator}    timeout=5s
    Element Should Be Visible    ${locator}

    # ====================================
    # OBTER DATA/HORA DA COLUNA
    # ====================================
    ${data_texto}=    Get Text    ${locator}
    Log    📅 Data exibida na coluna: ${data_texto}    console=True

    # Remover a palavra "às" para facilitar conversão
    ${data_hora_limpa}=    Replace String    ${data_texto}    ${SPACE}às${SPACE}    ${SPACE}
    ${data_hora_limpa}=    Strip String    ${data_hora_limpa}

    # Converter texto da coluna para epoch
    ${data_coluna_epoch}=    Convert Date
    ...    ${data_hora_limpa}
    ...    date_format=%d/%m/%Y %H:%M:%S
    ...    result_format=epoch

    # ====================================
    # OBTER DATA/HORA ATUAL DA MÁQUINA DE TESTES
    # ====================================
    ${data_sistema_epoch}=    Get Current Date    result_format=epoch

    # Formatar para exibição no log
    ${data_sistema_formatada}=    Get Current Date    result_format=%d/%m/%Y às %H:%M:%S
    ${data_coluna_formatada}=    Convert Date
    ...    ${data_coluna_epoch}
    ...    result_format=%d/%m/%Y às %H:%M:%S

    # ====================================
    # CALCULAR DIFERENÇA E VALIDAR
    # ====================================
    ${diferenca}=    Evaluate    abs(${data_sistema_epoch} - ${data_coluna_epoch})

    # Validar que a diferença está dentro da tolerância
    ${validacao_passou}=    Evaluate    ${diferenca} <= ${tolerancia_segundos}

    IF    not ${validacao_passou}
        Log
        ...    ❌ FALHA: Diferença de ${diferenca}s excede tolerância de ${tolerancia_segundos}s
        ...    console=True
        ...    level=ERROR
        Fail
        ...    Diferença entre data do sistema e data da coluna excede tolerância.\n\n📊 DETALHES:\n• Sistema: ${data_sistema_formatada}\n• Coluna:
        ...    ${data_coluna_formatada}\n• Diferença: ${diferenca} segundos\n• Tolerância: ${tolerancia_segundos} segundos\n\n💡 POSSÍVEIS CAUSAS:\n1. Timezone da máquina de testes diferente do servidor\n2. Atraso na renderização da página\n3. Relógio do servidor desincronizado
    END

    Log
    ...    ✅ VALIDAÇÃO APROVADA: Diferença de ${diferenca}s está dentro da tolerância de ${tolerancia_segundos}s
    ...    console=True

Validar Campo Rejeitou Letras
    [Documentation]    Valida que letras foram rejeitadas
    [Arguments]    ${nome_campo}    ${xpath_campo}
    ${valor}=    Get Value    ${xpath_campo}
    Should Not Contain    ${valor}    ABC
    Should Not Contain    ${valor}    XYZ
    Should Be Empty    ${valor}

Validar Campo Rejeitou Negativo
    [Documentation]    Valida que o negativo foi rejeitado
    [Arguments]    ${nome_campo}    ${xpath_campo}
    ${valor}=    Get Value    ${xpath_campo}
    Should Not Contain    ${valor}    -

Expandir Secao Itens De Seguranca
    [Documentation]    Expande a seção "Itens de segurança"
    Expandir Accordion    ${LOC_ACCORDION_ITENS_SEGURANCA}

Colapsar Secao Itens De Seguranca
    [Documentation]    Colapsa a seção "Itens de segurança"
    Colapsar Accordion    ${LOC_ACCORDION_ITENS_SEGURANCA}

Validar Secao Itens Seguranca Expandida
    [Documentation]    Valida que a seção "Itens de segurança" está expandida
    Validar Elemento Visivel    ${LOC_ACCORDION_ITENS_EXPANDIDO}

Validar Secao Itens Seguranca Colapsada
    [Documentation]    Valida que a seção "Itens de segurança" está colapsada
    Validar Elemento Nao Visivel    ${LOC_ACCORDION_ITENS_EXPANDIDO}

Validar Secao Condições do veículo por tipo Expandida
    [Documentation]    Valida que a seção "Itens de segurança" está expandida
    Validar Elemento Visivel    ${LOC_ACCORDION_CONDICOES_EXPANDIDO}

Validar Elemento Visivel
    [Documentation]    Valida se um elemento está visível na tela
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Element Should Be Visible    ${locator}

Validar Elemento Nao Visivel
    [Documentation]    Valida se um elemento NÃO está visível na tela
    [Arguments]    ${locator}
    Element Should Not Be Visible    ${locator}

Selecionar Radio Button
    [Documentation]    Seleciona um radio button
    [Arguments]    ${locator}
    Sleep    1s
    Scroll Element Into View    ${locator}
    Click Element    ${locator}

Expandir Accordion
    [Documentation]    Expande um accordion se estiver colapsado
    [Arguments]    ${locator_header}
    ${is_expanded}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${locator_header}/parent::div[contains(@class, 'Mui-expanded')]
    Scroll Element Into View    ${locator_header}
    IF    not ${is_expanded}    Click Element    ${locator_header}
    Sleep    500ms    # Aguarda animação

Colapsar Accordion
    [Documentation]    Colapsa um accordion se estiver expandido
    [Arguments]    ${locator_header}
    ${is_expanded}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${locator_header}/parent::div[contains(@class, 'Mui-expanded')]
    Scroll Element Into View    ${locator_header}
    IF    ${is_expanded}    Click Element    ${locator_header}
    Sleep    500ms    # Aguarda animação

Selecionar Condicao Eletrica
    [Documentation]    Seleciona uma condição para Elétrica
    [Arguments]    ${tipo}    # Normal, Com falhas, Não funciona
    IF    '${tipo}' == 'Normal'
        Selecionar Radio Button    ${LOC_RADIO_ELETRICA_NORMAL}
    ELSE IF    '${tipo}' == 'Com falhas'
        Selecionar Radio Button    ${LOC_RADIO_ELETRICA_COM_FALHAS}
    ELSE IF    '${tipo}' == 'Não funciona'
        Selecionar Radio Button    ${LOC_RADIO_ELETRICA_NAO_FUNCIONA}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Eletrica
    [Documentation]    Preenche o campo de observação da condição Elétrica
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_ELETRICA}    ${texto}

Validar Campo Observacao Lataria Visivel
    [Documentation]    Valida que o campo de observação de Lataria está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_LATARIA}

Validar Campo Observacao Eletrica Visivel
    [Documentation]    Valida que o campo de observação de Elétrica está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_ELETRICA}

Validar Campo Observacao Mecânica Visivel
    [Documentation]    Valida que o campo de observação de Mecânica está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_MECANICA}

Validar Campo Observacao Pintura Visivel
    [Documentation]    Valida que o campo de observação de Pintura está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_PINTURA}

Validar Campo Observacao Pneus Visivel
    [Documentation]    Valida que o campo de observação de Pneus está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_PNEUS}

Validar Campo Observacao Tapeçaria Visivel
    [Documentation]    Valida que o campo de observação de Tapeçaria está visível
    Validar Elemento Visivel    ${LOC_CAMPO_OBS_TAPECARIA}

Selecionar Condicao Lataria
    [Documentation]    Seleciona uma condição para Lataria
    [Arguments]    ${tipo}    # Conservado, Danificado, Péssimo
    IF    '${tipo}' == 'Conservado'
        Selecionar Radio Button    ${LOC_RADIO_LATARIA_CONSERVADO}
    ELSE IF    '${tipo}' == 'Danificado'
        Selecionar Radio Button    ${LOC_RADIO_LATARIA_DANIFICADO}
    ELSE IF    '${tipo}' == 'Péssimo'
        Selecionar Radio Button    ${LOC_RADIO_LATARIA_PESSIMO}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Lataria
    [Documentation]    Preenche o campo de observação da condição Lataria
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_LATARIA}    ${texto}

Selecionar Condicao Mecanica
    [Documentation]    Seleciona uma condição para Mecânica
    [Arguments]    ${tipo}    # Normal, Com falhas, Não funciona
    IF    '${tipo}' == 'Normal'
        Selecionar Radio Button    ${LOC_RADIO_MECANICA_NORMAL}
    ELSE IF    '${tipo}' == 'Com falhas'
        Selecionar Radio Button    ${LOC_RADIO_MECANICA_COM_FALHAS}
    ELSE IF    '${tipo}' == 'Não funciona'
        Selecionar Radio Button    ${LOC_RADIO_MECANICA_NAO_FUNCIONA}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Mecanica
    [Documentation]    Preenche o campo de observação da condição Mecânica
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_MECANICA}    ${texto}

Selecionar Condicao Pintura
    [Documentation]    Seleciona uma condição para Pintura
    [Arguments]    ${tipo}    # Bom, Danificado, Péssimo
    IF    '${tipo}' == 'Bom'
        Selecionar Radio Button    ${LOC_RADIO_PINTURA_BOM}
    ELSE IF    '${tipo}' == 'Danificado'
        Selecionar Radio Button    ${LOC_RADIO_PINTURA_DANIFICADO}
    ELSE IF    '${tipo}' == 'Péssimo'
        Selecionar Radio Button    ${LOC_RADIO_PINTURA_PESSIMO}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Pintura
    [Documentation]    Preenche o campo de observação da condição Pintura
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_PINTURA}    ${texto}

Selecionar Condicao Pneus
    [Documentation]    Seleciona uma condição para Pneus
    [Arguments]    ${tipo}    # Novo, Bom estado, Péssimo
    IF    '${tipo}' == 'Novo'
        Selecionar Radio Button    ${LOC_RADIO_PNEUS_NOVO}
    ELSE IF    '${tipo}' == 'Bom estado'
        Selecionar Radio Button    ${LOC_RADIO_PNEUS_BOM_ESTADO}
    ELSE IF    '${tipo}' == 'Péssimo'
        Selecionar Radio Button    ${LOC_RADIO_PNEUS_PESSIMO}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Pneus
    [Documentation]    Preenche o campo de observação da condição Pneus
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_PNEUS}    ${texto}

Selecionar Condicao Tapecaria
    [Documentation]    Seleciona uma condição para Tapeçaria
    [Arguments]    ${tipo}    # Bom, Danificado, Péssimo
    IF    '${tipo}' == 'Bom'
        Selecionar Radio Button    ${LOC_RADIO_TAPECARIA_BOM}
    ELSE IF    '${tipo}' == 'Danificado'
        Selecionar Radio Button    ${LOC_RADIO_TAPECARIA_DANIFICADO}
    ELSE IF    '${tipo}' == 'Péssimo'
        Selecionar Radio Button    ${LOC_RADIO_TAPECARIA_PESSIMO}
    ELSE
        Fail    Tipo inválido: ${tipo}
    END

Preencher Observacao Tapecaria
    [Documentation]    Preenche o campo de observação da condição Tapeçaria
    [Arguments]    ${texto}
    Preencher Campo Observação    ${LOC_CAMPO_OBS_TAPECARIA}    ${texto}

Validar Campo Com Valor
    [Documentation]    Valida se um campo contém determinado valor
    [Arguments]    ${locator}    ${valor_esperado}
    ${valor_atual}=    Get Value    ${locator}
    Should Be Equal    ${valor_atual}    ${valor_esperado}

Validar Campo Observacao Contem Texto
    [Documentation]    Valida que o campo de observação de uma condição contém determinado texto
    [Arguments]    ${condicao}    ${texto_esperado}
    IF    '${condicao}' == 'Elétrica'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_ELETRICA}    ${texto_esperado}
    ELSE IF    '${condicao}' == 'Lataria'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_LATARIA}    ${texto_esperado}
    ELSE IF    '${condicao}' == 'Mecânica'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_MECANICA}    ${texto_esperado}
    ELSE IF    '${condicao}' == 'Pintura'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_PINTURA}    ${texto_esperado}
    ELSE IF    '${condicao}' == 'Pneus'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_PNEUS}    ${texto_esperado}
    ELSE IF    '${condicao}' == 'Tapeçaria'
        Validar Campo Com Valor    ${LOC_CAMPO_OBS_TAPECARIA}    ${texto_esperado}
    ELSE
        Fail    Condição não encontrada: ${condicao}
    END

Validar Condicao Selecionada
    [Documentation]    Valida que uma condição de veículo foi selecionada com o tipo correto
    [Arguments]    ${condicao}    ${tipo_esperado}
    IF    '${condicao}' == 'Elétrica'
        Validar Radio Button Selecionado Eletrica    ${tipo_esperado}
    ELSE IF    '${condicao}' == 'Lataria'
        Validar Radio Button Selecionado Lataria    ${tipo_esperado}
    ELSE IF    '${condicao}' == 'Mecânica'
        Validar Radio Button Selecionado Mecanica    ${tipo_esperado}
    ELSE IF    '${condicao}' == 'Pintura'
        Validar Radio Button Selecionado Pintura    ${tipo_esperado}
    ELSE IF    '${condicao}' == 'Pneus'
        Validar Radio Button Selecionado Pneus    ${tipo_esperado}
    ELSE IF    '${condicao}' == 'Tapeçaria'
        Validar Radio Button Selecionado Tapecaria    ${tipo_esperado}
    ELSE
        Fail    Condição não encontrada: ${condicao}
    END

Validar Radio Button Selecionado
    [Documentation]    Valida se um radio button está selecionado
    [Arguments]    ${locator}
    Sleep    1s
    Scroll Element Into View    ${locator}
    ${is_selected}=    Get Element Attribute    ${locator}    checked
    Should Be Equal    ${is_selected}    true    msg=Radio button não está selecionado: ${locator}

Validar Radio Button Selecionado Eletrica
    [Documentation]    Valida qual radio button está selecionado para Elétrica
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Normal'
        Validar Radio Button Selecionado    ${LOC_RADIO_ELETRICA_NORMAL}
    ELSE IF    '${tipo_esperado}' == 'Com falhas'
        Validar Radio Button Selecionado    ${LOC_RADIO_ELETRICA_COM_FALHAS}
    ELSE IF    '${tipo_esperado}' == 'Não funciona'
        Validar Radio Button Selecionado    ${LOC_RADIO_ELETRICA_NAO_FUNCIONA}
    ELSE
        Fail    Tipo inválido para Elétrica: ${tipo_esperado}
    END

Validar Radio Button Selecionado Lataria
    [Documentation]    Valida qual radio button está selecionado para Lataria
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Conservado'
        Validar Radio Button Selecionado    ${LOC_RADIO_LATARIA_CONSERVADO}
    ELSE IF    '${tipo_esperado}' == 'Danificado'
        Validar Radio Button Selecionado    ${LOC_RADIO_LATARIA_DANIFICADO}
    ELSE IF    '${tipo_esperado}' == 'Péssimo'
        Validar Radio Button Selecionado    ${LOC_RADIO_LATARIA_PESSIMO}
    ELSE
        Fail    Tipo inválido para Lataria: ${tipo_esperado}
    END

Validar Radio Button Selecionado Mecanica
    [Documentation]    Valida qual radio button está selecionado para Mecânica
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Normal'
        Validar Radio Button Selecionado    ${LOC_RADIO_MECANICA_NORMAL}
    ELSE IF    '${tipo_esperado}' == 'Com falhas'
        Validar Radio Button Selecionado    ${LOC_RADIO_MECANICA_COM_FALHAS}
    ELSE IF    '${tipo_esperado}' == 'Não funciona'
        Validar Radio Button Selecionado    ${LOC_RADIO_MECANICA_NAO_FUNCIONA}
    ELSE
        Fail    Tipo inválido para Mecânica: ${tipo_esperado}
    END

Validar Radio Button Selecionado Pintura
    [Documentation]    Valida qual radio button está selecionado para Pintura
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Bom'
        Validar Radio Button Selecionado    ${LOC_RADIO_PINTURA_BOM}
    ELSE IF    '${tipo_esperado}' == 'Danificado'
        Validar Radio Button Selecionado    ${LOC_RADIO_PINTURA_DANIFICADO}
    ELSE IF    '${tipo_esperado}' == 'Péssimo'
        Validar Radio Button Selecionado    ${LOC_RADIO_PINTURA_PESSIMO}
    ELSE
        Fail    Tipo inválido para Pintura: ${tipo_esperado}
    END

Validar Radio Button Selecionado Pneus
    [Documentation]    Valida qual radio button está selecionado para Pneus
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Novo'
        Validar Radio Button Selecionado    ${LOC_RADIO_PNEUS_NOVO}
    ELSE IF    '${tipo_esperado}' == 'Bom estado'
        Validar Radio Button Selecionado    ${LOC_RADIO_PNEUS_BOM_ESTADO}
    ELSE IF    '${tipo_esperado}' == 'Péssimo'
        Validar Radio Button Selecionado    ${LOC_RADIO_PNEUS_PESSIMO}
    ELSE
        Fail    Tipo inválido para Pneus: ${tipo_esperado}
    END

Validar Radio Button Selecionado Tapecaria
    [Documentation]    Valida qual radio button está selecionado para Tapeçaria
    [Arguments]    ${tipo_esperado}
    IF    '${tipo_esperado}' == 'Bom'
        Validar Radio Button Selecionado    ${LOC_RADIO_TAPECARIA_BOM}
    ELSE IF    '${tipo_esperado}' == 'Danificado'
        Validar Radio Button Selecionado    ${LOC_RADIO_TAPECARIA_DANIFICADO}
    ELSE IF    '${tipo_esperado}' == 'Péssimo'
        Validar Radio Button Selecionado    ${LOC_RADIO_TAPECARIA_PESSIMO}
    ELSE
        Fail    Tipo inválido para Tapeçaria: ${tipo_esperado}
    END
