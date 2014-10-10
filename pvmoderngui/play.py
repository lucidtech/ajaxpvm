__author__ = 'lucidtech'

import SOAPpy
import json

wurl = "https://admin:admin1@192.168.92.146:8080/wsdl"
surl = "https://admin:admin1@192.168.92.146:8080/soap"

ws = SOAPpy.WSDL.Proxy(wurl)
sc = SOAPpy.SOAPProxy(surl)

aom = ws.methods
aok = ws.methods.keys()

print ws
