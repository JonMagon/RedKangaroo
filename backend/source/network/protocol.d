module network.protocol;

import std.algorithm.mutation;
import std.stdio;

public class ReadPacket {
private:
	ubyte[] data;
	uint pos;
	
public:
	this(ubyte[] _data) {
		data = _data;
	}

	@property ulong Length() { return data.length; }
	//@property int data(int value) { return m_data = value; }

	void Seek(uint count) {
		pos += count;
	}
	
	ubyte[] ReadBytes(uint length) {
		return data[pos .. (pos += length)];
	}

	uint ReadCUInt() {
		char code = ReadUByte();
		switch (code & 0xE0)
		{
			case 0x0E:
				return ReadUInt();
			case 0xC0:
				pos -= 1;
				return ReadUInt() & 0x1FFFFFFF;
			case 0x80:
			case 0xA0:
				pos -= 1;
				return ReadUShort() & 0x3FFF;
			default:
				return code;
		}
	}
	
	ubyte[] ReadOctets() {
		uint length = ReadCUInt();
		return data[pos .. (pos += length)];
	}
	
	string ReadString() {
		return (cast(char[]) ReadOctets()).idup;
	}
	
	uint ReadUInt() {
		return *cast(uint*) reverse(data[pos .. (pos += 4)]);
	}
	
	ushort ReadUShort() {
		return *cast(ushort*) reverse(data[pos .. (pos += 2)]);
	}
	
	ubyte ReadUByte() {
		return data[pos++];
	}
}

public class WritePacket {
private:
	ubyte[131072] data;
	uint pos;
	
public:
	
	void WriteUInt(uint val) {
		data[pos .. (pos += uint.sizeof)] = reverse((cast(ubyte*) &val)[0 .. uint.sizeof]);
	}
	
	void WriteUShort(ushort val) {
		data[pos .. (pos += ushort.sizeof)] = reverse((cast(ubyte*) &val)[0 .. ushort.sizeof]);
	}
	
	void WriteString(string val) {
		auto val_length = val.length;
		WriteCUInt(*cast(ushort*) &val_length);
		data[pos .. (pos += val.length)] = cast(ubyte[]) (val.dup);
	}
	
	void WriteOctets(ubyte[] val) {
		auto val_length = val.length;
		WriteCUInt(*cast(ushort*) &val_length);
		data[pos .. (pos += val.length)] = val;
	}
	
	void WriteUByte(ubyte val) {
		data[pos++] = val;
	}
	
	void WriteCUInt(uint val) {
		if (val < 127)
			WriteUByte(*cast(ubyte*) &val);
		else if (val < 16383)
			WriteUShort((*cast(ushort*) &val) | 0x8000);
	}
	
	ubyte[] Pack(ushort opcode) {
		uint cursor;
		ubyte[] _tosend;
		_tosend.length = 131072;
		
		if (opcode < 127)
			_tosend[cursor++] = *cast(ubyte*) &opcode;
		else if (opcode < 16383) {
			auto opcode_modified = (*cast(ushort*) &opcode) | 0x8000;
			_tosend[cursor .. (cursor += ushort.sizeof)] = reverse((cast(ubyte*) &opcode_modified)[0 .. ushort.sizeof]);
		}
			
		if (pos < 127)
			_tosend[cursor++] = *cast(ubyte*) &pos;
		else if (opcode < 16383) {
			auto opcode_modified = (*cast(ushort*) &opcode) | 0x8000;
			_tosend[cursor .. (cursor += ushort.sizeof)] = reverse((cast(ubyte*) &opcode_modified)[0 .. ushort.sizeof]);
		}
			
		_tosend[cursor .. cursor + pos] = data[0 .. pos];
		
		// http://ddili.org/ders/d.en/formatted_output.html
		writefln("From: %(%02x %)", _tosend[0 .. cursor + pos]);
		
		return _tosend[0 .. cursor + pos];
	}
}