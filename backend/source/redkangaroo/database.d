module redkangaroo.database;

import std.conv;
import std.typecons;
import std.stdio;
import std.string;
import std.variant;
import mysql;

import redkangaroo.config;

class Database {
private:
	static Connection conn;
	
public:
	static void Instance() {
		conn = new Connection(
			format("host=%s;port=%d;user=%s;pwd=%s;db=%s",
					Config.MySQL.host,
					Config.MySQL.port,
					Config.MySQL.user,
					Config.MySQL.password,
					Config.MySQL.database)
		);
		scope(exit) conn.close();
	}
}