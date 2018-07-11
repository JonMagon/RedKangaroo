module api.user;

import vibe.data.json;
import vibe.web.rest;

@path("/user")
interface IAPIUser {
	Json get();
}

class APIUser : IAPIUser {
	Json get() {
		return serializeToJson(["foo": 42, "bar": 13]);
	}
}