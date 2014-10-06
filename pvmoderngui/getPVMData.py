__author__ = 'lucidtech'

import json
import datetime
from django.shortcuts import render_to_response
from django.http import HttpResponse
import SOAPpy

GENERAL_ERROR = dict(status="999", message="Error", groups="Error")
NOT_AUTH_ERROR = dict(status="998", message="User Not Authenticated", groups="Error")
SUCCESS = dict(status="0", message="Success", groups="Success")
pvms = None


def send(obj):
    # if isinstance(obj["groups"], datetime.datetime):
    #     obj["groups"] = time.maketime(obj["groups"].timetuple())
    # if isinstance(obj["groups"], SOAPpy.Types.structType):
    #     obj["groups"] = obj["groups"]._asdict()

    try:
        retjson = json.dumps(str(obj.data))
        return HttpResponse(retjson, content_type='application/json')

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
            # response["status"], response["message"], response["groups"] = pvms.invoke('listSupportedClouds', ())
            response = pvms.invoke('listSupportedClouds', ())
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
    response = {}
    if 'params' in request.GET:
        params = request.GET['params']
    else:
        params = ()

    try:
        # response["status"], response["message"], response["groups"] = pvms.invoke(request.GET['method'], params)
        response = pvms.invoke(request.GET['method'], params)

    except SOAPpy.Errors.HTTPError:
        return send(GENERAL_ERROR)

    return send(response)


def index(request):
    return render_to_response('index.html')

