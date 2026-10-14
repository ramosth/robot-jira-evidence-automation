*** Settings ***
Documentation       Keywords de validações e ações específicas da tela de listagem

Resource            ../../config/package.robot


*** Keywords ***
# ========================================
# VALIDAÇÕES DO ESTADO VAZIO
# ========================================

Validar Icone Visual De Lista Vazia
    [Documentation]    Valida que o ícone de lista vazia está centralizado e visível
    Wait Until Element Is Visible    ${LOC_ICONE_VAZIO}
    Element Should Be Visible    ${LOC_ICONE_VAZIO}

Validar Mensagem Principal Vazia
    [Documentation]    Valida a mensagem "Você não possui laudos!"
    Wait Until Element Is Visible    ${LOC_MSG_SEM_LAUDOS}
    Element Should Contain    ${LOC_MSG_SEM_LAUDOS}    ${mensagens.estado_vazio.titulo}

Validar Texto Orientacao Solicitar Laudo
    [Documentation]    Valida o texto de orientação para solicitar laudo
    Wait Until Element Is Visible    ${LOC_MSG_SOLICITAR_LAUDO}
    Element Should Contain    ${LOC_MSG_SOLICITAR_LAUDO}    ${mensagens.estado_vazio.descricao}

Validar Botao Solicitar Laudo No Centro
    [Documentation]    Valida que o botão "Solicitar laudo" está visível no centro da área vazia
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_VAZIO}
    Element Should Be Enabled    ${LOC_BTN_SOLICITAR_VAZIO}
    Element Text Should Be    ${LOC_BTN_SOLICITAR_VAZIO}    Solicitar laudo

Validar Botao Solicitar Laudo No Header
    [Documentation]    Valida que o botão "Solicitar laudo" no canto superior direito está visível
    Wait Until Element Is Visible    ${LOC_BTN_SOLICITAR_LAUDO}
    Element Should Be Enabled    ${LOC_BTN_SOLICITAR_LAUDO}
    Element Text Should Be    ${LOC_BTN_SOLICITAR_LAUDO}    Solicitar laudo

# ========================================
# VALIDAÇÕES DE ELEMENTOS NÃO PRESENTES
# ========================================

Validar Que Controles De Paginacao Nao Estao Visiveis
    [Documentation]    Valida que os controles de paginação NÃO estão visíveis
    Element Should Not Be Visible    ${LOC_BTN_ITENS_POR_PAGINA}

Clicar No Botao
    [Documentation]    Clica em um botão específico pelo nome
    [Arguments]    ${nome_botao}
    IF    '${nome_botao}' == 'Filtrar por data'
        Click Element    ${LOC_BTN_FILTRAR_DATA}

        Validar Botoes Calendario Funcionais
    END
    IF    '${nome_botao}' == 'Aplicar'
        Click Element    ${LOC_CAL_BTN_APLICAR}
    END
    IF    '${nome_botao}' == 'Limpar filtros'
        Click Element    ${LOC_BOTAO_LIMPAR_FILTROS}
    END
    IF    '${nome_botao}' == 'Solicitar laudo'
        Click Element    ${LOC_BTN_SOLICITAR_LAUDO}
    END
    IF    '${nome_botao}' == 'Download do laudo'
        Click Element    ${LOC_MENU_ITEM_DOWNLOAD}
    END
    IF    '${nome_botao}' == 'Corrigir laudo'
        Click Element    ${LOC_MENU_ITEM_CORRIGIR}
    END
    IF    '${nome_botao}' == 'Reemitir laudo'
        Click Element    ${LOC_MENU_ITEM_REEMITIR}
    END
    IF    '${nome_botao}' == 'Solicitar Laudo Centro'
        Click Element    ${LOC_BTN_SOLICITAR_VAZIO}
    END
    IF    '${nome_botao}' == 'Link Limpar Filtros'
        Click Element    ${LOC_LINK_LIMPAR_FILTROS}
    END
    Sleep    2s
