#include <stdlib.h>
#include <stdio.h>

#define SIZE 10

int* cpuHisto(int* arr, int* histogram){

    for (int i = 0; i < SIZE; i ++){
        histogram[arr[i]] += 1;
    }

    return histogram;
}


int main() {

    int test_arr [SIZE] = {9, 1, 2, 3, 3, 6, 6, 7, 3, 9};
    int histogram [SIZE] = {0};

    for (int i = 0; i < SIZE; i ++){
        printf("%d  ", histogram[i]);
    }
    printf("\n");

    cpuHisto(test_arr, histogram);

    for (int i = 0; i < SIZE; i ++){
        printf("%d  ", histogram[i]);
    }
    printf("\n");


    return 0;
}