0000000000010e72 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)>:
    for (int i = 0; i < N; ++i) {
   10e72:	16d05463          	blez	a3,10fda <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x168>
   10e76:	ffe6879b          	addiw	a5,a3,-2
                 int N) {
   10e7a:	7175                	addi	sp,sp,-144
   10e7c:	0017d71b          	srliw	a4,a5,0x1
   10e80:	f0d6                	sd	s5,96(sp)
   10e82:	02d70abb          	mulw	s5,a4,a3
   10e86:	00053283          	ld	t0,0(a0)
   10e8a:	e4e2                	sd	s8,72(sp)
   10e8c:	00063c03          	ld	s8,0(a2)
   10e90:	8e36                	mv	t3,a3
   10e92:	f4d2                	sd	s4,104(sp)
   10e94:	0005b383          	ld	t2,0(a1)
   10e98:	00169a1b          	slliw	s4,a3,0x1
   10e9c:	0017d69b          	srliw	a3,a5,0x1
   10ea0:	9bf9                	andi	a5,a5,-2
   10ea2:	e522                	sd	s0,136(sp)
   10ea4:	fc6a                	sd	s10,56(sp)
   10ea6:	0017041b          	addiw	s0,a4,1
   10eaa:	00169d13          	slli	s10,a3,0x1
   10eae:	0007871b          	sext.w	a4,a5
   10eb2:	e126                	sd	s1,128(sp)
   10eb4:	fcca                	sd	s2,120(sp)
   10eb6:	f8ce                	sd	s3,112(sp)
   10eb8:	f86e                	sd	s11,48(sp)
   10eba:	f43a                	sd	a4,40(sp)
   10ebc:	ecda                	sd	s6,88(sp)
   10ebe:	e8de                	sd	s7,80(sp)
   10ec0:	e0e6                	sd	s9,64(sp)
   10ec2:	000e099b          	sext.w	s3,t3
   10ec6:	002e1893          	slli	a7,t3,0x2
   10eca:	002a1f13          	slli	t5,s4,0x2
   10ece:	001a9a9b          	slliw	s5,s5,0x1
   10ed2:	0014141b          	slliw	s0,s0,0x1
   10ed6:	4501                	li	a0,0
   10ed8:	4481                	li	s1,0
   10eda:	4689                	li	a3,2
    for (int i = 0; i < N; ++i) {
   10edc:	4801                	li	a6,0
            for (; k + 1 < N; k += 2) {
   10ede:	4905                	li	s2,1
   10ee0:	00828d93          	addi	s11,t0,8
   10ee4:	8762                	mv	a4,s8
   10ee6:	8eea                	mv	t4,s10
        int row_base = i * N;
   10ee8:	77a2                	ld	a5,40(sp)
   10eea:	00ae8c33          	add	s8,t4,a0
   10eee:	ffe68d1b          	addiw	s10,a3,-2
        for (int j = 0; j < N; ++j) {
   10ef2:	0c0a                	slli	s8,s8,0x2
   10ef4:	ec6a                	sd	s10,24(sp)
   10ef6:	00970bb3          	add	s7,a4,s1
   10efa:	00d78cbb          	addw	s9,a5,a3
        int row_base = i * N;
   10efe:	4b01                	li	s6,0
   10f00:	9c6e                	add	s8,s8,s11
   10f02:	f042                	sd	a6,32(sp)
   10f04:	8d3a                	mv	s10,a4
   10f06:	8ff6                	mv	t6,t4
   10f08:	000b081b          	sext.w	a6,s6

            for (; k + 1 < N; k += 2) {
   10f0c:	0d2e0363          	beq	t3,s2,10fd2 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x160>
   10f10:	002b1593          	slli	a1,s6,0x2
   10f14:	00928633          	add	a2,t0,s1
   10f18:	959e                	add	a1,a1,t2



            int32_t s0 = 0, s1 = 0;
   10f1a:	4e81                	li	t4,0
   10f1c:	4301                	li	t1,0
   10f1e:	e46a                	sd	s10,8(sp)
   10f20:	e852                	sd	s4,16(sp)



   // ======================= O(N^3) ==========================
                s1 += A[A_idx] * B[B_idx];
   10f22:	01158a33          	add	s4,a1,a7
                s0 += A[A_idx] * B[B_idx];
   10f26:	4218                	lw	a4,0(a2)
   10f28:	419c                	lw	a5,0(a1)
                s1 += A[A_idx] * B[B_idx];
   10f2a:	00462d03          	lw	s10,4(a2)
   10f2e:	000a2a03          	lw	s4,0(s4)
                s0 += A[A_idx] * B[B_idx];
   10f32:	02e787bb          	mulw	a5,a5,a4

            for (; k + 1 < N; k += 2) {
   10f36:	0621                	addi	a2,a2,8

   10f38:	95fa                	add	a1,a1,t5
                s1 += A[A_idx] * B[B_idx];
   10f3a:	034d0a3b          	mulw	s4,s10,s4
                s0 += A[A_idx] * B[B_idx];
   10f3e:	0067833b          	addw	t1,a5,t1
                s1 += A[A_idx] * B[B_idx];
   10f42:	01da0ebb          	addw	t4,s4,t4



            for (; k + 1 < N; k += 2) {
   10f46:	fd861ee3          	bne	a2,s8,10f22 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xb0>
   10f4a:	6a42                	ld	s4,16(sp)
   10f4c:	6d22                	ld	s10,8(sp)
   // ======================= END O(N^3) ==========================



            C[row_base + j] = s0 + s1 + tail;
   10f4e:	01d307bb          	addw	a5,t1,t4
   10f52:	010a083b          	addw	a6,s4,a6
            for (; k < N; ++k) {
   10f56:	0158083b          	addw	a6,a6,s5
   10f5a:	03c45e63          	bge	s0,t3,10f96 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x124>
   10f5e:	8666                	mv	a2,s9
   10f60:	85a2                	mv	a1,s0
   10f62:	40b985bb          	subw	a1,s3,a1
   10f66:	1582                	slli	a1,a1,0x20
   10f68:	9181                	srli	a1,a1,0x20
   10f6a:	95b2                	add	a1,a1,a2
   10f6c:	080a                	slli	a6,a6,0x2
   10f6e:	060a                	slli	a2,a2,0x2
   10f70:	058a                	slli	a1,a1,0x2
   10f72:	9616                	add	a2,a2,t0
   10f74:	981e                	add	a6,a6,t2
   10f76:	9596                	add	a1,a1,t0
            int32_t tail = 0;
   10f78:	4301                	li	t1,0
                tail += A[A_idx] * B[B_idx];
   10f7a:	00062e83          	lw	t4,0(a2)
   10f7e:	00082703          	lw	a4,0(a6)
            for (; k < N; ++k) {
   10f82:	0611                	addi	a2,a2,4
   10f84:	9846                	add	a6,a6,a7
                tail += A[A_idx] * B[B_idx];
   10f86:	03d7073b          	mulw	a4,a4,t4
   10f8a:	0067033b          	addw	t1,a4,t1
            for (; k < N; ++k) {
   10f8e:	fec596e3          	bne	a1,a2,10f7a <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x108>
            C[row_base + j] = s0 + s1 + tail;
   10f92:	00f307bb          	addw	a5,t1,a5
   10f96:	00fba023          	sw	a5,0(s7)
        for (int j = 0; j < N; ++j) {
   10f9a:	0b05                	addi	s6,s6,1
   10f9c:	0b91                	addi	s7,s7,4
   10f9e:	f7cb15e3          	bne	s6,t3,10f08 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x96>
    for (int i = 0; i < N; ++i) {
   10fa2:	7802                	ld	a6,32(sp)
   10fa4:	876a                	mv	a4,s10
   10fa6:	8efe                	mv	t4,t6
   10fa8:	2805                	addiw	a6,a6,1
   10faa:	013686bb          	addw	a3,a3,s3
   10fae:	94c6                	add	s1,s1,a7
   10fb0:	9572                	add	a0,a0,t3
   10fb2:	f30e1be3          	bne	t3,a6,10ee8 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x76>
}
   10fb6:	642a                	ld	s0,136(sp)
   10fb8:	648a                	ld	s1,128(sp)
   10fba:	7966                	ld	s2,120(sp)
   10fbc:	79c6                	ld	s3,112(sp)
   10fbe:	7a26                	ld	s4,104(sp)
   10fc0:	7a86                	ld	s5,96(sp)
   10fc2:	6b66                	ld	s6,88(sp)
   10fc4:	6bc6                	ld	s7,80(sp)
   10fc6:	6c26                	ld	s8,72(sp)
   10fc8:	6c86                	ld	s9,64(sp)
   10fca:	7d62                	ld	s10,56(sp)
   10fcc:	7dc2                	ld	s11,48(sp)
   10fce:	6149                	addi	sp,sp,144
   10fd0:	8082                	ret
            int A_idx = row_base;
   10fd2:	6662                	ld	a2,24(sp)
            for (; k + 1 < N; k += 2) {
   10fd4:	4781                	li	a5,0
            int k = 0;
   10fd6:	4581                	li	a1,0
   10fd8:	b769                	j	10f62 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xf0>
   10fda:	8082                	ret
