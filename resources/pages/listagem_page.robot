*** Settings ***
Documentation       Page Object da tela "Lista de laudos".
...                 Passos Gherkin de navegação até a lista, menu de ações (três pontos),
...                 download do laudo e criação de laudos usados como pré-condição.
...
...                 Arquivo completado na versão de portfólio: estes passos são usados pela
...                 feature VC-16, mas ficavam em outro módulo do projeto original. Eles
...                 reaproveitam as keywords de baixo nível já existentes em
...                 tabela_keywords, listagem_keywords, modal_keywords e hooks.

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# DADO / QUANDO - NAVEGAÇÃO
# ============================================================================
Quando o usuário acessa a tela de listagem de laudos
    [Documentation]    A partir do portal, abre a ferramenta VeriCar (nova aba) e aguarda a lista de laudos.
    ...    Guarda o estado inicial da lista para as validações seguintes:
    ...    - ${quantidade_inicial}: total de laudos no contador ("1 - 10 de 49 registros" -> 49);
    ...    - ${dados_linha_1_inicial}: dados da primeira linha (usado para provar que um NOVO ID surgiu no topo).
    Clicar na ferramenta VeriCar
    Validar Pagina Listagem Carregada
    Guardar Estado Inicial Da Lista

Guardar Estado Inicial Da Lista
    [Documentation]    Registra quantidade e primeira linha da lista. Em uma conta sem laudos
    ...    (estado vazio) a quantidade é 0 e o ID inicial fica vazio.
    ${tem_laudos}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${LOC_TABELA_PRIMEIRA_LINHA}    timeout=10s
    IF    ${tem_laudos}
        ${quantidade}=    Obter Quantidade De Laudos Da Página
        ${dados_linha_1}=    Obter Todos Dados Da Linha    1
    ELSE
        ${quantidade}=    Set Variable    0
        ${dados_linha_1}=    Create Dictionary    id=${EMPTY}
    END
    Set Test Variable    ${quantidade_inicial}    ${quantidade}
    Set Test Variable    ${dados_linha_1_inicial}    ${dados_linha_1}
    Log    Estado inicial da lista: ${quantidade} laudo(s); primeiro ID: ${dados_linha_1.id}

E que botão "Solicitar laudo" está visível
    [Documentation]    Valida o botão "Solicitar laudo" no cabeçalho da lista, visível e habilitado.
    Validar Botao Solicitar Laudo No Header

Quando usuário clica no botão "Solicitar laudo"
    [Documentation]    Clica em "Solicitar laudo" no cabeçalho da lista e aguarda o modal abrir.
    Abrir Modal Solicitar Laudo

# ============================================================================
# ENTÃO - BOTÕES DO MODAL
# ============================================================================
E exibe botão "${texto_botao}" no rodapé
    [Documentation]    Valida que o botão está visível no rodapé do modal, habilitado ou não
    ...    (o "Continuar" começa desabilitado até o formulário ser preenchido).
    ${botao}=    Set Variable    ${LOC_MODAL_FOOTER}//button[normalize-space()='${texto_botao}']
    Wait Until Element Is Visible    ${botao}    timeout=10s
    Element Should Be Visible    ${botao}

E o botão do modal está habilitado e clicável
    [Documentation]    Valida que o botão do modal está visível e habilitado.
    [Arguments]    ${texto_botao}
    Validar Botao Modal    ${texto_botao}

E o botão do modal está desabilitado e clicável
    [Documentation]    Valida que o botão do modal está visível, porém DESABILITADO
    ...    (nome mantido como nos cenários originais).
    [Arguments]    ${texto_botao}
    Validar Botao Modal Desabilitado    ${texto_botao}

# ============================================================================
# MENU DE AÇÕES (três pontos)
# ============================================================================
E clica no ícone de três pontos do laudo desejado
    [Documentation]    Abre o menu de ações da linha do laudo informado.
    ...    O ID vem da pré-condição (ex.: ${LAUDO_COMPLETO}, criado no Suite Setup ou pelo
    ...    passo "Dado que tenha um laudo criado...").
    [Arguments]    ${id_laudo}
    Should Not Be Empty    ${id_laudo}
    ...    msg=ID do laudo vazio: a pré-condição de criação do laudo não foi executada.
    Clicar Menu Acoes Por ID    ${id_laudo}

Então sistema exibe menu dropdown próximo ao ícone
    [Documentation]    Valida que o menu de ações abriu com todas as opções visíveis.
    Validar Menu Acoes Expandido

