module redkangaroo.webserver;

import vibe.d;
import vibe.core.log;
import redkangaroo.config;

import api.system;
import api.user;

class WebServer {
private:
	void checkRequest(HTTPServerRequest req, HTTPServerResponse) {
		// TODO: I need to protect this place
		if (req.headers.get("Token") != Config.RedKangaroo.token) {
			logError("[IP: %s]: Invalid token.",
				req.clientAddress.toAddressString(), req.requestURI);
			throw new HTTPStatusException(HTTPStatus.Forbidden);
		}
	}
	
	void unspecifiedRoute(HTTPServerRequest req, HTTPServerResponse) {
		logWarn("[IP: %s]: A route with name '%s' could not be found. " ~
			"Check that `name: '%2$s'` was specified in the route's config.",
			req.clientAddress.toAddressString(), req.requestURI);
	}
	
public:
	static void Instance() {
		/*
		 * I have no idea how to make it better with routes
		 * HTTPServerSettings.errorPageHandler doesn't working
		 */
		
		auto route = new URLRouter;
		
		route.any("*", &checkRequest);
		
		// Interfaces
		registerRestInterface(route, new APISystem());
		registerRestInterface(route, new APIUser());

		route.any("*", &unspecifiedRoute);
		
		auto settings = new HTTPServerSettings;

		settings.port = Config.RedKangaroo.port;
		settings.bindAddresses = [Config.RedKangaroo.host];

		listenHTTP(settings, route);

		runApplication();
	}
}