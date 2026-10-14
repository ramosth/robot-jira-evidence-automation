*** Settings ***
Documentation       VC-16 - Nova Análise
...                 Feature: Nova Análise no sistema VeriCar
...                 Execução via terminal: robot --exclude manual tests/features/VC-16_NovaAnalise.robot

Resource            ../../config/package.robot

# Cria, uma única vez, o laudo completo usado pelos cenários de download e de PDF
# (${LAUDO_COMPLETO}). Para rodar só cenários do formulário mais rápido, comente a linha.
Suite Setup         Criar Laudos Completo Para Testes
Test Setup          Abrir Navegador E Acessar Sistema
Test Teardown       Evidenciar teste na pasta    VC-16


*** Variables ***
${LAUDO_COMPLETO}       ${EMPTY}


*** Test Cases ***
Cenário: QA-308 (FRONT) Abrir modal de Solicitação de Novo Laudo com sucesso
    [Documentation]    Valida abertura do modal e exibição correta dos indicadores de etapa
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que botão "Solicitar laudo" está visível
    Quando usuário clica no botão "Solicitar laudo"
    Então sistema abre o "Solicitar laudo"
    E entrar na etapa
    ...    1
    ...    ${vericar_modal.solicitar_laudo.titulo_etapa_1}
    E exibe botão "Cancelar" no rodapé
    E exibe botão "Continuar" no rodapé
    E o botão do modal está habilitado e clicável    Cancelar
    E o botão do modal está desabilitado e clicável    Continuar

Cenário: QA-309 (FRONT) Validar exibição de todos os campos obrigatórios no Step Dados
    [Documentation]    Valida que os 13 campos do formulário estão visíveis
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então todos os campos do formulário devem estar visíveis
    E os seguintes campos devem estar visíveis na seção Proposta e Cliente
    E os seguintes campos devem estar visíveis na seção Loja e Vendedor
    E os seguintes campos devem estar visíveis na seção Dados do Veículo

Cenário: QA-310 (FRONT) Validar campos opcionais marcados corretamente no Step Dados
    [Documentation]    Valida que os 3 campos opcionais exibem texto "(opcional)"
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então os campos opcionais devem estar marcados como "(opcional)"
    E o campo "Filial" deve exibir a marcação "(opcional)"
    E o campo "CPF do vendedor" deve exibir a marcação "(opcional)"
    E o campo "Quilometragem" deve exibir a marcação "(opcional)"

Cenário: QA-311 (FRONT) Validar alerta em campo obrigatório vazio - Número da Proposta
    [Documentation]    Valida mensagem de erro quando Número da proposta está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Número da proposta    ${LOC_INPUT_NUMERO_PROPOSTA}
    Então o campo "Número da proposta" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo
    ...    ${mensagens_form_solicitar.erro.num_proposta}
    ...    Número da proposta
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-312 (FRONT) Validar alerta em campo obrigatório vazio - Tipo do Cliente
    [Documentation]    Valida mensagem de erro quando Tipo do cliente não está selecionado
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Tipo do cliente    ${LOC_SELECT_TIPO_CLIENTE}
    E preencher o campo    Nome do cliente    TESTE
    Então o campo "Tipo do cliente" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.tipo_cliente}    Tipo do cliente
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-313 (FRONT) Validar alerta em campo obrigatório vazio - Nome do Cliente
    [Documentation]    Valida mensagem de erro quando Nome do cliente está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Nome do cliente    ${LOC_INPUT_NOME_CLIENTE}
    Então o campo "Nome do cliente" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.nome_cliente}    Nome do cliente
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-314 (FRONT) Validar alerta em campo obrigatório vazio - Documento do Cliente
    [Documentation]    Valida mensagem de erro quando Documento do cliente está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Documento do cliente    ${LOC_INPUT_DOCUMENTO_CLIENTE}
    Então o campo "Documento do cliente" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo
    ...    ${mensagens_form_solicitar.erro.documento_cliente}
    ...    Documento do cliente
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-315 (FRONT) Validar alerta em campo obrigatório vazio - CNPJ
    [Documentation]    Valida mensagem de erro quando CNPJ está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    CNPJ    ${LOC_INPUT_CNPJ}
    Então o campo "CNPJ" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.cnpj_loja}    CNPJ
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-316 (FRONT) Validar alerta em campo obrigatório vazio - Nome do Vendedor
    [Documentation]    Valida mensagem de erro quando Nome do vendedor está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Nome do vendedor    ${LOC_INPUT_NOME_VENDEDOR}
    Então o campo "Nome do vendedor" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.nome_vendedor}    Nome do vendedor
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-317 (FRONT) Validar alerta em campo obrigatório vazio - Placa
    [Documentation]    Valida mensagem de erro quando Placa está vazia
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Placa    ${LOC_INPUT_PLACA}
    Então o campo "Placa" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.placa}    Placa
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-318 (FRONT) Validar alerta em campo obrigatório vazio - RENAVAM
    [Documentation]    Valida mensagem de erro quando RENAVAM está vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    RENAVAM    ${LOC_INPUT_RENAVAM}
    Então o campo "RENAVAM" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.renavam}    RENAVAM
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-319 (FRONT) Validar alerta em campo obrigatório vazio - UF da Placa
    [Documentation]    Valida mensagem de erro quando UF da placa não está selecionada
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    UF da placa    ${LOC_SELECT_UF_PLACA}
    Então o campo "UF da placa" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.estado}    UF da placa
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-320 (FRONT) Validar alerta em campo obrigatório vazio - Cidade
    [Documentation]    Valida mensagem de erro quando Cidade está vazia
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário tenta avançar sem preencher o campo    Cidade    ${LOC_INPUT_CIDADE}
    Então o campo "Cidade" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.cidade}    Cidade
    E o usuário deve permanecer na etapa Dados
    E o botão "Continuar" deve permanecer desabilitado

Cenário: QA-321 (FRONT) Validar mensagem de erro com número de proposta inválido
    [Documentation]    Valida mensagem de erro quando Número da proposta contém letras
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Número da proposta" preenchido com "abc"
    Então o campo "Número da proposta" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo
    ...    ${mensagens_form_solicitar.erro.num_proposta}
    ...    Número da proposta
    E o usuário deve permanecer na etapa Dados

