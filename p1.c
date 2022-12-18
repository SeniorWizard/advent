#include <stdio.h>
#include <stdlib.h>

void maxbuf(long *max, int n, long sum) {
    for (int j = 0; j < n; j++) {
        if (sum <= max[j]) continue;
        for (int k = n-1; k > j; k--) max[k] = max[k-1];
        max[j] = sum;
        break;
    }
}

int main(void) {
    char line[64];
    long buf[3] = {0}, sum = 0;
    FILE *fp;
    fp = fopen("i1.txt", "r");
    while(fgets(line,sizeof(line),fp) != NULL) {
        if (line[0] == '\n' || line[0] == '\r') {
            maxbuf(buf,3,sum);
            sum = 0;
            continue;
        }

        sum += strtol(line,NULL,10);
    }
    printf("Elf is carrying max %ld cals.\n", buf[0]);
    printf("Top three Elfs carries %ld cals.\n", buf[0]+buf[1]+buf[2]);
    return 0;
}
