00000000000109f6 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i>:
   109f6:	7155                	addi	sp,sp,-208
   109f8:	fd26                	sd	s1,184(sp)
   109fa:	0016849b          	addiw	s1,a3,1
   109fe:	98f9                	andi	s1,s1,-2
   10a00:	f94a                	sd	s2,176(sp)
   10a02:	0294893b          	mulw	s2,s1,s1
   10a06:	f4ee                	sd	s11,104(sp)
   10a08:	001f4d97          	auipc	s11,0x1f4
   10a0c:	4e0dbd83          	ld	s11,1248(s11) # 204ee8 <_GLOBAL_OFFSET_TABLE_+0x3190>
   10a10:	000db783          	ld	a5,0(s11)
   10a14:	ecbe                	sd	a5,88(sp)
   10a16:	4781                	li	a5,0
   10a18:	57fd                	li	a5,-1
   10a1a:	e586                	sd	ra,200(sp)
   10a1c:	838d                	srli	a5,a5,0x3
   10a1e:	e832                	sd	a2,16(sp)
   10a20:	2527e863          	bltu	a5,s2,10c70 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x27a>
   10a24:	e1a2                	sd	s0,192(sp)
   10a26:	f152                	sd	s4,160(sp)
   10a28:	ed56                	sd	s5,152(sp)
   10a2a:	f54e                	sd	s3,168(sp)
   10a2c:	e95a                	sd	s6,144(sp)
   10a2e:	e55e                	sd	s7,136(sp)
   10a30:	f8ea                	sd	s10,112(sp)
   10a32:	f802                	sd	zero,48(sp)
   10a34:	fc02                	sd	zero,56(sp)
   10a36:	8436                	mv	s0,a3
   10a38:	8aaa                	mv	s5,a0
   10a3a:	8a2e                	mv	s4,a1
   10a3c:	2481                	sext.w	s1,s1
   10a3e:	1e090063          	beqz	s2,10c1e <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x228>
   10a42:	090a                	slli	s2,s2,0x2
   10a44:	854a                	mv	a0,s2
   10a46:	2db010ef          	jal	12520 <_Znwm>
   10a4a:	012509b3          	add	s3,a0,s2
   10a4e:	864a                	mv	a2,s2
   10a50:	4581                	li	a1,0
   10a52:	8d2a                	mv	s10,a0
   10a54:	f42a                	sd	a0,40(sp)
   10a56:	fc4e                	sd	s3,56(sp)
   10a58:	00133097          	auipc	ra,0x133
   10a5c:	85e080e7          	jalr	-1954(ra) # 1432b6 <memset>
   10a60:	854a                	mv	a0,s2
   10a62:	f84e                	sd	s3,48(sp)
   10a64:	e482                	sd	zero,72(sp)
   10a66:	e882                	sd	zero,80(sp)
   10a68:	2b9010ef          	jal	12520 <_Znwm>
   10a6c:	01250b33          	add	s6,a0,s2
   10a70:	864a                	mv	a2,s2
   10a72:	4581                	li	a1,0
   10a74:	89aa                	mv	s3,a0
   10a76:	e0aa                	sd	a0,64(sp)
   10a78:	e8da                	sd	s6,80(sp)
   10a7a:	00133097          	auipc	ra,0x133
   10a7e:	83c080e7          	jalr	-1988(ra) # 1432b6 <memset>
   10a82:	854a                	mv	a0,s2
   10a84:	e4da                	sd	s6,72(sp)
   10a86:	29b010ef          	jal	12520 <_Znwm>
   10a8a:	864a                	mv	a2,s2
   10a8c:	4581                	li	a1,0
   10a8e:	8baa                	mv	s7,a0
   10a90:	8b2a                	mv	s6,a0
   10a92:	00133097          	auipc	ra,0x133
   10a96:	824080e7          	jalr	-2012(ra) # 1432b6 <memset>
   10a9a:	1c805063          	blez	s0,10c5a <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x264>
   10a9e:	000ab883          	ld	a7,0(s5)
   10aa2:	000a3e83          	ld	t4,0(s4)
   10aa6:	00241713          	slli	a4,s0,0x2
   10aaa:	e162                	sd	s8,128(sp)
   10aac:	fce6                	sd	s9,120(sp)
   10aae:	00249813          	slli	a6,s1,0x2
   10ab2:	8e6a                	mv	t3,s10
   10ab4:	834e                	mv	t1,s3
   10ab6:	98ba                	add	a7,a7,a4
   10ab8:	4f01                	li	t5,0
   10aba:	40e887b3          	sub	a5,a7,a4
   10abe:	859a                	mv	a1,t1
   10ac0:	8676                	mv	a2,t4
   10ac2:	86f2                	mv	a3,t3
   10ac4:	4388                	lw	a0,0(a5)
   10ac6:	0591                	addi	a1,a1,4
   10ac8:	0791                	addi	a5,a5,4
   10aca:	c288                	sw	a0,0(a3)
   10acc:	4208                	lw	a0,0(a2)
   10ace:	0691                	addi	a3,a3,4
   10ad0:	0611                	addi	a2,a2,4
   10ad2:	fea5ae23          	sw	a0,-4(a1)
   10ad6:	ff1797e3          	bne	a5,a7,10ac4 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0xce>
   10ada:	2f05                	addiw	t5,t5,1
   10adc:	9e42                	add	t3,t3,a6
   10ade:	9eba                	add	t4,t4,a4
   10ae0:	9342                	add	t1,t1,a6
   10ae2:	00e788b3          	add	a7,a5,a4
   10ae6:	fde41ae3          	bne	s0,t5,10aba <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0xc4>
   10aea:	00149b9b          	slliw	s7,s1,0x1
   10aee:	fff48a9b          	addiw	s5,s1,-1
   10af2:	5ffd                	li	t6,-1
   10af4:	41700eb3          	neg	t4,s7
   10af8:	001ada9b          	srliw	s5,s5,0x1
   10afc:	41098cb3          	sub	s9,s3,a6
   10b00:	00898c13          	addi	s8,s3,8
   10b04:	020fd293          	srli	t0,t6,0x20
   10b08:	ec4e                	sd	s3,24(sp)
   10b0a:	0e8a                	slli	t4,t4,0x2
   10b0c:	0a86                	slli	s5,s5,0x1
   10b0e:	8e42                	mv	t3,a6
   10b10:	83da                	mv	t2,s6
   10b12:	4f01                	li	t5,0
   10b14:	4301                	li	t1,0
   10b16:	4a01                	li	s4,0
   10b18:	1f82                	slli	t6,t6,0x20
   10b1a:	e426                	sd	s1,8(sp)
   10b1c:	89da                	mv	s3,s6
   10b1e:	01530b33          	add	s6,t1,s5
   10b22:	0b0a                	slli	s6,s6,0x2
   10b24:	01cc86b3          	add	a3,s9,t3
   10b28:	9b62                	add	s6,s6,s8
   10b2a:	859e                	mv	a1,t2
   10b2c:	00df0633          	add	a2,t5,a3
   10b30:	9672                	add	a2,a2,t3
   10b32:	629c                	ld	a5,0(a3)
   10b34:	6210                	ld	a2,0(a2)
   10b36:	010588b3          	add	a7,a1,a6
   10b3a:	0057f4b3          	and	s1,a5,t0
   10b3e:	02061513          	slli	a0,a2,0x20
   10b42:	8d45                	or	a0,a0,s1
   10b44:	9381                	srli	a5,a5,0x20
   10b46:	01f67633          	and	a2,a2,t6
   10b4a:	e188                	sd	a0,0(a1)
   10b4c:	8fd1                	or	a5,a5,a2
   10b4e:	00f8b023          	sd	a5,0(a7)
   10b52:	06a1                	addi	a3,a3,8
   10b54:	41d585b3          	sub	a1,a1,t4
   10b58:	fcdb1ae3          	bne	s6,a3,10b2c <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x136>
   10b5c:	67a2                	ld	a5,8(sp)
   10b5e:	2a09                	addiw	s4,s4,2
   10b60:	935e                	add	t1,t1,s7
   10b62:	03a1                	addi	t2,t2,8
   10b64:	9f76                	add	t5,t5,t4
   10b66:	41de0e33          	sub	t3,t3,t4
   10b6a:	fafa4ae3          	blt	s4,a5,10b1e <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x128>
   10b6e:	67c2                	ld	a5,16(sp)
   10b70:	8b4e                	mv	s6,s3
   10b72:	64a2                	ld	s1,8(sp)
   10b74:	69e2                	ld	s3,24(sp)
   10b76:	0007b283          	ld	t0,0(a5)
   10b7a:	8f6a                	mv	t5,s10
   10b7c:	4f81                	li	t6,0
   10b7e:	4381                	li	t2,0
   10b80:	008d0a13          	addi	s4,s10,8
   10b84:	01fa88b3          	add	a7,s5,t6
   10b88:	088a                	slli	a7,a7,0x2
   10b8a:	98d2                	add	a7,a7,s4
   10b8c:	835a                	mv	t1,s6
   10b8e:	8e96                	mv	t4,t0
   10b90:	4e01                	li	t3,0
   10b92:	859a                	mv	a1,t1
   10b94:	867a                	mv	a2,t5
   10b96:	4501                	li	a0,0
   10b98:	6214                	ld	a3,0(a2)
   10b9a:	0005bb83          	ld	s7,0(a1)
   10b9e:	0621                	addi	a2,a2,8
   10ba0:	0206d793          	srli	a5,a3,0x20
   10ba4:	020bdc13          	srli	s8,s7,0x20
   10ba8:	038787bb          	mulw	a5,a5,s8
   10bac:	05a1                	addi	a1,a1,8
   10bae:	037686bb          	mulw	a3,a3,s7
   10bb2:	9fb5                	addw	a5,a5,a3
   10bb4:	9d3d                	addw	a0,a0,a5
   10bb6:	fec891e3          	bne	a7,a2,10b98 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x1a2>
   10bba:	00aea023          	sw	a0,0(t4)
   10bbe:	2e05                	addiw	t3,t3,1
   10bc0:	0e91                	addi	t4,t4,4
   10bc2:	9342                	add	t1,t1,a6
   10bc4:	fc8e47e3          	blt	t3,s0,10b92 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x19c>
   10bc8:	2385                	addiw	t2,t2,1
   10bca:	9f42                	add	t5,t5,a6
   10bcc:	92ba                	add	t0,t0,a4
   10bce:	9fa6                	add	t6,t6,s1
   10bd0:	fa83cae3          	blt	t2,s0,10b84 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x18e>
   10bd4:	000b0663          	beqz	s6,10be0 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x1ea>
   10bd8:	85ca                	mv	a1,s2
   10bda:	855a                	mv	a0,s6
   10bdc:	1ea000ef          	jal	10dc6 <_ZdlPvm>
   10be0:	6c0a                	ld	s8,128(sp)
   10be2:	7ce6                	ld	s9,120(sp)
   10be4:	00098663          	beqz	s3,10bf0 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x1fa>
   10be8:	85ca                	mv	a1,s2
   10bea:	854e                	mv	a0,s3
   10bec:	1da000ef          	jal	10dc6 <_ZdlPvm>
   10bf0:	040d0263          	beqz	s10,10c34 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x23e>
   10bf4:	6766                	ld	a4,88(sp)
   10bf6:	000db783          	ld	a5,0(s11)
   10bfa:	8fb9                	xor	a5,a5,a4
   10bfc:	4701                	li	a4,0
   10bfe:	e3bd                	bnez	a5,10c64 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x26e>
   10c00:	640e                	ld	s0,192(sp)
   10c02:	79aa                	ld	s3,168(sp)
   10c04:	7a0a                	ld	s4,160(sp)
   10c06:	6aea                	ld	s5,152(sp)
   10c08:	6b4a                	ld	s6,144(sp)
   10c0a:	6baa                	ld	s7,136(sp)
   10c0c:	60ae                	ld	ra,200(sp)
   10c0e:	74ea                	ld	s1,184(sp)
   10c10:	7da6                	ld	s11,104(sp)
   10c12:	85ca                	mv	a1,s2
   10c14:	856a                	mv	a0,s10
   10c16:	794a                	ld	s2,176(sp)
   10c18:	7d46                	ld	s10,112(sp)
   10c1a:	6169                	addi	sp,sp,208
   10c1c:	a26d                	j	10dc6 <_ZdlPvm>
   10c1e:	f402                	sd	zero,40(sp)
   10c20:	fc02                	sd	zero,56(sp)
   10c22:	f802                	sd	zero,48(sp)
   10c24:	e082                	sd	zero,64(sp)
   10c26:	e882                	sd	zero,80(sp)
   10c28:	e482                	sd	zero,72(sp)
   10c2a:	4d01                	li	s10,0
   10c2c:	4981                	li	s3,0
   10c2e:	4b01                	li	s6,0
   10c30:	e6d047e3          	bgtz	a3,10a9e <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0xa8>
   10c34:	6766                	ld	a4,88(sp)
   10c36:	000db783          	ld	a5,0(s11)
   10c3a:	8fb9                	xor	a5,a5,a4
   10c3c:	4701                	li	a4,0
   10c3e:	e39d                	bnez	a5,10c64 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x26e>
   10c40:	640e                	ld	s0,192(sp)
   10c42:	60ae                	ld	ra,200(sp)
   10c44:	79aa                	ld	s3,168(sp)
   10c46:	7a0a                	ld	s4,160(sp)
   10c48:	6aea                	ld	s5,152(sp)
   10c4a:	6b4a                	ld	s6,144(sp)
   10c4c:	6baa                	ld	s7,136(sp)
   10c4e:	7d46                	ld	s10,112(sp)
   10c50:	74ea                	ld	s1,184(sp)
   10c52:	794a                	ld	s2,176(sp)
   10c54:	7da6                	ld	s11,104(sp)
   10c56:	6169                	addi	sp,sp,208
   10c58:	8082                	ret
   10c5a:	85ca                	mv	a1,s2
   10c5c:	855e                	mv	a0,s7
   10c5e:	168000ef          	jal	10dc6 <_ZdlPvm>
   10c62:	b759                	j	10be8 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x1f2>
   10c64:	e162                	sd	s8,128(sp)
   10c66:	fce6                	sd	s9,120(sp)
   10c68:	00142097          	auipc	ra,0x142
   10c6c:	e60080e7          	jalr	-416(ra) # 152ac8 <__stack_chk_fail>
   10c70:	6766                	ld	a4,88(sp)
   10c72:	000db783          	ld	a5,0(s11)
   10c76:	8fb9                	xor	a5,a5,a4
   10c78:	4701                	li	a4,0
   10c7a:	e1a2                	sd	s0,192(sp)
   10c7c:	f54e                	sd	s3,168(sp)
   10c7e:	f152                	sd	s4,160(sp)
   10c80:	ed56                	sd	s5,152(sp)
   10c82:	e95a                	sd	s6,144(sp)
   10c84:	e55e                	sd	s7,136(sp)
   10c86:	e162                	sd	s8,128(sp)
   10c88:	fce6                	sd	s9,120(sp)
   10c8a:	f8ea                	sd	s10,112(sp)
   10c8c:	fff1                	bnez	a5,10c68 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x272>
   10c8e:	00166517          	auipc	a0,0x166
   10c92:	a1250513          	addi	a0,a0,-1518 # 1766a0 <__rseq_flags+0x8>
   10c96:	6bf0f0ef          	jal	20b54 <_ZSt20__throw_length_errorPKc>
   10c9a:	842a                	mv	s0,a0
   10c9c:	0088                	addi	a0,sp,64
   10c9e:	028000ef          	jal	10cc6 <_ZNSt6vectorIiSaIiEED1Ev>
   10ca2:	1028                	addi	a0,sp,40
   10ca4:	022000ef          	jal	10cc6 <_ZNSt6vectorIiSaIiEED1Ev>
   10ca8:	6766                	ld	a4,88(sp)
   10caa:	000db783          	ld	a5,0(s11)
   10cae:	8fb9                	xor	a5,a5,a4
   10cb0:	4701                	li	a4,0
   10cb2:	e162                	sd	s8,128(sp)
   10cb4:	fce6                	sd	s9,120(sp)
   10cb6:	fbcd                	bnez	a5,10c68 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x272>
   10cb8:	8522                	mv	a0,s0
   10cba:	00109097          	auipc	ra,0x109
   10cbe:	82a080e7          	jalr	-2006(ra) # 1194e4 <_Unwind_Resume>
   10cc2:	842a                	mv	s0,a0
   10cc4:	bff9                	j	10ca2 <_Z11gemm_approxRKSt6vectorIiSaIiEES3_RS1_i+0x2ac>
