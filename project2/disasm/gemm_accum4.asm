0000000000010cc4 <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)>:
    for (int i = 0; i < N; ++i) {
   10cc4:	1ad05663          	blez	a3,10e70 <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x1ac>
   10cc8:	ffc6879b          	addiw	a5,a3,-4
   10ccc:	0027d71b          	srliw	a4,a5,0x2
   10cd0:	02d7083b          	mulw	a6,a4,a3
                 int N) {
   10cd4:	7155                	addi	sp,sp,-208
   10cd6:	e5a2                	sd	s0,200(sp)
   10cd8:	6100                	ld	s0,0(a0)
   10cda:	00063303          	ld	t1,0(a2)
   10cde:	82b6                	mv	t0,a3
   10ce0:	fd4a                	sd	s2,184(sp)
   10ce2:	ed5a                	sd	s6,152(sp)
   10ce4:	00169913          	slli	s2,a3,0x1
   10ce8:	00269b1b          	slliw	s6,a3,0x2
   10cec:	0027d69b          	srliw	a3,a5,0x2
   10cf0:	9bf1                	andi	a5,a5,-4
   10cf2:	00269e13          	slli	t3,a3,0x2
   10cf6:	f156                	sd	s5,160(sp)
   10cf8:	e95e                	sd	s7,144(sp)
   10cfa:	0005ba83          	ld	s5,0(a1)
   10cfe:	9916                	add	s2,s2,t0
   10d00:	0007859b          	sext.w	a1,a5
   10d04:	2705                	addiw	a4,a4,1
   10d06:	00281b9b          	slliw	s7,a6,0x2
   10d0a:	01040693          	addi	a3,s0,16
   10d0e:	e1a6                	sd	s1,192(sp)
   10d10:	f94e                	sd	s3,176(sp)
   10d12:	f552                	sd	s4,168(sp)
   10d14:	e562                	sd	s8,136(sp)
   10d16:	e166                	sd	s9,128(sp)
   10d18:	fcea                	sd	s10,120(sp)
   10d1a:	f8ee                	sd	s11,112(sp)
   10d1c:	00229f13          	slli	t5,t0,0x2
   10d20:	00028d9b          	sext.w	s11,t0
   10d24:	002b1a13          	slli	s4,s6,0x2
   10d28:	00329993          	slli	s3,t0,0x3
   10d2c:	090a                	slli	s2,s2,0x2
   10d2e:	00271c1b          	slliw	s8,a4,0x2
   10d32:	4601                	li	a2,0
   10d34:	4c81                	li	s9,0
   10d36:	4791                	li	a5,4
    for (int i = 0; i < N; ++i) {
   10d38:	4881                	li	a7,0
            for (; k + 3 < N; k += 4) {
   10d3a:	4d0d                	li	s10,3
   10d3c:	e8ae                	sd	a1,80(sp)
   10d3e:	ec9a                	sd	t1,88(sp)
   10d40:	f0f2                	sd	t3,96(sp)
   10d42:	84de                	mv	s1,s7
   10d44:	f4b6                	sd	a3,104(sp)
        int row_base = i * N;
   10d46:	7706                	ld	a4,96(sp)
   10d48:	4f81                	li	t6,0
   10d4a:	fc32                	sd	a2,56(sp)
   10d4c:	00e60bb3          	add	s7,a2,a4
   10d50:	ffc7871b          	addiw	a4,a5,-4
   10d54:	f83a                	sd	a4,48(sp)
        for (int j = 0; j < N; ++j) {
   10d56:	6766                	ld	a4,88(sp)
   10d58:	0b8a                	slli	s7,s7,0x2
   10d5a:	e0be                	sd	a5,64(sp)
   10d5c:	019703b3          	add	t2,a4,s9
   10d60:	6746                	ld	a4,80(sp)
   10d62:	e4c6                	sd	a7,72(sp)
   10d64:	9f3d                	addw	a4,a4,a5
   10d66:	f43a                	sd	a4,40(sp)
   10d68:	7726                	ld	a4,104(sp)
   10d6a:	9bba                	add	s7,s7,a4
   10d6c:	000f881b          	sext.w	a6,t6



   // ======================= O(N^3) ==========================
            for (; k + 3 < N; k += 4) {
   10d70:	0e5d5c63          	bge	s10,t0,10e68 <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x1a4>
   10d74:	002f9693          	slli	a3,t6,0x2
   10d78:	019407b3          	add	a5,s0,s9
   10d7c:	96d6                	add	a3,a3,s5



            int32_t s0 = 0, s1 = 0, s2 = 0, s3 = 0;
   10d7e:	4e81                	li	t4,0
   10d80:	4e01                	li	t3,0
   10d82:	4301                	li	t1,0
   10d84:	4881                	li	a7,0
   10d86:	e466                	sd	s9,8(sp)
   10d88:	e86e                	sd	s11,16(sp)
   10d8a:	ec42                	sd	a6,24(sp)
   10d8c:	f01e                	sd	t2,32(sp)

                s1 += A[A_idx] * B[B_idx];
   10d8e:	01e68633          	add	a2,a3,t5
                s2 += A[A_idx] * B[B_idx];
   10d92:	013685b3          	add	a1,a3,s3
                s3 += A[A_idx] * B[B_idx];
   10d96:	01268833          	add	a6,a3,s2
                s0 += A[A_idx] * B[B_idx];
   10d9a:	4388                	lw	a0,0(a5)

   10d9c:	4298                	lw	a4,0(a3)
                s1 += A[A_idx] * B[B_idx];
   10d9e:	0047ad83          	lw	s11,4(a5)
                s2 += A[A_idx] * B[B_idx];
   10da2:	0087ac83          	lw	s9,8(a5)
                s3 += A[A_idx] * B[B_idx];

   10da6:	00c7a383          	lw	t2,12(a5)
                s1 += A[A_idx] * B[B_idx];
   10daa:	4210                	lw	a2,0(a2)
                s2 += A[A_idx] * B[B_idx];
   10dac:	418c                	lw	a1,0(a1)
                s3 += A[A_idx] * B[B_idx];
   10dae:	00082803          	lw	a6,0(a6)
                s0 += A[A_idx] * B[B_idx];
   10db2:	02a7073b          	mulw	a4,a4,a0

            for (; k + 3 < N; k += 4) {
   10db6:	07c1                	addi	a5,a5,16
   10db8:	96d2                	add	a3,a3,s4

                s1 += A[A_idx] * B[B_idx];
   10dba:	02cd863b          	mulw	a2,s11,a2
                s0 += A[A_idx] * B[B_idx];
   10dbe:	011708bb          	addw	a7,a4,a7
                s2 += A[A_idx] * B[B_idx];
   10dc2:	02bc85bb          	mulw	a1,s9,a1
                s1 += A[A_idx] * B[B_idx];
   10dc6:	0066033b          	addw	t1,a2,t1
                s3 += A[A_idx] * B[B_idx];
   10dca:	0303883b          	mulw	a6,t2,a6
                s2 += A[A_idx] * B[B_idx];
   10dce:	01c58e3b          	addw	t3,a1,t3
                s3 += A[A_idx] * B[B_idx];
   10dd2:	01d80ebb          	addw	t4,a6,t4



            for (; k + 3 < N; k += 4) {
   10dd6:	fafb9ce3          	bne	s7,a5,10d8e <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xca>
   // ======================= END O(N^3) ==========================



            C[row_base + j] = s0 + s1 + s2 + s3 + tail;
   10dda:	6862                	ld	a6,24(sp)
   10ddc:	0068873b          	addw	a4,a7,t1
   10de0:	01c7073b          	addw	a4,a4,t3
   10de4:	0168083b          	addw	a6,a6,s6
   10de8:	6ca2                	ld	s9,8(sp)
   10dea:	6dc2                	ld	s11,16(sp)
   10dec:	7382                	ld	t2,32(sp)
   10dee:	0098083b          	addw	a6,a6,s1
   10df2:	01d7073b          	addw	a4,a4,t4
            for (; k < N; ++k) {
   10df6:	025c5b63          	bge	s8,t0,10e2c <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x168>
   10dfa:	76a2                	ld	a3,40(sp)
   10dfc:	8662                	mv	a2,s8
   10dfe:	40cd863b          	subw	a2,s11,a2
   10e02:	1602                	slli	a2,a2,0x20
   10e04:	9201                	srli	a2,a2,0x20
   10e06:	9636                	add	a2,a2,a3
   10e08:	080a                	slli	a6,a6,0x2
   10e0a:	068a                	slli	a3,a3,0x2
   10e0c:	060a                	slli	a2,a2,0x2
   10e0e:	96a2                	add	a3,a3,s0
   10e10:	9856                	add	a6,a6,s5
   10e12:	9622                	add	a2,a2,s0
            int32_t tail = 0;
   10e14:	4581                	li	a1,0
                tail += A[A_idx] * B[B_idx];
   10e16:	4288                	lw	a0,0(a3)
   10e18:	00082783          	lw	a5,0(a6)
            for (; k < N; ++k) {
   10e1c:	0691                	addi	a3,a3,4
   10e1e:	987a                	add	a6,a6,t5
                tail += A[A_idx] * B[B_idx];
   10e20:	02a787bb          	mulw	a5,a5,a0
   10e24:	9dbd                	addw	a1,a1,a5
            for (; k < N; ++k) {
   10e26:	fed618e3          	bne	a2,a3,10e16 <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x152>
            C[row_base + j] = s0 + s1 + s2 + s3 + tail;
   10e2a:	9f2d                	addw	a4,a4,a1
   10e2c:	00e3a023          	sw	a4,0(t2)
        for (int j = 0; j < N; ++j) {
   10e30:	0f85                	addi	t6,t6,1
   10e32:	0391                	addi	t2,t2,4
   10e34:	f3f29ce3          	bne	t0,t6,10d6c <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xa8>
    for (int i = 0; i < N; ++i) {
   10e38:	68a6                	ld	a7,72(sp)
   10e3a:	7662                	ld	a2,56(sp)
   10e3c:	6786                	ld	a5,64(sp)
   10e3e:	2885                	addiw	a7,a7,1
   10e40:	9cfa                	add	s9,s9,t5
   10e42:	00fd87bb          	addw	a5,s11,a5
   10e46:	9616                	add	a2,a2,t0
   10e48:	ef129fe3          	bne	t0,a7,10d46 <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x82>
}
   10e4c:	642e                	ld	s0,200(sp)
   10e4e:	648e                	ld	s1,192(sp)
   10e50:	796a                	ld	s2,184(sp)
   10e52:	79ca                	ld	s3,176(sp)
   10e54:	7a2a                	ld	s4,168(sp)
   10e56:	7a8a                	ld	s5,160(sp)
   10e58:	6b6a                	ld	s6,152(sp)
   10e5a:	6bca                	ld	s7,144(sp)
   10e5c:	6c2a                	ld	s8,136(sp)
   10e5e:	6c8a                	ld	s9,128(sp)
   10e60:	7d66                	ld	s10,120(sp)
   10e62:	7dc6                	ld	s11,112(sp)
   10e64:	6169                	addi	sp,sp,208
   10e66:	8082                	ret
            int A_idx = row_base;
   10e68:	76c2                	ld	a3,48(sp)
            for (; k + 3 < N; k += 4) {
   10e6a:	4701                	li	a4,0
            int k = 0;
   10e6c:	4601                	li	a2,0
   10e6e:	bf41                	j	10dfe <gemm_accum4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x13a>
   10e70:	8082                	ret
