#include <stdlib.h>
#include <stdio.h>

#define NUM_THDS 2048
#define BLOCK_SIZE 1024

__global__ void gpuReduct(float* arr, char opperation){
    
    int globalIdx = threadIdx.x + (BLOCK_SIZE * blockIdx.x);

    for (int i = 1; i < (NUM_THDS*2); i *= 2){
        __syncthreads();
        if (globalIdx % i == 0){
            // initialize values for threads to use
            int idx1 = globalIdx * 2 ;
            float val1 = arr[idx1];
            int idx2 = (globalIdx * 2) + i;
            float val2 = arr[idx2];

            // MAX
            if (opperation == 'x'){
                if (val1 > val2){
                    arr[idx1] = val1;
                }
                else {
                    arr[idx1] = val2;
                }
            }
            
            // MIN
            else if (opperation == 'n'){
                if (val1 < val2){
                    arr[idx1] = val1;
                }
                else {
                    arr[idx1] = val2;
                }
            }

            // SUM
            else if (opperation == 's'){
                float locSum = val1 + val2;
                arr[idx1] = locSum;
            }

            // PROUDUCT
            else if (opperation == 'p'){
                float locProd = val1 * val2;
                arr[idx1] = locProd;
            }
        }
    }
    
    __syncthreads();
        
}


int main(){

    float *input;
    cudaMallocManaged(&input, (NUM_THDS*2)*sizeof(float));


    // MAX
    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = 1.0;
    }
    input[0] = 0.0;

    gpuReduct<<<NUM_THDS/BLOCK_SIZE, BLOCK_SIZE>>>(input, 'x');
    cudaDeviceSynchronize();
    printf("max value in arr is: %f\n", input[0]);

    // MIN
    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = 1.0;
    }
    input[0] = 0.0;

    gpuReduct<<<NUM_THDS/BLOCK_SIZE, BLOCK_SIZE>>>(input, 'n');
    cudaDeviceSynchronize();
    printf("min value in arr is: %f\n", input[0]);

    // SUM
    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = 1.0;
    }
    input[0] = 0.0;

    gpuReduct<<<NUM_THDS/BLOCK_SIZE, BLOCK_SIZE>>>(input, 's');
    cudaDeviceSynchronize();
    printf("sum of arr is: %f\n", input[0]);

    // PRODUCT
    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = 1.0;
    }
    input[0] = 0.0;

    gpuReduct<<<NUM_THDS/BLOCK_SIZE, BLOCK_SIZE>>>(input, 'p');
    cudaDeviceSynchronize();
    printf("product arr is: %f\n", input[0]);

    cudaFree(input);
}