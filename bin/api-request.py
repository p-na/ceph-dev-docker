#!/usr/bin/env python3
"""
Usage: api-request.py <method> <path> [<data>] [--raw]

<method>    post, get, put, delete or custom one
<path>      Path to the request except the '/api' prefix
<data>      JSON data

Options:
    --raw   Do not format the body of the response.

Note: api-request.py does only print the JSON body of the response to stdout,
all other messages are printed to stderr.  This has the nice side effect that
the output can directly be piped to `jq` to beautify or filter the response.

Example:

    Create an OSD:

        ./api-request.py post osd '{"uuid": "4f576c1e-93e0-4d81-bec9-098d5393e9d3", "svc_id": 5}'

    Get OSD data:

        ./api-request.py get osd/0 | jq
"""

import requests
import docopt
import subprocess
import json
import urllib3
import sys
import os
from pygments.lexers import PythonTracebackLexer
from pygments import highlight
from pygments.formatters import TerminalFormatter
from pprint import pprint, pformat
from colors import red, green

urllib3.disable_warnings()

TIMEOUT = 30


def get_api_url():
    key_error_found = False
    while True:
        try:
            result = subprocess.run(
                ['/ceph/build/bin/ceph', 'mgr', 'services'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True,
                timeout=5,
                cwd='/ceph/build')
            result = json.loads(result.stdout)['dashboard']
            if key_error_found:
                sys.stdout.write(os.linesep)
                sys.stdout.flush()
            return result
        except subprocess.TimeoutExpired:
            print(
                'Timeout expired while trying to get API URL, re-trying...',
                file=sys.stderr)
        except KeyboardInterrupt:
            sys.exit('Aborting...')
        except KeyError:
            if key_error_found:
                sys.stderr.write('.')
                sys.stderr.flush()
            else:
                key_error_found = True
                msg = 'No API URL available! Check the output of ' + \
                    '`ceph mgr services`. Waiting'
                print(msg, file=sys.stderr, end='')
        except json.JSONDecodeError:
            sys.exit(red('Error decoding JSON'), file=sys.stderr)


def log_in(session, api_url):
    resp = session.post(
        api_url + 'api/auth',
        json={
            'username': 'admin',
            'password': 'admin',
        },
        verify=False)
    resp.raise_for_status()
    return resp.json()


def bold(text):
    return '\033[1m' + str(text) + '\033[0m'


if __name__ == '__main__':
    args = docopt.docopt(__doc__)
    session = requests.Session()
    api_url = get_api_url()
    data = log_in(session, api_url)
    headers = {'Authorization': 'Bearer {}'.format(data['token'])}
    url = api_url + 'api/' + args['<path>']
    try:
        resp = session.request(
            args['<method>'],
            url,
            json=args['<data>'],
            verify=False,
            timeout=TIMEOUT,
            headers=headers)
    except requests.exceptions.ReadTimeout:
        msg = 'Request timed out after {} seconds '.format(TIMEOUT) + \
            '(client-side)'
        sys.exit(red(msg))

    data_str = 'with' if args['<data>'] else 'without'
    status_code = resp.status_code
    failed = False
    if str(status_code).startswith('2'):
        status_code = bold(green(status_code))
    else:
        status_code = bold(red(status_code))
        failed = True
    print(
        '{} to {} {} payload data returned status code {}'.format(
            bold(args['<method>'].upper()), bold(url), bold(data_str),
            status_code),
        file=sys.stderr)
    if args['<data>']:
        print(bold('Data: '), file=sys.stderr)
        print(pformat(json.loads(args['<data>'])), file=sys.stderr)

    print(bold('Response:'), file=sys.stderr)
    body = resp.json()
    if body:
        if 'traceback' in body and not args['--raw']:
            traceback = body['traceback']
            del body['traceback']
            print('Details: ' + body['detail'], file=sys.stderr)
            print('Status: ' + body['status'], file=sys.stderr)
            print(
                'Traceback: ' + highlight(traceback, PythonTracebackLexer(),
                                          TerminalFormatter()),
                file=sys.stderr)
        else:
            print(json.dumps(resp.json()))
    else:
        print('Response didn\'t contain a body', file=sys.stderr)

    if failed:
        sys.exit()
