#include "mex.h"

#define min(a, b)  (((a) < (b)) ? (a) : (b))
#define argmin(a, b)  (((a) < (b)) ? 0 : 1)
#define ptr(i1, i2) (3 * i2 + i1)

/* 
 * function v = maskPOver(Pt1, Pt2)
 *
 * History
 *   create  -  Feng Zhou, 11-09-2010
 *   modify  -  Feng Zhou, 09-03-2010
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

    // Pt1
    double *Pt1 = mxGetPr(prhs[0]);
    int nPt1 = mxGetN(prhs[0]);
    
    // Pt2
    double *Pt2 = mxGetPr(prhs[1]);
    int nPt2 = mxGetN(prhs[1]);
    
    // v
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *v = mxGetPr(plhs[0]);
    *v = 0;

    // search
    double i1, j1, i2, j2;
    int p1 = 0;
    int p2 = 0;
    while (p1 < nPt1 && p2 < nPt2) {
        i1 = Pt1[ptr(0, p1)];
        j1 = Pt1[ptr(1, p1)];
        i2 = Pt2[ptr(0, p2)];
        j2 = Pt2[ptr(1, p2)];

        if (i1 == i2 && j1 == j2) {
            *v = *v + Pt1[ptr(2, p1)] * Pt2[ptr(2, p2)];
            ++p1;
            ++p2;
        } else if (j1 < j2 || (j1 == j2 && i1 < i2)) {
            ++p1;
        } else {
            ++p2;
        }
    }
}