Cenário: QA-322 (FRONT) Validar mensagem de erro com documento do cliente inválido
    [Documentation]    Valida mensagem de erro quando Documento do cliente tem menos caracteres
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Documento do cliente" preenchido com "123"
    Então o campo "Documento do cliente" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo
    ...    ${mensagens_form_solicitar.erro.documento_cliente}
    ...    Documento do cliente
    ...    ${tipo_cliente_teste}
    E o usuário deve permanecer na etapa Dados

Cenário: QA-323 (FRONT) Validar mensagem de erro com CNPJ inválido
    [Documentation]    Valida mensagem de erro quando CNPJ tem formato incompleto
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "CNPJ" preenchido com "12345678901234"
    Então o campo "CNPJ" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.cnpj_loja_invalido}    CNPJ
    E o usuário deve permanecer na etapa Dados

Cenário: QA-510 (FRONT) Validar a solicitação com CNPJ alfanumérico válido
    [Documentation]    Valida mensagem de erro quando CNPJ tem formato incompleto
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando submete o formulário com o campo "CNPJ alfanumérico"
    E o usuário clica no botão "Continuar"
    Então o sistema deve avançar para a etapa Itens
    E a etapa Dados deve exibir indicador de conclusão

Cenário: QA-324 (FRONT) Validar mensagem de erro com nome do vendedor inválido
    [Documentation]    Valida mensagem de erro quando Nome do vendedor contém números e símbolos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Nome do vendedor" preenchido com "123@#$"
    Então o campo "Nome do vendedor" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.nome_vendedor}    Nome do vendedor
    E o usuário deve permanecer na etapa Dados

Cenário: QA-325 (FRONT) Validar mensagem de erro com placa inválida
    [Documentation]    Valida mensagem de erro quando Placa tem formato incompleto
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Placa" preenchido com "ABC"
    Então o campo "Placa" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.placa}    Placa
    E o usuário deve permanecer na etapa Dados

Cenário: QA-326 (FRONT) Validar mensagem de erro com RENAVAM inválido
    [Documentation]    Valida mensagem de erro quando RENAVAM contém letras
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "RENAVAM" preenchido com "ABC123"
    Então o campo "RENAVAM" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.renavam}    RENAVAM
    E o usuário deve permanecer na etapa Dados

Cenário: QA-327 (FRONT) Validar mensagem de erro com cidade inválida
    [Documentation]    Valida mensagem de erro quando Cidade contém números e símbolos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Cidade" preenchido com "123@#$"
    Então o campo "Cidade" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.cidade}    Cidade
    E o usuário deve permanecer na etapa Dados

Cenário: QA-328 (FRONT) Validar preencher os campos obrigatórios e avançar para Step Itens
    [Documentation]    Valida que sistema avança para etapa Itens quando dados estão corretos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário preenche todos os campos obrigatórios corretamente
    E o usuário clica no botão "Continuar"
    Então o sistema deve avançar para a etapa Itens
    E a etapa Dados deve exibir indicador de conclusão

Cenário: QA-329 (FRONT) Validar funcionalidade do botão Cancelar no Step Dados
    [Documentation]    Valida que clicar Cancelar fecha modal sem salvar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário clica no botão "Cancelar"
    Então o modal deve ser fechado
    E o usuário deve retornar para a tela de listagem
    E nenhum laudo deve ser salvo

Cenário: QA-330 (FRONT) Validar os dados ao voltar do Step Itens para Step Dados
    [Documentation]    Valida que dados permanecem ao voltar da etapa Itens para Dados
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos corretamente
    Quando o usuário clica no botão "Continuar"
    E o usuário está na etapa Itens
    Quando o usuário retorna para a etapa Dados
    Então todos os valores preenchidos devem estar preservados

Cenário: QA-331 (FRONT) Validar campo Filial (opcional) pode permanecer vazio
    [Documentation]    Valida que Filial opcional não exibe erro quando vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos obrigatórios corretamente
    Quando o usuário deixa o campo "Filial" vazio
    Quando o usuário tenta avançar sem preencher o campo    Filial    ${LOC_INPUT_FILIAL}
    Então o sistema não deve exibir erro no campo "Filial"
    E o sistema deve permitir avançar para a etapa Itens

Cenário: QA-332 (FRONT) Validar campo CPF do Vendedor (opcional) pode permanecer vazio
    [Documentation]    Valida que CPF do vendedor opcional não exibe erro quando vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos obrigatórios corretamente
    Quando o usuário deixa o campo "CPF do vendedor" vazio
    Quando o usuário tenta avançar sem preencher o campo    CPF do vendedor    ${LOC_INPUT_CPF_VENDEDOR}
    Então o sistema não deve exibir erro no campo "CPF do vendedor"
    E o sistema deve permitir avançar para a etapa Itens

Cenário: QA-333 (FRONT) Validar campo Quilometragem (opcional) pode permanecer vazio
    [Documentation]    Valida que Quilometragem opcional não exibe erro quando vazio
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos obrigatórios corretamente
    Quando o usuário deixa o campo "Quilometragem" vazio
    Quando o usuário tenta avançar sem preencher o campo    Quilometragem    ${LOC_INPUT_QUILOMETRAGEM}
    Então o sistema não deve exibir erro no campo "Quilometragem"
    E o sistema deve permitir avançar para a etapa Itens

Cenário: QA-334 (FRONT) Validar múltiplos campos obrigatórios vazios simultaneamente
    [Documentation]    Valida que todos os 10 campos obrigatórios exibem erro quando vazios
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que todos os campos obrigatórios estão vazios
    Quando o usuário tenta avançar sem preencher nenhum campo obrigatório
    Então todos os 10 campos obrigatórios devem estar destacados em vermelho
    E devem ser exibidas 10 mensagens de erro simultaneamente
    E o usuário deve permanecer na etapa Dados

