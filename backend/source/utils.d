module utils;

import core.sys.posix.arpa.inet;
import std.conv;

string GetIP(uint ip) {
	in_addr addr;
	addr.s_addr = ip;
	
	return to!string(inet_ntoa(addr));
}

struct ServerVars {
	uint zoneid;
	uint aid;
}