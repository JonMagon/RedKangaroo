import std.base64;
import std.conv;
import std.file;
import std.stdio;
import vibe.d;
import redkangaroo.database;
import redkangaroo.config;
import redkangaroo.webserver;

void main() {
	writefln("RedKangaroo Daemon\n" ~ 
			 "Version: 0.0.1-alpha\n" ~
			 "Build time: %s %s", __DATE__, __TIME__);

	setLogFile(getcwd() ~ "/global.log");
	
	Config.Instance(getcwd() ~ "/config.json");
	Database.Instance();
	WebServer.Instance();
}