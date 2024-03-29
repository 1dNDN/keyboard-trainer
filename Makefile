CC = g++

APP_NAME = keyboard_ninja
LIB_NAME = keyboard_ninja_lib
TEST_NAME = test

CFLAGS = -Wall -Wextra -lstdc++ -lm
CPPFLAGS = -I src -MP -MMD

BIN_DIR = bin
OBJ_DIR = obj
SRC_DIR = src
TEST_DIR = test

APP_PATH = $(BIN_DIR)/$(APP_NAME)
LIB_PATH = $(OBJ_DIR)/$(SRC_DIR)/$(LIB_NAME)/$(LIB_NAME).a
TEST_PATH = $(BIN_DIR)/$(TEST_DIR)
APP_FOLDER_PATH = $(OBJ_DIR)/$(SRC_DIR)/$(APP_NAME)
LIB_FOLDER_PATH = $(OBJ_DIR)/$(SRC_DIR)/$(LIB_NAME)
TEST_FOLDER_PATH = $(OBJ_DIR)/$(TEST_DIR)

BUILD_FOLD := $(shell mkdir -p $(BIN_DIR))
BUILD_FOLD := $(shell mkdir -p $(APP_FOLDER_PATH))
BUILD_FOLD := $(shell mkdir -p $(LIB_FOLDER_PATH))
BUILD_FOLD := $(shell mkdir -p $(TEST_FOLDER_PATH))

SRC_EXT = cpp

APP_SRC = $(shell find $(SRC_DIR)/$(APP_NAME) -name '*.$(SRC_EXT)')
APP_OBJ = $(APP_SRC:$(SRC_DIR)/%.$(SRC_EXT)=$(OBJ_DIR)/$(SRC_DIR)/%.o)

LIB_SRC = $(shell find $(SRC_DIR)/$(LIB_NAME) -name '*.$(SRC_EXT)')
LIB_OBJ = $(LIB_SRC:$(SRC_DIR)/%.$(SRC_EXT)=$(OBJ_DIR)/$(SRC_DIR)/%.o)

TEST_SRC = $(shell find test -name '*.$(SRC_EXT)')
TEST_OBJ = $(TEST_SRC:test/%.cpp=obj/test/%.o)

DEPS = $(APP_OBJ:.o=.d) $(LIB_OBJ:.o=.d) $(TEST_OBJ:.o=.d)

.PHONY: all test clean
all: $(APP_PATH)

-include $(DEPS)
	
$(APP_PATH): $(APP_OBJ) $(LIB_PATH)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@ 

$(LIB_PATH): $(LIB_OBJ)
	ar rcs $@ $^

$(OBJ_DIR)/%.o: %.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -I thirdparty $< -o $@ -lm
	
test: $(TEST_PATH)
-include $(DEPS)
$(TEST_PATH): $(TEST_OBJ) $(LIB_PATH)
	$(CC) $(CFLAGS) -I thirdparty $^ -o $@ -lm

clean:
	$(RM) $(APP_PATH) $(LIB_PATH) $(TEST_PATH)
	find $(OBJ_DIR) -name '*.o' -exec $(RM) '{}' \;
	find $(OBJ_DIR) -name '*.d' -exec $(RM) '{}' \;
	