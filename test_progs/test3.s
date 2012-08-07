		lda $r1,2
		lda $r2,15
start:	addq $r2, $r2, $r2
		bsr $r26, loopy
		call_pal 0x555
loopy:	addq $r2, $r2, $r2
        subq $r1, $r1, $r1
        bne $r1, loopy
        ret
