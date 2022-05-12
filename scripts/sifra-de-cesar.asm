.data
	selecao: .asciiz "Digite 1 para criptograr e 2 para descriptografar: "
	fator: .asciiz "Informe o fator da Sifra: "
	pulaLinha: .asciiz "\n"	
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
	DESCRIPTOGRAFAR:
		# descriptografa uma mensagem
		jal SIFRA
		
		# valor fornecido está em $t0
		move $t1, $v0
		mul $t1, $t1, -1	# como a sifra será descriptografa, é necessário tornar a sifra negativa

		# está aqui só para checagem
		li $v0, 1
		move $a0, $t1
		syscall
		
		j FIM
	CRIPTOGRAFAR:
		# criptografa uma mensagem
		jal SIFRA
		
		# valor fornecido está em $t0
		move $t1, $v0

		# está aqui só para checagem
		li $v0, 1
		move $a0, $t1
		syscall
		
		j FIM
	FIM:
		li $v0, 10
		syscall
		
	