Cenário: QA-335 (FRONT) Validar acesso ao Step Itens após preenchimento do Step Dados
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Itens
    ...    Como usuário do VeriCar
    ...    Quero acessar o step de Itens de Segurança após preencher os dados
    ...    Para selecionar os equipamentos do veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    E que o usuário preencheu todos os campos corretamente
    E o usuário clica no botão "Continuar"
    Então sou direcionado para o step "Itens"
    E o step "Itens" está ativo e destacado
    E o título exibe o texto    ${vericar_texto.solicitar_laudo.etapa_2.titulo}
    E o subtítulo exibe o texto    ${vericar_texto.solicitar_laudo.etapa_2.descricao}
    E as condições do veículo por tipo são exibidas
    E expando a seção "Itens de segurança"
    E a lista de itens de segurança é exibida
    E os botões "Voltar", "Pular etapa" e "Continuar" estão visíveis

Cenário: QA-336 (FRONT) Validar exibição da lista completa de itens de segurança
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Itens
    ...    Como usuário do VeriCar
    ...    Quero visualizar todos os itens de segurança disponíveis
    ...    Para selecionar os equipamentos presentes no veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    Então o item "Airbag" está visível com checkbox desmarcado
    E o item "Buzina" está visível com checkbox desmarcado
    E o item "Cabo de bateria" está visível com checkbox desmarcado
    E o item "Chave de roda" está visível com checkbox desmarcado
    E o item "Cintos de segurança" está visível com checkbox desmarcado
    E o item "Compressor" está visível com checkbox desmarcado
    E o item "Encosto de cabeça" está visível com checkbox desmarcado
    E o item "Freio ABS" está visível com checkbox desmarcado
    E o item "Extintor de incêndio na validade" está visível com checkbox desmarcado
    E o item "Espelhos (internos e retrovisores)" está visível com checkbox desmarcado
    E o item "Freio de estacionamento (freio de mão)" está visível com checkbox desmarcado
    E o item "Luzes indicadoras de direção" está visível com checkbox desmarcado
    E o item "Limpador de para-brisas" está visível com checkbox desmarcado
    E o item "Lanterna" está visível com checkbox desmarcado
    E o item "Macaco" está visível com checkbox desmarcado
    E o item "Manual do veículo" está visível com checkbox desmarcado
    E o item "Triângulo de sinalização" está visível com checkbox desmarcado

Cenário: QA-337 (FRONT) Validar funcionalidade do botão Pular Etapa no Step Itens
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Itens
    ...    Como usuário do VeriCar
    ...    Quero poder pular a seleção de itens de segurança
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E que nenhum item de segurança foi selecionado    ${forms_solicitacao.itens_de_seguranca}
    Então nenhum item de segurança fica registrado
    Quando clico no botão "Pular etapa"
    Então sou direcionado para o step "Anexos"
    E o step "Anexos" está ativo e destacado

Cenário: QA-338 (FRONT) Validar seleção de um único item de segurança
    [Documentation]    Funcionalidade: Solicitação de Laudo - Seleção Step Itens
    ...    Como usuário do VeriCar
    ...    Quero selecionar um item de segurança
    ...    Para registrar os equipamentos do veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E marco o checkbox do item "Airbag"
    Então o checkbox do item "Airbag" fica marcado
    E os demais checkboxes permanecem desmarcados    Airbag

Cenário: QA-339 (FRONT) Validar seleção de múltiplos itens de segurança
    [Documentation]    Fucionalidade: Solicitação de Laudo - Seleção Step Itens
    ...    Como usuário do VeriCar
    ...    Quero selecionar múltiplos itens de segurança
    ...    Para registrar todos os equipamentos do veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E marco o checkbox do item "Airbag"
    E marco o checkbox do item "Freio ABS"
    E marco o checkbox do item "Compressor"
    Então o checkbox do item "Airbag" fica marcado
    E o checkbox do item "Freio ABS" fica marcado
    E o checkbox do item "Compressor" fica marcado

Cenário: QA-340 (FRONT) Validar expansão da seção Itens de Segurança
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Itens
    ...    Como usuário do VeriCar
    ...    Quero expandir a seção de Itens de Segurança
    ...    Para visualizar e selecionar os itens
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E a seção "Itens de segurança" está colapsada
    Quando expando a seção "Itens de segurança"
    Então a seção "Itens de segurança" está expandida
    E todos os 17 itens são exibidos

Cenário: QA-341 (FRONT) Validar colapso da seção Itens de Segurança
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Itens
    ...    Como usuário do VeriCar
    ...    Quero colapsar a seção de Itens de Segurança
    ...    Para organizar a visualização da tela
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    Quando colapso a seção "Itens de segurança"
    Então a seção "Itens de segurança" está colapsada

Cenário: QA-342 (FRONT) Validar seleção de condição Elétrica e exibição da observação
    [Documentation]    Funcionalidade: Solicitação de Laudo - Condições do Veículo
    ...    Como usuário do VeriCar
    ...    Quero selecionar a condição Elétrica do veículo
    ...    Para registrar o estado do sistema elétrico
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E seleciono a condição "Elétrica" como "Não funciona"
    Então o campo de observação da condição "Elétrica" é exibido

Cenário: QA-343 (FRONT) Validar preenchimento de observação para condição Elétrica
    [Documentation]    Funcionalidade: Solicitação de Laudo - Condições do Veículo
    ...    Como usuário do VeriCar
    ...    Quero preencher observações sobre a condição Elétrica
    ...    Para detalhar problemas encontrados
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E seleciono a condição "Elétrica" como "${forms_solicitacao.condicoes_veiculo.condicao_1.tipo}"
    E preencho a observação da condição com o texto
    ...    Elétrica
    ...    ${forms_solicitacao.condicoes_veiculo.condicao_1.observacao}
    Então o campo de observação da condição "Elétrica" contém o texto "Sistema apresenta falhas intermitentes"

Cenário: QA-584 (FRONT) Validar seleção de múltiplas condições do veículo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Condições do Veículo
    ...    Como usuário do VeriCar
    ...    Quero selecionar condições para diferentes aspectos do veículo
    ...    Para registrar o estado geral do veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
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

