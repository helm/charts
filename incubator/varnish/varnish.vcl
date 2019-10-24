vcl 4.0;

// https://www.varnish-software.com/wiki/content/tutorials/varnish/sample_vclTemplate.html

backend default {
    .host = "my-tomcat.default.svc.cluster.local";
    .port = "80";
}

sub vcl_recv {
    // Passing real IP to backend
    if (req.restarts == 0) {
        if (req.http.X-Forwarded-For) {
           set req.http.X-Forwarded-For = req.http.X-Forwarded-For + ", " + client.ip;
       } else {
           set req.http.X-Forwarded-For = client.ip;
       }
    }
    if (req.method == "POST") {
        return (pass);
    }
    if (req.method == "DELETE") {
        return (pass);
    }
    if (req.method == "PUT") {
        return (pass);
    }

    if (req.url ~ "^/static/.*$" || req.url ~ "^/widget/.*$"){
        unset req.http.Cookie;
        set req.grace = 6h;
        return(hash);
    }

    if (req.url ~ "^[^?]*\.(bmp|css|gif|ico|jpeg|jpg|js|png|svg|svgz|ttf|woff|woff2)(\?.*)?$") {
        unset req.http.Cookie;
        set req.grace = 6h;
        return (hash);
    }

    return (pass);
}


sub vcl_backend_response {

    if (bereq.url ~ "^/static/.*$" || bereq.url ~ "^/widget/.*$"){
        unset bereq.http.set-cookie;
        set beresp.grace = 6h;
        set beresp.ttl = 7200s;
        return(deliver);
    }

    if (bereq.url ~ "^[^?]*\.(bmp|css|gif|ico|jpeg|jpg|js|png|svg|svgz|ttf|woff|woff2)(\?.*)?$") {
        unset bereq.http.set-cookie;
        set beresp.grace = 6h;
        set beresp.ttl = 7200s;
        return(deliver);
    }

    # if backend throws 4xx and 5xxx
    if (beresp.status >= 400) {
        if (bereq.is_bgfetch) {
            return (abandon);
        }
        # We should never cache a 5xx response.
        set beresp.uncacheable = true;
    }
    if (bereq.http.set-cookie ~ "token=") {
        # We should never cache a logged in user.
        set beresp.uncacheable = true;
    }
    # we do store this every 10s with a long graceperiod in case backend gets slow
    unset bereq.http.set-cookie;
    set beresp.grace = 10m;
    set beresp.ttl = 5s;
    return(deliver);
}
