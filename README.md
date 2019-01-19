# ExtendingCore
This repo is all about writing your own extensions to AudioKit in C/C++, in the same style as  [AudioKitCore](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore).

You might want to do this if you want to implement, say, a polyphonic synthesizer in AudioKit, and you want to keep real-time DSP operations like mixing and modulation in C++ inside a single AudioKit "Node".

While AudioKit already offers an extensive collection of pre-built DSP nodes, it's not possible for us to offer every conceivable combination of low-level elements. Instead we provide, in [AudioKitCore](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore), a basic collection of elements plus a few fully composed examples (e.g. [AKSampler](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore/Sampler) and [AKModulatedDelay](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore/ModulatedDelay)). There is also a [basic "extending AudioKit" tutorial example](https://github.com/AudioKit/AudioKit/tree/master/Developer/macOS/ExtendingAudioKit) within the main AudioKit repo, which this repo builds upon.

## From DSP code to AudioKit Nodes
AudioKit is primarily a framework for programming audio in Swift. Because Swift's run-time overhead makes it not fast/efficient enough for real-time audio DSP, it's necessary to write the DSP parts (which Apple refers to as *kernels*) in C and/or C++. Making DSP code accessible from Swift involves adding several layers of code as follows.

First, the core C/C\++ code is wrapped in a thin Objective-C layer, to form the actual DSP kernel class, which inherits from the AudioKit class *AKDSPBase*. Because Swift code can connect to Objective-C code, and Objective-C code can connect directly to C/C\++ code, this Objective-C layer forms the "glue" between the Swift and C/C\++ layers.

