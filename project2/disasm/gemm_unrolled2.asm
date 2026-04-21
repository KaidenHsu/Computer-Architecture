00000000000109f6 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)>:
    for (int i = 0; i < N; ++i) {
   109f6:	14d05363          	blez	a3,10b3c <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x146>
   109fa:	ffe6879b          	addiw	a5,a3,-2
                    int N) {
   109fe:	7175                	addi	sp,sp,-144
   10a00:	0017d71b          	srliw	a4,a5,0x1
   10a04:	f0d6                	sd	s5,96(sp)
   10a06:	02d70abb          	mulw	s5,a4,a3
   10a0a:	fcca                	sd	s2,120(sp)
   10a0c:	00053903          	ld	s2,0(a0)
   10a10:	e0e6                	sd	s9,64(sp)
	return *(this->_M_impl._M_start + __n);
   10a12:	00063c83          	ld	s9,0(a2)
   10a16:	8f36                	mv	t5,a3
   10a18:	2705                	addiw	a4,a4,1
   10a1a:	f4d2                	sd	s4,104(sp)
   10a1c:	00169a1b          	slliw	s4,a3,0x1
   10a20:	0017d69b          	srliw	a3,a5,0x1
   10a24:	9bf9                	andi	a5,a5,-2
	return *(this->_M_impl._M_start + __n);
   10a26:	0005b283          	ld	t0,0(a1)
   10a2a:	e126                	sd	s1,128(sp)
   10a2c:	fc6a                	sd	s10,56(sp)
   10a2e:	0007859b          	sext.w	a1,a5
   10a32:	00169d13          	slli	s10,a3,0x1
   10a36:	0017149b          	slliw	s1,a4,0x1
   10a3a:	00890713          	addi	a4,s2,8
   10a3e:	ecda                	sd	s6,88(sp)
   10a40:	e8de                	sd	s7,80(sp)
   10a42:	f86e                	sd	s11,48(sp)
   10a44:	e522                	sd	s0,136(sp)
   10a46:	f8ce                	sd	s3,112(sp)
   10a48:	e4e2                	sd	s8,72(sp)
   10a4a:	000f0d9b          	sext.w	s11,t5
   10a4e:	002f1313          	slli	t1,t5,0x2
   10a52:	002a1e13          	slli	t3,s4,0x2
   10a56:	001a9a9b          	slliw	s5,s5,0x1
   10a5a:	4b01                	li	s6,0
   10a5c:	4501                	li	a0,0
   10a5e:	4689                	li	a3,2
    for (int i = 0; i < N; ++i) {
   10a60:	4b81                	li	s7,0
            for (; k + 1 < N; k += 2) {
   10a62:	4385                	li	t2,1
   10a64:	e852                	sd	s4,16(sp)
   10a66:	f46a                	sd	s10,40(sp)
   10a68:	882e                	mv	a6,a1
   10a6a:	88e6                	mv	a7,s9
   10a6c:	863a                	mv	a2,a4
        int row_base = i * N;
   10a6e:	77a2                	ld	a5,40(sp)
   10a70:	ffe68d1b          	addiw	s10,a3,-2
        for (int j = 0; j < N; ++j) {
   10a74:	00a889b3          	add	s3,a7,a0
   10a78:	01678fb3          	add	t6,a5,s6
   10a7c:	0f8a                	slli	t6,t6,0x2
   10a7e:	ec6a                	sd	s10,24(sp)
   10a80:	00a90c33          	add	s8,s2,a0
   10a84:	8d46                	mv	s10,a7
   10a86:	9fb2                	add	t6,t6,a2
   10a88:	00d80cbb          	addw	s9,a6,a3
        int row_base = i * N;
   10a8c:	4401                	li	s0,0
   10a8e:	8ec2                	mv	t4,a6
   10a90:	88de                	mv	a7,s7
   10a92:	f036                	sd	a3,32(sp)
   10a94:	00040b9b          	sext.w	s7,s0

            for (; k + 1 < N; k += 2) {
   10a98:	087f0f63          	beq	t5,t2,10b36 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x140>
   10a9c:	00241813          	slli	a6,s0,0x2
   10aa0:	9816                	add	a6,a6,t0
   10aa2:	85e2                	mv	a1,s8

            int32_t sum = 0;
   10aa4:	4781                	li	a5,0 // a5 = 0
   10aa6:	e422                	sd	s0,8(sp) // save s0



   // ======================= O(N^3) ==========================
                sum += A[A_idx] * B[B_idx];
   10aa8:	0005aa03          	lw	s4,0(a1) // load A[A_idx]
   10aac:	00082703          	lw	a4,0(a6) // load B[B_idx]

                sum += A[A_idx] * B[B_idx];
   10ab0:	00680433          	add	s0,a6,t1 // calcualte address for B[B_idx+N]
   10ab4:	41d4                	lw	a3,4(a1) // load A[A_idx+1]
   10ab6:	4000                	lw	s0,0(s0) // load B[B_idx+1]

                sum += A[A_idx] * B[B_idx];
   10ab8:	0347073b          	mulw	a4,a4,s4 // a4 = A[A_idx] * B[B_idx]

            for (; k + 1 < N; k += 2) {
   10abc:	05a1                	addi	a1,a1,8 // A_idx += 2
   10abe:	9872                	add	a6,a6,t3 // B_idx += 2*N

                sum += A[A_idx] * B[B_idx];
   10ac0:	028686bb          	mulw	a3,a3,s0 // a3 = A[A_idx+1] * B[B_idx+N]
                sum += A[A_idx] * B[B_idx];
   10ac4:	9f3d                	addw	a4,a4,a5 // 
                sum += A[A_idx] * B[B_idx];
   10ac6:	00e687bb          	addw	a5,a3,a4 // a5 = A[A_idx]*B[B_idx] + A[A_idx+1]*B[B_idx+N]



            for (; k + 1 < N; k += 2) {
   10aca:	fcbf9fe3          	bne	t6,a1,10aa8 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xb2>
   // ======================= END O(N^3) ==========================



            for (; k < N; ++k) {
   10ace:	6422                	ld	s0,8(sp)
   10ad0:	05e4c163          	blt	s1,t5,10b12 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x11c>
            C[row_base + j] = sum;
   10ad4:	00f9a023          	sw	a5,0(s3)
        for (int j = 0; j < N; ++j) {
   10ad8:	0405                	addi	s0,s0,1
   10ada:	0991                	addi	s3,s3,4
   10adc:	fbe41ce3          	bne	s0,t5,10a94 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x9e>
    for (int i = 0; i < N; ++i) {
   10ae0:	7682                	ld	a3,32(sp)
   10ae2:	8bc6                	mv	s7,a7
   10ae4:	2b85                	addiw	s7,s7,1
   10ae6:	8876                	mv	a6,t4
   10ae8:	88ea                	mv	a7,s10
   10aea:	01b686bb          	addw	a3,a3,s11
   10aee:	951a                	add	a0,a0,t1
   10af0:	9b7a                	add	s6,s6,t5
   10af2:	f77f1ee3          	bne	t5,s7,10a6e <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x78>
}
   10af6:	642a                	ld	s0,136(sp)
   10af8:	648a                	ld	s1,128(sp)
   10afa:	7966                	ld	s2,120(sp)
   10afc:	79c6                	ld	s3,112(sp)
   10afe:	7a26                	ld	s4,104(sp)
   10b00:	7a86                	ld	s5,96(sp)
   10b02:	6b66                	ld	s6,88(sp)
   10b04:	6bc6                	ld	s7,80(sp)
   10b06:	6c26                	ld	s8,72(sp)
   10b08:	6c86                	ld	s9,64(sp)
   10b0a:	7d62                	ld	s10,56(sp)
   10b0c:	7dc2                	ld	s11,48(sp)
   10b0e:	6149                	addi	sp,sp,144
   10b10:	8082                	ret
   10b12:	6742                	ld	a4,16(sp)
            for (; k < N; ++k) {
   10b14:	8866                	mv	a6,s9
   10b16:	01770bbb          	addw	s7,a4,s7
   10b1a:	015b8bbb          	addw	s7,s7,s5
                sum += A[A_idx] * B[B_idx];
   10b1e:	080a                	slli	a6,a6,0x2
   10b20:	002b9593          	slli	a1,s7,0x2
   10b24:	984a                	add	a6,a6,s2
   10b26:	9596                	add	a1,a1,t0
   10b28:	00082803          	lw	a6,0(a6)
   10b2c:	418c                	lw	a1,0(a1)
   10b2e:	030585bb          	mulw	a1,a1,a6
   10b32:	9fad                	addw	a5,a5,a1
            for (; k < N; ++k) {
   10b34:	b745                	j	10ad4 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xde>
            int A_idx = row_base;
   10b36:	6862                	ld	a6,24(sp)
            int32_t sum = 0;
   10b38:	4781                	li	a5,0
   10b3a:	b7d5                	j	10b1e <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x128>
   10b3c:	8082                	ret