Cenário: QA-344 (FRONT) Validar seleção de todos os itens de segurança disponíveis
    [Documentation]    Funcionalidade: Solicitação de Laudo - Seleção Step Itens
    ...    Como usuário do VeriCar
    ...    Quero selecionar todos os itens de segurança
    ...    Para registrar um veículo com equipamentos completos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    Quando marco todos os checkboxes de itens de segurança
    Então todos os 17 itens ficam marcados

Cenário: QA-345 (FRONT) Validar funcionalidade do botão Voltar no Step Itens
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Itens
    ...    Como usuário do VeriCar
    ...    Quero voltar para o step anterior
    ...    Para revisar ou corrigir dados preenchidos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E que selecionei alguns itens de segurança
    Quando clico no botão "Voltar"
    Então sou redirecionado para o step "Dados"
    E o step "Dados" está ativo
    E todos os dados preenchidos anteriormente são mantidos

Cenário: QA-346 (FRONT) Validar funcionalidade do botão Continuar no Step Itens vazio
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Itens
    ...    Como usuário do VeriCar
    ...    Quero avançar sem selecionar itens de segurança
    ...    Para continuar quando não há equipamentos a registrar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E que nenhum item de segurança foi selecionado    ${forms_solicitacao.itens_de_seguranca}
    Quando clico no botão "Continuar"
    Então sou direcionado para o step "Anexos"
    E o step "Anexos" está ativo e destacado

Cenário: QA-347 (FRONT) Validar função do botão Continuar no Step Itens com seleções
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Itens
    ...    Como usuário do VeriCar
    ...    Quero avançar após selecionar itens de segurança
    ...    Para continuar o processo de solicitação
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E que selecionei os itens "Airbag", "Buzina" e "Compressor"
    Quando clico no botão "Continuar"
    Então sou direcionado para o step "Anexos"
    E o step "Anexos" está ativo e destacado

Cenário: QA-348 (FRONT) Validar persistência das seleções ao voltar do Step Anexos
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação entre Steps
    ...    Como usuário do VeriCar
    ...    Quero que minhas seleções de itens sejam mantidas ao navegar entre steps
    ...    Para não precisar selecionar novamente
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E expando a seção "Itens de segurança"
    E que selecionei os itens com observação    Airbag    Buzina
    Quando clico no botão "Continuar"
    E que avancei para o step "Anexos"
    Quando clico no botão "Voltar"
    Então sou redirecionado para o step "Itens"
    E expando a seção "Itens de segurança"
    E o checkbox do item "Airbag" está marcado
    E o checkbox do item "Buzina" está marcado

Cenário: QA-349 (FRONT) Validar acesso ao Step Anexos após Step Itens
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero acessar o step de Anexos após o step de Itens
    ...    Para fazer upload de imagens do veículo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E clico no botão "Pular etapa"
    Então sou direcionado para o step "Anexos"
    E o step "Anexos" está ativo e destacado
    E o título exibe o texto    ${vericar_texto.solicitar_laudo.etapa_3.titulo}
    E o subtítulo exibe o texto    ${vericar_texto.solicitar_laudo.etapa_3.descricao}
    E a área de upload é exibida com o texto "Arraste ou clique aqui para enviar as imagens"
    E as informações Apenas arquivos png, jpg ou jpeg são exibidas
    E as informações "Máximo de 6 imagens (total combinado de até 2 MB)" são exibidas
    E as informações "Resoluções recomendadas: 1920x1080, 960x540 ou 1024x768" são exibidas
    E os botões "Voltar", "Pular etapa" e "Continuar" estão visíveis

Cenário: QA-350 (FRONT) Validar exibição da área de upload de imagens
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero visualizar a área de upload de imagens
    ...    Para saber como anexar arquivos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    Então a área de upload exibe o ícone de nuvem
    E o texto "Arraste ou clique aqui para enviar as imagens" está visível
    E o botão "Selecione o arquivo" está visível e habilitado
    E as especificações técnicas estão visíveis abaixo da área de upload

Cenário: QA-351 (FRONT) Validar funcionalidade do botão Pular Etapa no Step Anexos
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero poder pular o anexo de imagens
    ...    Para avançar rapidamente quando não há imagens para anexar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que nenhuma imagem foi anexada
    Quando clico no botão "Pular etapa"
    Então sou direcionado para o step "Resumo"
    E o step "Resumo" está ativo e destacado
    E o step "Anexos" exibe um indicador de conclusão
    E nenhuma imagem fica registrada

Cenário: QA-353 (FRONT) Validar upload de múltiplas imagens com sucesso
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de múltiplas imagens
    ...    Para anexar várias fotos do veículo ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho 4 imagens dentro do limite de 2MB
    E seleciono 4 imagens
    Então após o upload, são exibidas 4 miniaturas
    E 4 miniaturas são exibidas
    E cada imagem exibe seu nome
    E cada imagem tem ícones de exclusão

Cenário: QA-354 (FRONT) Validar exibição de miniatura da imagem após upload
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero visualizar miniatura da imagem após upload
    ...    Para confirmar que o arquivo correto foi anexado
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que fiz upload da imagem    ${forms_solicitacao.imagem.foto01}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E a imagem é visualizável na miniatura    ${nome_arquivo_teste}
    E o nome do arquivo está visível abaixo da miniatura    ${nome_arquivo_teste}

Cenário: QA-355 (FRONT) Validar upload de imagem em formato PNG
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de imagem PNG
    ...    Para anexar fotos neste formato ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto01}
    Quando faço upload da imagem    ${forms_solicitacao.imagem.foto01}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-356 (FRONT) Validar upload de imagem em formato JPG/JPEG
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de imagem JPG ou JPEG
    ...    Para anexar fotos nestes formatos ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto07}
    Quando faço upload da imagem    ${forms_solicitacao.imagem.foto07}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-357 (FRONT) Validar limite máximo de 6 imagens para upload
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de até 6 imagens
    ...    Para anexar múltiplas fotos do veículo respeitando o limite
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E selecionei as 6 imagens permitidas
    Então todas as 6 imagens são carregadas com sucesso
    E a área de upload se torna indisponível

