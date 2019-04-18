CXXFLAGS += -Wall -std=c++11 \
   -Werror \
   -Wextra \
   -Wconversion \
   -Wno-deprecated \
   -Winit-self \
   -Wsign-conversion \
   -Wredundant-decls \
   -Wvla -Wshadow -Wctor-dtor-privacy -Wnon-virtual-dtor -Woverloaded-virtual \
   -Winit-self \
   -Wpointer-arith \
   -Wcast-qual \
   -Wcast-align \
   -Wdouble-promotion \
   -Wold-style-cast -Wno-error=old-style-cast \
   -Wsign-promo \
   -Wswitch-enum \
   -Wswitch-default \
   -Wundef \
   -MMD

CPPFLAGS += -I$(INC_DIR)

LDFLAGS += 	-lgtest_main \
			-lgtest \
			-lpthread \
			-pthread \
			-lgmock

EXE = BookConstructor
EXE_TEST = executeTests

SCR_DIR = src
INC_DIR = include
BUILD_DIR = build
TEST_DIR = gtests

SOURCES=$(wildcard $(SCR_DIR)/*.cpp)
OBJECTS=$(SOURCES:$(SCR_DIR)/%.cpp=$(BUILD_DIR)/%.o)

SOURCES_T=$(wildcard $(TEST_DIR)/*.cpp)
OBJECTS_T=$(SOURCES_T:$(TEST_DIR)/%.cpp=$(BUILD_DIR)/%.o) $(filter-out $(BUILD_DIR)/main.o, $(OBJECTS))

# --------------------------------------------------------------

.PHONY: all clean distclean

.DEFAULT_GOAL:= all

all: directories $(EXE)

#Make the Directories
directories:
	@mkdir -p $(BUILD_DIR)

# --------------------------------------------------------------

$(EXE): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o $@

# --------------------------------------------------------------

test: $(EXE_TEST)

$(EXE_TEST): $(OBJECTS_T)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@ #put LDFLAGS before objects and LDLIBS after

# --------------------------------------------------------------

$(BUILD_DIR)/%.o : $(SCR_DIR)/%.cpp #$(SCR_DIR)/%.h $(SCR_DIR)/%.d
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o : $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

-include $(OBJECTS:%.o=%.d) #(.d are dependency files automatically produced by -MMD flag)

clean:
	$(RM) $(BUILD_DIR)/* #delete all files(.o, .d)

distclean: clean
	$(RM) $(EXE)

print-%  : ; @echo $* = $($*)
