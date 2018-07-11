module redkangaroo.webserver;

import vibe.d;
import redkangaroo.config;

import api.user;

class WebServer {
	public:
		static void Instance() {
			auto routes = new URLRouter;
			registerRestInterface(routes, new APIUser());

			auto settings = new HTTPServerSettings;
			settings.sessionStore = new MemorySessionStore;
			settings.port = Config.RedKangaroo.port;
			settings.bindAddresses = [Config.RedKangaroo.host];

			listenHTTP(settings, routes);

			runApplication();
		}
}

/*
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
}*/