from jinja2 import Environment, FileSystemLoader
import datetime

def capitalizeFirstLetterOnly(string):
    return string[:1].upper() + string[1:]

env = Environment(
    loader = FileSystemLoader('templates'),
    trim_blocks = True,
    lstrip_blocks = True
)
env.filters['capitalizeFirstLetterOnly'] = capitalizeFirstLetterOnly

vars = {
    'author': 'Shane Dunne',
    'year': str(datetime.datetime.now().year),
    'class': 'Organ',
    'AUID': 'AKor',
    'baseClass': 'Organ',
    'rampedParameters': [
        ('masterVolume', 1.0, 0.0, 1.0, 'fraction'),
        ('pitchBend', 2.0, -1000.0, 1000.0, 'semitones, signed'),
        ('vibratoDepth', 1.0, 0.0, 1000.0, 'semitones, usually < 1.0'),
        ('drawbar0', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar1', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar2', 1.0, 0.0, 1.0, 'fraction'),
        ('drawbar3', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar4', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar5', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar6', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar7', 0.0, 0.0, 1.0, 'fraction'),
        ('drawbar8', 0.0, 0.0, 1.0, 'fraction'),
        ],
    'rampedParameterInitValues': [
        
    ],
    'simpleParameters': [
        ('attackDuration', 0.0, 0.0, 10.0, 'seconds'),
        ('decayDuration', 0.0, 0.0, 10.0, 'seconds'),
        ('sustainLevel', 1.0, 0.0, 1.0, 'fraction'),
        ('releaseDuration', 0.0, 0.0, 10.0, 'seconds'),
        ('power', 1.0, 1.0, 2.0, 'arbitrary, 1.0 - 2.0'),
        ('drive', 1.0, 1.0, 2.5, 'arbitrary, 1.0 - 2.5'),
        ('outputLevel', 1.0, 1.0, 2.5, 'arbitrary, 1.0 - 2.5'),
        ('leslieSpeed', 4.0, 1.0, 8.0, 'arbitrary, 1 .. 8'),
    ],
    'chunkSize': 16
}

template = env.get_template('AKDSP.hpp')
with open('AKOrganDSP.hpp', 'w') as outfile:
    outfile.write(template.render(vars).encode('utf-8'))

template = env.get_template('AKDSP.mm')
with open('AKOrganDSP.mm', 'w') as outfile:
    outfile.write(template.render(vars).encode('utf-8'))

template = env.get_template('AKAudioUnit.swift')
with open('AKOrganAudioUnit.swift', 'w') as outfile:
    outfile.write(template.render(vars).encode('utf-8'))

template = env.get_template('AKNode.swift')
with open('AKOrgan.swift', 'w') as outfile:
    outfile.write(template.render(vars).encode('utf-8'))
