__author__ = 'lucidtech'

import json
from django.shortcuts import render_to_response
from django.http import HttpResponse
import SOAPpy

GENERAL_ERROR = dict(status="999", message="Error", groups="Error")
NOT_AUTH_ERROR = dict(status="998", message="User Not Authenticated", groups="Error")
SUCCESS = dict(status="0", message="Success", groups="Success")
pvms = None


# TODO add timeout for inactivity here/cookies/js... don't know which


def send(obj):

    try:
        retjson = json.dumps(SOAPpy.Types.simplify(obj.data))
        return HttpResponse(retjson, content_type='application/json')
        # return HttpResponse(obj, content_type='application/json')

    except TypeError:
        return send(GENERAL_ERROR)


def notauthenticated(method):
    if pvms is None:
        send(NOT_AUTH_ERROR)
    else:
        method


def init(request):
    response = {}
    global pvms
    required = ['username', 'password', 'protocol', 'host', 'route', 'port']
    if sorted(request.GET.keys()) == sorted(required):
        k = request.GET
        url = k['protocol'] + "://" + k['username'] + ":" + k['password'] + "@" + k['host'] + ":" + k['port'] + '/' + k['route']
        pvms = SOAPpy.SOAPProxy(url)
        # make a test call to see if we are authenticated
        try:
            response = pvms.invoke('getVersion', ())
        except SOAPpy.Errors.HTTPError:
            send(NOT_AUTH_ERROR)
    else:
        return send(GENERAL_ERROR)
    return send(response)


def methods(request):
    w_file = '/Users/lucidtech/Dropbox/Developer/PycharmProjects/learningDjango/static/pvm.wsdl'
    ws = SOAPpy.WSDL.Proxy(w_file)
    wsdl_methods = []
    for method in ws.methods.keys():
        takes = []
        for param in ws.methods[method].inparams:
            takes.append(dict(name=param.name, type=param.type[1]))
        wsdl_methods.append(dict(method=method, takes=takes))
    return HttpResponse(json.dumps(wsdl_methods), content_type='application/json')


# @notauthenticated
def pvm(request):

    def unpackParams(*p):
        return p

    if 'params' in request.GET:
        params = json.loads(request.GET['params'])
    else:
        params = []

    try:
        response = pvms.invoke(request.GET['method'], unpackParams(*params))

    except SOAPpy.Errors.HTTPError:
        return send(GENERAL_ERROR)

    return send(response)


def index(request):
    return render_to_response('index.html')

def views(request):
    return render_to_response('views/'+ request.GET['template'] + '.html')

