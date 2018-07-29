module network.gnet.RoleBase;

import network.protocol;

@packet(0xBC5, gamedbd)
struct GetRoleBaseArg {
	RoleId key;
}

struct RoleId {
	uint id;
	
	
}

@packet(0x77, gdeliveryd)
struct GetPlayerIDByName_Re {
	int retcode;
	int localsid;
	string rolename;
	int roleid;
	byte reason;
}