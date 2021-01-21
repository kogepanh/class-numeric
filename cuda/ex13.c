#include <stdio.h>
#include <stdlib.h>
__global__ void add(int *da, int *db, int *dc)
{
    const unsigned int xid = threadIdx.x + blockIdx.x * blockDim.x;
    const unsigned int yid = threadIdx.y + blockIdx.y * blockDim.y;
    int idx = xid * N + yid;

    if (xid < N && yid < N)
    {
        int x = 0;
        for (int i = 0; i < N; i++)
        {
            x += da[xid * N + i] * db[i * N + yid];
        }
        dc[idx] = x;
    }
}

int main(int argc, char **argv)
{
    int Nx, Ny, id;
    int *ha = (int *)malloc(sizeof(int) * Nx * Ny);
    int *hb = (int *)malloc(sizeof(int) * Nx * Ny);
    int *hc = (int *)malloc(sizeof(int) * Nx * Ny);

    // 初期値の代入

    int *da, *db, *dc;
    cudaMalloc((void **)&da, sizeof(int) * Nx * Ny);
    cudaMalloc((void **)&db, sizeof(int) * Nx * Ny);
    cudaMalloc((void **)&dc, sizeof(int) * Nx * Ny);

    cudaMemcpy(da, ha, sizeof(int) * Nx * Ny, cudaMemcpyHostToDevice);
    cudaMemcpy(db, hb, sizeof(int) * Nx * Ny, cudaMemcpyHostToDevice);

    add<<<1, N>>>(dc, da, db);
    cudaMemcpy(hc, dc, sizeof(int) * Nx * Ny, cudaMemcpyDeviceToHost);

    // Print

    return 0;
}