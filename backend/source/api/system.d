module api.system;

import std.string;
import vibe.data.json;
import vibe.web.rest;

@path("/system")
interface IAPISystem {
@safe:
	Json getGSInstances();
}

class APISystem : IAPISystem {
	@path("gs_instances")
	Json getGSInstances() {
		import std.process : executeShell;
		
		Json instances = Json.emptyObject;

		auto ps = executeShell("ps aux | grep [.]/gs");
		auto result = splitLines(ps.output);
		foreach (line; result) {
			auto columns = line.split;
			instances[columns[11]] = serializeToJson(
				[
					"pid": columns[1],
					"cpu": columns[2],
					"mem": columns[3]
				]
			);
		}
		
		return instances;
	}
}