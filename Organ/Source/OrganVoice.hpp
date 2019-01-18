//
//  OrganVoice.hpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#pragma once
#include <math.h>

#include "VoiceBase.hpp"
#include "DrawbarsOscillator.hpp"
#include "ADSREnvelope.h"

namespace AudioKitCore
{
    struct OrganParameters
    {
        float drawbars[DrawbarsOscillator::phaseCount];
        float mixLevel;
    };

    struct OrganVoiceParameters
    {
        OrganParameters organ;
    };

    struct OrganModParameters
    {
        float masterVol;
        float phaseDeltaMul;
    };

    struct OrganVoice : public VoiceBase
    {
        DrawbarsOscillator drawBarOsc;
        ADSREnvelope ampEG;

        OrganVoice() : VoiceBase() {}
        virtual ~OrganVoice() = default;

        void init(double sampleRate,
                  WaveStack *pOscStack,
                  OrganVoiceParameters* pTimbreParameters,
                  OrganModParameters* pModParameters);

        void updateAmpAdsrParameters() { ampEG.updateParams(); }

        void start(unsigned evt, unsigned noteNum, unsigned velocity, float freqHz, float volume) override;
        void restart(unsigned evt, unsigned noteNum, unsigned velocity, float freqHz, float volume) override;
        void release(unsigned evt) override;
        bool isReleasing(void) override { return ampEG.isReleasing(); }
        void stop(unsigned evt) override;

        // return true if amp envelope is finished
        bool doModulation(void) override;
        bool getSamples(int sampleCount, float *leftOuput, float *rightOutput) override;
    };
}
