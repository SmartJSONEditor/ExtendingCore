//
//  MySynthVoice.hpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#pragma once
#include <math.h>

#include "DrawbarsOscillator.hpp"
#include "ADSREnvelope.h"

namespace AudioKitCore
{
    struct OrganParameters
    {
        float drawbars[DrawbarsOscillator::phaseCount];
        float mixLevel;
    };

    struct MySynthVoiceParameters
    {
        OrganParameters organ;
    };

    struct MySynthVoice
    {
        MySynthVoiceParameters *pParameters;

        DrawbarsOscillator drawBarOsc;
        ADSREnvelope ampEG;

        unsigned event;     // last "event number" associated with this voice
        int noteNumber;     // MIDI note number, or -1 if not playing any note
        float noteFrequency;// note frequency in Hz
        float noteVolume;      // fraction 0.0 - 1.0, based on MIDI velocity

        // temporary holding variables
        int newNoteNumber;  // holds new note number while damping note before restarting
        float newNoteVol;   // holds new note volume while damping note before restarting
        float tempGain;     // product of global volume, note volume, and amp EG

        MySynthVoice() : noteNumber(-1) {}

        void init(double sampleRate,
                  WaveStack *pOscStack,
                  MySynthVoiceParameters *pParameters);

        void updateAmpAdsrParameters() { ampEG.updateParams(); }

        void start(unsigned evt, unsigned noteNumber, float frequency, float volume);
        void restart(unsigned evt, float volume);
        void restart(unsigned evt, unsigned noteNumber, float frequency, float volume);
        void release(unsigned evt);
        void stop(unsigned evt);

        // return true if amp envelope is finished
        bool prepToGetSamples(float masterVol,
                              float phaseDeltaMultiplier,
                              float cutoffMultiple,
                              float cutoffStrength,
                              float resLinear);
        bool getSamples(int sampleCount, float *leftOuput, float *rightOutput);
    };
}
