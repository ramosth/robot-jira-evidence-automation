*** Settings ***
Documentation       Arquivo de Setup And Teardown

Resource            package.robot


*** Keywords ***
Abrir Navegador E Acessar Sistema
    [Documentation]    Test Setup: abre o Chrome já configurado para os testes e acessa o portal.
    ...    - define a pasta results/downloads como destino dos downloads (laudos em PDF);
    ...    - desativa o print automático em falha (o print é feito no teardown, com nome padronizado);
    ...    - limpa prints soltos de execuções anteriores.
    ${download_outputdir}    Join Path    ${EXECDIR}    results    downloads
    Create Directory    ${download_outputdir}

    ${download_directory}    Join Path    ${EXECDIR}    results    downloads
    ${prefs}    Create Dictionary
    ...    download.default_directory=${download_directory}
    ...    safebrowsing.enabled=True

    Open Browser
    ...    url=${config.browser.url_portal}
    ...    browser=${config.browser.name}
    ...    options=add_experimental_option("prefs",${prefs});add_experimental_option("excludeSwitches", ["enable-logging"]);add_argument("--disable-gpu");add_argument("--disable-dev-shm-usage");add_argument("--no-sandbox");add_argument("--disable-extensions");add_argument("--disable-infobars");add_argument("--start-maximized");add_argument("--remote-debugging-port=9222");add_argument("--disable-features=VizDisplayCompositor")

    Set Selenium Implicit Wait    ${config.browser.implicit_wait}
    Set Selenium Timeout    ${config.browser.implicit_wait}

    # IMPORTANTE: Desabilita screenshot automático
    Register Keyword To Run On Failure    NOTHING

    Organizar arquivos de log    directory=${EXECDIR}    action=deletar    file_extension=png

Evidenciar teste na pasta
    [Documentation]    Test Teardown: salva a evidência do cenário e encerra o navegador.
    ...    O print vai para results/screenshots/screenshots DD-MM-AAAA/<pasta>/ com o nome
    ...    "<ID> <título> [ SUCESSO|FALHA ] HH_MM_SS.png". Esse padrão é o que permite ao
    ...    add_comentario.py encontrar o screenshot mais recente de cada card do Jira.
    ...    Por fim, remove os arquivos baixados durante o teste (csv, pdf, zip, xml, json).
    [Arguments]    ${folder}
    # formata data para registro da evidencia
    ${date}    Get Time
    ${date_string}    Convert To String    ${date}
    ${date_formated}    Replace String    ${date_string}    :    _
    ${only_hour}    Split String    ${date_formated}    separator=${None}
    # formata data para criar pasta do dia
    ${only_date}    Split String    ${date_string}    separator=${None}
    ${date_splited}    Split String    ${only_date[0]}    separator=-
    Set Test Variable    ${year}    ${date_splited[0]}
    Set Test Variable    ${month}    ${date_splited[1]}
    Set Test Variable    ${day}    ${date_splited[2]}
    ${full_directory}    Convert To String    ${config.files.screenshot_outputted} ${day}-${month}-${year}/${folder}
    Create Directory    ${full_directory}
    Set Screenshot Directory    ${full_directory}
    ${string_name}    Convert To String    ${TEST_NAME}
    ${nome_cenario}    Remove String    ${string_name}    Cenário:
    Sleep    1s
    IF    '${TEST_STATUS}' == 'PASS'
        Capture Page Screenshot    filename=${nome_cenario} [ SUCESSO ] ${only_hour[1]}.png
    ELSE IF    '${TEST_STATUS}' == 'FAIL'
        Capture Page Screenshot    filename=${nome_cenario} [ FALHA ] ${only_hour[1]}.png
    END
    Close All Browsers
    Sleep    2s    # Aguarda recursos serem liberados após fechar navegador
    Organizar arquivos de log    deletar    csv
    Organizar arquivos de log    deletar    pdf
    Organizar arquivos de log    deletar    zip
    Organizar arquivos de log    deletar    xml
    Organizar arquivos de log    deletar    json

