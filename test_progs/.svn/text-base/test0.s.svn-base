/*
	TEST PROGRAM #1: copy memory contents of 16 elements starting at
			 address 0x1000 over to starting address 0x1100. 
	

	long output[16];

	void
	main(void)
	{
	  long i;
	  *a = 0x1000;
          *b = 0x1100;
	 
	  for (i=0; i < 16; i++)
	    {
	      a[i] = i*10; 
	      b[i] = a[i]; 
	    }
	}
*/
<<<<<<< .mine
=======
		data = 0x1000
		data1 = 0x20
		lda	$r5,0x2
bob:	lda	$r1,data
		lda	$r3, 0x1
		lda	$r2,data1
        subq $r5,$r3,$r5
        bne $r5,bob
done:	call_pal        0x555
>>>>>>> .r148

	data = 0x1000		/*  */
	data1 = 0x20		/*  */
	lda	$r5,0x0         /* 0 */
	lda	$r1,data         /* 4 */
	lda	$r3, 0x1         /* 8 */
	lda	$r2,data1         /* 12 */
	addq	$r5, $r1, $r5    /* [16] 0x1000 + 0x0 = 0x1000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	addq	$r5, $r1, $r5    /* [20] 0x1000 + 0x1000 = 0x2000 */
	/* bne     $r3, done	  [24] */
	mulq	$r3, $r2, $r7	 /* [28] */
	mulq	$r3, $r7, $r7	 /* [32] */
done:	call_pal        0x555	 /* [36] */

