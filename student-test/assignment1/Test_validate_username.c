#include "unity.h"
#include <stdbool.h>
#include <string.h>

#include "username-from-conf-file.h"

extern const char* my_username();

/**
* This function should:
*   1) Call the my_username() function in Test_assignment_validate.c to get your hard coded username.
*   2) Obtain the value returned from function malloc_username_from_conf_file() in username-from-conf-file.h within
*       the assignment autotest submodule at assignment-autotest/test/assignment1/
*   3) Use unity assertion TEST_ASSERT_EQUAL_STRING_MESSAGE to check the two strings are equal.
*/
void test_validate_my_username()
{
    const char* expected_username = my_username();
    char* actual_username = malloc_username_from_conf_file();

    TEST_ASSERT_EQUAL_STRING_MESSAGE(expected_username, actual_username, "Usernames do not match!");

    free(actual_username);
}

