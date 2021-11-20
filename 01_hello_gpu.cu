#include <stdio.h>
#include <cuda.h>

__global__ void helloFromGPU (int n)
{
	printf("Hello from GPU with grid %d, block %d, and thread %d\n", n, blockIdx.x, threadIdx.x);
	//printf("From:%d, %d ", n, blockIdx.x);
}

int main (void)
{
	helloFromGPU<<<1,10>>>(1);

	cudaDeviceSynchronize();

	helloFromGPU<<<10,1>>>(2);

	cudaDeviceSynchronize();

	printf("Hello CPU\n");

	return 0;
}
