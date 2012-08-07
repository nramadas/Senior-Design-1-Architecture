		br stupid
		call_pal 0x555
stupid:	lda $r1, 20
		br cool
		call_pal 0x555
gross:	call_pal 0x555
cool:	lda $r2, 10
		br gross
