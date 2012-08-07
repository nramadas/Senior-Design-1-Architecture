/*
	TEST PROGRAM #1: Test LSQ 
*/	

	data1 = 0x1000
	data2 = 0x200
	lda	$r5,0x0
	lda	$r1,data1
	lda	$r3, 0x1
	lda	$r2,data2
	addq	$r5, $r1, $r5   /* [16] 0x1000 + 0x0 = 0x1000 */
	addq	$r5, $r1, $r5   /* [20] 0x1000 + 0x1000 = 0x2000 */
	stq	$r5, 0x50($r2)	/* MEM[0x250] = 0x2000 */
	ldq	$r4, 0x50($r2)	/* r4 = 0x2000 = MEM[0x250] */
    addq	$r5, $r4, $r5	/* r5 = 0x4000 */
	stq	$r5, 0x50($r2)	/* MEM[0x260] = 0x4000 */
	ldq $r4, 0x50($r2)
	addq	$r4, $r1, $r4
	stq $r4, 0x60($r2)
done:	call_pal        0x555	 /* [36] */

