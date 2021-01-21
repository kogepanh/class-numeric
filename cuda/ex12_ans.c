#include <stdio.h>
__global__ void add(int *dc, int *da, int *db)
{
    const unsigned int td = threadIdx.x;
    dc[td] = da[td] + db[td];
}

int main(int argc, char **argv)
{
    int N = 5;
    int *ha = (int *)malloc(sizeof(int) * N);
    int *hb = (int *)malloc(sizeof(int) * N);
    int *hc = (int *)malloc(sizeof(int) * N);

    for (int i = 0; i < N; i++)
    {
        ha[i] = i;
        hb[i] = i * 10;
        hc[i] = 0;
    }

    int *da, *db, *dc;
    cudaMalloc((void **)&da, sizeof(int) * N);
    cudaMalloc((void **)&db, sizeof(int) * N);
    cudaMalloc((void **)&dc, sizeof(int) * N);

    cudaMemcpy(da, ha, sizeof(int) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(db, hb, sizeof(int) * N, cudaMemcpyHostToDevice);

    add<<<1, N>>>(dc, da, db);
    cudaMemcpy(hc, dc, sizeof(int) * N, cudaMemcpyDeviceToHost);

    // Print

    return 0;
}