Cenário: QA-358 (FRONT) Validar mensagem de erro ao exceder limite de 2MB
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero ser alertado quando o tamanho total das imagens exceder 2MB
    ...    Para corrigir o upload antes de prosseguir
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que já anexei uma imagem    ${forms_solicitacao.imagem.foto02}
    Quando tento fazer upload da imagem    ${forms_solicitacao.imagem.foto08}
    Então uma mensagem de erro é exibida
    E o texto "O tamanho máximo combinado é 2MB" é exibido
    E a imagem não é anexada    imagem_3_lateral_esquerda.png
    E apenas a primeira imagem permanece anexada    imagem_2_lateral_direita.png

Cenário: QA-359 (FRONT) Validar mensagem de erro com formato de arquivo não suportado
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero ser alertado quando tentar anexar arquivo com formato não suportado
    ...    Para corrigir o formato antes de prosseguir
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    Quando tento fazer upload da imagem    ${forms_solicitacao.imagem.foto09}
    Então uma mensagem de erro é exibida
    E o texto informando formatos aceitos é destacado
    E a imagem não é anexada    ${nome_arquivo_teste}

Cenário: QA-360 (FRONT) Validar exclusão de imagem anexada
    [Documentation]    Funcionalidade: Solicitação de Laudo - Gerenciamento Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero excluir uma imagem anexada
    ...    Para remover arquivos incorretos ou desnecessários
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto01}
    Quando faço upload da imagem    ${forms_solicitacao.imagem.foto01}
    Quando clico no ícone de exclusão da imagem    ${nome_arquivo_teste}
    Então a imagem é removida da lista de anexos
    E a miniatura não é mais exibida    ${nome_arquivo_teste}

Cenário: QA-364 (FRONT) Validar funcionalidade do botão Voltar no Step Anexos
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero voltar para o step anterior
    ...    Para revisar ou corrigir seleções de itens
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E seleciono 2 imagens
    Quando clico no botão "Voltar"
    Então sou redirecionado para o step "Itens"
    E todas as seleções anteriores são mantidas

Cenário: QA-365 (FRONT) Validar funcionalidade do botão Continuar no Step Anexos vazio
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero avançar sem anexar imagens
    ...    Para continuar quando não há imagens disponíveis
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que nenhuma imagem foi anexada
    Quando clico no botão "Continuar"
    Então sou direcionado para o step "Resumo"
    E o step "Resumo" está ativo e destacado

Cenário: QA-366 (FRONT) Validar funcionalidade do botão Continuar no Step Anexos com dados
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero avançar após anexar imagens
    ...    Para continuar o processo de solicitação
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E seleciono 3 imagens
    Quando clico no botão "Continuar"
    Então sou direcionado para o step "Resumo"
    E o step "Resumo" está ativo e destacado
    E as 3 miniaturas das imagens são exibidas

Cenário: QA-367 (FRONT) Validar persistência das imagens ao voltar do Step Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação entre Steps
    ...    Como usuário do VeriCar
    ...    Quero que minhas imagens anexadas sejam mantidas ao navegar entre steps
    ...    Para não precisar fazer upload novamente
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Quando clico no botão "Voltar"
    Então sou redirecionado para o step "Anexos"
    E 2 miniaturas são exibidas
    E cada imagem exibe seu nome
    E cada imagem tem ícones de exclusão

Cenário: QA-368 (FRONT) Validar acesso ao Step Resumo após Step Anexos
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero acessar o step de Resumo após o step de Anexos
    ...    Para revisar todas as informações antes de solicitar o laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E o título exibe o texto    ${vericar_texto.solicitar_laudo.etapa_4.titulo}
    E o subtítulo exibe o texto    ${vericar_texto.solicitar_laudo.etapa_4.descricao}
    E todas as seções de dados preenchidos são exibidas
    E os botões "Voltar" e "Solicitar laudo" estão visíveis

Cenário: QA-369 (FRONT) Validar exibição da seção Proposta e Cliente no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar os dados de Proposta e Cliente no resumo
    ...    Para confirmar as informações antes de solicitar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que preenchi os dados de proposta e cliente no Step Dados
    Então a seção "Proposta e cliente" é exibida
    E o campo "Filial" exibe "${filial_teste}" (se preenchido)
    E o campo "Número da proposta" exibe "${numeroProposta_teste}"
    E o campo "Tipo do cliente" exibe "${tipoCliente_teste}"
    E o campo "Nome do cliente" exibe "${nomeCliente_teste}"
    E o campo "Documento do cliente" exibe "${documentoCliente_teste}"

Cenário: QA-370 (FRONT) Validar exibição da seção Loja e Vendedor no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar os dados de Loja e Vendedor no resumo
    ...    Para confirmar as informações antes de solicitar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que preenchi os dados de loja e vendedor no Step Dados
    Então a seção "Loja e vendedor" é exibida
    E o campo "CNPJ da loja" exibirá "${cnpjLoja_teste}"
    E o campo "CPF do vendedor" exibe "${cpfVendedor_teste}" (se preenchido)
    E o campo "Nome do vendedor" exibe "${nomeVendedor_teste}"

Cenário: QA-371 (FRONT) Validar exibição da seção Dados do Veículo no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar os dados do veículo no resumo
    ...    Para confirmar as informações antes de solicitar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que preenchi os dados do veículo no Step Dados
    Então a seção "Dados do veículo" é exibida
    E o campo "Placa" exibe "${placa_teste}"
    E o campo "RENAVAM" exibe "${renavam_teste}"
    E o campo "UF da placa" exibe "${ufPlaca_teste}"
    E o campo "Cidade" exibe "${cidade_teste}"
    E o campo "Quilometragem" exibe "${quilometragem_teste}" (se preenchido)

Cenário: QA-372 (FRONT) Validar exibição da seção Itens de Segurança no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar os itens de segurança selecionados no resumo
    ...    Para confirmar os equipamentos antes de solicitar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que selecionei "Buzina"
    E que selecionei "Compressor"
    Então a seção "Itens de segurança" é exibida
    E o item "Buzina" é exibido
    E o item "Compressor" é exibido

Cenário: QA-373 (FRONT) Validar ocultação da seção Itens de Segurança quando vazia
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero que a seção de Itens de Segurança seja ocultada quando não há itens
    ...    Para manter o resumo limpo e objetivo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    E que não selecionei nenhum item no Step Itens
    Então a seção "Itens de segurança" não é exibida no resumo

