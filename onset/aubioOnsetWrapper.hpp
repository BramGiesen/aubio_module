#include <aubio/aubio.h>

class AubioWrapper {
    public:
        AubioWrapper();
        ~AubioWrapper();

        smpl_t process(fvec_t* inputBuffer);

        void setHopfactor(unsigned int hopfactor);

        void setSilenceThreshold(smpl_t silence_threshold);
        void setOnsetThreshold(smpl_t onset_threshold);

        //audio proccessing settings
        unsigned int buffersize = 512;
        unsigned int hopsize = 512;
        unsigned int samplerate = 48000;

    private:
        //output buffer
        fvec_t *onset;

        //onset detector
        aubio_onset_t* onset_detector;

        //onset detection settings
        const char_t* onset_method = "default";
        smpl_t silence_threshold = -90.0f;
        smpl_t onset_threshold = 0.5f;

};