import random
from robot.api.deco import keyword


class CNPJAlfanumericoGenerator:
    """Biblioteca para gerar CNPJs alfanuméricos válidos para uso em testes automatizados (formato 2026)"""
    
    # Letras permitidas (excluindo I, O, U, Q e F para evitar confusão)
    LETRAS_PERMITIDAS = [c for c in 'ABCDEGHIJKLMNPRSTUVWXYZ' if c not in ['I', 'O', 'U', 'Q', 'F']]
    NUMEROS = '0123456789'
    CARACTERES_ALFANUM = LETRAS_PERMITIDAS + list(NUMEROS)
    
    def _gerar_caractere_alfanumerico(self):
        """Gera um caractere alfanumérico aleatório (letra ou número)"""
        return random.choice(self.CARACTERES_ALFANUM)
    
    def _converter_para_valor_ascii(self, caractere):
        """
        Converte caractere para valor usado no cálculo do DV.
        Números: valor numérico (0-9)
        Letras: valor ASCII - 48 (A=17, B=18, C=19, etc.)
        """
        if caractere.isdigit():
            return int(caractere)
        else:
            return ord(caractere) - 48
    
    def _calcular_digito_verificador(self, cnpj_base, posicao):
        """
        Calcula um dígito verificador usando módulo 11.
        
        Args:
            cnpj_base (list): Lista com os caracteres do CNPJ
            posicao (int): 1 para primeiro DV, 2 para segundo DV
        """
        if posicao == 1:
            pesos = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
            tamanho = 12
        else:  # posicao == 2
            pesos = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
            tamanho = 13
        
        soma = 0
        for i in range(tamanho):
            valor = self._converter_para_valor_ascii(cnpj_base[i])
            soma += valor * pesos[i]
        
        resto = soma % 11
        digito = 11 - resto
        
        if digito >= 10:
            digito = 0
        
        return digito

    @keyword("Gerar CNPJ Alfanumérico Válido")
    def gerar_cnpj_alfanumerico_valido(self, formatado=True):
        """
        Gera um CNPJ alfanumérico válido fake para uso em testes (formato 2026).
        
        Args:
            formatado (bool): Se True, retorna CNPJ formatado (XX.XXX.XXX/XXXX-XX)
                             Se False, retorna apenas os caracteres
        
        Returns:
            str: CNPJ alfanumérico válido gerado
            
        Examples:
            | ${cnpj_formatado} | Gerar CNPJ Alfanumérico Válido |
            | ${cnpj_simples}   | Gerar CNPJ Alfanumérico Válido | ${False} |
        """
        # Gera os primeiros 8 caracteres alfanuméricos (raiz do CNPJ)
        cnpj_base = [self._gerar_caractere_alfanumerico() for _ in range(8)]
        
        # Gera os próximos 4 caracteres alfanuméricos (ordem do estabelecimento)
        cnpj_base.extend([self._gerar_caractere_alfanumerico() for _ in range(4)])
        
        # Calcula o primeiro dígito verificador
        primeiro_digito = self._calcular_digito_verificador(cnpj_base, 1)
        cnpj_base.append(str(primeiro_digito))
        
        # Calcula o segundo dígito verificador
        segundo_digito = self._calcular_digito_verificador(cnpj_base, 2)
        cnpj_base.append(str(segundo_digito))
        
        # Converte para string
        cnpj_completo = ''.join(cnpj_base)
        
        # Retorna formatado ou não
        if formatado:
            return f"{cnpj_completo[:2]}.{cnpj_completo[2:5]}.{cnpj_completo[5:8]}/{cnpj_completo[8:12]}-{cnpj_completo[12:]}"
        else:
            return cnpj_completo

    @keyword("Gerar Lista de CNPJs Alfanuméricos Válidos")
    def gerar_lista_cnpjs_alfanumericos_validos(self, quantidade=1, formatado=True):
        """
        Gera uma lista de CNPJs alfanuméricos válidos fake para uso em testes.
        
        Args:
            quantidade (int): Quantidade de CNPJs para gerar
            formatado (bool): Se True, retorna CNPJs formatados
        
        Returns:
            list: Lista de CNPJs alfanuméricos válidos gerados
            
        Examples:
            | @{cnpjs} | Gerar Lista de CNPJs Alfanuméricos Válidos | 5 |
            | @{cnpjs} | Gerar Lista de CNPJs Alfanuméricos Válidos | 3 | ${False} |
        """
        return [self.gerar_cnpj_alfanumerico_valido(formatado) for _ in range(int(quantidade))]

    @keyword("Validar CNPJ Alfanumérico")
    def validar_cnpj_alfanumerico(self, cnpj):
        """
        Valida se um CNPJ alfanumérico é válido.
        
        Args:
            cnpj (str): CNPJ alfanumérico para validar
        
        Returns:
            bool: True se CNPJ for válido, False caso contrário
            
        Examples:
            | ${valido} | Validar CNPJ Alfanumérico | AB.C12.D3E/4F5G-67 |
        """
        # Remove formatação (pontos, barra e traço)
        cnpj_limpo = cnpj.replace('.', '').replace('/', '').replace('-', '').upper()
        
        # Verifica se tem 14 caracteres
        if len(cnpj_limpo) != 14:
            return False
        
        # Verifica se os dois últimos caracteres são números
        if not cnpj_limpo[12:14].isdigit():
            return False
        
        # Verifica se os 12 primeiros caracteres são alfanuméricos válidos
        for i in range(12):
            char = cnpj_limpo[i]
            if char.isdigit():
                continue
            if char not in self.LETRAS_PERMITIDAS:
                return False
        
        # Separa base e dígitos verificadores
        cnpj_base = list(cnpj_limpo[:12])
        dv_informado = [int(cnpj_limpo[12]), int(cnpj_limpo[13])]
        
        # Calcula primeiro dígito verificador
        primeiro_digito = self._calcular_digito_verificador(cnpj_base, 1)
        
        # Calcula segundo dígito verificador
        cnpj_base.append(str(primeiro_digito))
        segundo_digito = self._calcular_digito_verificador(cnpj_base, 2)
        
        # Verifica se os dígitos calculados conferem
        return dv_informado[0] == primeiro_digito and dv_informado[1] == segundo_digito

    @keyword("Gerar CNPJ Alfanumérico Com Filial")
    def gerar_cnpj_alfanumerico_com_filial(self, numero_filial="0001", formatado=True):
        """
        Gera um CNPJ alfanumérico válido com número específico de filial (formato 2026).
        
        Args:
            numero_filial (str): Número da filial (4 caracteres alfanuméricos) - padrão: "0001"
            formatado (bool): Se True, retorna CNPJ formatado
        
        Returns:
            str: CNPJ alfanumérico válido gerado com filial específica
            
        Examples:
            | ${cnpj_matriz}  | Gerar CNPJ Alfanumérico Com Filial |
            | ${cnpj_filial1} | Gerar CNPJ Alfanumérico Com Filial | 0002 |
            | ${cnpj_filial2} | Gerar CNPJ Alfanumérico Com Filial | A001 | ${False} |
        """
        # Validação e preparação do número da filial
        numero_filial = str(numero_filial).upper().zfill(4)
        
        if len(numero_filial) != 4:
            raise ValueError("Número da filial deve ter 4 caracteres")
        
        # Verifica se os caracteres da filial são válidos
        for char in numero_filial:
            if not char.isdigit() and char not in self.LETRAS_PERMITIDAS:
                raise ValueError(f"Caractere '{char}' não é permitido no CNPJ alfanumérico")
        
        # Gera os primeiros 8 caracteres alfanuméricos (base da empresa)
        cnpj_base = [self._gerar_caractere_alfanumerico() for _ in range(8)]
        
        # Adiciona o número da filial
        cnpj_base.extend(list(numero_filial))
        
        # Calcula o primeiro dígito verificador
        primeiro_digito = self._calcular_digito_verificador(cnpj_base, 1)
        cnpj_base.append(str(primeiro_digito))
        
        # Calcula o segundo dígito verificador
        segundo_digito = self._calcular_digito_verificador(cnpj_base, 2)
        cnpj_base.append(str(segundo_digito))
        
        # Converte para string
        cnpj_completo = ''.join(cnpj_base)
        
        # Retorna formatado ou não
        if formatado:
            return f"{cnpj_completo[:2]}.{cnpj_completo[2:5]}.{cnpj_completo[5:8]}/{cnpj_completo[8:12]}-{cnpj_completo[12:]}"
        else:
            return cnpj_completo

    @keyword("Gerar CNPJ Alfanumérico Com Raiz")
    def gerar_cnpj_alfanumerico_com_raiz(self, raiz, formatado=True):
        """
        Gera um CNPJ alfanumérico válido com raiz específica (8 primeiros caracteres).
        Útil para gerar matriz e filiais da mesma empresa.
        
        Args:
            raiz (str): Raiz do CNPJ (8 caracteres alfanuméricos)
            formatado (bool): Se True, retorna CNPJ formatado
        
        Returns:
            str: CNPJ alfanumérico válido gerado com raiz específica
            
        Examples:
            | ${cnpj} | Gerar CNPJ Alfanumérico Com Raiz | A1B2C3D4 |
        """
        # Validação da raiz
        raiz = str(raiz).upper()
        
        if len(raiz) != 8:
            raise ValueError("Raiz deve ter 8 caracteres")
        
        # Verifica se os caracteres da raiz são válidos
        for char in raiz:
            if not char.isdigit() and char not in self.LETRAS_PERMITIDAS:
                raise ValueError(f"Caractere '{char}' não é permitido no CNPJ alfanumérico")
        
        # Usa a raiz fornecida
        cnpj_base = list(raiz)
        
        # Gera os próximos 4 caracteres alfanuméricos (ordem do estabelecimento)
        cnpj_base.extend([self._gerar_caractere_alfanumerico() for _ in range(4)])
        
        # Calcula o primeiro dígito verificador
        primeiro_digito = self._calcular_digito_verificador(cnpj_base, 1)
        cnpj_base.append(str(primeiro_digito))
        
        # Calcula o segundo dígito verificador
        segundo_digito = self._calcular_digito_verificador(cnpj_base, 2)
        cnpj_base.append(str(segundo_digito))
        
        # Converte para string
        cnpj_completo = ''.join(cnpj_base)
        
        # Retorna formatado ou não
        if formatado:
            return f"{cnpj_completo[:2]}.{cnpj_completo[2:5]}.{cnpj_completo[5:8]}/{cnpj_completo[8:12]}-{cnpj_completo[12:]}"
        else:
            return cnpj_completo