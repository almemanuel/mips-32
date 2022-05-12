# código em C
# int exemplo ( int g, int h, int i, int j) {
#    int f;
#    f = ( g + h ) - ( i + j );
#    return f;
# }

# $a0 = g
# $a1 = h
# $a2 = i
# $a3 = j
# $s0 = f

.text
	# $aX são registradores de argumentos para a função
	li $a0, 15 		# g = $a0 = 15
	li $a1, 20		# h = $a1 = 20
	li $a2, 10		# i = $a2 = 10
	li $a3, 5		# j = $a3 = 5

	exemplo:
		addi $sp, $sp, -12	# ajusta a pilha
		sw $t1, 8($sp)		# salva $t1
		sw $t0, 4($sp)		# salva $t2
		sw $s0, 0($sp)		# salva $t3
		
		add $t0, $a0, $a1	# (g + h) = 15 + 20 = 35
		add $t1, $a2, $a3	# (i + j) = 10 + 5 = 15
		sub $s0, $t0, $t1	# (g + h) - (i + j) = 35 - 15 = 5
		
		# $vX equivale ao return
		add $v0, $s0, $zero	# f($v0 = $s0 + 0)
		
		# volta tudo ao estado original
		lw $s0, 0($sp)
		lw $t0, 4($sp)
		lw $t1, 8($sp)
		addi, $sp, $sp, 12
		
		jr $ra