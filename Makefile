PRGRM = aubio_module
TRGT =  aubio_module.o aubio_onset.o aubio_pitch.o hopbuffer.o aubio_through.o
OBJ = main.o $(addprefix src/, $(TRGT))

AUBIO_PATH = ../aubio

BASE_FLAGS += -I$(AUBIO_PATH)/src
CXXFLAGS := $(BASE_FLAGS) -Wall -g -std=c++11
CXXFLAGS +=
LDFLAGS =
LDLIBS = $(AUBIO_PATH)/libaubio.a
ifdef $(DEBUG_INFO)
CXXFLAGS += -ggdb
endif

all: $(PRGRM)

libs:
	$(MAKE) -C $(AUBIO_PATH)

# link the program
$(PRGRM): $(OBJ)
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

# builds given .o files dependend on their corresponding .cpp and .h files
%.o: %.cpp libs
	$(CXX) -c $(CXXFLAGS) $(CPPFLAGS) $< -o $@ $(LDLIBS)


# Compile tests of individual segments of the code.
debug: onset_test pitch_test none_test hop_test fvec_test

onset_test: src/aubio_onset_test.o src/aubio_onset.o src/aubio_module.o src/hopbuffer.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

pitch_test: src/aubio_pitch_test.o src/aubio_pitch.o src/aubio_module.o src/hopbuffer.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

none_test: src/aubio_through_test.o src/aubio_through.o src/aubio_module.o src/hopbuffer.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

hop_test: src/hopbuffer_test.o src/hopbuffer.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

fvec_test: src/fvec_test.o src/hopbuffer.o
	$(CXX) -o $@ $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS)

clean:
	rm $(PRGRM)
	rm $(OBJ)
	$(MAKE) clean -C $(AUBIO_PATH)

cleandebug:
	rm onset_test
	rm pitch_test
	rm none_test
	rm hop_test
	rm fvec_test
	rm src/*_test.o
	rm $(filter-out main.o,$(OBJ))


.PHONY: all clean cleandebug
