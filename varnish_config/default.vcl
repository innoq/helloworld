#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

import xkey;
import std;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "helloworld.innoq.info";
    .port = "80";
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.
    
    # Force cache lookup for /statuses (ignoring Cookie-Header)
    if (req.method == "GET" && req.url ~ "^/statuses$") {
    	set req.http.X-Disabled-Cookie = req.http.Cookie;
	unset req.http.Cookie;
    }
    else {
        # Has there been a Cookie in an earlier Request (meaning we are now
        # receiving an ESI request) which we need to restore?
        if (req.http.X-Disabled-Cookie) {
            set req.http.Cookie = req.http.X-Disabled-Cookie;
            unset req.http.X-Disabled-Cookie;
        }
    }
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    # Delete all Set-Cookie attempts on ressources which had no Cookie sent by
    # force since they will contain only unauthorized (session) cookies
    if (bereq.http.X-Disabled-Cookie) {
        unset beresp.http.Set-Cookie;
    }

    if (beresp.http.cache-control ~ "s-maxage") {
	# Delete Set-Cookie since varnish wont cache otherwise
	unset beresp.http.Set-Cookie;

	# No other proxy should be caching anymore
	set beresp.http.cache-control = regsub(beresp.http.cache-control, "s-maxage", "s-disabled-maxage");
    }

    # Check if we should process ESI or not
    if (beresp.http.x-esi == "true") {
	set beresp.do_esi = true;
    }
}

sub vcl_hit {
    set req.http.X-Varnish-TTL = obj.ttl;
    set req.http.X-Varnish-Cache = "hit";
}

sub vcl_miss {
    set req.http.X-Varnish-TTL = 0;
    set req.http.X-Varnish-Cache = "miss";
}

sub vcl_deliver {
    set resp.http.X-Varnish-TTL = req.http.X-Varnish-TTL;
    set resp.http.X-Varnish-Cache = req.http.X-Varnish-Cache;
    
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.

    # See if there are any XKey tags to purge
    if (resp.http.xkey-purge) {
        set resp.http.xkey-purged = xkey.purge(resp.http.xkey-purge);
    }

}

