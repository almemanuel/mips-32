.data
	pergunta: .asciiz "Idade: "
	resposta: .asciiz "Sua idade é "
.text
	# imprime uma string
	li $v0, 4
	la $a0, pergunta
	syscall
	
	# leitura do inteiro
	li $v0, 5
	syscall
	
	# valor fornecido está em $t0
	move $t0, $v0

	li $v0, 4
	la $a0, resposta
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
