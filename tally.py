import os
import time
import tempfile
from gzip import open as gzip_open
from mailbox import mbox
from dateutil import parser
import dataset

LOCAL = 'data'

engine = dataset.connect('sqlite:///okfn.sqlite3')
mail_table = engine['okfn_mail']

for dirname, fn, files in os.walk(LOCAL):
    list_name = dirname[len(LOCAL) + 1:]
    print list_name, dirname, files
    for file_name in files:
        path = os.path.join(dirname, file_name)
        with gzip_open(path) as fh:
            with tempfile.NamedTemporaryFile(suffix='.mbox') as dst:
                dst.write(fh.read())
                mail = mbox(dst.name)
                for msg in mail:
                    data = {
                        'list': list_name,
                        'message_id': msg.get('Message-ID'),
                        'subject': msg.get('Subject'),
                        'from': msg.get('From'),
                        'reply_to': msg.get('In-Reply-To')
                    }
                    try:
                        s = data['from'].decode('utf-8')
                        data['from'] = s
                    except:
                        try:
                            data['from'] = data['from'].split('(', 1)[0]
                        except:
                            data['from'] = None
                    try:
                        s = data['subject'].decode('utf-8')
                        data['subject'] = s
                    except:
                        data['subject'] = None
                    date = msg.get('Date')
                    try:
                        date = parser.parse(date)
                    except:
                        date = None
                    if date is None:
                        continue
                    data['date'] = date
                    print [data['list'], data['from'], data['subject']]
                    mail_table.upsert(data, ['list', 'message_id', 'from'])
