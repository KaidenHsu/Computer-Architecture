0000000000010b3e <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)>:
    for (int i = 0; i < N; ++i) {
   10b3e:	18d05263          	blez	a3,10cc2 <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x184>
   10b42:	ffc6879b          	addiw	a5,a3,-4
   10b46:	0027d71b          	srliw	a4,a5,0x2
   10b4a:	02d7083b          	mulw	a6,a4,a3
                    int N) {
   10b4e:	7171                	addi	sp,sp,-176
   10b50:	f126                	sd	s1,160(sp)
   10b52:	6104                	ld	s1,0(a0)
	return *(this->_M_impl._M_start + __n);
   10b54:	6208                	ld	a0,0(a2)
   10b56:	8336                	mv	t1,a3
   10b58:	00169293          	slli	t0,a3,0x1
   10b5c:	e94e                	sd	s3,144(sp)
   10b5e:	0017099b          	addiw	s3,a4,1
   10b62:	ffc7f713          	andi	a4,a5,-4
   10b66:	ed4a                	sd	s2,152(sp)
   10b68:	f4e2                	sd	s8,104(sp)
   10b6a:	0005b903          	ld	s2,0(a1)
   10b6e:	00269c1b          	slliw	s8,a3,0x2
   10b72:	0007059b          	sext.w	a1,a4
   10b76:	0027d69b          	srliw	a3,a5,0x2
   10b7a:	929a                	add	t0,t0,t1
   10b7c:	0003061b          	sext.w	a2,t1
   10b80:	4701                	li	a4,0
   10b82:	f522                	sd	s0,168(sp)
   10b84:	e552                	sd	s4,136(sp)
   10b86:	e156                	sd	s5,128(sp)
   10b88:	f8de                	sd	s7,112(sp)
   10b8a:	f0e6                	sd	s9,96(sp)
   10b8c:	ecea                	sd	s10,88(sp)
   10b8e:	e8ee                	sd	s11,80(sp)
   10b90:	00269793          	slli	a5,a3,0x2
   10b94:	fcda                	sd	s6,120(sp)
   10b96:	00231f13          	slli	t5,t1,0x2
   10b9a:	002c1413          	slli	s0,s8,0x2
   10b9e:	00331393          	slli	t2,t1,0x3
   10ba2:	028a                	slli	t0,t0,0x2
   10ba4:	0029999b          	slliw	s3,s3,0x2
   10ba8:	00281d1b          	slliw	s10,a6,0x2
   10bac:	4a01                	li	s4,0
   10bae:	4691                	li	a3,4
    for (int i = 0; i < N; ++i) {
   10bb0:	4c81                	li	s9,0
            for (; k + 3 < N; k += 4) {
   10bb2:	4a8d                	li	s5,3
   10bb4:	01048d93          	addi	s11,s1,16
   10bb8:	8bba                	mv	s7,a4
   10bba:	e4b2                	sd	a2,72(sp)
   10bbc:	fc2e                	sd	a1,56(sp)
   10bbe:	e0aa                	sd	a0,64(sp)
        int row_base = i * N;
   10bc0:	6606                	ld	a2,64(sp)
   10bc2:	00fb8b33          	add	s6,s7,a5
   10bc6:	0b0a                	slli	s6,s6,0x2
   10bc8:	01460eb3          	add	t4,a2,s4
   10bcc:	7662                	ld	a2,56(sp)
   10bce:	ffc6871b          	addiw	a4,a3,-4
        for (int j = 0; j < N; ++j) {
   10bd2:	f866                	sd	s9,48(sp)
   10bd4:	00c68fbb          	addw	t6,a3,a2
        int row_base = i * N;
   10bd8:	4e01                	li	t3,0
   10bda:	9b6e                	add	s6,s6,s11
   10bdc:	ec5e                	sd	s7,24(sp)
   10bde:	f036                	sd	a3,32(sp)
   10be0:	f43a                	sd	a4,40(sp)
   10be2:	8cbe                	mv	s9,a5
   10be4:	000e089b          	sext.w	a7,t3



   // ======================= O(N^3) ==========================
            for (; k + 3 < N; k += 4) {
   10be8:	0c6ad963          	bge	s5,t1,10cba <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x17c>
   10bec:	002e1613          	slli	a2,t3,0x2
   10bf0:	014486b3          	add	a3,s1,s4
   10bf4:	964a                	add	a2,a2,s2



            int32_t sum = 0;
   10bf6:	4781                	li	a5,0
   10bf8:	e052                	sd	s4,0(sp)
   10bfa:	e446                	sd	a7,8(sp)
   10bfc:	e876                	sd	t4,16(sp)

                sum += A[A_idx] * B[B_idx];
   10bfe:	01e60733          	add	a4,a2,t5
                sum += A[A_idx] * B[B_idx];
   10c02:	4288                	lw	a0,0(a3)
   10c04:	00062b83          	lw	s7,0(a2)
                sum += A[A_idx] * B[B_idx];
   10c08:	00760833          	add	a6,a2,t2
                sum += A[A_idx] * B[B_idx];
   10c0c:	42cc                	lw	a1,4(a3)
   10c0e:	00072e83          	lw	t4,0(a4)
                sum += A[A_idx] * B[B_idx];
   10c12:	00082883          	lw	a7,0(a6)
   10c16:	4698                	lw	a4,8(a3)
                sum += A[A_idx] * B[B_idx];
   10c18:	00560a33          	add	s4,a2,t0
   10c1c:	00c6a803          	lw	a6,12(a3)
                sum += A[A_idx] * B[B_idx];
   10c20:	02ab853b          	mulw	a0,s7,a0
                sum += A[A_idx] * B[B_idx];
   10c24:	000a2a03          	lw	s4,0(s4)

            for (; k + 3 < N; k += 4) {
   10c28:	06c1                	addi	a3,a3,16
   10c2a:	9622                	add	a2,a2,s0

                sum += A[A_idx] * B[B_idx];
   10c2c:	03d585bb          	mulw	a1,a1,t4
                sum += A[A_idx] * B[B_idx];
   10c30:	9d3d                	addw	a0,a0,a5
                sum += A[A_idx] * B[B_idx];
   10c32:	0317073b          	mulw	a4,a4,a7
                sum += A[A_idx] * B[B_idx];
   10c36:	9da9                	addw	a1,a1,a0
                sum += A[A_idx] * B[B_idx];
   10c38:	0348083b          	mulw	a6,a6,s4
                sum += A[A_idx] * B[B_idx];
   10c3c:	9f2d                	addw	a4,a4,a1
                sum += A[A_idx] * B[B_idx];
   10c3e:	00e807bb          	addw	a5,a6,a4




            for (; k + 3 < N; k += 4) {
   10c42:	fadb1ee3          	bne	s6,a3,10bfe <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xc0>
   // ======================= END O(N^3) ==========================



            for (; k < N; ++k) {
   10c46:	6a02                	ld	s4,0(sp)
   10c48:	68a2                	ld	a7,8(sp)
   10c4a:	6ec2                	ld	t4,16(sp)
   10c4c:	0269d863          	bge	s3,t1,10c7c <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x13e>
   10c50:	018888bb          	addw	a7,a7,s8
   10c54:	01a888bb          	addw	a7,a7,s10
   10c58:	86fe                	mv	a3,t6
   10c5a:	85ce                	mv	a1,s3
   10c5c:	068a                	slli	a3,a3,0x2
   10c5e:	088a                	slli	a7,a7,0x2
   10c60:	96a6                	add	a3,a3,s1
   10c62:	98ca                	add	a7,a7,s2
                sum += A[A_idx] * B[B_idx];
   10c64:	0006a803          	lw	a6,0(a3)
   10c68:	0008a603          	lw	a2,0(a7)
            for (; k < N; ++k) {
   10c6c:	2585                	addiw	a1,a1,1
   10c6e:	0691                	addi	a3,a3,4
                sum += A[A_idx] * B[B_idx];
   10c70:	0306063b          	mulw	a2,a2,a6
            for (; k < N; ++k) {
   10c74:	98fa                	add	a7,a7,t5
                sum += A[A_idx] * B[B_idx];
   10c76:	9fb1                	addw	a5,a5,a2
            for (; k < N; ++k) {
   10c78:	feb316e3          	bne	t1,a1,10c64 <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x126>
            C[row_base + j] = sum;
   10c7c:	00fea023          	sw	a5,0(t4)
        for (int j = 0; j < N; ++j) {
   10c80:	0e05                	addi	t3,t3,1
   10c82:	0e91                	addi	t4,t4,4
   10c84:	f7c310e3          	bne	t1,t3,10be4 <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xa6>
    for (int i = 0; i < N; ++i) {
   10c88:	87e6                	mv	a5,s9
   10c8a:	7cc2                	ld	s9,48(sp)
   10c8c:	6be2                	ld	s7,24(sp)
   10c8e:	7682                	ld	a3,32(sp)
   10c90:	6726                	ld	a4,72(sp)
   10c92:	2c85                	addiw	s9,s9,1
   10c94:	9a7a                	add	s4,s4,t5
   10c96:	9eb9                	addw	a3,a3,a4
   10c98:	9b9a                	add	s7,s7,t1
   10c9a:	f39313e3          	bne	t1,s9,10bc0 <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x82>
}
   10c9e:	742a                	ld	s0,168(sp)
   10ca0:	748a                	ld	s1,160(sp)
   10ca2:	696a                	ld	s2,152(sp)
   10ca4:	69ca                	ld	s3,144(sp)
   10ca6:	6a2a                	ld	s4,136(sp)
   10ca8:	6a8a                	ld	s5,128(sp)
   10caa:	7b66                	ld	s6,120(sp)
   10cac:	7bc6                	ld	s7,112(sp)
   10cae:	7c26                	ld	s8,104(sp)
   10cb0:	7c86                	ld	s9,96(sp)
   10cb2:	6d66                	ld	s10,88(sp)
   10cb4:	6dc6                	ld	s11,80(sp)
   10cb6:	614d                	addi	sp,sp,176
   10cb8:	8082                	ret
            int A_idx = row_base;
   10cba:	76a2                	ld	a3,40(sp)
            int k = 0;
   10cbc:	4581                	li	a1,0
            int32_t sum = 0;
   10cbe:	4781                	li	a5,0
   10cc0:	bf71                	j	10c5c <gemm_unrolled4(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x11e>
   10cc2:	8082                	ret
