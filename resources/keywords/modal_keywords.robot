*** Settings ***
Documentation       Keywords para menu de ações e modais da listagem

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# MODAIS
# ============================================================================

E abrir modal contendo
    [Documentation]    Valida se o conjunto do MODAL PRINCIPAL corresponde ao esperado
    [Arguments]    ${titulo}
    Sleep    4s
    # Valida título e botão 'Fechar' do modal
    Validar Titulo Do Modal    ${LOC_MODAL_TITULO}    ${titulo}
    Wait Until Element Is Visible    ${LOC_BOTAO_FECHAR_MODAL}
    Element Should Be Enabled    ${LOC_BOTAO_FECHAR_MODAL}

E visualizar modal contendo
    [Documentation]    Valida se o conjunto do MODAL AUXILIAR corresponde ao esperado
    [Arguments]
    ...    ${titulo}
    ...    ${mensagem1}=${None}
    ...    ${mensagem2}=${None}
    ...    ${botao1}=${None}
    ...    ${botao2}=${None}
    Sleep    1s
    # Aguarda modal estar visível antes de validar
    Wait Until Element Is Visible    ${LOC_MODAL_AUXILIAR_TITULO}

    # Valida título do modal
    Validar Titulo Do Modal Auxiliar    ${LOC_MODAL_AUXILIAR_TITULO}    ${titulo}

    # Valida botão 'Fechar' do modal
    Wait Until Element Is Visible    ${LOC_BOTAO_FECHAR_MODAL_AUXILIAR}
    Element Should Be Enabled    ${LOC_BOTAO_FECHAR_MODAL_AUXILIAR}

    # Valida mensagens opcionais
    IF    '${mensagem1}' != '${None}'
        Validar Mensagem Modal    ${LOC_SUB_TITULO_MODAL_AUXILIAR}    ${mensagem1}
    END
    IF    '${mensagem2}' != '${None}'
        Validar Mensagem Modal    ${LOC_TEXTO_MODAL_AUXILIAR}    ${mensagem2}
    END

    # Valida botões opcionais
    IF    '${botao1}' != '${None}'    Validar Botao Modal    ${botao1}
    IF    '${botao2}' != '${None}'    Validar Botao Modal    ${botao2}

    Log    ✓ Modal validado com sucesso: ${titulo}

Validar Titulo Do Modal
    [Documentation]    Valida se o título do modal corresponde ao esperado
    [Arguments]    ${locator}    ${titulo_esperado}

    ${xpath_titulo}=    Set Variable
    ...    ${LOC_MODAL_TITULO}\[normalize-space(text())=normalize-space('${titulo_esperado}')]

    Wait Until Element Is Visible    ${xpath_titulo}
    Element Text Should Be    ${LOC_MODAL_TITULO}    ${titulo_esperado}    ignore_case=False

Validar Titulo Do Modal Auxiliar
    [Documentation]    Valida se o título do modal corresponde ao esperado
    [Arguments]    ${locator}    ${titulo_esperado}

    ${xpath_titulo}=    Set Variable
    ...    ${LOC_MODAL_AUXILIAR_TITULO}\[normalize-space(text())=normalize-space('${titulo_esperado}')]

    Wait Until Element Is Visible    ${xpath_titulo}
    Element Text Should Be    ${LOC_MODAL_AUXILIAR_TITULO}    ${titulo_esperado}    ignore_case=False

Validar Mensagem Modal
    [Documentation]    Valida se uma mensagem específica está visível no modal
    [Arguments]    ${locator}    ${texto_esperado}

    Wait Until Element Is Visible    ${locator}
    ${texto_atual}=    Get Text    ${locator}
    ${texto_atual_normalizado}=    Strip String    ${texto_atual}
    ${texto_esperado_normalizado}=    Strip String    ${texto_esperado}

    Should Contain    ${texto_atual_normalizado}    ${texto_esperado_normalizado}
    ...    msg=Mensagem não encontrada. Esperado: '${texto_esperado_normalizado}' | Atual: '${texto_atual_normalizado}'

Validar Botao Modal
    [Documentation]    Valida se um botão específico está visível e habilitado no modal
    [Arguments]    ${texto_botao}

    ${xpath_botao}=    Set Variable
    ...    //button[normalize-space(text())=normalize-space('${texto_botao}')]

    Wait Until Element Is Visible    ${xpath_botao}
    Element Should Be Enabled    ${xpath_botao}

Validar Botao Modal Desabilitado
    [Documentation]    Valida se um botão específico está visível e desabilitado no modal
    [Arguments]    ${texto_botao}

    ${xpath_botao}=    Set Variable
    ...    //button[normalize-space(text())=normalize-space('${texto_botao}')]

    Wait Until Element Is Visible    ${xpath_botao}
    Element Should Be Disabled    ${xpath_botao}

