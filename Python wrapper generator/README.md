# audiokit-codegenerators
Wrapper generators for [AudioKit](https://github.com/AudioKit/AudioKit) nodes, based on [Jinja2](http://jinja.pocoo.org/) templates. This helps when creating new synth nodes based on C++ code in AudioKit Core and/or additional code written in a similar fashion.

Works fine in the Python v2.7 installed by default on macOS Mojave (or Windows, or Linux), BUT you'll need to install Jinja32 as
```
sudo easy_install Jinja2
```

Actually I did
```
sudo easy_install pip
sudo pip Jinja2
```
because I'm used to *pip*.

Once you've done that, run (in this directory):
```
python Organ.py
```
This will create four files, which collectively wrap the C++ *AKOrgan* class defined in *Organ/Source/Organ[.hpp|.cpp]*, for use in an AudioKit Swift program.
* *AKOrganDSP.hpp*: Objective-C header, based on *templates-synth/AKDSP.hpp*
* *AKOrgabDSP.mm*: Objective-C wrapper for *AKOrgan* C++ code, based on *templates-synth/AKDSP.mm*
* *AKOrganAudioUnit.swift*: Swift AU class, based on *templates-synth/AKAudioUnit.swift*
* *AKOrgan.swift*: Top-level *AKPolyphonicNode*-derived class, based on *templates-synth/AKNode.swift*

These template-generated files will get you 90% of the way to working code. You'll likely get a compile error in the top-level Swift file, owing to an extra comma being generated at the end of a function-arguments list; I saw no point in making the templates more complex just to make little issues like this go away. It's more helpful that the templates remain simple and legible, so you can understand the structure of the auto-generated code.