E menu contém exatamente ${quantidade} opções na ordem
    [Documentation]    Valida a quantidade de opções do menu e a ordem definida em
    ...    listagem_laudo.yaml (Reemitir, Corrigir, Download).
    ${opcoes}=    Get Element Count    ${LOC_MENU_DROPDOWN}//li[@role='menuitem']
    Should Be Equal As Integers    ${opcoes}    ${quantidade}
    ...    msg=O menu deveria ter ${quantidade} opções, mas tem ${opcoes}.
    FOR    ${posicao}    ${opcao}    IN ENUMERATE    @{menu_acoes}    start=1
        Validar Opcao Esta Na Posicao    ${opcao}    ${posicao}
    END

Quando clica na opção "${opcao}"
    [Documentation]    Clica em uma opção do menu de ações (ex.: "Download do laudo").
    Clicar No Botao    ${opcao}

# ============================================================================
# DOWNLOAD
# ============================================================================
Então o arquivo é baixado com o nome
    [Documentation]    Aguarda o download terminar em results/downloads e guarda o nome
    ...    do arquivo em ${arquivo_baixado} (usado pelas validações do PDF).
    [Arguments]    ${nome_parcial}
    ${arquivo}=    Verificar se download foi concluído    ${nome_parcial}
    Should End With    ${arquivo}    .pdf    msg=O arquivo baixado não é um PDF: ${arquivo}

# ============================================================================
# DADO - LAUDOS CRIADOS COMO PRÉ-CONDIÇÃO
# Cada passo faz o fluxo completo pela interface e guarda o ID gerado em
# ${novo_id_gerado}. Também são usados pelo Suite Setup (hooks.robot).
# ============================================================================
Dado que tenha um laudo criado com todos os campos e a placa desejada
    [Documentation]    Cria um laudo com todos os campos, condições do veículo, itens de
    ...    segurança e as 6 imagens. ${placa} é opcional (padrão: placa aleatória da massa).
    ...    Ao final, ${LAUDO_COMPLETO} recebe o ID criado.
    [Arguments]    ${placa}=${EMPTY}
    Acessar Portal Com Usuario Padrao
    Quando estou no step "Anexos"    ${placa}
    E selecionei as 6 imagens permitidas
    Quando clico no botão "Continuar"
    E entrar na etapa    4    ${vericar_modal.solicitar_laudo.titulo_etapa_4}
    Solicitar Laudo E Guardar Novo ID
    Set Test Variable    ${LAUDO_COMPLETO}    ${novo_id_gerado}

Dado que tenha um laudo criado com todos os campos e a placa desejada para reemissão
    [Documentation]    Mesmo fluxo do laudo completo, com uma placa específica
    ...    (ex.: placa com retorno parcial da base estadual, para testar a reemissão).
    [Arguments]    ${placa}
    Dado que tenha um laudo criado com todos os campos e a placa desejada    ${placa}

Dado que tenha um laudo criado sem imagens
    [Documentation]    Cria um laudo com dados e itens de segurança, pulando a etapa de anexos.
    Acessar Portal Com Usuario Padrao
    Quando estou no step "Anexos"
    Quando clico no botão "Pular etapa"
    E entrar na etapa    4    ${vericar_modal.solicitar_laudo.titulo_etapa_4}
    Solicitar Laudo E Guardar Novo ID

Dado que tenha um laudo básico criado sem itens de segurança e imagens
    [Documentation]    Cria um laudo apenas com os dados obrigatórios: pula as etapas Itens e Anexos.
    Acessar Portal Com Usuario Padrao
    Quando estou no step "Itens"
    Quando clico no botão "Pular etapa"
    E entrar na etapa    3    ${vericar_modal.solicitar_laudo.titulo_etapa_3}
    Quando clico no botão "Pular etapa"
    E entrar na etapa    4    ${vericar_modal.solicitar_laudo.titulo_etapa_4}
    Solicitar Laudo E Guardar Novo ID

Acessar Portal Com Usuario Padrao
    [Documentation]    Login com o usuário super e troca para a conta de testes.
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001

Solicitar Laudo E Guardar Novo ID
    [Documentation]    No Step Resumo: solicita o laudo, volta para a lista e captura o novo ID
    ...    na primeira linha (${novo_id_gerado}).
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
    Quando clico no botão "Voltar para lista de laudos"
    E sou redirecionado para a tela "Lista de laudos"
    E o novo ID do laudo é exibido na lista
    Log To Console    ✓ Laudo criado: ${novo_id_gerado}

# ============================================================================
# FILTRO POR DATA
# ============================================================================
Validar Botoes Calendario Funcionais
    [Documentation]    Após abrir o filtro por data, valida que o calendário está aberto e
    ...    que o botão "Aplicar" está visível e habilitado.
    Wait Until Element Is Visible    ${LOC_CAL_BTN_APLICAR}    timeout=10s
    Element Should Be Enabled    ${LOC_CAL_BTN_APLICAR}