Cenário: QA-374 (FRONT) Validar exibição da seção Imagens para Análise no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar as imagens anexadas no resumo
    ...    Para confirmar os arquivos antes de solicitar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que anexei 2 imagens no Step Anexos
    Então a seção "Imagens para análise" é exibida
    E o título "Anexos" é exibido
    E as 2 miniaturas das imagens são exibidas
    E cada imagem exibe seu nome
    E cada imagem tem ícones de exclusão
    E o tamanho "208kb" é exibido

Cenário: QA-375 (FRONT) Validar ocultação da seção Imagens para Análise quando vazia
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero que a seção de Imagens seja ocultada quando não há imagens
    ...    Para manter o resumo limpo e objetivo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    E que não anexei nenhuma imagem no Step Anexos
    Então a seção "Imagens para análise" não é exibida no resumo

Cenário: QA-511 (FRONT) Validar exclusão de imagem a partir do Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero fazer exclusão de uma imagem a partir do resumo
    ...    Para remover o arquivo antes de solicitar o laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Quando clico no ícone de exclusão da imagem    ${nome_arquivo_teste}
    Então a imagem é removida da lista de anexos
    E a miniatura não é mais exibida    ${nome_arquivo_teste}
    E as 1 miniaturas das imagens são exibidas

Cenário: QA-377 (FRONT) Validar funcionalidade do botão Voltar no Step Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero voltar para o step anterior
    ...    Para revisar ou corrigir anexos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E clico no botão "Voltar"
    Então sou redirecionado para o step "Anexos"
    E o step "Anexos" está ativo e destacado
    E todas as imagens anexadas anteriormente são mantidas

Cenário: QA-378 (FRONT) Validar exibição completa de todos os dados no Resumo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Step Resumo
    ...    Como usuário do VeriCar
    ...    Quero visualizar todos os dados preenchidos em um único resumo
    ...    Para ter visão completa antes de solicitar o laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E que preenchi todos os campos do Step Dados
    E que selecionei itens no Step Itens com observações
    E que anexei imagens no Step Anexos
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    E todos os dados preenchidos são exibidos corretamente
    E todas as observações de itens são exibidas
    E todas as miniaturas de imagens são exibidas

Cenário: QA-379 (FRONT) Validar solicitação de laudo com sucesso
    [Documentation]    Funcionalidade: Solicitação de Laudo - Finalização
    ...    Como usuário do VeriCar
    ...    Quero solicitar o laudo após revisar os dados
    ...    Para concluir o processo e gerar o documento
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"

Cenário: QA-381 (FRONT) Validar exibição do modal de confirmação de sucesso
    [Documentation]    Funcionalidade: Solicitação de Laudo - Feedback de Sucesso
    ...    Como usuário do VeriCar
    ...    Quero receber confirmação visual de que o laudo foi emitido
    ...    Para ter certeza de que o processo foi concluído
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"

Cenário: QA-382 (FRONT) Validar redirecionamento para lista de laudos após sucesso
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação após Sucesso
    ...    Como usuário do VeriCar
    ...    Quero retornar à lista de laudos após emitir o laudo
    ...    Para visualizar todos os laudos gerados
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
    Quando clico no botão "Voltar para lista de laudos"
    Então o modal de erro é fechado
    E sou redirecionado para a tela "Lista de laudos"
    E o novo ID do laudo é exibido na lista

Cenário: QA-384 (FRONT) Validar fechamento do modal de sucesso pelo botão X
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação após Sucesso
    ...    Como usuário do VeriCar
    ...    Quero fechar o modal de sucesso
    ...    Para retornar à lista de laudos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
    Quando clico no botão X de fechar
    Então o modal de erro é fechado
    E sou redirecionado para a tela "Lista de laudos"
    E o novo ID do laudo é exibido na lista

Cenário: QA-385 (FRONT) Validar geração de novo ID na lista após emissão do laudo
    [Documentation]    Funcionalidade: Solicitação de Laudo - Geração de ID
    ...    Como usuário do VeriCar
    ...    Quero que um novo ID seja gerado automaticamente
    ...    Para identificar o laudo criado
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
    Quando clico no botão X de fechar
    Então o modal de erro é fechado
    E sou redirecionado para a tela "Lista de laudos"
    E o novo ID do laudo é exibido na lista
    Então um novo ID de laudo é exibido na primeira posição da lista
    E o ID contém 17 dígitos numéricos
    E o campo "Responsável" exibe o nome do usuário logado
    E o campo "Última atualização" exibe a data e hora atual

Cenário: QA-386 (FRONT) Validar acesso ao laudo gerado a partir da lista
    [Documentation]    Funcionalidade: Solicitação de Laudo - Acesso ao Laudo Gerado
    ...    Como usuário do VeriCar
    ...    Quero acessar o laudo recém-criado a partir da lista
    ...    Para realizar ações sobre ele
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
    Quando clico no botão X de fechar
    E sou redirecionado para a tela "Lista de laudos"
    E o novo ID do laudo é exibido na lista
    E clica no ícone de três pontos do laudo desejado    ${novo_id_gerado}
    Então sistema exibe menu dropdown próximo ao ícone
    E menu contém exatamente 3 opções na ordem

Cenário: QA-387 (FRONT) Validar integridade dos dados no laudo gerado
    [Documentation]    Funcionalidade: Solicitação de Laudo - Integridade de Dados
    ...    Como usuário do VeriCar
    ...    Quero que todos os dados preenchidos sejam salvos no laudo
    ...    Para garantir a precisão do documento
    [Tags]    regression    sanity
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar seções do PDF    ${arquivo_baixado}

Cenário: QA-388 (FRONT) Validar exibição do modal de erro na emissão do laudo
    [Documentation]    Pré-condição: Frontend rodando localmente com configuração apontando para backend local.
    ...    O backend deve estar em execução COM TOKEN EXPIRADO DA AWS NO S3 para validar comportamento de erro de conexão.
    [Tags]    regression    sanity    manual
    # Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    # E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão com erro"

