module redkangaroo.config;

import std.conv;
import std.file;
import std.json;

public class ConfigReader {
private:
	Connection conn;
	
public:
	this(string filename) {
		auto content = to!string(read(filename));
		
		JSONValue[string] document = parseJSON(content).object;
		JSONValue[] employees = document["employees"].array;

		foreach (employeeJson; employees) {
			JSONValue[string] employee = employeeJson.object;

			string firstName = employee["firstName"].str;
			string lastName = employee["lastName"].str;

			auto e = Employee(firstName, lastName);
			writeln("Constructed: ", e);
		}
	}

}