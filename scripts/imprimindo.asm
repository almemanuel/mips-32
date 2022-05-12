.data
	pergunta: .asciiz "Nome: "
	saudacao: .asciiz "Olá, "
	nome: .space 25
.text
	# impressao da pergunta
	li $v0, 4
	la $a0, pergunta
	syscall
	
	# leitura do nome
	li $v0, 8
	la $a0, nome
	la $a1, 2