Organizar arquivos de log
    [Documentation]    Move ou apaga arquivos de uma extensão em um diretório (padrão: results/downloads).
    ...    action=mover exige o argumento folder (destino); action=deletar remove os arquivos.
    [Arguments]
    ...    ${action}
    ...    ${file_extension}
    ...    ${folder}=${None}
    ...    ${directory}=${EXECDIR}//results//downloads
    ${directory_list}    List Files In Directory    ${directory}    *.${file_extension}
    IF    '${action}' == 'mover'
        Create Directory    ${folder}
        FOR    ${item}    IN    @{directory_list}
            Move File    ${item}    ${folder}
            # Log To Console    ${item} movido para pasta ${folder}
        END
    ELSE IF    '${action}' == 'deletar'
        FOR    ${item}    IN    @{directory_list}
            Remove File    ${directory}/${item}
            # Log To Console    ${item} deletado!!
        END
    END

Verificar se download foi concluído
    [Documentation]    Aguarda até que o arquivo específico seja baixado completamente
    [Arguments]    ${filename}

    ${caminho_arquivo}    Join Path    ${EXECDIR}    results    downloads

    # Aguarda até que o arquivo específico exista no diretório
    Wait Until Keyword Succeeds    300s    2s
    ...    Arquivo Específico Existe    ${caminho_arquivo}    ${filename}

    # Buscar o arquivo completo
    ${arquivo_completo}    Buscar Arquivo Por Nome Parcial    ${caminho_arquivo}    ${filename}

    # Aguarda até que o arquivo tenha tamanho > 0 (download completo)
    ${caminho_completo}    Join Path    ${caminho_arquivo}    ${arquivo_completo}
    Wait Until Keyword Succeeds    60s    2s
    ...    Arquivo Tem Conteúdo    ${caminho_completo}

    # Salva o nome do arquivo
    Set Test Variable    ${arquivo_baixado}    ${arquivo_completo}

    Log    ✅ Download concluído: ${arquivo_completo}

    RETURN    ${arquivo_completo}

Buscar Arquivo Por Nome Parcial
    [Documentation]    Retorna o nome completo do arquivo que contém o nome parcial
    [Arguments]    ${diretorio}    ${nome_parcial}

    ${arquivos}    List Files In Directory    ${diretorio}

    FOR    ${arquivo}    IN    @{arquivos}
        ${contem}    Run Keyword And Return Status
        ...    Should Contain    ${arquivo}    ${nome_parcial}
        IF    ${contem}    RETURN    ${arquivo}
    END

    Fail    Arquivo contendo "${nome_parcial}" não encontrado

Arquivo Específico Existe
    [Documentation]    Verifica se existe arquivo contendo o nome especificado
    [Arguments]    ${diretorio}    ${nome_parcial}

    ${arquivos}    List Files In Directory    ${diretorio}

    ${encontrado}    Set Variable    ${False}
    FOR    ${arquivo}    IN    @{arquivos}
        ${contem}    Run Keyword And Return Status
        ...    Should Contain    ${arquivo}    ${nome_parcial}
        IF    ${contem}
            ${encontrado}    Set Variable    ${True}
            BREAK
        END
    END

    Should Be True    ${encontrado}
    ...    msg=Arquivo contendo "${nome_parcial}" não encontrado em ${diretorio}

Arquivo Tem Conteúdo
    [Documentation]    Verifica se o arquivo tem tamanho maior que zero
    [Arguments]    ${caminho_arquivo}

    File Should Exist    ${caminho_arquivo}
    ${tamanho}    Get File Size    ${caminho_arquivo}
    Should Be True    ${tamanho} > 0
    ...    msg=Arquivo ainda está vazio (0 bytes): ${caminho_arquivo}