Então sistema abre o ${tipo_modal}
    [Documentation]    Valida que o modal informado foi aberto, conferindo o título e, quando aplicável,
    ...    os indicadores de etapa (stepper). Ex.: Então sistema abre o "Solicitar laudo".
    IF    ${tipo_modal} == 'Solicitar laudo'
        E abrir modal contendo
        ...    titulo=${vericar_modal.solicitar_laudo.titulo}
    ELSE IF    ${tipo_modal} == 'Corrigir laudo'
        E abrir modal contendo
        ...    titulo=${correcao_modal.correcao_laudo.titulo}

        ${step1}=    Create Dictionary
        ...    numero=1
        ...    nome=${correcao_modal.correcao_laudo.titulo_etapa_1}
        ...    status=ativo
        ${step2}=    Create Dictionary
        ...    numero=2
        ...    nome=${correcao_modal.correcao_laudo.titulo_etapa_2}
        ...    status=inativo

        Validar Sequencia De Steps    ${step1}    ${step2}
    ELSE IF    ${tipo_modal} == 'Reemitir laudo'
        E abrir modal contendo
        ...    titulo=${reemitir_modal.reemitir_laudo.titulo}
    ELSE IF    ${tipo_modal} == 'Emissão em processamento'
        E visualizar modal contendo
        ...    titulo=${vericar_modal.emissao_em_processamento.titulo}
        ...    mensagem1=${vericar_modal.emissao_em_processamento.conteudo_1}
        ...    botao1=${vericar_modal.emissao_em_processamento.botao_1}
    ELSE IF    ${tipo_modal} == 'Emissão com erro'
        E visualizar modal contendo
        ...    titulo=${vericar_modal.emissao_erro.titulo}
        ...    mensagem1=${vericar_modal.emissao_erro.conteudo_1}
        ...    mensagem2=${vericar_modal.emissao_erro.conteudo_2}
        ...    botao1=${vericar_modal.emissao_erro.botao_1}
        ...    botao2=${vericar_modal.emissao_erro.botao_2}
    ELSE IF    ${tipo_modal} == 'Correção com sucesso'
        E visualizar modal contendo
        ...    titulo=${correcao_modal.correcao_sucesso.titulo}
        ...    mensagem1=${correcao_modal.correcao_sucesso.conteudo_1}
        ...    botao1=${correcao_modal.correcao_sucesso.botao_1}
        ...    botao2=${correcao_modal.correcao_sucesso.botao_2}
    ELSE IF    ${tipo_modal} == 'Correção com erro'
        E visualizar modal contendo
        ...    titulo=${correcao_modal.correcao_erro.titulo}
        ...    mensagem1=${correcao_modal.correcao_erro.conteudo_1}
        ...    mensagem2=${correcao_modal.correcao_erro.conteudo_2}
        ...    botao1=${correcao_modal.correcao_erro.botao_1}
        ...    botao2=${correcao_modal.correcao_erro.botao_2}
    ELSE IF    ${tipo_modal} == 'Reemissão com sucesso'
        E visualizar modal contendo
        ...    titulo=${reemitir_modal.reemissao_sucesso.titulo}
        ...    mensagem1=${reemitir_modal.reemissao_sucesso.conteudo_1}
        ...    mensagem2=${reemitir_modal.reemissao_sucesso.conteudo_2}
        ...    botao1=${reemitir_modal.reemissao_sucesso.botao_1}
        ...    botao2=${reemitir_modal.reemissao_sucesso.botao_2}
    ELSE IF    ${tipo_modal} == 'Reemissão com erro'
        E visualizar modal contendo
        ...    titulo=${reemitir_modal.reemissao_erro.titulo}
        ...    mensagem1=${reemitir_modal.reemissao_erro.conteudo_1}
        ...    mensagem2=${reemitir_modal.reemissao_erro.conteudo_2}
        ...    botao1=${reemitir_modal.reemissao_erro.botao_1}
        ...    botao2=${reemitir_modal.reemissao_erro.botao_2}
    END

