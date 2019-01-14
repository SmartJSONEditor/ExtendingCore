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
    MyAKSynthParameterFilterCutoff,
    MyAKSynthParameterFilterStrength,
    MyAKSynthParameterFilterResonance,

    // simple parameters

    MyAKSynthParameterAttackDuration,
    MyAKSynthParameterDecayDuration,
    MyAKSynthParameterSustainLevel,
    MyAKSynthParameterReleaseDuration,
    MyAKSynthParameterFilterAttackDuration,
    MyAKSynthParameterFilterDecayDuration,
    MyAKSynthParameterFilterSustainLevel,
    MyAKSynthParameterFilterReleaseDuration,

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
    AKLinearParameterRamp filterCutoffRamp;
    AKLinearParameterRamp filterStrengthRamp;
    AKLinearParameterRamp filterResonanceRamp;
    
    MyAKSynthDSP();
    void init(int channelCount, double sampleRate) override;
    void deinit() override;

    void setParameter(uint64_t address, float value, bool immediate) override;
    float getParameter(uint64_t address) override;
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif
