/*
 * I'll keep working on this.
 */

module network.protocol;

import std.bitmanip;
import std.range.primitives;
import std.utf;
import std.conv;

static void sendPacket(T)(T packet) { 
	import std.stdio;
	import std.array : appender;
	import redkangaroo.config;

	auto packetAttributes = __traits(getAttributes, T)[0];
	auto opcode = packetAttributes.opcode;
	auto service = packetAttributes.service;
	
	auto outPacket = appender!(const ubyte[])();
	foreach (i, ref part; packet.tupleof) {
		enum attributes = __traits(getAttributes, packet.tupleof[i]);
		
		if (attributes.length > 0) {
			foreach (attr; attributes)
				if (is(typeof(attr) == pwbuild)) {
					if (attr.min <= Config.Services.pwbuild
						&& (attr.max == 0 || Config.Services.pwbuild <= attr.max))
						outPacket.append!(typeof(part))(part);
					break;
				}
		}
		else outPacket.append!(typeof(part))(part);
	}
	
	auto wrap = appender!(const ubyte[])();
	wrap.append!CUInt(opcode);
	wrap.append!CUInt(to!uint(outPacket.data.length));
		
	writeln(wrap.data ~ outPacket.data);
	
	import std.socket, std.stdio;
	
	ubyte[128 * 1024] buffer;
	
	auto socket = new Socket(AddressFamily.INET,  SocketType.STREAM);
	socket.connect(new InternetAddress("localhost", 29100));
	scope(exit) {
		socket.shutdown(SocketShutdown.BOTH);
		socket.close();
	}
	
	if (service == gdeliveryd) socket.receive(buffer);
	
	socket.send(wrap.data ~ outPacket.data);
	
	writeln(buffer[0 .. socket.receive(buffer)]);
}

// Services
enum int gdeliveryd = 0x01;
enum int gamedbd = 0x02;

struct pwbuild {
	int min;
	int max;
}

struct packet {
	uint opcode;
	int service;
}

struct CUInt {
	uint value;
	
	this(R)(auto ref R rng) if (isInputRange!R && is(ElementType!R : const(ubyte))) {
		auto code = rng.peek!ubyte;
		switch (code & 0xE0) {
			case 0xE0:
				rng.read!ubyte;
				alue = rng.read!uint;
				break;
			case 0xC0:
				value = rng.read!uint & 0x1FFFFFFF;
				break;
			case 0x80:
			case 0xA0:
				value = rng.read!ushort & 0x3FFF;
				break;
			default:
				value = rng.read!ubyte;
				break;
		}
	}
	
	this(R)(R rng, uint val) if (isOutputRange!(R, ubyte)) {
		if (val <= 0x7F)
			rng.append!ubyte(*cast(ubyte*) &val);
		else if (val < 0x3FFF) {
			auto val_ = *cast(ushort*) &val;
			val_ |= 0x8000;
			rng.append!ushort(val_);
		}
		else if (val <= 0x1FFFFFFF)
			rng.append!uint(val | 0xC0000000);
		else {
			rng.append!ubyte(0xE0);
			rng.append!uint(val);
		}
	}
}

alias read = std.bitmanip.read;

@trusted uint read(T : CUInt, R)(auto ref R range) 
if (isInputRange!R && is(ElementType!R : const(ubyte))) {
	return CUInt(range).value;
}

alias append = std.bitmanip.append;

@trusted void append(T : CUInt, R)(R range, uint value)
if (isOutputRange!(R, ubyte)) {
	CUInt(range, value);
}

@trusted void append(T : string, R)(R range, string value)
if (isOutputRange!(R, ubyte)) {
	ubyte[] bytes = cast(ubyte[]) value.toUTF16;
	CUInt(range, to!uint(bytes.length));
	put(range, bytes);
}

@trusted void append(T : T[], R)(R range, T[] value)
if (isOutputRange!(R, ubyte)) {
	put(range, value);
}