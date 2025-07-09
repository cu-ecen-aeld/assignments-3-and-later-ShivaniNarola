#include "systemcalls.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <stdbool.h>

/**
 * @brief Use the system() function to run a command.
 *
 * @param cmd Command to execute using system()
 * @return true if system() returns 0, false otherwise.
 */
bool do_system(const char *cmd)
{
    if (cmd == NULL) return false;
    int ret = system(cmd);
    return (ret == 0);
}

/**
 * @brief Use fork() and execv() to execute a command.
 *
 * @param count Number of arguments (including program)
 * @param ... Arguments (first one should be full path to executable)
 * @return true if the command succeeded, false otherwise.
 */
bool do_exec(int count, ...)
{
    va_list args;
    va_start(args, count);

    char *command[count + 1]; // +1 for NULL at the end
    for (int i = 0; i < count; i++) {
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;
    va_end(args);

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork failed");
        return false;
    } else if (pid == 0) {
        execv(command[0], command);
        perror("execv failed");
        exit(EXIT_FAILURE);
    } else {
        int status;
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid failed");
            return false;
        }
        return WIFEXITED(status) && WEXITSTATUS(status) == 0;
    }
}

/**
 * @brief Use fork(), execv(), and redirect output to a file.
 *
 * @param outputfile Path to file where stdout should be redirected
 * @param count Number of arguments (including program)
 * @param ... Arguments (first one should be full path to executable)
 * @return true if the command succeeded, false otherwise.
 */
bool do_exec_redirect(const char *outputfile, int count, ...)
{
    va_list args;
    va_start(args, count);

    char *command[count + 1];
    for (int i = 0; i < count; i++) {
        command[i] = va_arg(args, char *);
    }
    command[count] = NULL;
    va_end(args);

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork failed");
        return false;
    } else if (pid == 0) {
        int fd = open(outputfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd == -1) {
            perror("open failed");
            exit(EXIT_FAILURE);
        }
        dup2(fd, STDOUT_FILENO); // redirect stdout to file
        close(fd);

        execv(command[0], command);
        perror("execv failed");
        exit(EXIT_FAILURE);
    } else {
        int status;
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid failed");
            return false;
        }
        return WIFEXITED(status) && WEXITSTATUS(status) == 0;
    }
}

