		lda $r0, 0x1
		lda $r1, 0x1
		lda $r2, 0x2
		lda $r3, 0x3
		lda $r4, 0x4
loop:	addq $r1, $r0, $r1
		addq $r2, $r0, $r2
		addq $r3, $r0, $r3
		addq $r4, $r0, $r4
		addq $r1, $r0, $r1
		addq $r2, $r0, $r2
		addq $r3, $r0, $r3
		addq $r4, $r0, $r4
		cmple $r1,0xff,$r5
		bne $r5, loop
		stq
		call_pal 0x555