Cenário: QA-389 (FRONT) Validar tentativa de reemissão após erro
    [Documentation]    Pré-condição: Frontend rodando localmente com configuração apontando para backend local.
    ...    O backend deve estar em execução COM TOKEN EXPIRADO DA AWS NO S3 para validar comportamento de erro de conexão.
    [Tags]    regression    sanity    manual
    # Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    # E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão com erro"
    Quando clico no botão "Tentar emitir novamente"
    Então o modal de erro é fechado
    E sou redirecionado para o step "Resumo"
    E todos os dados preenchidos são mantidos
    E posso clicar novamente em "Solicitar laudo"

Cenário: QA-390 (FRONT) Validar cancelamento após erro
    [Documentation]    Pré-condição: Frontend rodando localmente com configuração apontando para backend local.
    ...    O backend deve estar em execução COM TOKEN EXPIRADO/INCORRETO DA AWS NO S3 para validar comportamento de erro de conexão.
    [Tags]    regression    sanity    manual
    # Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    # E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão com erro"
    Quando clico no botão "Voltar para a lista de laudos"
    Então o modal de erro é fechado
    E sou redirecionado para a tela "Lista de laudos"
    E nenhum novo ID de laudo é gerado

Cenário: QA-391 (FRONT) Validar fechamento do modal de erro pelo botão X
    [Documentation]    Pré-condição: Frontend rodando localmente com configuração apontando para backend local.
    ...    O backend deve estar em execução COM TOKEN EXPIRADO DA AWS NO S3 para validar comportamento de erro de conexão.
    [Tags]    regression    sanity    manual
    # Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    # E trocar para conta    1001
    Quando estou no step "Resumo"
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão com erro"
    Quando clico no botão X de fechar
    Então o modal de erro é fechado
    E permaneço no step "Resumo"
    E todos os dados preenchidos são mantidos

Cenário: QA-394 (FRONT) Validar fechamento do modal pelo X em qualquer step
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Geral
    ...    Como usuário do VeriCar
    ...    Quero fechar o modal de solicitação a qualquer momento
    ...    Para cancelar o processo quando necessário
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Resumo"
    E clico no botão X no canto superior direito do modal
    Então o modal é fechado
    E sou redirecionado para a tela "Lista de laudos"
    E nenhum novo ID de laudo é gerado

Cenário: QA-395 (FRONT) Validar indicadores de progresso dos steps
    [Documentation]    Funcionalidade: Solicitação de Laudo - Navegação Geral
    ...    Como usuário do VeriCar
    ...    Quero visualizar quais steps já foram concluídos
    ...    Para acompanhar meu progresso no processo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então todos os campos do formulário devem estar visíveis
    E que preencho todos os campos e avanço para o step "Itens"
    Então o step "Dados" exibe um ícone de check ou indicador de conclusão
    E o step "Itens" está destacado como ativo
    Quando avanço para o step "Anexos"
    Então o step "Itens" exibe indicador de conclusão
    E o step "Anexos" está destacado como ativo

Cenário: QA-398 (FRONT) Validar resolução aceita de imagem 800x600
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação de Upload
    ...    Como usuário do VeriCar
    ...    Quero ser alertado quando a resolução da imagem não for aceita
    ...    Para corrigir o arquivo antes de anexar
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto10}
    E seleciono a imagem    ${forms_solicitacao.imagem.foto10}
    E o nome é exibido    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-400 (FRONT) Validar aceitação de caracteres especiais em campos de texto
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação de Entrada
    ...    Como usuário do VeriCar
    ...    Quero poder inserir caracteres especiais quando necessário
    ...    Para preencher nomes e informações corretamente
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então todos os campos do formulário devem estar visíveis
    Quando o usuário submete o formulário com o campo "Nome do cliente" preenchido com "${forms_solicitacao.nomes.cliente_caracteres_especiais}"
    E preencho o campo    Nome do vendedor    ${forms_solicitacao.nomes.vendedor_caracteres_especiais}
    E nenhuma mensagem de erro é exibida
    E o usuário clica no botão "Continuar"
    E o usuário clica no botão "Continuar"
    E clico no botão "Pular etapa"
    E os caracteres especiais são preservados no resumo

Cenário: QA-401 (FRONT) Validar restrição de entrada em campos numéricos
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação de Entrada
    ...    Como usuário do VeriCar
    ...    Quero que campos numéricos aceitem apenas números
    ...    Para evitar erros de preenchimento
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então todos os campos do formulário devem estar visíveis
    Quando preencho o campo    Número da proposta    ABC
    Então as letras não são inseridas no campo
    Quando preencho o campo    RENAVAM    XYZ123
    Então o campo "RENAVAM" deve estar destacado em vermelho
    E deve exibir a mensagem de erro no campo    ${mensagens_form_solicitar.erro.renavam}    RENAVAM
    E o usuário deve permanecer na etapa Dados

Cenário: QA-402 (FRONT) Validar limite de caracteres em campos de texto
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação de Entrada
    ...    Como usuário do VeriCar
    ...    Quero que campos de texto tenham limites apropriados
    ...    Para evitar inserção de texto excessivamente longo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Então todos os campos do formulário devem estar visíveis
    Quando o usuário submete o formulário com o campo "Nome do cliente" preenchido com "${forms_solicitacao.limites.nome_cliente}"
    E preencho o campo    Nome do vendedor    ${forms_solicitacao.limites.nome_vendedor}
    E preencho o campo    Filial    ${forms_solicitacao.limites.filial}
    E preencho o campo    Cidade    ${forms_solicitacao.limites.cidade}
    E preencho o campo    Número da proposta    ${forms_solicitacao.limites.numero_proposta}
    E preencho o campo    Quilometragem    ${forms_solicitacao.limites.quilometragem}
    Então todos os valores preenchidos devem estar dentro do limite esperado
    E o botão do modal está habilitado e clicável    Continuar

