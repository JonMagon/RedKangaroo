module network.gnet.GetPlayerIDByName;

import network.protocol;

@packet(0x76, gdeliveryd)
struct GetPlayerIDByName {
	string rolename;
	int localsid;
	byte reason;
}

@packet(0x77, gdeliveryd)
struct GetPlayerIDByName_Re {
	int retcode;
	int localsid;
	string rolename;
	int roleid;
	byte reason;
}