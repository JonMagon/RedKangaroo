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
	
	writeln(__traits(getAttributes, T));

	auto outPacket = appender!(const ubyte[])();
	foreach (i, ref part; packet.tupleof) {
		enum attributes = __traits(getAttributes, packet.tupleof[i]);
		if (attributes.length > 0)
			foreach (attr; attributes) // wtf?
				writefln("%d - %d", attr.min, attr.max);
		outPacket.append!(typeof(part))(part);
	}
	writeln(outPacket.data);
}

struct pw {
	int min;
	int max;
}

struct packet {
	uint opcode;
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
	
	this(R)(R rng, int val) if (isOutputRange!(R, ubyte)) {
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

// сейчас только для байт сделать, потом передалать для любого массива
// но для любого ещё и CUInt писать впереди

@trusted void append(T : T[], R)(R range, T[] value)
if (isOutputRange!(R, ubyte)) {
	put(range, value);
}