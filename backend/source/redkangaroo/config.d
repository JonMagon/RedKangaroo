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
			string token;
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

			JSONValue json = parseJSON(content);

			RedKangaroo.host         = json["RedKangaroo"]["host"].str;
			RedKangaroo.port         = to!ushort(json["RedKangaroo"]["port"].integer);
			RedKangaroo.token        = json["RedKangaroo"]["token"].str;
			RedKangaroo.allowGetInfo = json["RedKangaroo"]["allowGetInfo"].type == JSON_TYPE.TRUE;

			Services.gdeliverydPort = to!int(json["services"]["gdeliverydPort"].integer);
			Services.gamedbdPort    = to!int(json["services"]["gamedbdPort"].integer);

			MySQL.host     = json["mysql"]["host"].str;
			MySQL.port     = to!int(json["mysql"]["port"].integer);
			MySQL.user     = json["mysql"]["user"].str;
			MySQL.password = json["mysql"]["password"].str;
			MySQL.database = json["mysql"]["database"].str;

			if (RedKangaroo.token.length == 0) {
				import std.uuid;

				RedKangaroo.token = randomUUID().toString();
				json["RedKangaroo"]["token"].str = RedKangaroo.token;

				write(fileName, json.toPrettyString());

				logInfo("The new token is generated: %s", RedKangaroo.token);
			}
		}
		catch (FileException e) {
			logFatal("File %s not found or no read permission.", fileName);
			throw e;
		}
		catch (RangeError e) {
			logFatal("The lack of the needed elements is detected in the configuration file. " ~
					 "Please update the file from the repository.");
			throw e;
		}
		catch (Exception e) {
			logFatal("Invalid %s file. Please correct it and try again.", fileName);
			throw e;
		}
	}
}