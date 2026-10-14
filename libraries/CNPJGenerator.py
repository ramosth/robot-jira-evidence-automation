import random
from robot.api.deco import keyword


class CNPJGenerator:
    """Biblioteca para gerar CNPJs válidos para uso em testes automatizados"""

    @keyword("Gerar CNPJ Válido")
    def gerar_cnpj_valido(self, formatado=True):
        """
        Gera um CNPJ válido fake para uso em testes.
        
        Args:
            formatado (bool): Se True, retorna CNPJ formatado (xx.xxx.xxx/xxxx-xx)
                             Se False, retorna apenas os números
        
        Returns:
            str: CNPJ válido gerado
            
        Examples:
            | ${cnpj_formatado} | Gerar CNPJ Válido |
            | ${cnpj_numeros}   | Gerar CNPJ Válido | ${False} |
        """
        # Gera os primeiros 12 dígitos aleatoriamente
        cnpj_base = [random.randint(0, 9) for _ in range(12)]
        
        # Calcula o primeiro dígito verificador
        pesos_1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_base[i] * pesos_1[i] for i in range(12))
        primeiro_digito = 11 - (soma % 11)
        if primeiro_digito >= 10:
            primeiro_digito = 0
        
        cnpj_base.append(primeiro_digito)
        
        # Calcula o segundo dígito verificador
        pesos_2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_base[i] * pesos_2[i] for i in range(13))
        segundo_digito = 11 - (soma % 11)
        if segundo_digito >= 10:
            segundo_digito = 0
        
        cnpj_base.append(segundo_digito)
        
        # Converte para string
        cnpj_numerico = ''.join(map(str, cnpj_base))
        
        # Retorna formatado ou não
        if formatado:
            return f"{cnpj_numerico[:2]}.{cnpj_numerico[2:5]}.{cnpj_numerico[5:8]}/{cnpj_numerico[8:12]}-{cnpj_numerico[12:]}"
        else:
            return cnpj_numerico

    @keyword("Gerar Lista de CNPJs Válidos")
    def gerar_lista_cnpjs_validos(self, quantidade=1, formatado=True):
        """
        Gera uma lista de CNPJs válidos fake para uso em testes.
        
        Args:
            quantidade (int): Quantidade de CNPJs para gerar
            formatado (bool): Se True, retorna CNPJs formatados
        
        Returns:
            list: Lista de CNPJs válidos gerados
            
        Examples:
            | @{cnpjs} | Gerar Lista de CNPJs Válidos | 5 |
            | @{cnpjs} | Gerar Lista de CNPJs Válidos | 3 | ${False} |
        """
        return [self.gerar_cnpj_valido(formatado) for _ in range(int(quantidade))]

    @keyword("Validar CNPJ")
    def validar_cnpj(self, cnpj):
        """
        Valida se um CNPJ é válido (apenas para verificação).
        
        Args:
            cnpj (str): CNPJ para validar
        
        Returns:
            bool: True se CNPJ for válido, False caso contrário
            
        Examples:
            | ${valido} | Validar CNPJ | 12.345.678/0001-90 |
        """
        # Remove formatação
        cnpj_numeros = ''.join(filter(str.isdigit, str(cnpj)))
        
        # Verifica se tem 14 dígitos
        if len(cnpj_numeros) != 14:
            return False
            
        # Verifica se não são todos números iguais
        if cnpj_numeros == cnpj_numeros[0] * 14:
            return False
        
        # Converte para lista de inteiros
        cnpj_list = [int(d) for d in cnpj_numeros]
        
        # Calcula primeiro dígito verificador
        pesos_1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_list[i] * pesos_1[i] for i in range(12))
        primeiro_digito = 11 - (soma % 11)
        if primeiro_digito >= 10:
            primeiro_digito = 0
            
        # Calcula segundo dígito verificador
        pesos_2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_list[i] * pesos_2[i] for i in range(13))
        segundo_digito = 11 - (soma % 11)
        if segundo_digito >= 10:
            segundo_digito = 0
        
        # Verifica se os dígitos calculados conferem
        return cnpj_list[12] == primeiro_digito and cnpj_list[13] == segundo_digito

    @keyword("Gerar CNPJ Com Filial")
    def gerar_cnpj_com_filial(self, numero_filial="0001", formatado=True):
        """
        Gera um CNPJ válido com número específico de filial.
        
        Args:
            numero_filial (str): Número da filial (4 dígitos) - padrão: "0001"
            formatado (bool): Se True, retorna CNPJ formatado
        
        Returns:
            str: CNPJ válido gerado com filial específica
            
        Examples:
            | ${cnpj_matriz}  | Gerar CNPJ Com Filial |
            | ${cnpj_filial1} | Gerar CNPJ Com Filial | 0002 |
            | ${cnpj_filial2} | Gerar CNPJ Com Filial | 0003 | ${False} |
        """
        # Validação do número da filial
        numero_filial = str(numero_filial).zfill(4)
        if len(numero_filial) != 4 or not numero_filial.isdigit():
            raise ValueError("Número da filial deve ter 4 dígitos")
        
        # Gera os primeiros 8 dígitos aleatoriamente (base da empresa)
        cnpj_base = [random.randint(0, 9) for _ in range(8)]
        
        # Adiciona o número da filial
        cnpj_base.extend([int(d) for d in numero_filial])
        
        # Calcula o primeiro dígito verificador
        pesos_1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_base[i] * pesos_1[i] for i in range(12))
        primeiro_digito = 11 - (soma % 11)
        if primeiro_digito >= 10:
            primeiro_digito = 0
        
        cnpj_base.append(primeiro_digito)
        
        # Calcula o segundo dígito verificador
        pesos_2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        soma = sum(cnpj_base[i] * pesos_2[i] for i in range(13))
        segundo_digito = 11 - (soma % 11)
        if segundo_digito >= 10:
            segundo_digito = 0
        
        cnpj_base.append(segundo_digito)
        
        # Converte para string
        cnpj_numerico = ''.join(map(str, cnpj_base))
        
        # Retorna formatado ou não
        if formatado:
            return f"{cnpj_numerico[:2]}.{cnpj_numerico[2:5]}.{cnpj_numerico[5:8]}/{cnpj_numerico[8:12]}-{cnpj_numerico[12:]}"
        else:
            return cnpj_numerico