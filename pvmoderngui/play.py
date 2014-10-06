__author__ = 'lucidtech'

import SOAPpy
import cgi
import xml.etree.ElementTree as ET

w_file = 'https://admin:admin1@192.168.92.146:8080/soap'
p = SOAPpy.SOAPProxy(w_file)
r = str(p.listApi())
# x = ET.fromstring(r)
xt = ET.parse(p.listApi())
print r