package openfl.display3D._internal.assembler;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class OpcodeMap
{
	public static var map(get, never):Map<String, Opcode>;
	private static var _map:Map<String, Opcode>;

	private static function get_map():Map<String, Opcode>
	{
		if (OpcodeMap._map == null)
		{
			OpcodeMap._map = new Map<String, Opcode>();
			OpcodeMap._map.set("mov", new Opcode("vector", "vector", 4, "none", 0, 0x00, true, false, false, false));
			OpcodeMap._map.set("add", new Opcode("vector", "vector", 4, "vector", 4, 0x01, true, false, false, false));
			OpcodeMap._map.set("sub", new Opcode("vector", "vector", 4, "vector", 4, 0x02, true, false, false, false));
			OpcodeMap._map.set("mul", new Opcode("vector", "vector", 4, "vector", 4, 0x03, true, false, false, false));
			OpcodeMap._map.set("div", new Opcode("vector", "vector", 4, "vector", 4, 0x04, true, false, false, false));
			OpcodeMap._map.set("rcp", new Opcode("vector", "vector", 4, "none", 0, 0x05, true, false, false, false));
			OpcodeMap._map.set("min", new Opcode("vector", "vector", 4, "vector", 4, 0x06, true, false, false, false));
			OpcodeMap._map.set("max", new Opcode("vector", "vector", 4, "vector", 4, 0x07, true, false, false, false));
			OpcodeMap._map.set("frc", new Opcode("vector", "vector", 4, "none", 0, 0x08, true, false, false, false));
			OpcodeMap._map.set("sqt", new Opcode("vector", "vector", 4, "none", 0, 0x09, true, false, false, false));
			OpcodeMap._map.set("rsq", new Opcode("vector", "vector", 4, "none", 0, 0x0a, true, false, false, false));
			OpcodeMap._map.set("pow", new Opcode("vector", "vector", 4, "vector", 4, 0x0b, true, false, false, false));
			OpcodeMap._map.set("log", new Opcode("vector", "vector", 4, "none", 0, 0x0c, true, false, false, false));
			OpcodeMap._map.set("exp", new Opcode("vector", "vector", 4, "none", 0, 0x0d, true, false, false, false));
			OpcodeMap._map.set("nrm", new Opcode("vector", "vector", 4, "none", 0, 0x0e, true, false, false, false));
			OpcodeMap._map.set("sin", new Opcode("vector", "vector", 4, "none", 0, 0x0f, true, false, false, false));
			OpcodeMap._map.set("cos", new Opcode("vector", "vector", 4, "none", 0, 0x10, true, false, false, false));
			OpcodeMap._map.set("crs", new Opcode("vector", "vector", 4, "vector", 4, 0x11, true, true, false, false));
			OpcodeMap._map.set("dp3", new Opcode("vector", "vector", 4, "vector", 4, 0x12, true, true, false, false));
			OpcodeMap._map.set("dp4", new Opcode("vector", "vector", 4, "vector", 4, 0x13, true, true, false, false));
			OpcodeMap._map.set("abs", new Opcode("vector", "vector", 4, "none", 0, 0x14, true, false, false, false));
			OpcodeMap._map.set("neg", new Opcode("vector", "vector", 4, "none", 0, 0x15, true, false, false, false));
			OpcodeMap._map.set("sat", new Opcode("vector", "vector", 4, "none", 0, 0x16, true, false, false, false));
			OpcodeMap._map.set("ted", new Opcode("vector", "vector", 4, "sampler", 1, 0x26, true, false, true, false));
			OpcodeMap._map.set("kil", new Opcode("none", "scalar", 1, "none", 0, 0x27, true, false, true, false));
			OpcodeMap._map.set("tex", new Opcode("vector", "vector", 4, "sampler", 1, 0x28, true, false, true, false));
			OpcodeMap._map.set("m33", new Opcode("vector", "matrix", 3, "vector", 3, 0x17, true, false, false, true));
			OpcodeMap._map.set("m44", new Opcode("vector", "matrix", 4, "vector", 4, 0x18, true, false, false, true));
			OpcodeMap._map.set("m43", new Opcode("vector", "matrix", 3, "vector", 4, 0x19, true, false, false, true));
			OpcodeMap._map.set("sge", new Opcode("vector", "vector", 4, "vector", 4, 0x29, true, false, false, false));
			OpcodeMap._map.set("slt", new Opcode("vector", "vector", 4, "vector", 4, 0x2a, true, false, false, false));
			OpcodeMap._map.set("sgn", new Opcode("vector", "vector", 4, "vector", 4, 0x2b, true, false, false, false));
			OpcodeMap._map.set("seq", new Opcode("vector", "vector", 4, "vector", 4, 0x2c, true, false, false, false));
			OpcodeMap._map.set("sne", new Opcode("vector", "vector", 4, "vector", 4, 0x2d, true, false, false, false));
		}

		return OpcodeMap._map;
	}
}
