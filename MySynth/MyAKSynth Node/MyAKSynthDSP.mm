//
//  MyAKSynthDSP.cpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#import "MyAKSynthDSP.hpp"
#include <math.h>

extern "C" void *createMyAKSynthDSP(int channelCount, double sampleRate) {
    return new MyAKSynthDSP();
}

extern "C" void doMyAKSynthPlayNote(void *pDSP, UInt8 noteNumber, UInt8 velocity, float noteFrequency)
{
    ((MyAKSynthDSP*)pDSP)->playNote(noteNumber, velocity, noteFrequency);
}

extern "C" void doMyAKSynthStopNote(void *pDSP, UInt8 noteNumber, bool immediate)
{
    ((MyAKSynthDSP*)pDSP)->stopNote(noteNumber, immediate);
}

extern "C" void doMyAKSynthSustainPedal(void *pDSP, bool pedalDown)
{
    ((MyAKSynthDSP*)pDSP)->sustainPedal(pedalDown);
}


MyAKSynthDSP::MyAKSynthDSP() : MyAKCoreSynth()
{
    masterVolumeRamp.setTarget(1.0, true);
    pitchBendRamp.setTarget(0.0, true);
    vibratoDepthRamp.setTarget(0.0, true);
}

void MyAKSynthDSP::init(int channelCount, double sampleRate)
{
    AKDSPBase::init(channelCount, sampleRate);
    MyAKCoreSynth::init(sampleRate);
}

void MyAKSynthDSP::deinit()
{
    MyAKCoreSynth::deinit();
}

void MyAKSynthDSP::setParameter(uint64_t address, float value, bool immediate)
{
    switch (address) {
        case MyAKSynthParameterRampDuration:
            masterVolumeRamp.setRampDuration(value, sampleRate);
            pitchBendRamp.setRampDuration(value, sampleRate);
            vibratoDepthRamp.setRampDuration(value, sampleRate);
            break;

        case MyAKSynthParameterMasterVolume:
            masterVolumeRamp.setTarget(value, immediate);
            break;
        case MyAKSynthParameterPitchBend:
            pitchBendRamp.setTarget(value, immediate);
            break;
        case MyAKSynthParameterVibratoDepth:
            vibratoDepthRamp.setTarget(value, immediate);
            break;

        case MyAKSynthParameterDrawbar1:
        case MyAKSynthParameterDrawbar2:
        case MyAKSynthParameterDrawbar3:
        case MyAKSynthParameterDrawbar4:
        case MyAKSynthParameterDrawbar5:
        case MyAKSynthParameterDrawbar6:
        case MyAKSynthParameterDrawbar7:
        case MyAKSynthParameterDrawbar8:
        case MyAKSynthParameterDrawbar9:
        case MyAKSynthParameterDrawbar10:
        case MyAKSynthParameterDrawbar11:
        case MyAKSynthParameterDrawbar12:
        case MyAKSynthParameterDrawbar13:
        case MyAKSynthParameterDrawbar14:
        case MyAKSynthParameterDrawbar15:
        case MyAKSynthParameterDrawbar16:
            drawbarRamp[address - MyAKSynthParameterDrawbar1].setTarget(value, immediate);
            break;

        case MyAKSynthParameterAttackDuration:
            setAmpAttackDurationSeconds(value);
            break;
        case MyAKSynthParameterDecayDuration:
            setAmpDecayDurationSeconds(value);
            break;
        case MyAKSynthParameterSustainLevel:
            setAmpSustainFraction(value);
            break;
        case MyAKSynthParameterReleaseDuration:
            setAmpReleaseDurationSeconds(value);
            break;
    }
}

float MyAKSynthDSP::getParameter(uint64_t address)
{
    switch (address) {
        case MyAKSynthParameterRampDuration:
            return pitchBendRamp.getRampDuration(sampleRate);

        case MyAKSynthParameterMasterVolume:
            return masterVolumeRamp.getTarget();
        case MyAKSynthParameterPitchBend:
            return pitchBendRamp.getTarget();
        case MyAKSynthParameterVibratoDepth:
            return vibratoDepthRamp.getTarget();

        case MyAKSynthParameterDrawbar1:
        case MyAKSynthParameterDrawbar2:
        case MyAKSynthParameterDrawbar3:
        case MyAKSynthParameterDrawbar4:
        case MyAKSynthParameterDrawbar5:
        case MyAKSynthParameterDrawbar6:
        case MyAKSynthParameterDrawbar7:
        case MyAKSynthParameterDrawbar8:
        case MyAKSynthParameterDrawbar9:
        case MyAKSynthParameterDrawbar10:
        case MyAKSynthParameterDrawbar11:
        case MyAKSynthParameterDrawbar12:
        case MyAKSynthParameterDrawbar13:
        case MyAKSynthParameterDrawbar14:
        case MyAKSynthParameterDrawbar15:
        case MyAKSynthParameterDrawbar16:
            return drawbarRamp[address - MyAKSynthParameterDrawbar1].getTarget();

        case MyAKSynthParameterAttackDuration:
            return getAmpAttackDurationSeconds();
        case MyAKSynthParameterDecayDuration:
            return getAmpDecayDurationSeconds();
        case MyAKSynthParameterSustainLevel:
            return getAmpSustainFraction();
        case MyAKSynthParameterReleaseDuration:
            return getAmpReleaseDurationSeconds();
    }
    return 0;
}

void MyAKSynthDSP::process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset)
{
    // process in chunks of maximum length CHUNKSIZE
    for (int frameIndex = 0; frameIndex < frameCount; frameIndex += AKSYNTH_CHUNKSIZE) {
        int frameOffset = int(frameIndex + bufferOffset);
        int chunkSize = frameCount - frameIndex;
        if (chunkSize > AKSYNTH_CHUNKSIZE) chunkSize = AKSYNTH_CHUNKSIZE;

        // ramp parameters
        masterVolumeRamp.advanceTo(now + frameOffset);
        masterVolume = (float)masterVolumeRamp.getValue();
        pitchBendRamp.advanceTo(now + frameOffset);
        pitchOffset = (float)pitchBendRamp.getValue();
        vibratoDepthRamp.advanceTo(now + frameOffset);
        vibratoDepth = (float)vibratoDepthRamp.getValue();
        for (int i = 0; i < 16; i++)
        {
            drawbarRamp[i].advanceTo(now + frameOffset);
            setDrawBar(i, (float)drawbarRamp[i].getValue());
        }

        // get data
        float *outBuffers[2];
        outBuffers[0] = (float *)outBufferListPtr->mBuffers[0].mData + frameOffset;
        outBuffers[1] = (float *)outBufferListPtr->mBuffers[1].mData + frameOffset;
        unsigned channelCount = outBufferListPtr->mNumberBuffers;
        MyAKCoreSynth::render(channelCount, chunkSize, outBuffers);
    }
}
