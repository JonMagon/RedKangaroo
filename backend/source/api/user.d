module api.user;

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
	
	Json getID(string rolename) {
		import network.gnet.GetPlayerIDByName;
		
		GetPlayerIDByName request = {
			rolename: rolename
		};
		
		sendPacket(request);
		
		return serializeToJson(rolename);
	}
}