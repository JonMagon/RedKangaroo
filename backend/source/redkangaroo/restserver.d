module redkangaroo.restserver;

import vibe.d;
import vibe.core.log;
import redkangaroo.config;
import redkangaroo.security;

import api.system;
import api.user;

class RESTServer {
private:
	static void checkRequest(HTTPServerRequest req, HTTPServerResponse) {
		/*if (Config.RedKangaroo.allowGetInfo) {
			logFatal("The request was rejected. " ~
				"It needs to set the value of allowGetInfo to false.");
			throw new HTTPStatusException(HTTPStatus.internalServerError);
		}
		
		if (!new OTP().checkToken(req.headers.get("Token"))) {
			logError("[IP: %s]: Invalid token.",
				req.clientAddress.toAddressString(), req.requestURI);
			throw new HTTPStatusException(HTTPStatus.forbidden);
		}*/
		
		
		// DEBUG !
	}
	
	static void getInfo(HTTPServerRequest, HTTPServerResponse res) {
		import std.datetime;
		import std.conv;
		
		if (!Config.RedKangaroo.allowGetInfo)
			throw new HTTPStatusException(HTTPStatus.forbidden);
		
		res.writePrettyJsonBody(
			Json([
				"token": Json(Config.RedKangaroo.token),
				"stepWindow": Json(Config.RedKangaroo.stepWindow),
				"timestamp": Json(Clock.currTime(UTC()).toUnixTime())
			])
		);
	}
	
	static void errorHandler(HTTPServerRequest req, HTTPServerResponse res,
							 HTTPServerErrorInfo error) {
		res.writePrettyJsonBody(Json(["error": Json(error.code)]));
	}
	
	static void unspecifiedRoute(HTTPServerRequest req, HTTPServerResponse) {
		logWarn("[IP: %s]: A route with name '%s' could not be found. " ~
			"Check that `name: '%2$s'` was specified in the route's config.",
			req.clientAddress.toAddressString(), req.requestURI);
	}
	
public:
	static void Instance() {
		auto router = new URLRouter;
		
		router.any("/info", &getInfo);
		
		router.any("*", &checkRequest);
		
		// Interfaces
		registerRestInterface(router, new APISystem());
		registerRestInterface(router, new APIUser());

		router.any("*", &unspecifiedRoute);
		
		auto settings = new HTTPServerSettings;

		settings.errorPageHandler = toDelegate(&errorHandler);
		
		settings.port = Config.RedKangaroo.port;
		settings.bindAddresses = [Config.RedKangaroo.host];

		listenHTTP(settings, router);

		runApplication();
	}
}