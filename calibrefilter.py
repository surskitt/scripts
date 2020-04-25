#!/usr/bin/env python

import fileinput
import json


j = json.loads("".join(fileinput.input()))

for b in j:
    pdf = [i for i in b["formats"] if i.endswith("pdf")]
    epub = [i for i in b["formats"] if i.endswith("epub")]
    path = pdf or epub
    if not path:
        continue
    fn = path[0]

    title = b["title"]
    tags = ", ".join(b["*tags"])
    out = f"{title} ({tags})	{fn}"

    print(out)
