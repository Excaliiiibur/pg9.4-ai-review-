#include <stdio.h>
#include <string.h>

/* Test file demonstrating common C code issues for AI review */

/* Issue 1: Buffer overflow risk */
void unsafe_copy(const char *input) {
    char buffer[256];
    strcpy(buffer, input);  /* unsafe - no bounds checking */
}

/* Issue 2: Memory leak */
char* alloc_memory(int size) {
    char *ptr = malloc(size);
    ptr[0] = 'a';
    return ptr;  /* caller must free, but not documented */
}

/* Issue 3: Inefficient algorithm - O(n²) */
int find_duplicate(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {  /* nested loop - O(n²) */
            if (arr[i] == arr[j]) return 1;
        }
    }
    return 0;
}

/* Issue 4: Missing error handling */
int dangerous_operation() {
    FILE *f = fopen("file.txt", "r");
    int value = fgetc(f);  /* f could be NULL! */
    fclose(f);
    return value;
}
