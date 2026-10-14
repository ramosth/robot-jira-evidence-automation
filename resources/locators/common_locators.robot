*** Settings ***
Documentation       Elementos referente aos itens comuns dos componentes: Filtro, Modal, Mensagem central da tela sem resultados, Snackbar e Tooltip


*** Variables ***
# Loading
${LOADING_ICONE}                        //div[@class='lds-interwind']

# Snackbar
${SNACKBAR_SUPERIOR_LATERAL_DIREITO}    //div[contains(@class,'MuiSnackbar-root')]//div[contains(@class,'MuiAlert-message')]
${SNACKBAR_INFERIOR}                    //div[contains(@class,'MuiSnackbarContent-message')]//p

# ============================================================================
# MODAL
# ============================================================================
${LOC_MODAL_TITULO}                     //div[contains(@class,'MuiBox-root')]/button/following-sibling::p
${LOC_BOTAO_FECHAR_MODAL}               //div[contains(@class,'MuiBox-root')]/p/preceding-sibling::button//*[@data-testid='CloseIcon']
${LOC_MODAL_AUXILIAR}                   //div[contains(@role,'dialog')]
${LOC_MODAL_AUXILIAR_TITULO}            //div[contains(@class, 'css-1trv35u')]/p
${LOC_SUB_TITULO_MODAL_AUXILIAR}        //div[contains(@class,'css-1950fy6')]//p[1]
${LOC_TEXTO_MODAL_AUXILIAR}             //div[contains(@class,'css-1950fy6')]//p[2]
${LOC_BOTAO_FECHAR_MODAL_AUXILIAR}      (//div[contains(@class,'MuiBox-root')]/p/preceding-sibling::button//*[@data-testid='CloseIcon'])[2]
