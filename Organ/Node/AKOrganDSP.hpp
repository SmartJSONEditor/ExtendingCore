//
//  AKOrganDSP.hpp
//  AudioKit
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2019 AudioKit. All rights reserved.
//

#pragma once

#import <AVFoundation/AVFoundation.h>
#import "AKInterop.h"

typedef NS_ENUM(AUParameterAddress, AKOrganParameter)
{
    // ramped parameters
    
    AKOrganParameterMasterVolume,
    AKOrganParameterPitchBend,
    AKOrganParameterVibratoDepth,
    AKOrganParameterDrawbar0,
    AKOrganParameterDrawbar1,
    AKOrganParameterDrawbar2,
    AKOrganParameterDrawbar3,
    AKOrganParameterDrawbar4,
    AKOrganParameterDrawbar5,
    AKOrganParameterDrawbar6,
    AKOrganParameterDrawbar7,
    AKOrganParameterDrawbar8,

    // simple parameters

    AKOrganParameterAttackDuration,
    AKOrganParameterDecayDuration,
    AKOrganParameterSustainLevel,
    AKOrganParameterReleaseDuration,
    AKOrganParameterPower,
    AKOrganParameterDrive,
    AKOrganParameterOutputLevel,

    // ensure this is always last in the list, to simplify parameter addressing
    AKOrganParameterRampDuration,
};

#ifndef __cplusplus

AKDSPRef createAKOrganDSP(int channelCount, double sampleRate);
void doAKOrganPlayNote(AKDSPRef pDSP, UInt8 noteNumber, UInt8 velocity, float noteFrequency);
void doAKOrganStopNote(AKDSPRef pDSP, UInt8 noteNumber, bool immediate);
void doAKOrganSustainPedal(AKDSPRef pDSP, bool pedalDown);

#else

#import "AKDSPBase.hpp"
#include "Organ.hpp"
#include "AKLinearParameterRamp.hpp"

struct AKOrganDSP : AKDSPBase, Organ
{
    // ramped parameters
    AKLinearParameterRamp masterVolumeRamp;
    AKLinearParameterRamp pitchBendRamp;
    AKLinearParameterRamp vibratoDepthRamp;
    AKLinearParameterRamp drawbar0Ramp;
    AKLinearParameterRamp drawbar1Ramp;
    AKLinearParameterRamp drawbar2Ramp;
    AKLinearParameterRamp drawbar3Ramp;
    AKLinearParameterRamp drawbar4Ramp;
    AKLinearParameterRamp drawbar5Ramp;
    AKLinearParameterRamp drawbar6Ramp;
    AKLinearParameterRamp drawbar7Ramp;
    AKLinearParameterRamp drawbar8Ramp;
    
    AKOrganDSP();
    void init(int channelCount, double sampleRate) override;
    void deinit() override;

    void setParameter(uint64_t address, float value, bool immediate) override;
    float getParameter(uint64_t address) override;
    
    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override;
};

#endif