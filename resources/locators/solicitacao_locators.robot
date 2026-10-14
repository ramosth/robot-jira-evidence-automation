*** Settings ***
Documentation       Localizadores para funcionalidade de Solicitação de Laudo - Etapa 1 (Dados)


*** Variables ***
# ============================================================================
# MODAL - ESTRUTURA PRINCIPAL
# ============================================================================
${LOC_MODAL_SOLICITA_LAUDO}                     //div[contains(@class,'MuiBox-root')]/button/following-sibling::p[text()='Solicitação de novo laudo']
${LOC_MODAL_HEADER}                             //div[contains(@class, 'css-1gd2ocs')]
${LOC_MODAL_TITLE}                              //div[contains(@class,'MuiBox-root')]/button/following-sibling::p
${LOC_BTN_FECHAR_MODAL}                         //div[contains(@class,'MuiBox-root')]/p/preceding-sibling::button//*[@data-testid='CloseIcon']
${LOC_MODAL_BODY}                               //div[contains(@class, 'css-udvepw')]
${LOC_MODAL_FOOTER}                             //div[contains(@class, 'css-h6er2y')]

# ============================================================================
# INDICADORES DE ETAPA (STEPPER)
# ============================================================================
${LOC_STEPPER_CONTAINER}                        //div[contains(@class, 'css-1lv50lp')]
${LOC_STEPPER_CONTAINER_TITULO}                 //div[contains(@class, 'css-lvf5qk')]/p[1]
${LOC_STEPPER_CONTAINER_DESCRICAO}              //div[contains(@class, 'css-lvf5qk')]/p[2]

${LOC_STEP_1_DADOS}                             //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Dados')]]
${LOC_STEP_1_DADOS_NUMBER}                      //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Dados')]]//div[contains(@class, 'css-90hjbj')]/p
${LOC_STEP_1_DADOS_LABEL}                       //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Dados')]]/p
${LOC_STEP_1_DADOS_ACTIVE}                      //div[contains(@class,'css-90hjbj')]//p[contains(text(),'1')]
${LOC_STEP_1_DADOS_COMPLETED}                   //p[contains(text(),'Dados')]/parent::div[contains(@class, 'css-u6zh8m')]//div[contains(@class, 'css-150pfx6')]

${LOC_STEP_2_ITENS}                             //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Itens')]]
${LOC_STEP_2_ITENS_NUMBER}                      //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Itens')]]//div[contains(@class, 'css-90hjbj')]/p
${LOC_STEP_2_ITENS_LABEL}                       //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Itens')]]/p
${LOC_STEP_2_ITENS_ACTIVE}                      //div[contains(@class,'css-90hjbj')]//p[contains(text(),'2')]
${LOC_STEP_2_ITENS_COMPLETED}                   //p[contains(text(),'Itens')]/parent::div[contains(@class, 'css-u6zh8m')]//div[contains(@class, 'css-150pfx6')]

${LOC_STEP_3_ANEXOS}                            //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Anexos')]]
${LOC_STEP_3_ANEXOS_NUMBER}                     //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Anexos')]]//div[contains(@class, 'css-90hjbj')]/p
${LOC_STEP_3_ANEXOS_LABEL}                      //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Anexos')]]/p
${LOC_STEP_3_ANEXOS_ACTIVE}                     //div[contains(@class,'css-90hjbj')]//p[contains(text(),'3')]
${LOC_STEP_3_ANEXOS_COMPLETED}                  //p[contains(text(),'Anexos')]/parent::div[contains(@class, 'css-u6zh8m')]//div[contains(@class, 'css-150pfx6')]

${LOC_STEP_4_RESUMO}                            //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Resumo')]]
${LOC_STEP_4_RESUMO_NUMBER}                     //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Resumo')]]//div[contains(@class, 'css-90hjbj')]/p
${LOC_STEP_4_RESUMO_LABEL}                      //div[contains(@class, 'css-u6zh8m') and .//p[contains(text(), 'Resumo')]]/p
${LOC_STEP_4_RESUMO_ACTIVE}                     //div[contains(@class,'css-90hjbj')]//p[contains(text(),'4')]

# ============================================================================
# SEÇÃO: PROPOSTA E CLIENTE
# ============================================================================
${LOC_SECAO_PROPOSTA_CLIENTE}                   //div[contains(@class, 'MuiAccordionSummary-content') and .//p[contains(text(), 'Proposta e cliente')]]

