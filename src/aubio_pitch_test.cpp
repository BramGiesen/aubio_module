#include <iostream>
#include <math.h>

#include "aubio_pitch.hpp"

#define PI_2 6.28318530717959

int main() {

    AubioPitch pitch_detector;
    pitch_detector.setPitchMethod("yin");
    pitch_detector.setPitchOutput("Hz");

    std::cout << "This is a Test of the AubioPitch class. A buffer of " << pitch_detector.getBuffersize() << " samples long filled with a sine is put through the algorithm. We see the input first and then the output in Hz and as a midi note." << std::endl;

    float sin_freq = 880.0f;
    float sin_Fs = 48000.0f;
    float sin_phase = 0.0f;  //range from 0.0f to 1.0f

    std::cout << "Input: sine " << sin_freq << "Hz @ " << sin_Fs << "Hz" << std::endl;

    // Test signal initialisation (only one buffer in length)
    float* tempbuffer = new float[pitch_detector.getBuffersize()];
    for(unsigned int i = 0; i < pitch_detector.getBuffersize(); i++) {
        sin_phase += sin_freq / sin_Fs;
        if(sin_phase >= 1) {
            sin_phase = sin_phase - 1; //wrap phase from 0 to 1
        }
        tempbuffer[i] = sin(sin_phase * PI_2 );
    }

    // Run the buffer through Aubio and print the answer
    float freq = pitch_detector.process(tempbuffer);
    std::cout << "Detected frequency: " << freq << "Hz" << std::endl;

    pitch_detector.setPitchOutput("midi");
    int pitch = pitch_detector.process(tempbuffer);
    std::cout << "Detected pitch: midinote " << pitch << std::endl;

    std::cout << "Detection confidence " << pitch_detector.getPitchConfidence() << std::endl;

    // Garbage collection
    delete [] tempbuffer;

    return 0;
}

