module redkangaroo.config;

import std.conv;
import std.file;
import std.json;
import core.exception;

import redkangaroo.exceptions;

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
			catch (JSONException) {
				throw new ConfigLoadException(fileName);
			}
			catch (RangeError) {
				throw new ConfigLoadException(fileName);
			}
		}
}