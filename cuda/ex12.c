#include <stdio.h>
__global__ void addKernel(int *c, const int *a, const int *b, int size)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < size)
    {
        c[i] = a[i] + b[i];
    }
}

// ベクトルを並列に追加するための関数
void addWithCuda(int *c, const int *a, const int *b, int size)
{
    int *dev_a = nullptr;
    int *dev_b = nullptr;
    int *dev_c = nullptr;

    // 3つのベクトルにGPUバッファを割り当てる
    cudaMalloc((void **)&dev_c, size * sizeof(int));
    cudaMalloc((void **)&dev_a, size * sizeof(int));
    cudaMalloc((void **)&dev_b, size * sizeof(int));

    // 入力ベクトルをGPUバッファにコピーする
    cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);

    // カーネルを起動する
    addKernel<<<2, (size + 1) / 2>>>(dev_c, dev_a, dev_b, size);

    // カーネルが終了するまでエラーを返す
    cudaDeviceSynchronize();

    // 出力ベクトルをホストメモリにコピーする
    cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
}

int main(int argc, char **argv)
{
    const int arraySize = 5;
    const int a[arraySize] = {1, 2, 3, 4, 5};
    const int b[arraySize] = {10, 20, 30, 40, 50};
    int c[arraySize] = {0};

    addWithCuda(c, a, b, arraySize);
    cudaDeviceReset();
    return 0;
}
