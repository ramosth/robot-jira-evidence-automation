*** Settings ***
Documentation       Page Object do laudo em PDF (Termo de Avaliação de Veículo).
...                 Valida o conteúdo do arquivo baixado na lista de laudos usando a
...                 biblioteca Python libraries/LaudoPDF.py.
...
...                 Arquivo completado na versão de portfólio: estes passos são usados pela
...                 feature VC-16, mas ficavam em outro módulo do projeto original.

Resource            ../../config/package.robot


*** Keywords ***
# ============================================================================
# APOIO
# ============================================================================
Ler Texto Do Laudo Baixado
    [Documentation]    Lê o PDF baixado (results/downloads/<arquivo>) e retorna o texto completo.
    [Arguments]    ${arquivo}
    ${caminho}=    Join Path    ${EXECDIR}    results    downloads    ${arquivo}
    File Should Exist    ${caminho}
    ${texto}=    Extrair Texto Do Laudo    ${caminho}
    RETURN    ${texto}

Validar Dado Do Teste No Laudo Se Existir
    [Documentation]    Compara um campo do laudo com o valor usado na criação do laudo,
    ...    quando a variável existir no teste (ex.: ${placa_teste}). Assim o mesmo passo
    ...    serve para laudos criados no próprio teste ou em uma execução anterior.
    [Arguments]    ${texto}    ${campo}    ${nome_variavel}
    ${esperado}=    Get Variable Value    \${${nome_variavel}}    ${None}
    IF    $esperado is not None and $esperado != ''
        ${valor}=    Obter Valor Do Campo No Laudo    ${texto}    ${campo}
        Should Be Equal As Strings    ${valor}    ${esperado}
        ...    msg=${campo} no laudo ('${valor}') diferente do informado na solicitação ('${esperado}').
    END

# ============================================================================
# ENTÃO - VALIDAÇÕES DO PDF
# ============================================================================
E validar seções do PDF
    [Documentation]    Integridade do laudo:
    ...    - título "TERMO DE AVALIAÇÃO DE VEÍCULO";
    ...    - seções obrigatórias na ordem (Dados do Cliente > Dados do Veículo > Avaliação > Estado do Veículo);
    ...    - dados informados na solicitação (proposta, cliente, placa, RENAVAM e UF) iguais aos do PDF.
    [Arguments]    ${arquivo}
    ${texto}=    Ler Texto Do Laudo Baixado    ${arquivo}
    Laudo Deve Conter Os Textos    ${texto}    ${laudo_pdf.titulo}
    Secoes Do Laudo Devem Estar Na Ordem    ${texto}    @{laudo_pdf.secoes}
    Validar Dado Do Teste No Laudo Se Existir    ${texto}    Proposta/Contrato    numeroProposta_teste
    Validar Dado Do Teste No Laudo Se Existir    ${texto}    Nome/Razão Social    nomeCliente_teste
    Validar Dado Do Teste No Laudo Se Existir    ${texto}    Placa    placa_teste
    Validar Dado Do Teste No Laudo Se Existir    ${texto}    Renavam    renavam_teste
    Validar Dado Do Teste No Laudo Se Existir    ${texto}    UF Placa    ufPlaca_teste

E validar consistência do carimbo de data e hora no PDF
    [Documentation]    Valida o "Data | Hora Emissão" do laudo: data e hora válidas, não
    ...    futuras e geradas há no máximo 60 minutos (o laudo acabou de ser emitido).
    [Arguments]    ${arquivo}
    ${texto}=    Ler Texto Do Laudo Baixado    ${arquivo}
    ${emissao}=    Validar Carimbo De Data E Hora Do Laudo    ${texto}    tolerancia_minutos=60
    Log    Laudo emitido em ${emissao}

E validar seção Header e Footer do PDF
    [Documentation]    Em TODAS as páginas do laudo:
    ...    - cabeçalho com o título do documento e o número da Proposta/Contrato;
    ...    - rodapé com as bases consultadas, cada uma com data e hora da consulta.
    [Arguments]    ${arquivo}
    ${caminho}=    Join Path    ${EXECDIR}    results    downloads    ${arquivo}
    @{paginas}=    Extrair Paginas Do Laudo    ${caminho}
    FOR    ${numero}    ${pagina}    IN ENUMERATE    @{paginas}    start=1
        Log    Validando cabeçalho e rodapé da página ${numero}
        Laudo Deve Conter Os Textos    ${pagina}    ${laudo_pdf.titulo}    Proposta/Contrato
        Obter Bases Consultadas Do Laudo    ${pagina}    @{laudo_pdf.bases_consultadas}
    END

E validar consistência do campo ${campo} nas seções Débitos/Restrições do PDF
    [Documentation]    Valida um campo da seção "Avaliação" (débitos e restrições) conforme
    ...    a regra do campo (veja LaudoPDF.Validar Campo De Debitos E Restricoes).
    ...    tem_gravame: ${True}/${False} para conferir o valor esperado do "Gravame ativo".
    [Arguments]    ${arquivo}    ${tem_gravame}=${None}
    ${texto}=    Ler Texto Do Laudo Baixado    ${arquivo}
    Should Contain    ${laudo_pdf.campos_debitos_restricoes}    ${campo}
    ...    msg=Campo '${campo}' não faz parte da seção Débitos/Restrições.
    ${valor}=    Validar Campo De Debitos E Restricoes    ${texto}    ${campo}    ${tem_gravame}
    Log    ${campo}: ${valor}
