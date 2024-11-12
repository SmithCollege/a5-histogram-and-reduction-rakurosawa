#include <stdlib.h>
#include <stdio.h>

#define NUM_THDS 5
// #define BLOCK_SIZE 1024

__global__ void lessThdDiv(float* arr, char opperation){

    for (int i = NUM_THDS; i > 0; i /= 2){
        __syncthreads();
        if(threadIdx.x <= i){
            int idx1 = threadIdx.x * 2;
            float val1 = arr[idx1];
            int idx2 = (threadIdx.x * 2) + 1; 
            float val2 = arr[idx2];

            // MAX
            if (opperation == 'x'){
                if (val1 > val2){
                    arr[threadIdx.x] = val1;
                }
                else {
                    arr[threadIdx.x] = val2;
                }
            }
        }
    }
    __syncthreads();

    // edge case of the last two values still need to be dealt with:

    // MAX
    if (opperation == 'x'){
        if (arr[0] < arr[1]){
            arr[0] = arr[1];
        }
    }

    __syncthreads();
}

int main(){

    float *input;
    cudaMallocManaged(&input, (NUM_THDS*2)*sizeof(float));

    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = i;
        printf("%f, ", input[i]);
    }

    printf("\n");

    lessThdDiv<<<1, NUM_THDS>>>(input, 'x');
    cudaDeviceSynchronize();

    for (int i = 0; i < (NUM_THDS*2); i++) {
        printf("%f, ", input[i]);
    }
    printf("\n");

    cudaFree(input);
}