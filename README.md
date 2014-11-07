ajaxpvm
=======

ajax style pvm

Recreate the PVM GUI as a Single Page Application (SPA).

ajaxpvm relies on 
knockoutjs 3.4
jquery
requirejs

Currently implemented using Django to serve files and to act as proxy for the SOAPpy Proxy to PVM.
Intention is to replace the Django requirement and re-implement the application without server side dependencies (using a simple Node based httpserver) and rely on a client side JS SAOP library.  This requires CORS enablement on the PVM
