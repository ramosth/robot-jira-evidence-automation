import random
from robot.api.deco import keyword


class CPFGenerator:
    """Biblioteca para gerar CPFs válidos para uso em testes automatizados"""

    @keyword("Gerar CPF Válido")
    def gerar_cpf_valido(self, formatado=True):
        """
        Gera um CPF válido fake para uso em testes.
        
        Args:
            formatado (bool): Se True, retorna CPF formatado (xxx.xxx.xxx-xx)
                             Se False, retorna apenas os números
        
        Returns:
            str: CPF válido gerado
            
        Examples:
            | ${cpf_formatado} | Gerar CPF Válido |
            | ${cpf_numeros}   | Gerar CPF Válido | ${False} |
        """
        # Gera os primeiros 9 dígitos aleatoriamente
        cpf_base = [random.randint(0, 9) for _ in range(9)]
        
        # Calcula o primeiro dígito verificador
        soma = sum(cpf_base[i] * (10 - i) for i in range(9))
        primeiro_digito = 11 - (soma % 11)
        if primeiro_digito >= 10:
            primeiro_digito = 0
        
        cpf_base.append(primeiro_digito)
        
        # Calcula o segundo dígito verificador
        soma = sum(cpf_base[i] * (11 - i) for i in range(10))
        segundo_digito = 11 - (soma % 11)
        if segundo_digito >= 10:
            segundo_digito = 0
        
        cpf_base.append(segundo_digito)
        
        # Converte para string
        cpf_numerico = ''.join(map(str, cpf_base))
        
        # Retorna formatado ou não
        if formatado:
            return f"{cpf_numerico[:3]}.{cpf_numerico[3:6]}.{cpf_numerico[6:9]}-{cpf_numerico[9:]}"
        else:
            return cpf_numerico

    @keyword("Gerar Lista de CPFs Válidos")
    def gerar_lista_cpfs_validos(self, quantidade=1, formatado=True):
        """
        Gera uma lista de CPFs válidos fake para uso em testes.
        
        Args:
            quantidade (int): Quantidade de CPFs para gerar
            formatado (bool): Se True, retorna CPFs formatados
        
        Returns:
            list: Lista de CPFs válidos gerados
            
        Examples:
            | @{cpfs} | Gerar Lista de CPFs Válidos | 5 |
            | @{cpfs} | Gerar Lista de CPFs Válidos | 3 | ${False} |
        """
        return [self.gerar_cpf_valido(formatado) for _ in range(int(quantidade))]

    @keyword("Validar CPF")
    def validar_cpf(self, cpf):
        """
        Valida se um CPF é válido (apenas para verificação).
        
        Args:
            cpf (str): CPF para validar
        
        Returns:
            bool: True se CPF for válido, False caso contrário
            
        Examples:
            | ${valido} | Validar CPF | 123.456.789-09 |
        """
        # Remove formatação
        cpf_numeros = ''.join(filter(str.isdigit, str(cpf)))
        
        # Verifica se tem 11 dígitos
        if len(cpf_numeros) != 11:
            return False
            
        # Verifica se não são todos números iguais
        if cpf_numeros == cpf_numeros[0] * 11:
            return False
        
        # Converte para lista de inteiros
        cpf_list = [int(d) for d in cpf_numeros]
        
        # Calcula primeiro dígito verificador
        soma = sum(cpf_list[i] * (10 - i) for i in range(9))
        primeiro_digito = 11 - (soma % 11)
        if primeiro_digito >= 10:
            primeiro_digito = 0
            
        # Calcula segundo dígito verificador
        soma = sum(cpf_list[i] * (11 - i) for i in range(10))
        segundo_digito = 11 - (soma % 11)
        if segundo_digito >= 10:
            segundo_digito = 0
        
        # Verifica se os dígitos calculados conferem
        return cpf_list[9] == primeiro_digito and cpf_list[10] == segundo_digito