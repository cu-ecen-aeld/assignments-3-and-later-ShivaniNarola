#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

int main(int argc, char *argv[]) {
    openlog(NULL, 0, LOG_USER);

    if (argc != 3) {
        syslog(LOG_ERR, "Invalid number of arguments");
        return 1;
    }

    FILE *f = fopen(argv[1], "w");
    if (!f) {
        syslog(LOG_ERR, "Failed to open file: %s", argv[1]);
        return 1;
    }

    fprintf(f, "%s", argv[2]);
    fclose(f);

    syslog(LOG_DEBUG, "Writing %s to %s", argv[2], argv[1]);

    closelog();
    return 0;
}

