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
	
	// /user/id?name=kek
	Json getID(string name) {
		@packet(0x214)
		struct GetPlayerIDByName {
			string name = "kek";
			uint localsid = 0;
			ubyte reason = 0;
			@pw(156) {
				uint allahu = 129;
				uint sex = 2;
			}
			string shmek = "cheburek";
			@pw(153) uint vah = 13;
		}
		
		GetPlayerIDByName packet;
		
		sendPacket(packet);
		
		return serializeToJson(name);
	}
	

}