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

            // MIN
            else if (opperation == 'n'){
                if (val1 < val2){
                    arr[threadIdx.x] = val1;
                }
                else {
                    arr[threadIdx.x] = val2;
                }
            }

            // SUM
            else if (opperation == 's'){
                // adjusting values to prevent calculation errors 
                arr[idx1] = 0;
                arr[idx2] = 0;
                float locSum = val1 + val2;
                arr[threadIdx.x] = locSum;
            }

            // PROUDUCT
            else if (opperation == 'p'){
                // adjusting values to prevent calculation errors 
                arr[idx1] = 1;
                arr[idx2] = 1;
                float locProd = val1 * val2;
                arr[threadIdx.x] = locProd;
            }
        }
    }
    __syncthreads();

    // edge case of the last two values that still need to be dealt with:

    // MAX
    if (opperation == 'x' && arr[0] < arr[1]){
        arr[0] = arr[1];
    }

    // MIN
    else if (opperation == 'n' && arr[0] > arr[1]){
        arr[0] = arr[1];
    }

    // SUM
    else if (opperation == 's'){
        arr[0] = arr[0] + arr[1];
    }

    // PRODUCT
    else if (opperation == 'p'){
        arr[0] = arr[0] * arr[1];
    }

    __syncthreads();
}

int main(){

    float *input;
    cudaMallocManaged(&input, (NUM_THDS*2)*sizeof(float));

    for (int i = 0; i < (NUM_THDS*2); i++) {
        input[i] = i;
    }

    lessThdDiv<<<1, NUM_THDS>>>(input, 'p');
    cudaDeviceSynchronize();
    // printf("max value in arr is: %f\n", input[0]);
    // printf("min value in arr is: %f\n", input[0]);
    // printf("sum of arr is: %f\n", input[0]);
    printf("product arr is: %f\n", input[0]);

    cudaFree(input);
}