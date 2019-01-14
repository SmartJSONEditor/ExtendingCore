//
//  MyAKSynthDSP.hpp
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#pragma once

#import <AVFoundation/AVFoundation.h>
#import "AKInterop.h"

typedef NS_ENUM(AUParameterAddress, MyAKSynthParameter)
{
    // ramped parameters
    
    MyAKSynthParameterMasterVolume,
    MyAKSynthParameterPitchBend,
    MyAKSynthParameterVibratoDepth,

    MyAKSynthParameterDrawbar1,
    MyAKSynthParameterDrawbar2,
    MyAKSynthParameterDrawbar3,
    MyAKSynthParameterDrawbar4,
    MyAKSynthParameterDrawbar5,
    MyAKSynthParameterDrawbar6,
    MyAKSynthParameterDrawbar7,
    MyAKSynthParameterDrawbar8,
    MyAKSynthParameterDrawbar9,
    MyAKSynthParameterDrawbar10,
    MyAKSynthParameterDrawbar11,
    MyAKSynthParameterDrawbar12,
    MyAKSynthParameterDrawbar13,
    MyAKSynthParameterDrawbar14,
    MyAKSynthParameterDrawbar15,
    MyAKSynthParameterDrawbar16,

    // simple parameters

    MyAKSynthParameterAttackDuration,
    MyAKSynthParameterDecayDuration,
    MyAKSynthParameterSustainLevel,
    MyAKSynthParameterReleaseDuration,

    // ensure this is always last in the list, to simplify parameter addressing
    MyAKSynthParameterRampDuration,
};

#ifndef __cplusplus

AKDSPRef createMyAKSynthDSP(int channelCount, double sampleRate);
void doMyAKSynthPlayNote(AKDSPRef pDSP, UInt8 noteNumber, UInt8 velocity, float noteFrequency);
void doMyAKSynthStopNote(AKDSPRef pDSP, UInt8 noteNumber, bool immediate);
void doMyAKSynthSustainPedal(AKDSPRef pDSP, bool pedalDown);

#else

#import "AKDSPBase.hpp"
#include "MyAKCoreSynth.hpp"
#import "AKLinearParameterRamp.hpp"

struct MyAKSynthDSP : AKDSPBase, MyAKCoreSynth
{
    // ramped parameters
    AKLinearParameterRamp masterVolumeRamp;
    AKLinearParameterRamp pitchBendRamp;
    AKLinearParameterRamp vibratoDepthRamp;
    AKLinearParameterRamp drawbarRamp[16];

    MyAKSynthDSP();
    void init(int channelCount, double sampleRate) override;
    void deinit() override;

    void setParameter(uint64_t address, float value, bool immediate) override;
    float getParameter(uint64_t address) override;
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif
