import std.stdio;
import std.socket;

import gauthd.protocol;
import std.variant;

import std.conv;
import std.base64;
import core.sys.posix.unistd;
import utils;

import redkangaroo.database;
import redkangaroo.config;

void main() {
	writefln("RedKangaroo Daemon\nVersion: 0.0.1-alpha\nBuild time: %s %s", __DATE__, __TIME__);

	ushort x = 1;
	if (*(cast(ubyte *) &x) == 0) {
		writeln("You can't use big-endian processor.");
		return;
	}
}