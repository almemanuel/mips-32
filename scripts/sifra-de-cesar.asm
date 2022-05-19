# reorganizar
# $tX para valores numericos em testes, etc, que serão alterados com frequencia
# $Sx para as strings e valores que tendem a ser mais estáticos durante a execução

.data
	selecao: .asciiz "Digite 1 para criptograr e 2 para descriptografar: "
	fator: .asciiz "Informe o fator da Sifra: "
	mensagem: .asciiz "OBSERVAÇÃO: NÃO SERÃO CONSIDERADOS CARACTERES ESPECIAIS\nInforme a mensagem: "
	pulaLinha: .asciiz "\n"	
	
	texto: .space 1000
.text
	OPCAO:
		# enquanto $t0 for diferente de 1 ou 2, executar este bloco de código
		# usuário seleciona a opção que deseja

		# INICIO OPCAO
		# imprime uma string
		li $v0, 4
		la $a0, selecao
		syscall
	
		# leitura do inteiro
		li $v0, 5
		syscall
	
		# valor fornecido está em $t0
		move $t0, $v0

		# enquanto $t0 for diferente de 1 ou 2, continua executando OPCAO
		beq $t0, 1, CRIPTOGRAFAR
		beq $t0, 2, DESCRIPTOGRAFAR
		j OPCAO
		
		# FIM OPCAO
	
	SIFRA:
		# lê o fator da cifra
		# como é uma função que não possui argumentos, não precisa ajustar a pilha

		# imprime uma string
		li $v0, 4
		la $a0, fator
		syscall
	
		# leitura do inteiro
		li $v0, 5
		syscall	
	
		jr $ra

	MENSAGEM:
		# programa recebe a mensagem do usuário e salva na memória
		# função sem argumentos, logo, sem ajuste de pilha
		
		# solicita ao usuário que informe a mensagem
		li $v0, 4
		la $a0, mensagem
		syscall
	
		# salva a inserção em texto
		li $v0, 8
		la $a0, texto
		la $a1, 1000
		syscall
	
		jr $ra

	DESCRIPTOGRAFAR:
		# descriptografa uma mensagem
		jal SIFRA
		
		# valor fornecido está em $t0
		move $t1, $v0
		mul $t1, $t1, -1	# como a sifra será descriptografa, é necessário tornar a sifra negativa

		jal MENSAGEM

		# salva o endereço de memoria do texto em $t2
		la $t2, texto
		
		# inicializa o registrador para navegar byte a byte na string
		add $t3, $zero, $zero
		
		j MANIPULANDO

	CRIPTOGRAFAR:
		# criptografa uma mensagem
		jal SIFRA
		
		# valor fornecido está em $t0
		move $t1, $v0
		
		jal MENSAGEM
		
		# salva o endereço de memoria do texto em $t2
		la $t2, texto
		
		# inicializa o registrador para navegar byte a byte na string
		add $t3, $zero, $zero
	MANIPULANDO:
		# combinando os dois componentes do endereço
		add $t4, $t3, $t2
	
		# leitura byte a byte
		lb $t5, 0($t4)
		
		# testa se continua ou não no laço MANIPULANDO
		beqz $t5, IMPRESSAO
		
		# verifica se é numerico
		addi $s0, $zero, 47
		slti $t6, $t5, 58
		slt $t7, $s0, $t5
		beq $t6, $t7, ALTERANUMERICO
		
		# verifica se é maiusculo
		addi $s0, $zero, 64
		slti $t6, $t5, 91
		slt $t7, $s0, $t5
		beq $t6, $t7, ALTERAMAIUSCULO
		
		# verifica se é minusculo
		addi $s0, $zero, 96
		slti $t6, $t5, 123
		slt $t7, $s0, $t5
		beq $t6, $t7, ALTERAMINUSCULO
		j INCREMENTA
		
	# se continuar, altera o caractere de acordo com a chave e escreve-o
		add $t6, $t5, $t1

		# testes para verificar se o resultado corresponde a um alfanumerico ASCII
		# fator positivo
		# quando atinge caractere + fator = valor da ultima letra deve fazer resultado - 26
		# fator negativo
		# quando atinge caractere + fator = valor da primeira letra deve fazer resultado + 26
		# mesma logica aplicada para os numeros, mas com um conjunto de 10 valores
		
		# solução: separar em 3 ALTERA diferente para cada um dos casos e todos avançavarem para ESCREVER
		# 1. realiza a operação fora dos blocos mesmo
		# 2. se o resultado estiver fora da faixa:
		# a. se for menor que o minimo, faz a soma do total de elementos do conjunto
		# b. subtrai esse mesmo valor, caso contrário
	ALTERAMAIUSCULO:
		j ESCREVER
	ALTERAMINUSCULO:
		j ESCREVER
	ALTERONUMERO:
		j ESCREVER
	ESCREVER:
		sb $t6, 0($t4)
		
	# incrementa o controlador em 1 e volta ao inicio de MANIPULANDO
	INCREMENTA:
		add $t3, $t3, 1
		j MANIPULANDO

	IMPRESSAO:
		li $v0, 4
		la $a0, texto
		syscall
		
		j FIM
	FIM:
		li $v0, 10
		syscall
		
	
