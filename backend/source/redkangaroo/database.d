module redkangaroo.database;

import std.conv;
import std.typecons;
import std.stdio;
import std.string;
import mysql;

public class MySQLConnector {
private:
	Connection conn;
	
public:
	this(string host, int port, string user, string password, string basename) {
		conn = new Connection(
			format("host=%s;port=%d;user=%s;%pwd=%s;db=%s",
			host, port, user, password, basename));
		scope(exit) conn.close();
	}
}