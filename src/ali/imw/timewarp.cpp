#include "mex.h"

#define ptr(i, j, c) (i + n1 * (j) + n1 * n2 * (c))

void mexFunction(int nlhs, mxArray *plhs[ ], int nrhs, const mxArray *prhs[ ]) {

    int i, j, n1, n2, k, p, p2, p3, c, dims[3];
    double *D, *A, *P, *L;
    double d, v, a;
    
    // input distance matrices
    D = mxGetPr(prhs[0]);
    n1 = mxGetM(prhs[0]);
    n2 = mxGetN(prhs[0]);
    k = int(mxGetScalar(prhs[1]));

    // accumulative distance path
    dims[0] = n1; dims[1] = n2; dims[2] = k;
    plhs[0] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    plhs[1] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    plhs[2] = mxCreateNumericArray(3, dims, mxDOUBLE_CLASS, mxREAL);
    A = mxGetPr(plhs[0]);
    P = mxGetPr(plhs[1]);
    L = mxGetPr(plhs[2]);
    
    // initialize
    a = 0;
    for (i = 0; i < n1; ++i) {
        for (j = 0; j < n2; ++j) {
            a += D[i * n2 + j];
        }
    }
    for (i = 0; i < n1; ++i) {
       for (j = 0; j < n2; ++j) {
           for (c = 0; c < k; ++c) {
                p = ptr(i, j, c);
                A[p] = a;
                P[p] = -1;
                L[p] = -1;
            }
        }
    }

    // dynamic programming
    for (i = 0; i < n1; ++i) {
        for (j = 0; j < n2; ++j) {
            p = j * n1 + i;
            d = D[p];
//            printf("%.2f\n", d);
            
            if (i == 0 && j == 0) {
                 A[p] = d;
                 P[p] = 0;
                 L[p] = 0;

            } else if (i == 0) {
                p2 = ptr(i, j, j);
                p3 = ptr(i, j - 1, j - 1);
//                printf("%d %d\n", p2, p3);

                if (j < k) {
                    A[p2] = A[p3] + d;
                    P[p2] = 1;
                    L[p2] = j;
                }
                
            } else if (j == 0) {
                // never happens

            } else {
                // from left
                for (c = 1; c < k; ++c) {
                    p2 = ptr(i, j, c);
                    p3 = ptr(i, j - 1, c - 1);
                    if (P[p3] != -1) {
                        A[p2] = A[p3] + d;
                        P[p2] = 1;
                        L[p2] = c;
                    }
                }

                // from upper-left
                p2 = ptr(i, j, 0);
                P[p2] = -1;
                A[p2] = a;
                for (c = 0; c < k; ++c) {
                    p3 = ptr(i - 1, j - 1, c);
                    v = A[p3] + d;
                    if (P[p3] != -1 && v < A[p2]) {
                        A[p2] = v;
                        P[p2] = 3;
                        L[p2] = c + 1;
                    }
                }
            }
        }
    }
}
