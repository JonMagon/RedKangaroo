module api.user;

import std.array : appender;
import vibe.data.json;
import vibe.web.rest;
import network.protocol;

@path("/user")
interface IAPIUser {
@safe:
	Json getName(int id);
	Json getID(string name);
}

class APIUser : IAPIUser {
	Json getName(int id) {
		return serializeToJson(["foo": id, "bar": 13]);
	}
	
	// /user/id?name=kek
	Json getID(string name) {
		auto GetPlayerIDByName = appender!(const ubyte[])();
		GetPlayerIDByName.append!CUInt(2);
		GetPlayerIDByName.append!string(name);
		GetPlayerIDByName.append!uint(0); // localsid
		GetPlayerIDByName.append!ubyte(0); // reason
		
		return serializeToJson(name);
	}
}