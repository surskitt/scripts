#!/usr/bin/python

import sys
import json
import xrp

x = xrp.parse_file(sys.argv[1], 'utf-8')

colors = {f'color{n}': [j for i, j in x.resources.items() if i.endswith(f'color{n}')][0]
          for n in range(16)}

special = {k: [j for i, j in x.resources.items() if i.endswith(k)][0]
           for k in ['foreground', 'background', 'cursor']}

out = {'colors': colors, 'special': special}

with open(sys.argv[2], 'w') as f:
    json.dump(out, f)
