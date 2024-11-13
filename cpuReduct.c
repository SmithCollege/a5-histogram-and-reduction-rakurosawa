#include <stdlib.h>
#include <stdio.h>

int cpuReduct(float* arr, char* opperation){
    if (opperation == "max"){
        float max = arr[0];
        for (int i = 1; i < sizeof(arr); i++) {
            if (arr[i] > max){
                max = arr[i];
            }
        }
        return max;
    }
    else if (opperation == "min"){
        float min = arr[0];
        for (int i = 1; i < sizeof(arr); i++) {
            if (arr[i] < min){
                min = arr[i];
            }
        }
        return min;
    }
    else if (opperation == "sum"){
        float sum = 0.0;
        for (int i = 0; i < sizeof(arr); i++) {
            sum += arr[i];
        }
        return sum;
    }
    else if (opperation == "product"){
        float product = 1.0;
        for (int i = 0; i < sizeof(arr); i++) {
            product *= arr[i];
        }
        return product;
    }       
}

int main() {

    float small_test_arr[8] = {3.0, 1.0, 7.0, 0.0, 4.0, 1.0, 6.0, 3.0};

    printf("max value in arr is: %d\n", cpuReduct(small_test_arr, "max"));
    printf("min value in arr is: %d\n", cpuReduct(small_test_arr, "min"));
    printf("sum of arr is: %d\n", cpuReduct(small_test_arr, "sum"));
    printf("product of arr is: %d\n", cpuReduct(small_test_arr, "product"));


    return 0;
}