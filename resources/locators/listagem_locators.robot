*** Settings ***
Documentation       Elementos da tela "Lista de laudos": cabeçalho, tabela, ordenação,
...                 menu de ações (três pontos), paginação e estado vazio.
...
...                 Este arquivo foi reconstruído na versão de portfólio: o mapeamento
...                 original ficava em outro módulo do projeto (feature de Listagem) que
...                 não fazia parte desta entrega. Os seletores seguem o padrão de
...                 componentes Material UI usado no restante do projeto.


*** Variables ***
# ============================================================================
# CABEÇALHO DA PÁGINA
# ============================================================================
${LOC_TITULO_PAGINA}                            //*[self::h1 or self::h4 or self::h5][normalize-space()='Lista de laudos']
${LOC_BTN_SOLICITAR_LAUDO}                      //button[normalize-space()='Solicitar laudo']
${LOC_BTN_USUARIO}                              //header//button[.//*[@data-testid='PersonIcon'] or .//*[@data-testid='AccountCircleIcon']]
${LOC_BTN_FILTRAR_DATA}                         //button[normalize-space()='Filtrar por data']
${LOC_CAL_BTN_APLICAR}                          //div[contains(@class,'MuiPickersLayout-root')]//button[normalize-space()='Aplicar']
${LOC_BOTAO_LIMPAR_FILTROS}                     //button[normalize-space()='Limpar filtros']
${LOC_LINK_LIMPAR_FILTROS}                      //a[normalize-space()='Limpar filtros'] | //p[normalize-space()='Limpar filtros']

# ============================================================================
# TABELA DE LAUDOS
# ============================================================================
${LOC_TABELA}                                   //table[contains(@class,'MuiTable-root')]
${LOC_TABELA_THEAD}                             //table[contains(@class,'MuiTable-root')]/thead
${LOC_TABELA_TBODY}                             //table[contains(@class,'MuiTable-root')]/tbody
${LOC_TABELA_LINHAS}                            //table[contains(@class,'MuiTable-root')]/tbody/tr
${LOC_TABELA_PRIMEIRA_LINHA}                    (//table[contains(@class,'MuiTable-root')]/tbody/tr)[1]

# Cabeçalhos das colunas
${LOC_TH_ID_LAUDO}                              //thead//th[contains(normalize-space(),'ID do Laudo')]
${LOC_TH_RESPONSAVEL}                           //thead//th[contains(normalize-space(),'Responsável')]
${LOC_TH_ULTIMA_ATUALIZACAO}                    //thead//th[contains(normalize-space(),'Última atualização')]
${LOC_TH_STATUS}                                //thead//th[contains(normalize-space(),'Status')]
${LOC_TH_ACOES}                                 //thead//th[contains(normalize-space(),'Ações')]

# ============================================================================
# ORDENAÇÃO (ícones dentro do cabeçalho de cada coluna)
# ============================================================================
${LOC_ICON_ORDENAR_ID}                          ${LOC_TH_ID_LAUDO}
${LOC_ICON_ORDENAR_RESPONSAVEL}                 ${LOC_TH_RESPONSAVEL}
${LOC_ICON_ORDENAR_DATA}                        ${LOC_TH_ULTIMA_ATUALIZACAO}
${LOC_ICON_ORDENAR_STATUS}                      ${LOC_TH_STATUS}

${LOC_ICON_ORDENAR_ID_CRESCENTE}                ${LOC_TH_ID_LAUDO}//*[@data-testid='ArrowUpwardIcon']
${LOC_ICON_ORDENAR_ID_DECRESCENTE}              ${LOC_TH_ID_LAUDO}//*[@data-testid='ArrowDownwardIcon']
${LOC_ICON_ORDENAR_RESPONSAVEL_CRESCENTE}       ${LOC_TH_RESPONSAVEL}//*[@data-testid='ArrowUpwardIcon']
${LOC_ICON_ORDENAR_RESPONSAVEL_DECRESCENTE}     ${LOC_TH_RESPONSAVEL}//*[@data-testid='ArrowDownwardIcon']
${LOC_ICON_ORDENAR_DATA_CRESCENTE}              ${LOC_TH_ULTIMA_ATUALIZACAO}//*[@data-testid='ArrowUpwardIcon']
${LOC_ICON_ORDENAR_DATA_DECRESCENTE}            ${LOC_TH_ULTIMA_ATUALIZACAO}//*[@data-testid='ArrowDownwardIcon']
${LOC_ICON_ORDENAR_STATUS_CRESCENTE}            ${LOC_TH_STATUS}//*[@data-testid='ArrowUpwardIcon']
${LOC_ICON_ORDENAR_STATUS_DECRESCENTE}          ${LOC_TH_STATUS}//*[@data-testid='ArrowDownwardIcon']

# ============================================================================
# MENU DE AÇÕES (três pontos de cada linha)
# ============================================================================
${LOC_MENU_DROPDOWN}                            //ul[@role='menu']
${LOC_MENU_ITEM_REEMITIR}                       //ul[@role='menu']//li[@role='menuitem'][normalize-space()='Reemitir laudo']
${LOC_MENU_ITEM_CORRIGIR}                       //ul[@role='menu']//li[@role='menuitem'][normalize-space()='Corrigir laudo']
${LOC_MENU_ITEM_DOWNLOAD}                       //ul[@role='menu']//li[@role='menuitem'][normalize-space()='Download do laudo']

# ============================================================================
# PAGINAÇÃO
# ============================================================================
# Contador no formato "1 - 10 de 49 registros"
${LOC_CONTADOR_REGISTROS}                       //p[contains(normalize-space(),' de ') and contains(normalize-space(),'registros')]
${LOC_BTN_PAGINA_ATIVA}                         //nav//button[contains(@class,'Mui-selected')]
${LOC_BTN_ITENS_POR_PAGINA}                     //div[@role='combobox' and ancestor::*[.//p[contains(text(),'por página')]]]
${LOC_MENU_ITENS_DROPDOWN}                      //ul[@role='listbox']
${LOC_OPCAO_10_ITENS}                           //ul[@role='listbox']/li[@data-value='10']
${LOC_OPCAO_20_ITENS}                           //ul[@role='listbox']/li[@data-value='20']
${LOC_OPCAO_50_ITENS}                           //ul[@role='listbox']/li[@data-value='50']

# ============================================================================
# ESTADO VAZIO (conta sem laudos)
# ============================================================================
${LOC_ICONE_VAZIO}                              //*[@data-testid='InboxIcon' or @data-testid='DescriptionOutlinedIcon']
${LOC_MSG_SEM_LAUDOS}                           //p[contains(normalize-space(),'não possui laudos')]
${LOC_MSG_SOLICITAR_LAUDO}                      //p[contains(normalize-space(),'não possui laudos')]/following-sibling::p[1]
${LOC_BTN_SOLICITAR_VAZIO}                      //p[contains(normalize-space(),'não possui laudos')]/following::button[normalize-space()='Solicitar laudo'][1]
