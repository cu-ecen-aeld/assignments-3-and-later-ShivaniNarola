#include "unity.h"
#include <stdbool.h>
#include <string.h>

extern const char* my_username();

void test_validate_my_username()
{
    TEST_ASSERT_TRUE(strcmp(my_username(), "ShivaniNarola") == 0);
}

