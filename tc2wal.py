#!/usr/bin/env python

import fileinput
import json

j = json.loads(''.join(fileinput.input()))

jp = {
    'colors': {f'color{n}': j[f'{n}'] for n in range(16)},
    'special': {k: j[k] if k in j else '#ffffff'
                for k in ['foreground', 'background', 'cursor']}
}

print(json.dumps(jp, indent=2))
