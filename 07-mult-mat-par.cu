#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>

#define BLOCK_SIZE 16

__global__ void mult (double *a, double *b, double *c) {
    int tam = blockDim.x;
    int row=blockIdx.x*tam+threadIdx.x;
    int col=blockIdx.x*tam+threadIdx.x;

    if (row < tam && col < tam) {
        int sum = 0;
        for(int k=0;k<tam;k++) {
            sum += a[row*tam+k]*b[k*tam+col];
        }
        c[row*tam+col] = sum;
            
    }
}

int main(int argc,char **argv){
    //Declara as matrizes
    double *matrizA, *matrizB, *matrizC;
    double *dev_a, *dev_b, *dev_c;
    
    //Declara as variáveis de tamanho e índice
    int tam,i,j;
    printf("Teste");
    //Lê a dimensão da matriz
    fscanf(stdin,"%d\n",&tam); 
   


    //Aloca as matrizes A e B no hosto
    cudaMallocHost((void**) &matrizA, (tam*tam*sizeof(double)));
    cudaMallocHost((void**) &matrizB, (tam*tam*sizeof(double)));
    cudaMallocHost((void**) &matrizC, (tam*tam*sizeof(double)));



    //Lê as matrizes A e B
    for(i=0;i<tam;i++)
        for(j=0;j<tam;j++)
            fscanf(stdin, "%lf ", &dev_a[i * tam + j]);
    for(i=0;i<tam;i++)
        for(j=0;j<tam;j++)
            fscanf(stdin,"%lf ",&dev_b[i*tam+j]);


    //Aloca memória na GPU
    cudaMalloc( (void**)&dev_a, tam * sizeof(int));
    cudaMalloc( (void**)&dev_b, tam * sizeof(int));
    cudaMalloc( (void**)&dev_c, tam * sizeof(int));

    // Copia as matrizes para a memória do device
    cudaMemcpy(dev_a, matrizA, sizeof(int)*tam*tam, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, matrizB, sizeof(int)*tam*tam, cudaMemcpyHostToDevice);


    unsigned int grid_rows = (tam + BLOCK_SIZE - 1) / BLOCK_SIZE;
    unsigned int grid_cols = (tam + BLOCK_SIZE - 1) / BLOCK_SIZE;
    dim3 dimGrid(grid_cols, grid_rows);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);

    mult<<<dimGrid,dimBlock>>>(dev_a, dev_b, dev_c);


    matrizC=(double*)malloc(tam*tam*sizeof(double));
    cudaMemcpy(dev_c,matrizC, sizeof(int),cudaMemcpyDeviceToHost);

    //Imprime o resultado    
    for(i=0;i<tam;i++){
        for(j=0;j<tam;j++)
            printf("%.1lf ",matrizC[i*tam+j]);
        printf("\n");
    }
    cudaFree(dev_a);
    cudaFree(dev_b);
    cudaFree(dev_c);

    //Desaloca as matrizes
    free(matrizC);

    return 0;
}
