import os
import re
import requests
from urlparse import urljoin
from urllib import urlretrieve
from lxml import html

BASE = 'https://lists.okfn.org/mailman/listinfo'
ARCH = 'https://lists.okfn.org/pipermail/%s/'
LOCAL = 'data'

res = requests.get(BASE)
for grp in re.findall('listinfo/([^\"]*)', res.content):
    url = ARCH % grp
    ir = requests.get(url)
    
    doc = html.fromstring(ir.content)
    for a in doc.findall('.//a'):
        zip = urljoin(url, a.get('href'))
        if not zip.endswith('.gz'):
            continue
        print [zip]
        path = os.path.join(LOCAL, grp)
        try:
            os.makedirs(path)
        except:
            pass
        file_path = os.path.join(path, a.get('href'))
        if os.path.is_file(file_path):
            continue
        urlretrieve(zip, file_path)

