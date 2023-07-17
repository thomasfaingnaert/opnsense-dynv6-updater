#!/usr/bin/env python3

import json

for file in ['+MANIFEST', '+COMPACT_MANIFEST']:
    with open(f'staging/{file}', 'r') as f:
        data = json.load(f)

    data['deps'] = {
            'bind-tools': {
                'origin': 'dns/bind-tools'
            }
    }

    with open(f'staging/{file}', 'w') as f:
        json.dump(data, f)
