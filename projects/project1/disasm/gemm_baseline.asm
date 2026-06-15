000000000001092c <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i>:
   1092c:	06d05663          	blez	a3,10998 <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x6c>
   10930:	00053e83          	ld	t4,0(a0)
   10934:	1141                	addi	sp,sp,-16
   10936:	e422                	sd	s0,8(sp)
   10938:	00269513          	slli	a0,a3,0x2
   1093c:	6180                	ld	s0,0(a1)
   1093e:	00063f83          	ld	t6,0(a2)
   10942:	01d503b3          	add	t2,a0,t4
   10946:	8f36                	mv	t5,a3
   10948:	881e                	mv	a6,t2
   1094a:	4281                	li	t0,0
   1094c:	8322                	mv	t1,s0
   1094e:	88fe                	mv	a7,t6
   10950:	4e01                	li	t3,0
   10952:	869a                	mv	a3,t1
   10954:	8776                	mv	a4,t4
   10956:	4601                	li	a2,0
   10958:	430c                	lw	a1,0(a4)
   1095a:	429c                	lw	a5,0(a3)
   1095c:	0711                	addi	a4,a4,4
   1095e:	96aa                	add	a3,a3,a0
   10960:	02b787bb          	mulw	a5,a5,a1
   10964:	9e3d                	addw	a2,a2,a5
   10966:	ff0719e3          	bne	a4,a6,10958 <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x2c>
   1096a:	00c8a023          	sw	a2,0(a7)
   1096e:	001e079b          	addiw	a5,t3,1
   10972:	0891                	addi	a7,a7,4
   10974:	0311                	addi	t1,t1,4
   10976:	00ff0463          	beq	t5,a5,1097e <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x52>
   1097a:	8e3e                	mv	t3,a5
   1097c:	bfd9                	j	10952 <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x26>
   1097e:	0012879b          	addiw	a5,t0,1
   10982:	8e9e                	mv	t4,t2
   10984:	982a                	add	a6,a6,a0
   10986:	9faa                	add	t6,t6,a0
   10988:	01c28563          	beq	t0,t3,10992 <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x66>
   1098c:	82be                	mv	t0,a5
   1098e:	93aa                	add	t2,t2,a0
   10990:	bf75                	j	1094c <_Z13gemm_baselineRKSt6vectorIiSaIiEES3_RS1_i+0x20>
   10992:	6422                	ld	s0,8(sp)
   10994:	0141                	addi	sp,sp,16
   10996:	8082                	ret
   10998:	8082                	ret
