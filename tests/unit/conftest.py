"""Torna a pasta libraries/integracao_jira importável nos testes."""

import os
import sys

RAIZ = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, os.path.join(RAIZ, "libraries", "integracao_jira"))
