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
    	unset req.http.Cookie;
    }
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    # Allow Backend to set ttl without missuage of Cache-Control Header
    if (beresp.http.x-reverse-proxy-ttl) {
	set beresp.ttl = std.duration(beresp.http.x-reverse-proxy-ttl + "s", 0s);

	# Delete Set-Cookie since varnish wont cache elsewise
	unset beresp.http.Set-Cookie;

	# We'll have to disable the Cache-Control Header (ment for the Client)
	# for a short while since it will overwrite our ttl
	set beresp.http.X-Temp-Cache-Control = beresp.http.Cache-Control;
	unset beresp.http.Cache-Control;
    }
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.

    # See if there are any XKey tags to purge
    if (resp.http.xkey-purge) {
        set resp.http.xkey-purged = xkey.purge(resp.http.xkey-purge);
    }

    # Switch back Cache-Control Header
    if (resp.http.X-Temp-Cache-Control) {
        set resp.http.Cache-Control = resp.http.X-Temp-Cache-Control;
        unset resp.http.X-Temp-Cache-Control;
    }
}