0000000000010988 <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)>:
    for (int i = 0; i < N; ++i) {
   10988:	06d05663          	blez	a3,109f4 <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x6c>
   1098c:	00053e83          	ld	t4,0(a0)
                   int N) {
   10990:	1141                	addi	sp,sp,-16
   10992:	e422                	sd	s0,8(sp)
   10994:	00269513          	slli	a0,a3,0x2
      _GLIBCXX_NODISCARD _GLIBCXX20_CONSTEXPR
      const_reference
      operator[](size_type __n) const _GLIBCXX_NOEXCEPT
      {
	__glibcxx_requires_subscript(__n);
	return *(this->_M_impl._M_start + __n);
   10998:	6180                	ld	s0,0(a1)
   1099a:	00063f83          	ld	t6,0(a2)
   1099e:	01d503b3          	add	t2,a0,t4
   109a2:	8f36                	mv	t5,a3
   109a4:	881e                	mv	a6,t2
    for (int i = 0; i < N; ++i) {
   109a6:	4281                	li	t0,0
        for (int j = 0; j < N; ++j) {
   109a8:	88a2                	mv	a7,s0
   109aa:	837e                	mv	t1,t6
   109ac:	4e01                	li	t3,0
    for (int i = 0; i < N; ++i) {
   109ae:	86c6                	mv	a3,a7
   109b0:	8776                	mv	a4,t4
            int32_t sum = 0;
   109b2:	4601                	li	a2,0
                sum += A[row_base + k] * B[k * N + j];
   109b4:	430c                	lw	a1,0(a4)
   109b6:	429c                	lw	a5,0(a3)



   // ======================= O(N^3) ==========================
            for (int k = 0; k < N; ++k) {
   109b8:	0711                	addi	a4,a4,4
   109ba:	96aa                	add	a3,a3,a0

                sum += A[row_base + k] * B[k * N + j];
   109bc:	02b787bb          	mulw	a5,a5,a1
   109c0:	9e3d                	addw	a2,a2,a5

            for (int k = 0; k < N; ++k) {
   109c2:	ff0719e3          	bne	a4,a6,109b4 <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x2c>
   // ======================= END O(N^3) ==========================



            C[row_base + j] = sum;
   109c6:	00c32023          	sw	a2,0(t1)
        for (int j = 0; j < N; ++j) {
   109ca:	001e079b          	addiw	a5,t3,1
   109ce:	0311                	addi	t1,t1,4
   109d0:	0891                	addi	a7,a7,4
   109d2:	00ff0463          	beq	t5,a5,109da <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x52>
   109d6:	8e3e                	mv	t3,a5
   109d8:	bfd9                	j	109ae <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x26>
    for (int i = 0; i < N; ++i) {
   109da:	0012879b          	addiw	a5,t0,1
   109de:	8e9e                	mv	t4,t2
   109e0:	982a                	add	a6,a6,a0
   109e2:	9faa                	add	t6,t6,a0
   109e4:	01c28563          	beq	t0,t3,109ee <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x66>
   109e8:	82be                	mv	t0,a5
   109ea:	93aa                	add	t2,t2,a0
   109ec:	bf75                	j	109a8 <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x20>
}
   109ee:	6422                	ld	s0,8(sp)
   109f0:	0141                	addi	sp,sp,16
   109f2:	8082                	ret
   109f4:	8082                	ret
