module redkangaroo.config;

import std.conv;
import std.file;
import std.json;
import vibe.core.log;

class Config {
	public:
		struct RedKangaroo {
			static:
				string host;
				ushort port;
				string key;
				bool allowGetInfo;
		}
	
		struct Services {
			static:
				int gdeliverydPort;
				int gamedbdPort;
		}
	
		struct MySQL {
			static:
				string host;
				int port;
				string user;
				string password;
				string database;
		}

		static void Instance(string fileName) {
			import core.exception : RangeError;
			
			try {
				auto content = to!string(read(fileName));

				JSONValue json = parseJSON(content).object;

				RedKangaroo.host         = json.object["RedKangaroo"].object["host"].str;
				RedKangaroo.port         = to!ushort(json.object["RedKangaroo"].object["port"].integer);
				RedKangaroo.key          = json.object["RedKangaroo"].object["key"].str;
				RedKangaroo.allowGetInfo = json.object["RedKangaroo"].object["allowGetInfo"].type == JSON_TYPE.TRUE;

				Services.gdeliverydPort = to!int(json.object["services"].object["gdeliverydPort"].integer);
				Services.gamedbdPort    = to!int(json.object["services"].object["gamedbdPort"].integer);

				MySQL.host     = json.object["mysql"].object["host"].str;
				MySQL.port     = to!int(json.object["mysql"].object["port"].integer);
				MySQL.user     = json.object["mysql"].object["user"].str;
				MySQL.password = json.object["mysql"].object["password"].str;
				MySQL.database = json.object["mysql"].object["database"].str;
			}
			catch (FileException e) {
				logFatal("Exception thrown for file I/O errors.", fileName);
				throw e;
			}
			catch (RangeError e) {
				logFatal("The lack of the needed elements is detected in the configuration file.\n" ~
						 "Please, update the file from the repository.");
				throw e;
			}
			catch (Exception e) {
				logFatal("Invalid %s file. Please correct it and try again.", fileName);
				throw e;
			}
		}
}