Cenário: QA-583 (FRONT) Validar limite de caracteres no campo de observação
    [Documentation]    Funcionalidade: Solicitação de Laudo - Validação Step Itens
    ...    Como usuário do VeriCar
    ...    Quero saber o limite de caracteres para observações
    ...    Para não exceder o espaço disponível
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Itens"
    E seleciono a condição "Elétrica" como "${forms_solicitacao.condicoes_veiculo.condicao_1.tipo}"
    E preencho a observação da condição com o texto    Elétrica    ${forms_solicitacao.limites.observacao_item}
    Então o valor de observação preenchido deve estar dentro do limite esperado
    Quando clico no botão "Continuar"
    E o usuário clica no botão "Continuar"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"

Cenário: QA-404 (FRONT) Validar resolução aceita de imagem 1920x1080
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de imagem com resolução 1920x1080
    ...    Para anexar foto em alta resolução ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto13}
    E seleciono a imagem    ${forms_solicitacao.imagem.foto13}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E o nome é exibido    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-405 (FRONT) Validar resolução aceita de imagem 960x540
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de imagem com resolução 960x540
    ...    Para anexar foto em resolução média ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto11}
    E seleciono a imagem    ${forms_solicitacao.imagem.foto11}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E o nome é exibido    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-406 (FRONT) Validar resolução aceita de imagem 1024x768
    [Documentation]    Funcionalidade: Solicitação de Laudo - Upload Step Anexos
    ...    Como usuário do VeriCar
    ...    Quero fazer upload de imagem com resolução 1024x768
    ...    Para anexar foto em resolução padrão ao laudo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando estou no step "Anexos"
    E que tenho uma imagem    ${forms_solicitacao.imagem.foto12}
    E seleciono a imagem    ${forms_solicitacao.imagem.foto12}
    Então a miniatura da imagem é exibida    ${nome_arquivo_teste}
    E o nome é exibido    ${nome_arquivo_teste}
    E nenhuma mensagem de erro é exibida

Cenário: QA-512 (FRONT) Validar campo Quilometragem (opcional) não pode ser negativo
    [Documentation]    Valida que Quilometragem opcional exibe erro quando for inteiro negativo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Quilometragem" preenchido com "-100"
    Então o valor negativo não é inserido no campo
    E o valor do campo deve ser    Quilometragem    100

Cenário: QA-516 (FRONT) Validar campo Quilometragem (opcional) sendo maior que 7 dígitos
    [Documentation]    Valida que Quilometragem opcional exibe erro quando for maior que 7 dígitos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Quilometragem" preenchido com "12345678"
    Então o valor negativo não é inserido no campo
    E o valor do campo deve ser    Quilometragem    1234567

Cenário: QA-517 (FRONT) Validar campo Filial (opcional) não pode ser maior que 30 dígitos
    [Documentation]    Valida que Filial opcional exibe erro quando for maior que 30 dígitos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Filial" preenchido com "PROP-123456789012345678901234567890-EXTRA"
    Então o valor do campo deve ser    Filial    PROP-1234567890123456789012345

Cenário: QA-518 (FRONT) Validar campo Número da proposta não pode ser maior que 30 dígitos
    [Documentation]    Valida que Número da proposta exibe erro quando for maior que 30 dígitos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E que o modal de solicitação está aberto na etapa Dados
    Quando o usuário submete o formulário com o campo "Número da proposta" preenchido com "12345678901234567890123456789042"
    Então o valor do campo deve ser    Número da proposta    123456789012345678901234567890

Cenário: QA-363 (FRONT) Verificar consistência do carimbo de data e hora no PDF
    [Tags]    regression    sanity
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    E clica no ícone de três pontos do laudo desejado    ${laudo_completo}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${laudo_completo}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do carimbo de data e hora no PDF    ${arquivo_baixado}

Cenário: QA-380 (FRONT) Verificar informações de bases consultadas no rodapé do laudo
    [Tags]    regression    sanity
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    E clica no ícone de três pontos do laudo desejado    ${laudo_completo}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${laudo_completo}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar seção Header e Footer do PDF    ${arquivo_baixado}

Cenário: QA-383 (FRONT) Solicitar laudo de um veículo com Gravame ativo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo Gravame ativo nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}
    ...    tem_gravame=${True}

Cenário: QA-392 (FRONT) Solicitar laudo de um veículo com Licenciamentos vencidos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo Licenciamentos vencidos nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-393 (FRONT) Solicitar laudo de um veículo com RENAJUD
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo RENAJUD nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-396 (FRONT) Solicitar laudo de um veículo com DPVATs vencidos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo DPVATs vencidos nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-397 (FRONT) Solicitar laudo com todos os campos de observações preenchidos
    [Tags]    regression    sanity
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    E clica no ícone de três pontos do laudo desejado    ${laudo_completo}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${laudo_completo}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar seções do PDF    ${arquivo_baixado}

Cenário: QA-399 (FRONT) Solicitar laudo de um veículo com IPVAs vencidos
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo IPVAs vencidos nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-519 (FRONT) Solicitar laudo de um veículo com Multas Vencidas
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo Multas Vencidas nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-520 (FRONT) Solicitar laudo de um veículo com Restrição por roubo
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo Restrição por roubo nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-521 (FRONT) Solicitar laudo de um veículo com Bloqueio por restrição
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    Quando o usuário acessa a tela de listagem de laudos
    E clica no ícone de três pontos do laudo desejado    ${LAUDO_COMPLETO}
    Quando clica na opção "Download do laudo"
    Então o arquivo é baixado com o nome    laudo-${LAUDO_COMPLETO}
    E o sistema exibe um snackbar com a mensagem    sucesso    ${mensagens_download.sucesso}
    E validar consistência do campo Bloqueio por restrição nas seções Débitos/Restrições do PDF
    ...    ${arquivo_baixado}

Cenário: QA-582 (FRONT) Validar solicitação de laudo com imagem 800x600 com sucesso
    [Tags]    regression    sanity
    Dado que acesse o Portal com o usuário    &{LOGIN_SUPER}
    E trocar para conta    1001
    E que anexei imagem 800x600 no Step Anexos
    E que preenchi todos os campos do Step Dados
    E que selecionei itens no Step Itens com observações
    Então todas as seções são exibidas: "Proposta e cliente, Loja e vendedor, Dados do veículo, Itens de segurança e Imagens para análise"
    Quando clico no botão "Solicitar laudo"
    Então sistema abre o "Emissão em processamento"
