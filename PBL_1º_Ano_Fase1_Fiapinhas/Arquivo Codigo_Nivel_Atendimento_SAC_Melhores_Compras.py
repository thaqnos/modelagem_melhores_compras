 def classificar_satisfacao(nota):
 if nota > 90:
        return "Atendimento de qualidade"
    elif 70 <= nota <= 89:
        return "Atendimento neutro"
    else:
        return "Atendimento insatisfatório"
 
# Entrada da nota de satisfação
nota_cliente = float(input("Informe a nota de satisfação (0 a 100): "))
 
# Chamada da função e impressão do resultado
resultado = classificar_satisfacao(nota_cliente)
print(resultado)

