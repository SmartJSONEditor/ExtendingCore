//
//  MyAKCoreSynth.hpp
//  AudioKit Core
//
//  Created by Shane Dunne, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

#ifdef __cplusplus
#include <memory>

#define AKSYNTH_CHUNKSIZE 16            // process samples in "chunks" this size

namespace AudioKitCore
{
    struct MySynthVoice;
}

class MyAKCoreSynth
{
public:
    MyAKCoreSynth();
    ~MyAKCoreSynth();
    
    /// returns system error code, nonzero only if a problem occurs
    int init(double sampleRate);
    
    /// call this to un-load all samples and clear the keymap
    void deinit();
    
    void playNote(unsigned noteNumber, unsigned velocity, float noteFrequency);
    void stopNote(unsigned noteNumber, bool immediate);
    void sustainPedal(bool down);
    void setMasterVolume(float vol) { masterVolume = vol; }
    float getMasterVolume() { return masterVolume; }
    void setPitchOffset(float offset) { pitchOffset = offset; }
    void setVibratoDepth(float depth) { vibratoDepth = depth; }
    
    void  setAmpAttackDurationSeconds(float value);
    float getAmpAttackDurationSeconds(void);
    void  setAmpDecayDurationSeconds(float value);
    float getAmpDecayDurationSeconds(void);
    void  setAmpSustainFraction(float value);
    float getAmpSustainFraction(void);
    void  setAmpReleaseDurationSeconds(float value);
    float getAmpReleaseDurationSeconds(void);

    // 9 Hammond-style drawbars
    void setDrawBar(int index, float value);
    float getDrawBar(int index);
    
    void render(unsigned channelCount, unsigned sampleCount, float *outBuffers[]);
    
protected:
 
    struct InternalData;
    std::unique_ptr<InternalData> data;
    
    /// "event" counter for voice-stealing (reallocation)
    unsigned eventCounter;
    
    // performance parameters
    float masterVolume, pitchOffset, vibratoDepth;
    
    void play(unsigned noteNumber, unsigned velocity, float noteFrequency);
    void stop(unsigned noteNumber, bool immediate);
    
    AudioKitCore::MySynthVoice *voicePlayingNote(unsigned noteNumber);
};

#endif
