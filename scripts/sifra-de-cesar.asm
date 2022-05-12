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
		
	DESCRIPTOGRAFAR:
		
	CRIPTOGRAFAR:
		jal SIFRA
	
