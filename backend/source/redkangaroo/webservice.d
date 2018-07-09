module redkangaroo.webservice;

import vibe.d;

import redkangaroo.config;

class WebService {
    /*
    Using session variables such as this one,
    information associated with individual users
    can be persisted throughout all requests
    for the duration of each user's session.
    */
    private SessionVar!(string, "username")
        username_;

    /*
    By default requests to the root path ("/")
    are routed to the index method.
    */
    void index(HTTPServerResponse res) {
        auto contents = q{<html><head>
            <title>Tell me!</title>
        </head><body>
        <form action="/username" method="POST">
        Your name:
        <input type="text" name="username">
        <input type="submit" value="Submit">
        </form>
        </body>
        </html>};

        res.writeBody(contents,
                "text/html; charset=UTF-8");
    }

    /*
    The @path attribute can be used to customize
    url routing. Here requests to "/name"
    will be mapped to the getName method.
    */
    @path("/name")
    void getName(HTTPServerRequest req,
            HTTPServerResponse res) {
        import std.string : format;

        // Generate header info <li>
        // tags by inspecting the request's
        // headers property.
        string[] headers;
        foreach(key, value; req.headers) {
            headers ~=
                "<li>%s: %s</li>"
                .format(key, value);
        }
        auto contents = q{<html><head>
            <title>Tell me!</title>
        </head><body>
        <h1>Your name: %s</h1>
        <h2>Headers</h2>
        <ul>
        %s
        </ul>
        </body>
        </html>}.format(username_,
                headers.join("\n"));

        res.writeBody(contents,
                "text/html; charset=UTF-8");
    }

    void postUsername(string username,
            HTTPServerResponse res)
    {
        username_ = username;
        auto contents = q{<html><head>
            <title>Tell me!</title>
        </head><body>
        <h1>Your name: %s</h1>
        </body>
        </html>}.format(username_);

        res.writeBody(contents,
                "text/html; charset=UTF-8");
    }
}

void getInfo(HTTPServerRequest req, HTTPServerResponse res) {
    import std.datetime;
    import std.digest.sha;
    import std.conv;
    
    ubyte[32] hash256 = sha256Of(
        Config.RedKangaroo.key ~
        to!string(
            dur!"seconds"(
                Clock.currTime(UTC()).toUnixTime()
            ).total!"minutes"
        )
    );
    res.writeBody(toHexString(hash256));
}