import std.base64;
import std.conv;
import std.file;
import std.stdio;

import network.protocol;

import redkangaroo.database;
import redkangaroo.config;
import redkangaroo.webservice;

import vibe.d;

void main() {
	writefln("RedKangaroo Daemon\nVersion: 0.0.1-alpha\nBuild time: %s %s", __DATE__, __TIME__);

	ushort x = 1;
	if (*(cast(ubyte *) &x) == 0) {
		writeln("You can't use big-endian processor.");
		return;
	}
	
	Config.Instance(getcwd() ~ "/config.json");
	Database.Instance();
	
	// Start web server
	
    auto router = new URLRouter;
    router.registerWebInterface(new WebService);
    
	if (Config.RedKangaroo.allowGetInfo)
		router.get("/info", &getInfo);

    auto settings = new HTTPServerSettings;
    settings.sessionStore = new MemorySessionStore;
    settings.port = Config.RedKangaroo.port;
	settings.bindAddresses = [Config.RedKangaroo.host];
	
    listenHTTP(settings, router);
	
    runApplication();
}