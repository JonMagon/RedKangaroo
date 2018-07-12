module api.user;

import vibe.data.json;
import vibe.web.rest;

@path("/user")
interface IAPIUser {
@safe:
	Json getName(int id);
}

class APIUser : IAPIUser {
	Json getName(int id) {
		return serializeToJson(["foo": id, "bar": 13]);
	}
}