Q = [1 1; 1 1]
R = [1 0; 0 1]
N = [1 0; 0 1]

[K,S,e] = lqr(A,B,Q,R,N);