Next, the DSP kernel is wrapped up into an *Audio Unit*, a very specific code structure which a part of the macOS or iOS operating systems (called [AVAudioEngine](https://developer.apple.com/documentation/avfoundation/avaudioengine)) can connect with others in a single real-time audio DSP signal path. Audio Units can be defined either in Objective-C or Swift, and naturally we use the Swift option, defining a Swift class which inherits from the AudioKit class *AKAudioUnitBase*. (Most synthesis units inherit from *AKAudioUnitBase* indirectly, through the instrument-specific subclass *AKGeneratorAudioUnitBase*.)

AudioKit implements a whole set of mechanisms to save AudioKit users from having to deal directly with the *AVAudioEngine*. These require the Swift *audio unit* class to be wrapped in yet another Swift class, which inherits from the AudioKit class *AKNode*. (Polyphonic synthesis units will usually inherit from the *AKNode* subclass *AKPolyphonicNode*.)

The end result of all these layers is that if we have Swift *AKNode*-derived classes *MySynth* and *MyEffect*, for example, we can write app-level code in Swift like this:
```swift
let synth = MySynth()
let effect = MyEffect()
synth >>> effect
synth.pitchBend = 0.5
effect.level = 0.9
...
```

## Suggested approach to prototyping and development
Based on [my](https://github.com/getdunne) experience with developing new code modules for [AudioKitCore](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore), I no longer recommend using AudioKit as a development platform for new C/C\++ code. Instead I like to use [JUCE](https://juce.com/), because it allows me to write everything (even a GUI) in C\++, on Windows or Linux, using IDEs like [Visual Studio](https://visualstudio.microsoft.com/) or [CLion](https://www.jetbrains.com/clion/), which offer a smoother C++ development workflow than Apple's [Xcode](https://developer.apple.com/xcode/).

Now, you might ask, "why not *only* use JUCE?" JUCE certainly has some nice advantages, especially if your goal is to create audio apps or DAW plug-ins for use on Windows, Mac, or Linux platforms, and especially if you would also like to deploy the same code on iOS or Android devices. However, JUCE has associated licensing costs and rules, and what can be a very steep learning curve. Furthermore, not everyone likes to write entire apps in C\++; Swift is arguably a much nicer language, and this is basically why we have AudioKit.

In terms of this repo, my goal is to create new modules for use with AudioKit, so that, once the low-level DSP code is written and tested, I and others can use it conveniently from Swift. Hence my development work-flow involves the following steps:
1. Define what I want to do--what DSP module I want to write.
2. Write low-level DSP code *as simply as possible* in C++.
3. Create a simple stand-alone app or plug-in using JUCE, to wrap my new DSP code while I'm still developing, testing, and expanding it.
4. Write Objective-C and Swift wrappers to make the new DSP code accessible from Swift as a new AudioKit Node object, using tools and techniques defined and described in these pages.
5. Write a simple AudioKit program to test and validate the new Node(s), including a GUI written in Swift for either iOS or macOS.
6. (If appropriate) Expand the new AudioKit app into a new AudioKit-based product.

The point of steps 1 and 2 is subtle but important. Creating useful, efficient, robust DSP code takes effort, and it's advisable to (1) have a clear plan for what you're making, and (2) keep your code simple, legible, and if at all possible, *platform-independent*, because you're likely to want to repurpose it later.

The point of step 3 is to develop your low-level DSP code using *appropriate* tools, which avoid the need to mix different programming languages, and facilitate debugging. I happen to like JUCE and Visual Studio; others might prefer the [Steinberg VST3 and ASIO SDKs](https://www.steinberg.net/en/company/developers.html), Oliver Larkin's [iPlug 2](https://iplug2.github.io/), or any of several audio frameworks available on Linux.

The biggest point about steps 4 and 5 is that they come *after* your DSP code is essentially done--written, debugged, and at least partly optimized. Once you get to step 5, you're dealing with a complex multi-language environment in Xcode, which is *not at all* ideal if you still have more debugging to do. At this stage, your goal should simply be to *validate* that all of your DSP code's functions and parameters are accessible from Swift, and that operations like parameter-updating can be done dynamically (not just prior to start-up) and execute smoothly with no audio glitching.

## What's here
This repo is the result of working through first 5 steps of the process described above, to create a new polyphonic synthesizer (polysynth) somewhat reminiscent of a [Hammond organ](https://en.wikipedia.org/wiki/Hammond_organ), which makes use of the [DrawbarsOscillator](https://github.com/AudioKit/AudioKit/blob/master/AudioKit/Core/AudioKitCore/Synth/DrawbarsOscillator.hpp) class from [AudioKitCore/Synth](https://github.com/AudioKit/AudioKit/tree/master/AudioKit/Core/AudioKitCore/Synth), and adds a simple distortion effect and an emulation of the [Leslie](https://en.wikipedia.org/wiki/Leslie_speaker) rotating-speaker effect which gave the Hammond organs part of their characteristic sound.

NOTE: The Leslie effect code is adapted from the [setBfree project](https://github.com/pantherb/setBfree) which is open-source, but *subject to the GPL license*, which does NOT permit its use in closed-source projects. (The [setBfree GitHub repo](https://github.com/pantherb/setBfree) specifies the GPL2, but the [actual code](https://github.com/pantherb/setBfree/blob/master/b_whirl/whirl.c) specifies that it may be used under the terms of any later version. I use the [GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html), which provides clarification for how GPL-licensed code can be used together with more permissive licenses, such as the [MIT license](https://opensource.org/licenses/MIT), which governs the rest of the code in this repo, as well as all of AudioKit.)

* The *Common* folder contains some new C++ classes which are written as part of *AudioKitCore* and are likely to move to that part of AudioKit in future.
* The *Leslie* folder contains the C Leslie-effect code from the [setBfree project](https://github.com/pantherb/setBfree), and my own C++ wrapper code.
* The *Organ* folder contains the rest of the Organ code example, including both a preliminary JUCE-based version and an AudioKit version.
* The *Python wrapper generator* folder contains template-based code generation tools which substantially automate the work of step 4 in the previous section.

See the *README.md* files in each folder for more details.