# Campo: Filial (opcional)
${LOC_LABEL_FILIAL}                             //p[contains(text(), 'Filial')]
${LOC_TEXTO_OPCIONAL_FILIAL}                    //p[contains(@class, 'MuiTypography-root') and contains(text(), 'Filial (opcional)')]
${LOC_INPUT_FILIAL}                             //input[@name='filial']
${LOC_CONTADOR_INPUT_FILIAL}                    //p[contains(@id, 'solicitar-laudo-input-filial-txt-char-count')]

# Campo: Número da proposta (obrigatório)
${LOC_LABEL_NUMERO_PROPOSTA}                    //p[contains(text(), 'Número da proposta')]
${LOC_INPUT_NUMERO_PROPOSTA}                    //input[@name='numeroProposta']
${LOC_ERRO_NUMERO_PROPOSTA}                     //input[@name='numeroProposta']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_NUMERO_PROPOSTA_INVALIDO}           //input[@name='numeroProposta' and contains(@aria-invalid, 'true')]
${LOC_CONTADOR_INPUT_NUMERO_PROPOSTA}           //p[contains(@id, 'solicitar-laudo-input-numero-proposta-txt-char-count')]

# Campo: Tipo do cliente (obrigatório - select)
${LOC_LABEL_TIPO_CLIENTE}                       //p[contains(text(), 'Tipo do cliente')]
${LOC_SELECT_TIPO_CLIENTE}                      (//div[@role='combobox'])[1]
${LOC_OPTION_TIPO_CLIENTE_PLACEHOLDER}          //div[@role='combobox' and .//span[contains(text(), 'Selecione: Pessoa Jurídica ou Física')]]
${LOC_OPTION_TIPO_CLIENTE_PJ}                   //div[@name='menu-tipoCliente']//ul/li[@role='option' and contains(text(), 'Pessoa Jurídica')]
${LOC_OPTION_TIPO_CLIENTE_PF}                   //div[@name='menu-tipoCliente']//ul/li[@role='option' and contains(text(), 'Pessoa Física')]
${LOC_ERRO_TIPO_CLIENTE}                        //div[@role='combobox' and .//span[contains(text(), 'Selecione: Pessoa Jurídica ou Física')]]/following::p[contains(@class, 'Mui-error')][1]
${LOC_SELECT_TIPO_CLIENTE_INVALIDO}             //p[text()='Tipo do cliente']/../..//div[contains(@class, 'Mui-error MuiInputBase-formControl')]

# Campo: Nome do cliente (obrigatório)
${LOC_LABEL_NOME_CLIENTE}                       //p[contains(text(), 'Nome do cliente')]
${LOC_INPUT_NOME_CLIENTE}                       //input[@name='nomeCliente']
${LOC_ERRO_NOME_CLIENTE}                        //input[@name='nomeCliente']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_NOME_CLIENTE_INVALIDO}              //input[@name='nomeCliente' and contains(@aria-invalid, 'true')]
${LOC_CONTADOR_INPUT_NOME_CLIENTE}              //p[contains(@id, 'solicitar-laudo-input-nome-cliente-txt-char-count')]

# Campo: Documento do cliente (obrigatório)
${LOC_LABEL_DOCUMENTO_CLIENTE}                  //p[contains(text(), 'Documento do cliente')]
${LOC_INPUT_DOCUMENTO_CLIENTE}                  //input[@name='documentoCliente']
${LOC_ERRO_DOCUMENTO_CLIENTE}                   //input[@name='documentoCliente']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_DOCUMENTO_CLIENTE_INVALIDO}         //input[@name='documentoCliente' and contains(@aria-invalid, 'true')]

# ============================================================================
# SEÇÃO: LOJA E VENDEDOR
# ============================================================================
${LOC_SECAO_LOJA_VENDEDOR}                      //div[contains(@class, 'MuiAccordionSummary-content') and .//p[contains(text(), 'Loja e vendedor')]]

# Campo: CNPJ (obrigatório)
${LOC_LABEL_CNPJ}                               //p[contains(text(), 'CNPJ')]
${LOC_INPUT_CNPJ}                               //input[@name='cnpjLoja']
${LOC_ERRO_CNPJ}                                //input[@name='cnpjLoja']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_CNPJ_INVALIDO}                      //input[@name='cnpjLoja' and contains(@aria-invalid, 'true')]

# Campo: CPF do vendedor (opcional)
${LOC_LABEL_CPF_VENDEDOR}                       //p[contains(text(), 'CPF do vendedor')]
${LOC_TEXTO_OPCIONAL_CPF_VENDEDOR}              //p[contains(@class, 'MuiTypography-root') and contains(text(), 'CPF do vendedor (opcional)')]
${LOC_INPUT_CPF_VENDEDOR}                       //input[@name='cpfVendedor' and @placeholder='Ex: 000.000.100-00']
${LOC_ERRO_CPF_VENDEDOR}                        //input[@name='cpfVendedor']/following::p[contains(@class, 'Mui-error')][1]

# Campo: Nome do vendedor (obrigatório)
${LOC_LABEL_NOME_VENDEDOR}                      //p[contains(text(), 'Nome do vendedor')]
${LOC_INPUT_NOME_VENDEDOR}                      //input[@name='nomeVendedor' and @placeholder='Nome completo do responsável']
${LOC_ERRO_NOME_VENDEDOR}                       //input[@name='nomeVendedor']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_NOME_VENDEDOR_INVALIDO}             //input[@name='nomeVendedor' and contains(@aria-invalid, 'true')]
${LOC_CONTADOR_INPUT_NOME_VENDEDOR}             //p[contains(@id, 'solicitar-laudo-input-nome-vendedor-txt-char-count')]

# ============================================================================
# SEÇÃO: DADOS DO VEÍCULO
# ============================================================================
${LOC_SECAO_DADOS_VEICULO}                      //div[contains(@class, 'MuiAccordionSummary-content') and .//p[contains(text(), 'Dados do veículo')]]

# Campo: Placa (obrigatório)
${LOC_LABEL_PLACA}                              //p[contains(text(), 'Placa')]
${LOC_INPUT_PLACA}                              //input[@name='placa' and @placeholder='Ex: ABC-1234']
${LOC_ERRO_PLACA}                               //input[@name='placa']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_PLACA_INVALIDO}                     //input[@name='placa' and contains(@aria-invalid, 'true')]

# Campo: RENAVAM (obrigatório)
${LOC_LABEL_RENAVAM}                            //p[contains(text(), 'RENAVAM')]
${LOC_INPUT_RENAVAM}                            //input[@name='renavam' and @placeholder='Insira o número do RENAVAM']
${LOC_ERRO_RENAVAM}                             //input[@name='renavam']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_RENAVAM_INVALIDO}                   //input[@name='renavam' and contains(@aria-invalid, 'true')]

# Campo: UF da placa (obrigatório - select)
${LOC_LABEL_UF_PLACA}                           //p[contains(text(), 'UF da placa')]
${LOC_SELECT_UF_PLACA}                          (//div[@role='combobox'])[2]
${LOC_OPTION_UF_PLACEHOLDER}                    //div[@role='combobox' and .//span[contains(text(), 'Selecione o Estado (Ex: SP, MG)')]]
${LOC_OPTION_UF}                                //li[@role='option']
${LOC_ERRO_UF_PLACA}                            //div[@role='combobox' and .//span[contains(text(), 'Selecione o Estado (Ex: SP, MG)')]]/following::p[contains(@class, 'Mui-error')][1]
${LOC_SELECT_UF_PLACA_INVALIDO}                 //p[text()='UF da placa']/../..//div[contains(@class, 'Mui-error MuiInputBase-formControl')]

# Campo: Cidade (obrigatório)
${LOC_LABEL_CIDADE}                             //p[contains(text(), 'Cidade')]
${LOC_INPUT_CIDADE}                             //input[@name='cidade']
${LOC_ERRO_CIDADE}                              //input[@name='cidade']/following::p[contains(@class, 'Mui-error')][1]
${LOC_INPUT_CIDADE_INVALIDO}                    //input[@name='cidade' and contains(@aria-invalid, 'true')]
${LOC_CONTADOR_INPUT_CIDADE}                    //p[contains(@id, 'solicitar-laudo-input-cidade-txt-char-count')]

# Campo: Quilometragem (opcional)
${LOC_LABEL_QUILOMETRAGEM}                      //p[contains(text(), 'Quilometragem')]
${LOC_TEXTO_OPCIONAL_QUILOMETRAGEM}             //p[contains(@class, 'MuiTypography-root') and contains(text(), 'Quilometragem (opcional)')]
${LOC_INPUT_QUILOMETRAGEM}                      //input[@name='quilometragem' and @placeholder='Insira o valor atual (apenas números)']
${LOC_INPUT_QUILOMETRAGEM_INVALIDO}             //input[@name='quilometragem' and contains(@aria-invalid, 'true')]
${LOC_CONTADOR_INPUT_QUILOMETRAGEM}             //p[contains(@id, 'solicitar-laudo-input-quilometragem-txt-char-count')]

# ============================================================================
# BOTÕES DE AÇÃO (FOOTER)
# ============================================================================
${LOC_BTN_CANCELAR}                             //button[@type='button' and contains(text(), 'Cancelar')]
${LOC_BTN_VOLTAR}                               //button[@type='button' and contains(text(), 'Voltar')]
${LOC_BTN_CONTINUAR}                            //button[@type='button' and contains(text(), 'Continuar')]
${LOC_BTN_PULAR_ETAPA}                          //button[contains(@class, 'MuiButton') and contains(text(), 'Pular etapa')]
${LOC_BTN_CONTINUAR_DESABILITADO}               //button[@type='button' and contains(text(), 'Continuar') and @disabled]
${LOC_BTN_CONTINUAR_HABILITADO}                 //button[@type='button' and contains(text(), 'Continuar') and not(@disabled)]
${LOC_BTN_VOLTAR_HABILITADO}                    //button[contains(text(), 'Voltar') and not(@disabled)]
${LOC_BTN_PULAR_ETAPA_HABILITADO}               //button[contains(text(), 'Pular etapa') and not(@disabled)]

# ============================================================================
# BOTÃO SOLICITAR LAUDO (TELA PRINCIPAL)
# ============================================================================
${LOC_BTN_SOLICITAR_LAUDO_PRINCIPAL}            //button[contains(text(), 'Solicitar laudo')]

# ============================================================================
# MENSAGENS DE ERRO GERAIS
# ============================================================================
${LOC_TODOS_CAMPOS_INVALIDOS}                   //input[contains(@aria-invalid, 'true')]
${LOC_TODAS_MENSAGENS_ERRO}                     //input/following::p[contains(@class, 'Mui-error')]

# ============================================================================
# ETAPA 2 (ITENS)
# ============================================================================

# ==================== ACCORDION: CONDIÇÕES DO VEÍCULO POR TIPO ====================
${LOC_ACCORDION_CONDICOES}                      //p[text()='Condições do veículo por tipo']
${LOC_ACCORDION_CONDICOES_EXPANDIDO}            //p[text()='Condições do veículo por tipo']/ancestor::div[contains(@class, 'Mui-expanded')][1]

# --- Elétrica ---
${LOC_LABEL_ELETRICA}                           //p[text()='Elétrica']
${LOC_RADIO_ELETRICA_NORMAL}                    (//input[@type='radio' and @value='1'])[1]
${LOC_RADIO_ELETRICA_COM_FALHAS}                (//input[@type='radio' and @value='2'])[1]
${LOC_RADIO_ELETRICA_NAO_FUNCIONA}              (//input[@type='radio' and @value='3'])[1]
${LOC_CAMPO_OBS_ELETRICA}                       (//input[@placeholder='Adicione observações'])[1]
${LOC_CONTADOR_INPUT_OBS_ELETRICA}              //p[contains(@id, 'solicitar-laudo-input-observacao-eletrica-txt-char-count')]

# --- Lataria ---
${LOC_LABEL_LATARIA}                            //p[text()='Lataria']
${LOC_RADIO_LATARIA_CONSERVADO}                 //input[@type='radio' and @value='4']
${LOC_RADIO_LATARIA_DANIFICADO}                 (//input[@type='radio' and @value='5'])[1]
${LOC_RADIO_LATARIA_PESSIMO}                    (//input[@type='radio' and @value='6'])[1]
${LOC_CAMPO_OBS_LATARIA}                        (//input[@placeholder='Adicione observações'])[2]

# --- Mecânica ---
${LOC_LABEL_MECANICA}                           //p[text()='Mecânica']
${LOC_RADIO_MECANICA_NORMAL}                    (//input[@type='radio' and @value='1'])[2]
${LOC_RADIO_MECANICA_COM_FALHAS}                (//input[@type='radio' and @value='2'])[2]
${LOC_RADIO_MECANICA_NAO_FUNCIONA}              (//input[@type='radio' and @value='3'])[2]
${LOC_CAMPO_OBS_MECANICA}                       (//input[@placeholder='Adicione observações'])[3]

# --- Pintura ---
${LOC_LABEL_PINTURA}                            //p[text()='Pintura']
${LOC_RADIO_PINTURA_BOM}                        (//input[@type='radio' and @value='7'])[1]
${LOC_RADIO_PINTURA_DANIFICADO}                 (//input[@type='radio' and @value='5'])[2]
${LOC_RADIO_PINTURA_PESSIMO}                    (//input[@type='radio' and @value='6'])[2]
${LOC_CAMPO_OBS_PINTURA}                        (//input[@placeholder='Adicione observações'])[4]

# --- Pneus ---
${LOC_LABEL_PNEUS}                              //p[text()='Pneus']
${LOC_RADIO_PNEUS_NOVO}                         //input[@type='radio' and @value='8']
${LOC_RADIO_PNEUS_BOM_ESTADO}                   //input[@type='radio' and @value='9']
${LOC_RADIO_PNEUS_PESSIMO}                      (//input[@type='radio' and @value='6'])[3]
${LOC_CAMPO_OBS_PNEUS}                          (//input[@placeholder='Adicione observações'])[5]

# --- Tapeçaria ---
${LOC_LABEL_TAPECARIA}                          //p[text()='Tapeçaria']
${LOC_RADIO_TAPECARIA_BOM}                      (//input[@type='radio' and @value='7'])[2]
${LOC_RADIO_TAPECARIA_DANIFICADO}               (//input[@type='radio' and @value='5'])[3]
${LOC_RADIO_TAPECARIA_PESSIMO}                  (//input[@type='radio' and @value='6'])[4]
${LOC_CAMPO_OBS_TAPECARIA}                      (//input[@placeholder='Adicione observações'])[6]

# ==================== ACCORDION: ITENS DE SEGURANÇA ====================
${LOC_ACCORDION_ITENS_SEGURANCA}                //p[text()='Itens de segurança']
${LOC_ACCORDION_ITENS_EXPANDIDO}                //p[text()='Itens de segurança']/ancestor::div[contains(@class, 'Mui-expanded')][1]

# ============================================================================
# LISTA DE 17 ITENS DE SEGURANÇA (Checkboxes)
# ============================================================================
${LOC_CHECKBOX_AIRBAG}                          //p[contains(text(), 'Airbag')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_AIRBAG}                             //p[contains(text(), 'Airbag')]

${LOC_CHECKBOX_BUZINA}                          //p[contains(text(), 'Buzina')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_BUZINA}                             //p[contains(text(), 'Buzina')]

${LOC_CHECKBOX_CABO_BATERIA}                    //p[contains(text(), 'Cabo de bateria')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_CABO_BATERIA}                       //p[contains(text(), 'Cabo de bateria')]

${LOC_CHECKBOX_CHAVE_RODA}                      //p[contains(text(), 'Chave de roda')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_CHAVE_RODA}                         //p[contains(text(), 'Chave de roda')]

${LOC_CHECKBOX_CINTOS_SEGURANCA}                //p[contains(text(), 'Cintos de segurança')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_CINTOS_SEGURANCA}                   //p[contains(text(), 'Cintos de segurança')]

${LOC_CHECKBOX_COMPRESSOR}                      //p[contains(text(), 'Compressor')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_COMPRESSOR}                         //p[contains(text(), 'Compressor')]

${LOC_CHECKBOX_ENCOSTO_CABECA}                  //p[contains(text(), 'Encosto de cabeça')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_ENCOSTO_CABECA}                     //p[contains(text(), 'Encosto de cabeça')]

${LOC_CHECKBOX_FREIO_ABS}                       //p[contains(text(), 'Freio ABS')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_FREIO_ABS}                          //p[contains(text(), 'Freio ABS')]

${LOC_CHECKBOX_EXTINTOR}                        //p[contains(text(), 'Extintor de incêndio na validade')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_EXTINTOR}                           //p[contains(text(), 'Extintor de incêndio na validade')]

${LOC_CHECKBOX_ESPELHOS}                        //p[contains(text(), 'Espelhos (internos e retrovisores)')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_ESPELHOS}                           //p[contains(text(), 'Espelhos (internos e retrovisores)')]

${LOC_CHECKBOX_FREIO_ESTACIONAMENTO}            //p[contains(text(), 'Freio de estacionamento (freio de mão)')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_FREIO_ESTACIONAMENTO}               //p[contains(text(), 'Freio de estacionamento (freio de mão)')]

${LOC_CHECKBOX_LUZES_DIRECAO}                   //p[contains(text(), 'Luzes indicadoras de direção')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_LUZES_DIRECAO}                      //p[contains(text(), 'Luzes indicadoras de direção')]

${LOC_CHECKBOX_LIMPADOR}                        //p[contains(text(), 'Limpador de para-brisas')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_LIMPADOR}                           //p[contains(text(), 'Limpador de para-brisas')]

${LOC_CHECKBOX_LANTERNA}                        //p[contains(text(), 'Lanterna')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_LANTERNA}                           //p[contains(text(), 'Lanterna')]

${LOC_CHECKBOX_MACACO}                          //p[contains(text(), 'Macaco')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_MACACO}                             //p[contains(text(), 'Macaco')]

${LOC_CHECKBOX_MANUAL_VEICULO}                  //p[contains(text(), 'Manual do veículo')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_MANUAL_VEICULO}                     //p[contains(text(), 'Manual do veículo')]

${LOC_CHECKBOX_TRIANGULO}                       //p[contains(text(), 'Triângulo de sinalização')]/preceding-sibling::span//input[@type='checkbox']
${LOC_LABEL_TRIANGULO}                          //p[contains(text(), 'Triângulo de sinalização')]

# Lista genérica de todos os checkboxes
${LOC_TODOS_CHECKBOXES_ITENS}                   //p[contains(text(), '%s')]/preceding-sibling::span//input[@type='checkbox']
${LOC_TODOS_CHECKBOXES_SELECIONADOS}            //span[contains(@class, 'Mui-checked')]//input[@type='checkbox']

# ============================================================================
# CAMPOS DE OBSERVAÇÃO (aparecem para Buzina e Compressor)
# ============================================================================
${LOC_OBSERVACAO_BUZINA}                        //p[text()='Buzina']/preceding-sibling::span[contains(@class, 'Mui-checked')]//input[@type='checkbox']/following::textarea[1]
${LOC_OBSERVACAO_COMPRESSOR}                    //p[text()='Compressor']/preceding-sibling::span[contains(@class, 'Mui-checked')]//input[@type='checkbox']/following::textarea[1]

# Locator genérico para qualquer campo de observação visível
${LOC_CAMPOS_OBSERVACAO_VISIVEIS}               //p[text()='%s']/preceding-sibling::span[contains(@class, 'Mui-checked')]//input[@type='checkbox']/following::textarea[1]

# ============================================================================
# MODAL - ETAPA 3 (ANEXOS)
# ============================================================================

# ============================================================================
# ÁREA DE UPLOAD
# ============================================================================
${LOC_INPUT_FILE}                               //input[@type='file']
${LOC_AREA_UPLOAD}                              //div[contains(@class, 'MuiBox-root css-60vmj8')]
${LOC_ICONE_NUVEM}                              (//div[contains(@class, 'css-118jxmp')]//span[contains(text(), 'cloud_upload')])[1]
${LOC_TEXTO_ARRASTE_CLIQUE}                     //p[contains(text(), 'Arraste ou clique aqui para enviar as imagens')]
${LOC_BTN_SELECIONE_ARQUIVO}                    //button[contains(., 'Selecione o arquivo')]
${LOC_BTN_SELECIONE_ARQUIVO_DESABILITADO}       //button[contains(@class, 'MuiButton-outlinedPrimary') and .//text()[contains(., 'Selecione o arquivo')]]

# ============================================================================
# ESPECIFICAÇÕES TÉCNICAS
# ============================================================================
${LOC_ESPECIFICACAO_FORMATOS}                   //span[contains(text(), 'Apenas arquivos .png ou .jpg são aceitos')]
${LOC_ESPECIFICACAO_LIMITE}                     //span[contains(normalize-space(.), 'Máximo de 6 imagens (total combinado de até 2 MB)')]
${LOC_ESPECIFICACAO_RESOLUCOES}                 //span[contains(text(), 'Resoluções recomendadas: 1920x1080, 960x540 ou 1024x768')]
${LOC_CONTADOR_TAMANHO}                         //span[contains(text(), 'Total combinado:')]

# ============================================================================
# MINIATURAS DE IMAGENS ANEXADAS
# ============================================================================
${LOC_LISTA_MINIATURAS}                         //div[contains(@class, 'MuiStack-root css-pb4y8c')]//div[contains(@class, 'css-bpub36')]
${LOC_MINIATURA_IMAGEM}                         //div[contains(@class, 'css-w3wife')]
${LOC_NOME_ARQUIVO}                             (//div[contains(@class, 'css-1fjtzvx')]/p)
${LOC_TAMANHO_ARQUIVO}                          (//div[contains(@class, 'css-1fjtzvx')]/span)
${LOC_ICONE_EXCLUSAO}                           (//button[.//*[contains(@data-testid, 'DeleteIcon')]])

# Locators dinâmicos para arquivos específicos
${LOC_MINIATURA_POR_NOME}                       (//p[contains(text(), '{filename}')]/following::div[contains(@class, 'css-w3wife')])[1]
${LOC_EXCLUSAO_POR_NOME}                        (//p[contains(text(), '{filename}')]/following::button[.//*[contains(@data-testid, 'DeleteIcon')]])[1]

# ============================================================================
# MENSAGENS DE ERRO
# ============================================================================
${LOC_MENSAGEM_ERRO}                            //div[contains(@class, 'css-1fjtzvx')]
${LOC_MENSAGEM_ERRO_NOME_ARQUIVO}               //div[contains(@class, 'css-1fjtzvx')]//p
${LOC_MENSAGEM_ERRO_TEXTO}                      //div[contains(@class, 'css-1fjtzvx')]//span[2]
${LOC_ERRO_TAMANHO_EXCEDIDO}                    //*[contains(text(), 'tamanho máximo') or contains(text(), '2MB')]
${LOC_ERRO_FORMATO_INVALIDO}                    //*[contains(text(), 'Formato não suportado. Utilize arquivos .jpg ou .png.')]

# ============================================================================
# MODAL - ETAPA 4 (RESUMO)
# ============================================================================

# ============================================================================
# SEÇÃO: PROPOSTA E CLIENTE
# ============================================================================
${LOC_CAMPO_FILIAL_RESUMO}                      //p[contains(text(), 'Filial')]//following-sibling::p
${LOC_CAMPO_NUMERO_PROPOSTA_RESUMO}             //p[contains(text(), 'Número da proposta')]/following-sibling::p
${LOC_CAMPO_TIPO_CLIENTE_RESUMO}                //p[contains(text(), 'Tipo do cliente')]/following-sibling::p
${LOC_CAMPO_NOME_CLIENTE_RESUMO}                //p[contains(text(), 'Nome do cliente')]/following-sibling::p
${LOC_CAMPO_DOCUMENTO_CLIENTE_RESUMO}           //p[contains(text(), 'Documento do cliente')]/following-sibling::p

# ============================================================================
# SEÇÃO: LOJA E VENDEDOR
# ============================================================================
${LOC_CAMPO_CNPJ_RESUMO}                        //p[contains(text(), 'CNPJ')]/following-sibling::p
${LOC_CAMPO_CPF_VENDEDOR_RESUMO}                //p[contains(text(), 'CPF do vendedor')]/following-sibling::p
${LOC_CAMPO_NOME_VENDEDOR_RESUMO}               //p[contains(text(), 'Nome do vendedor')]/following-sibling::p

# ============================================================================
# SEÇÃO: DADOS DO VEÍCULO
# ============================================================================
${LOC_CAMPO_PLACA_RESUMO}                       //p[contains(text(), 'Placa')]/following-sibling::p
${LOC_CAMPO_RENAVAM_RESUMO}                     //p[contains(text(), 'RENAVAM')]/following-sibling::p
${LOC_CAMPO_UF_PLACA_RESUMO}                    //p[contains(text(), 'UF da placa')]/following-sibling::p
${LOC_CAMPO_CIDADE_RESUMO}                      //p[contains(text(), 'Cidade')]/following-sibling::p
${LOC_CAMPO_QUILOMETRAGEM_RESUMO}               //p[contains(text(), 'Quilometragem')]/following-sibling::p

# ============================================================================
# SEÇÃO: ITENS DE SEGURANÇA
# ============================================================================
${LOC_SECAO_ITENS_SEGURANCA}                    //div[contains(@class, 'css-mro3c9')]//h6[contains(text(), 'Itens de segurança')]
${LOC_LISTA_ITENS_SELECIONADOS}                 (//div[contains(@class, 'MuiGrid-container')])[2]
${LOC_ITEM_SELECIONADO}                         (//div[contains(@class, 'MuiGrid-container')])[2]/div[contains(@class, 'MuiGrid-item')]//p[1]
${LOC_OBSERVACAO_ITEM}                          (//div[contains(@class, 'MuiGrid-container')])[2]/div[contains(@class, 'MuiGrid-item')]//p[2]

# Locators dinâmicos para itens específicos
${LOC_ITEM_SELECIONADO_POR_NOME}                //p[contains(@class, 'css-2ft782')][contains(text(), '{item_name}')]
${LOC_OBSERVACAO_POR_CONDICAO}                  /following-sibling::p[2]
${LOC_TIPO_POR_CONDICAO}                        /following-sibling::p[1]
${LOC_CONDICAO_POR_CONDICAO}                    //div[contains(@class, 'rpybyc')]//p[contains(@class, 'css-11vpzsi')][contains(text(), '{item_name}')]

# ============================================================================
# SEÇÃO: IMAGENS PARA ANÁLISE
# ============================================================================
${LOC_SECAO_IMAGENS_ANALISE}                    //div[contains(@class, 'css-mro3c9')]//h6[contains(text(), 'Imagens para análise')]
${LOC_TITULO_ANEXOS}                            //div[contains(@class, 'css-16g25vp')]/p[contains(text(), 'Anexos')]
${LOC_LISTA_MINIATURAS_RESUMO}                  //div[contains(@class, 'css-axw7ok')]
${LOC_MINIATURA_RESUMO}                         //div[contains(@class, 'css-axw7ok')]//div[contains(@class, 'css-w3wife')]
${LOC_NOME_ARQUIVO_RESUMO}                      //div[contains(@class, 'css-1fjtzvx')]//p[contains(@class, 'css-1ffh95p')]
${LOC_TAMANHO_ARQUIVO_RESUMO}                   //div[contains(@class, 'css-1fjtzvx')]//span[contains(@class, 'css-c4621z')]
${LOC_ICONE_EXCLUIR_RESUMO}                     //div[contains(@class, 'css-axw7ok')]//button[contains(@aria-label,"Remover imagem")]

# Locators dinâmicos para imagens específicas
${LOC_MINIATURA_RESUMO_POR_NOME}                //p[contains(@class, 'css-1ffh95p') and contains(text(), '{filename}')]/following::div[contains(@class, 'css-w3wife')]
${LOC_EXCLUIR_RESUMO_POR_NOME}                  //p[contains(@class, 'css-1ffh95p') and contains(text(), '{filename}')]/following::button[contains(@aria-label,"Remover imagem")]

# ============================================================================
# BOTÕES DE AÇÃO (FOOTER)
# ============================================================================
${LOC_BTN_SOLICITAR_LAUDO_FOOTER}               //div[contains(@class, 'css-1j9bsaa')]//button[contains(text(), 'Solicitar laudo')]

# ============================================================================
# VALIDAÇÕES ESPECÍFICAS DE VALORES
# ============================================================================
# Locators para validar valores específicos exibidos
${LOC_VALOR_CAMPO_RESUMO}                       //p[contains(text(), '{field_label}')]//following-sibling::p[contains(text(), '{expected_value}')]
${LOC_SECAO_VISIVEL}                            //div[contains(@class, 'css-mro3c9') and .//h6[contains(text(), '{section_name}')]]
${LOC_SECAO_NAO_VISIVEL}                        //div[contains(@class, 'css-mro3c9') and .//h6[contains(text(), '{section_name}')]]

# ============================================================================
# MODAL DE ERRO - BOTÕES
# ============================================================================
${LOC_BTN_VOLTAR_LISTA_ERRO}                    //button[contains(text(), 'Voltar para a lista de laudos')]
${LOC_BTN_TENTAR_NOVAMENTE}                     //button[contains(text(), 'Tentar emitir novamente')]

# ============================================================================
# LISTA DE LAUDOS - PÓS CRIAÇÃO
# ============================================================================
${LOC_NOVO_ID_PRIMEIRA_POSICAO}                 (//div[contains(@class, 'report-item')])[1]//span[contains(@class, 'report-id')]
${LOC_CAMPO_RESPONSAVEL}                        //span[contains(@class, 'responsible')]
${LOC_CAMPO_ULTIMA_ATUALIZACAO}                 //span[contains(@class, 'last-update')]

# ============================================================================
# ALIASES (completados na versão de portfólio)
# Referenciados pelas keywords mas sem mapeamento no módulo original:
# - "CNPJ da loja" é o mesmo campo "CNPJ" do formulário;
# - os modais de Reemissão/Correção reutilizam os componentes do resumo da
#   Solicitação, então os seletores são os mesmos.
# ============================================================================
${LOC_INPUT_CNPJ_LOJA}                          ${LOC_INPUT_CNPJ}
${LOC_ERRO_CNPJ_LOJA}                           ${LOC_ERRO_CNPJ}
${LOC_SECAO_VISIVEL_REEMITE}                    ${LOC_SECAO_VISIVEL}
${LOC_SECAO_NAO_VISIVEL_REEMITE}                ${LOC_SECAO_NAO_VISIVEL}
${LOC_ITEM_SELECIONADO_POR_NOME_REEMITE}        ${LOC_ITEM_SELECIONADO_POR_NOME}
${LOC_MINIATURA_RESUMO_REEMITE}                 ${LOC_MINIATURA_RESUMO}
