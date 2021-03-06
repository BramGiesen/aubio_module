# Aubio Module
This repository is a wrapper around the Aubio library. This wrapper is made for the [PedalMangler](https://gitlab.com/csd-netwerk/dpf-plugins/pedalmangler-dpf) project. It is made so you can easliy switch between different detection types and methods, without worrying about buffersizes and hopsizes.

## How it works
The main part of the wrapper is the pure virtual base class (aubio_module.h). This class keeps track of the buffersize, hopsize and samplerate. Further more it also devides the incomming audio in the hopsizes. For this it uses the Hopbuffer class. This class makes buffers with the size of the buffersize but with the frequency of the hopsize.
This base class is pure virtual because of its audioDetector function. This function will be overwritten by the derrived clases holding the different algorithms. This way you can easily switch from an onset detector to a pitch detector if you wish so.

## Installation
To install this wrapper, add the repository as a submodule to your project.
~~~
git submodule add https://gitlab.hku.nl/csd-netwerk/aubio_module.git
~~~
Add the makefile to your own makefile or buildsystem of your choice.

## Usage
Include the needed `.h` files. Include `aubio_module.h` if you want to be able to switch between detectors. With the files included you can initialize the algorithms you want.

~~~
AubioModule* aubio;
AubioPitch pitch_detector;
AubioOnset onset_detector;

aubio = &pitch_detector; //now the pitch detector is selected
aubio = &onset_detector; //now the pitch detector is selected

float detected_value = aubio->process((float*)input_buffer);
~~~

As you can see in the example. You just call the `process()` function to see the result of the input buffer. The input buffer has to be a float pointer to buffer. The wrapper will take care of dividing it into the right hopbuffer.

## Parameters
#### Module:
- buffersize (`uint_t`)(8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192)
- hopsize (`uint_t`)(8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192)
- hopfactor (`uint_t`)(1, 2, 4, 8, 16) - alternative way to set hopsize
- samplerate (`uint_t`)(44100, 48000, 96000)
#### Pitch:
- Silence Threshold (`float`)(-90.0f - 0.0f)
- Methods (`string`)(Schmitt, fcomb, mcomb, yin, yinfast, yinfft)
#### Onset:
- Silence Threshold (`float`)(-90.0f - 0.0f)
- Onset Threshold (`float`)(0.0f - 1.0f)
- Methods (`string`)(energy, hfc, complex, phase, wphase, specdiff, kl, mkl, specflux);