E entrar na etapa
    [Documentation]    Valida que o modal está na etapa informada: título visível e stepper com a etapa
    ...    atual ativa, as anteriores concluídas e as seguintes pendentes.
    [Arguments]    ${numero_etapa}    ${titulo}

    ${xpath}=    Set Variable    //p[normalize-space(text())='${titulo}']

    Wait Until Element Is Visible    ${xpath}
    Element Should Be Visible    ${xpath}

    IF    '${numero_etapa}' == '1'
        ${step1}=    Create Dictionary    numero=1    nome=Dados    status=ativo
        ${step2}=    Create Dictionary    numero=2    nome=Itens    status=inativo
        ${step3}=    Create Dictionary    numero=3    nome=Anexos    status=inativo
        ${step4}=    Create Dictionary    numero=4    nome=Resumo    status=inativo

        Validar Sequencia De Steps    ${step1}    ${step2}    ${step3}    ${step4}
    ELSE IF    '${numero_etapa}' == '2' and '${titulo}' == 'Resumo'
        ${step1}=    Create Dictionary    numero=1    nome=Corrigir    status=concluido
        ${step2}=    Create Dictionary    numero=2    nome=Resumo    status=ativo

        Validar Sequencia De Steps    ${step1}    ${step2}
    ELSE IF    '${numero_etapa}' == '2'
        ${step1}=    Create Dictionary    numero=1    nome=Dados    status=concluido
        ${step2}=    Create Dictionary    numero=2    nome=Itens    status=ativo
        ${step3}=    Create Dictionary    numero=3    nome=Anexos    status=inativo
        ${step4}=    Create Dictionary    numero=4    nome=Resumo    status=inativo

        Validar Sequencia De Steps    ${step1}    ${step2}    ${step3}    ${step4}
    ELSE IF    '${numero_etapa}' == '3'
        ${step1}=    Create Dictionary    numero=1    nome=Dados    status=concluido
        ${step2}=    Create Dictionary    numero=2    nome=Itens    status=concluido
        ${step3}=    Create Dictionary    numero=3    nome=Anexos    status=ativo
        ${step4}=    Create Dictionary    numero=4    nome=Resumo    status=inativo

        Validar Sequencia De Steps    ${step1}    ${step2}    ${step3}    ${step4}
    ELSE IF    '${numero_etapa}' == '4'
        ${step1}=    Create Dictionary    numero=1    nome=Dados    status=concluido
        ${step2}=    Create Dictionary    numero=2    nome=Itens    status=concluido
        ${step3}=    Create Dictionary    numero=3    nome=Anexos    status=concluido
        ${step4}=    Create Dictionary    numero=4    nome=Resumo    status=ativo

        Validar Sequencia De Steps    ${step1}    ${step2}    ${step3}    ${step4}
    END

# ===========================================
# KEYWORDS DE STEPS (INDICADORES DE PROGRESSO)
# ===========================================

Validar Step Esta Ativo
    [Documentation]    Verifica se um step específico está ativo (azul)
    [Arguments]    ${numero_step}    ${nome_step}

    # Validar pelo número do step
    ${loc_numero}=    Set Variable    //div[contains(@class,'css-90hjbj')]//p[contains(text(),'${numero_step}')]
    Element Should Be Visible    ${loc_numero}
    ...    msg=Step ${numero_step} não está visível com classe ativa

    # Validar pelo nome do step
    ${loc_ativo}=    Set Variable
    ...    //p[contains(text(),'${nome_step}')]/preceding-sibling::div[contains(@class,'css-90hjbj')]
    Element Should Be Visible    ${loc_ativo}
    ...    msg=Step '${nome_step}' não está ativo

    Log    ✅ Step ${numero_step} - '${nome_step}' está ATIVO

Validar Step Esta Inativo
    [Documentation]    Verifica se um step específico está inativo (cinza)
    [Arguments]    ${numero_step}    ${nome_step}

    # Validar pelo número do step com classe inativa
    ${loc_inativo}=    Set Variable
    ...    //div[contains(@class,'css-u6zh8m')]//p[contains(text(),'${numero_step}')]
    Element Should Be Visible    ${loc_inativo}
    ...    msg=Step ${numero_step} - '${nome_step}' não está inativo

    Log    ✅ Step ${numero_step} - '${nome_step}' está INATIVO

Validar Step Esta Concluido
    [Documentation]    Verifica se um step foi concluído (com ícone de check)
    [Arguments]    ${nome_step}

    ${loc_check}=    Set Variable
    ...    //p[contains(text(),'${nome_step}')]/parent::div[contains(@class, 'css-u6zh8m')]//*[contains(@class, 'material-symbols') and text()='check']
    Scroll Element Into View    ${loc_check}
    Element Should Be Visible    ${loc_check}
    ...    msg=Step '${nome_step}' não está marcado como concluído

    Log    ✅ Step '${nome_step}' está CONCLUÍDO

Validar Status Do Step
    [Documentation]    Valida o status de um step (ativo, inativo ou concluído)
    [Arguments]    ${numero_step}    ${nome_step}    ${status}

    IF    '${status}' == 'ativo'
        Validar Step Esta Ativo    ${numero_step}    ${nome_step}
    ELSE IF    '${status}' == 'inativo'
        Validar Step Esta Inativo    ${numero_step}    ${nome_step}
    ELSE IF    '${status}' == 'concluido' or '${status}' == 'concluído'
        Validar Step Esta Concluido    ${nome_step}
    ELSE
        Fail    Status inválido: ${status}. Use 'ativo', 'inativo' ou 'concluido'
    END

Validar Sequencia De Steps
    [Documentation]    Valida o estado de múltiplos steps de uma vez
    [Arguments]    @{steps_config}

    FOR    ${step}    IN    @{steps_config}
        ${numero}=    Get From Dictionary    ${step}    numero
        ${nome}=    Get From Dictionary    ${step}    nome
        ${status}=    Get From Dictionary    ${step}    status
        Validar Status Do Step    ${numero}    ${nome}    ${status}
    END

    Log    ✅ Todos os steps foram validados com sucesso
