# reorganizar
# $tX para valores numericos em testes, etc, que serão alterados com frequencia
# $Sx para as strings e valores que tendem a ser mais estáticos durante a execução
# rever também as passagens dos rotulos e os comentários, visando esclarecer
# inserir ao inicio a função de cada registrador

.data
	selecao: .asciiz "Digite 1 para criptograr e 2 para descriptografar: "
	fator: .asciiz "\nInforme o fator da Cifra: "
	mensagem: .asciiz "\nOBSERVAÇÃO: NÃO SERÃO CONSIDERADOS CARACTERES ESPECIAIS\nTAMANHO MAXIMO DA MENSAGEM: 1000 caracteres\nInforme a mensagem: "
	pulaLinha: .asciiz "\n"	
	
	texto: .space 1000


.text
	OPCAO:
		# enquanto $t0 for diferente de 1 ou 2, executar este bloco de código
		# usuário seleciona a opção que deseja
		
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

				
	CIFRA:
		# lê o fator da cifra
		
		li $v0, 4
		la $a0, fator
		syscall
	
		li $v0, 5
		syscall	
	
		jr $ra


	MENSAGEM:
		# programa recebe a mensagem do usuário e salva na memória
		
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
		jal CIFRA
		
		# valor fornecido está em $t0
		move $s0, $v0
		
		# como a sifra será descriptografa, é necessário tornar a sifra negativa
		mul $s0, $s0, -1

		jal MENSAGEM

		# salva o endereço de memoria do texto em $s1
		la $s1, texto
		
		j MANIPULANDO

	CRIPTOGRAFAR:
		# criptografa uma mensagem
		jal CIFRA
		
		# valor fornecido está em $s0
		move $s0, $v0
		
		jal MENSAGEM
		
		# salva o endereço de memoria do texto em $s1
		la $s1, texto

				
	MANIPULANDO:
		# inicializa o registrador para navegar byte a byte na string
		add $t0, $zero, $zero

				
	LACO:
		# combinando os dois componentes do endereço
		add $t1, $t0, $s1
	
		# leitura byte a byte
		lb $t2, 0($t1)
		
		# se apontar para o fim da string, ir para IMPRESSAO
		beqz $t2, IMPRESSAO
		
		# TESTES PARA VERIFICAR SE É UM CARCTERE VALIDO PARA CIFRAR
		# $t7 = total de caracteres que são numéricos, maisculos ou minusculos
		# $t8 = código ASCII do menor caractere correspondente a um numero, maiusculo ou minusculo
		# $t9 = código ASCII do maior
		
		# verifica se $t2 é um numero
		# valores de referência para códigos ASCII de numeros
		addi $t7, $zero, 10
		addi $t8, $zero, 48
		addi $t9, $zero, 57
		
		# atribui os valores de referência aos registradores de argumento
		add $a1, $zero, $t2
		add $a2, $zero, $t8
		add $a3, $zero, $t9
		
		# verifica se os valores são válidos para um código ASCII correspondente a este tipo de caractere
		jal TESTE
		# resultado de TESTE
		move $t6, $v0
		# caso tenha dado tudo certo, prossegue para a próxima etapa
		beq $t6, $zero, ESCREVE
		
		# verifica se $t2 é maiusculo
		# esse valor de $t7 será mantido no próximo teste, pois correspondente ao total de letras do alfabeto
		addi $t7, $zero, 26
		addi $t8, $zero, 65
		addi $t9, $zero, 90

		add $a1, $zero, $t2
		add $a2, $zero, $t8
		add $a3, $zero, $t9
		jal TESTE
		
		move $t6, $v0
		beq $t6, $zero, ESCREVE
		
		# verifica se $t2 é minusculo
		addi $t8, $zero, 97
		addi $t9, $zero, 122
		
		add $a1, $zero, $t2
		add $a2, $zero, $t8
		add $a3, $zero, $t9
		jal TESTE
		
		move $t6, $v0
		beq $t6, $zero, ESCREVE
		
		# caso o caractere não seja alfanumérico, ele avança para o fim do laço (etiqueta INCREMENTA)
		j INCREMENTA
		
		
		TESTE:
			# verifica se $a2 <= $a1 <= $a3 para que esse caractere seja válido para manipulação
			# $a1 -> código ASCII do caractere para verificar
			# $a2 -> código ASCII minimo
			# $a3 -> código ASCII maximo
		
			# para verificar o código trabalhando com o conjunto dos inteiros
			# é necessário considerar o intervalo ($a2, $a3)
			subi $a2, $a2, 1
			addi $a3, $a3, 1

			slt $t4, $a2, $a1 # $t4 = 0 -> $a2 < $a1
			slt $t5, $a1, $a3 # $t5 = 0 -> $a3 > $a1
		
			# ($a2 < $a1 < $a2) -> ($t4 = $t5 <=> 0 = $t4 - $t5)
			sub $v0, $t4, $t5
		
			jr $ra
		
		ESCREVE:
			# realiza as manipulações necessárias
		
			# encripta/decifra $t3	
			add $t3, $t2, $s0
		
			add $a1, $t3, $zero
			add $a2, $zero, $t8
			add $a3, $zero, $t9		
			jal TESTE
		
			move $t6, $v0
		
			beq $t6, $zero, CARACTERECOMFATOR
		
			# caso o caractere cifrado não seja alfanumérico, realiza um aumento ou uma redução
			# no código ASCII
			beq $t5, $zero, REDUZ		
			AUMENTA:
				# se o código ASCII for menor que o desejado, realiza um aumento
				add $t3, $t3, $t7

				j CARACTERECOMFATOR
			REDUZ:
				# se o código ASCII for maior que o desejado, realiza uma redução
				sub $t3, $t3, $t7
		CARACTERECOMFATOR:
			sb $t3, 0($t1)
		
		INCREMENTA:
			# incrementa o controlador em 1 e volta ao inicio de MANIPULANDO
			add $t0, $t0, 1

			j LACO


	IMPRESSAO:
		li $v0, 4
		la $a0, texto
		syscall
		
		j FIM
	FIM:
		li $v0, 10
		syscall
		
	
