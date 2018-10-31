#!/usr/bin/env python3

from subprocess import run

result = run(['docker', 'ps'], capture_output=True)

print(result)