Criar Laudos Para Testes
    [Documentation]    Cria os 3 laudos necessários antes de executar os testes

    # Abre o navegador uma vez para criar os laudos
    Abrir Navegador E Acessar Sistema

    # Cria Laudo Completo
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    Set Suite Variable    ${LAUDO_COMPLETO}    ${novo_id_gerado}
    Set Suite Variable    ${NUMEROPROPOSTA_TESTE_COMPLETO}    ${numeroProposta_teste}
    Set Suite Variable    ${TIPOCLIENTE_TESTE_COMPLETO}    ${tipoCliente_teste}
    Set Suite Variable    ${DOCUMENTOCLIENTE_TESTE_COMPLETO}    ${documentoCliente_teste}
    Set Suite Variable    ${NOMECLIENTE_TESTE_COMPLETO}    ${nomeCliente_teste}
    Set Suite Variable    ${NOMEVENDEDOR_TESTE_COMPLETO}    ${nomeVendedor_teste}
    Set Suite Variable    ${CPFVENDEDOR_TESTE_COMPLETO}    ${cpfVendedor_teste}
    Set Suite Variable    ${CNPJLOJA_TESTE_COMPLETO}    ${cnpjLoja_teste}
    Set Suite Variable    ${QUILOMETRAGEM_TESTE_COMPLETO}    ${quilometragem_teste}
    Set Suite Variable    ${PLACA_TESTE_COMPLETO}    ${placa_teste}
    Set Suite Variable    ${RENAVAM_TESTE_COMPLETO}    ${renavam_teste}
    Set Suite Variable    ${UFPLACA_TESTE_COMPLETO}    ${ufPlaca_teste}
    Set Suite Variable    ${CIDADE_TESTE_COMPLETO}    ${cidade_teste}
    Set Suite Variable    ${FILIAL_TESTE_COMPLETO}    ${filial_teste}
    Set Suite Variable    ${ITEM_SEGURANCA_BUZINA_TESTE_COMPLETO}    Buzina
    Set Suite Variable    ${ITEM_SEGURANCA_COMPRESSOR_TESTE_COMPLETO}    Compressor
    Log To Console    ✓ Laudo completo criado: ${LAUDO_COMPLETO}

    # Cria Laudo Sem Imagens
    Dado que tenha um laudo criado sem imagens
    Set Suite Variable    ${LAUDO_SEM_IMAGENS}    ${novo_id_gerado}
    Log To Console    ✓ Laudo sem imagens criado: ${LAUDO_SEM_IMAGENS}

    # Cria Laudo Básico
    Dado que tenha um laudo básico criado sem itens de segurança e imagens
    Set Suite Variable    ${LAUDO_BASICO}    ${novo_id_gerado}
    Log To Console    ✓ Laudo básico criado: ${LAUDO_BASICO}

    # Cria Laudo Parcial (retorno parcial da base estadual)
    Dado que tenha um laudo criado com todos os campos e a placa desejada para reemissão
    ...    ${forms_solicitacao.placa_laudo_parcial}
    Set Suite Variable    ${LAUDO_PARCIAL}    ${novo_id_gerado}
    Log To Console    ✓ Laudo Parcial criado: ${LAUDO_PARCIAL}

    # Fecha o navegador após criar os laudos
    Close Browser

Criar Laudos Completo Para Testes
    [Documentation]    Cria laudo necessário antes de executar os testes

    # Abre o navegador uma vez para criar os laudos
    Abrir Navegador E Acessar Sistema

    # Cria Laudo Completo
    Dado que tenha um laudo criado com todos os campos e a placa desejada
    Set Suite Variable    ${LAUDO_COMPLETO}    ${novo_id_gerado}
    Set Suite Variable    ${NUMEROPROPOSTA_TESTE_COMPLETO}    ${numeroProposta_teste}
    Set Suite Variable    ${TIPOCLIENTE_TESTE_COMPLETO}    ${tipoCliente_teste}
    Set Suite Variable    ${DOCUMENTOCLIENTE_TESTE_COMPLETO}    ${documentoCliente_teste}
    Set Suite Variable    ${NOMECLIENTE_TESTE_COMPLETO}    ${nomeCliente_teste}
    Set Suite Variable    ${NOMEVENDEDOR_TESTE_COMPLETO}    ${nomeVendedor_teste}
    Set Suite Variable    ${CPFVENDEDOR_TESTE_COMPLETO}    ${cpfVendedor_teste}
    Set Suite Variable    ${CNPJLOJA_TESTE_COMPLETO}    ${cnpjLoja_teste}
    Set Suite Variable    ${QUILOMETRAGEM_TESTE_COMPLETO}    ${quilometragem_teste}
    Set Suite Variable    ${PLACA_TESTE_COMPLETO}    ${placa_teste}
    Set Suite Variable    ${RENAVAM_TESTE_COMPLETO}    ${renavam_teste}
    Set Suite Variable    ${UFPLACA_TESTE_COMPLETO}    ${ufPlaca_teste}
    Set Suite Variable    ${CIDADE_TESTE_COMPLETO}    ${cidade_teste}
    Set Suite Variable    ${FILIAL_TESTE_COMPLETO}    ${filial_teste}
    Set Suite Variable    ${ITEM_SEGURANCA_BUZINA_TESTE_COMPLETO}    Buzina
    Set Suite Variable    ${ITEM_SEGURANCA_COMPRESSOR_TESTE_COMPLETO}    Compressor
    Log To Console    ✓ Laudo completo criado: ${LAUDO_COMPLETO}

    # Fecha o navegador após criar os laudos
    Close Browser
