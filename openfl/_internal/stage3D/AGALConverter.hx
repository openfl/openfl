package openfl._internal.stage3D;

import openfl._internal.stage3D.SamplerState;
import openfl.utils.ByteArray;
import openfl.errors.IllegalOperationError;
import openfl.errors.IllegalOperationError;
import openfl.gl.GL;

import haxe.Int64;


@:enum
abstract RegType(Int)
{
	var Attribute = 0;
	var Constant = 1;
	var Temporary = 2;
	var Output = 3;
	var Varying = 4;
	var Sampler = 5;
}

private enum ProgramType {
	Vertex;
	Fragment;
}

private class DestReg {
	public var programType:ProgramType;
	public var type:RegType;
	public var mask:Int;
	public var n:Int;

	public function new()
	{
	}

	static public function Parse(v:UInt, programType:ProgramType):DestReg
	{
		var dr = new DestReg();
		dr.programType = programType;
		dr.type = cast ((v >> 24) & 0xF);
		dr.mask = ((v >> 16) & 0xF);
		dr.n = (v & 0xFFFF);
		return dr;
	}

	public function GetWriteMask():String
	{
		var str:String = ".";
		if ((mask & 1) != 0) str += "x";
		if ((mask & 2) != 0) str += "y";
		if ((mask & 4) != 0) str += "z";
		if ((mask & 8) != 0) str += "w";
		return str;
	}

	public function ToGLSL(useMask:Bool = true):String
	{
		var str:String;
		if (type == RegType.Output) {
			str = programType == ProgramType.Vertex ? "gl_Position" : "gl_FragColor";
		}
		else {
			str = AGALConverter.PrefixFromType(type, programType) + n;
		}

		if (useMask && mask != 0xF) {
			str += GetWriteMask();
		}
		return str;
	}
}

private class SourceReg {
	public var programType:ProgramType;
	public var d:Int;
	public var q:Int;
	public var itype:RegType;
	public var type:RegType;
	public var s:Int;
	public var o:Int;
	public var n:Int;
	public var sourceMask:Int;

	public function new()
	{}

	public static function Parse(v:Int64, programType:ProgramType, sourceMask:Int):SourceReg
	{
		var sr = new SourceReg();
		sr.programType = programType;
		sr.d = ((v >> 63) & 1).low; //  Direct=0/Indirect=1 for direct Q and I are ignored, 1bit
		sr.q = ((v >> 48) & 0x3).low; // index register component select
		sr.itype = cast ((v >> 40) & 0xF).low; // index register type
		sr.type = cast ((v >> 32) & 0xF).low; // type
		sr.s = ((v >> 24) & 0xFF).low; // swizzle
		sr.o = ((v >> 16) & 0xFF).low; // indirect offset
		sr.n = (v & 0xFFFF).low; // number
		sr.sourceMask = sourceMask;
		return sr;
	}

	public function ToGLSL(emitSwizzle:Bool = true, offset:Int = 0):String
	{
		if (type == RegType.Output) {
			return programType == ProgramType.Vertex ? "gl_Position" : "gl_FragColor";
		}


		var fullxyzw:Bool = (s == 228) && (sourceMask == 0xF);

		var swizzle = "";
		if (type != RegType.Sampler && !fullxyzw) {
			for (i in 0...4) {

				// only output swizzles for each source mask
				if ((sourceMask & (1 << i)) != 0) {
					switch ((s >> (i * 2)) & 3) {
						case 0:
							swizzle += "x";

						case 1:
							swizzle += "y";

						case 2:
							swizzle += "z";

						case 3:
							swizzle += "w";

					}
				}
			}
		}

		var str:String = AGALConverter.PrefixFromType(type, programType);
		if (d == 0) {
			// direct register
			str += (n + offset);
		} else {
			// indirect register
			str += o;
			var indexComponent:String = String.fromCharCode('x'.charCodeAt(0) + q);
			var indexRegister = AGALConverter.PrefixFromType(itype, programType) + this.n + "." + indexComponent;
			str += "[ Int(" + indexRegister + ") +" + offset + "]";
		}

		if (emitSwizzle && swizzle != "") {
			str += "." + swizzle;
		}
		return str;
	}
}

private class SamplerReg {
	public var programType:ProgramType ;
	public var f:Int ; // Filter (0=nearest,1=linear) (4 bits)
	public var m:Int ; // Mipmap (0=disable,1=nearest, 2=linear)
	public var w:Int ; // wrap (0=clamp 1=repeat)
	public var s:Int ; // special flags bit
	public var d:Int ; // dimension 0=2d 1=cube
	public var t:Int ; // texture format (0=none, dxt1=1, dxt5=2)
	public var type:RegType ;
	public var b:Int ; // lod bias
	public var n:Int ; // number

	public function new()
	{}

	public static function Parse(v:Int64, programType:ProgramType):SamplerReg
	{
		var sr = new SamplerReg();
		sr.programType = programType;
		sr.f = ((v >> 60) & 0xF).low; // filter
		sr.m = ((v >> 56) & 0xF).low; // mipmap
		sr.w = ((v >> 52) & 0xF).low; // wrap
		sr.s = ((v >> 48) & 0xF).low; // special
		sr.d = ((v >> 44) & 0xF).low; // dimension
		sr.t = ((v >> 40) & 0xF).low; // texture
		sr.type = cast ((v >> 32) & 0xF).low; // type
		sr.b = ((v >> 16) & 0xFF).low; // TODO: should this be .low?
		sr.n = (v & 0xFFFF).low; // number
		return sr;
	}

	public function ToGLSL():String
	{
		var str = AGALConverter.PrefixFromType(type, programType) + n;
		return str;
	}

	public function ToSamplerState():SamplerState
	{
		var magFilter:Int /*TextureMagFilter*/ = 0;
		var minFilter:Int /*TextureMinFilter*/ = 0;
		var wrapModeS:Int /*TextureWrapMode*/ = 0;
		var wrapModeT:Int /*TextureWrapMode*/ = 0;

		// translate mag filter
		switch (f)
		{
			case 0:
				magFilter = GL.NEAREST; //TextureMagFilter.Nearest;

			case 1:
				magFilter = GL.LINEAR; //TextureMagFilter.Linear;

			default:
				throw new IllegalOperationError(); //NotImplementedException();
		}

		// translate min filter
		switch (m)
		{
			// disable
			case 0:
				minFilter = (f != 0) ? GL.NEAREST : GL.LINEAR;

			// nearest
			case 1:
				minFilter = (f != 0) ? GL.NEAREST_MIPMAP_LINEAR : GL.NEAREST_MIPMAP_NEAREST;

			// linear
			case 2:
				minFilter = (f != 0) ? GL.LINEAR_MIPMAP_LINEAR : GL.LINEAR_MIPMAP_NEAREST;

			default:
				throw new IllegalOperationError();
		}

		// translate wrapping mode
		switch (w)
		{
			case 0:
				wrapModeS = GL.CLAMP_TO_EDGE;
				wrapModeT = GL.CLAMP_TO_EDGE;

			case 1:
				wrapModeS = GL.REPEAT;
				wrapModeT = GL.REPEAT;

			default:
				throw new IllegalOperationError();
		}

		// translate lod bias, sign extend and /8
		var lodBias:Float = ((b << 24) >> 24) / 8.0;

		var maxAniso:Float = 0.0;
		return new SamplerState(minFilter, magFilter, wrapModeS, wrapModeT, lodBias, maxAniso);
	}
}


private enum RegisterUsage {
	Unused;
	Vector4;
	Matrix44;
	Sampler2D;
	Sampler2DAlpha;
	SamplerCube;
	Vector4Array;
}

private class RegisterMapEntry {
	public function new()
	{}

	public var type:RegType ;
	public var number:Int ;
	public var name:String ;
	public var usage:RegisterUsage ;
}

class RegisterMap {

	public function new()
	{
		//Stub.
	}

	public function GetUsage(type:RegType, name:String, number:Int):RegisterUsage
	{
		for (entry in mEntries) {
			if (entry.type == type && entry.name == name && entry.number == number) {
				return entry.usage;
			}
		}
		return RegisterUsage.Unused;
	}

	public function GetRegisterUsage(sr:SourceReg):RegisterUsage
	{
		if (sr.d != 0) {
			return RegisterUsage.Vector4Array;
		}
		return GetUsage(sr.type, sr.ToGLSL(false), sr.n);
	}


	public function AddSR(sr:SourceReg, usage:RegisterUsage, offset:Int = 0):Void
	{
		if (sr.d != 0) {
			Add(sr.itype, AGALConverter.PrefixFromType(sr.itype, sr.programType) + sr.n, sr.n, RegisterUsage.Vector4);
			Add(sr.type, AGALConverter.PrefixFromType(sr.type, sr.programType) + sr.o, sr.o, RegisterUsage.Vector4Array);
			return;
		}
		Add(sr.type, sr.ToGLSL(false, offset), sr.n + offset, usage);
	}

	public function AddSaR(sr:SamplerReg, usage:RegisterUsage):Void
	{
		Add(sr.type, sr.ToGLSL(), sr.n, usage);
	}

	public function AddDR(dr:DestReg, usage:RegisterUsage):Void
	{
		Add(dr.type, dr.ToGLSL(false), dr.n, usage);
	}

	public function Add(type:RegType, name:String, number:Int, usage:RegisterUsage):Void
	{
		for (entry in mEntries) {

			if (entry.type == type && entry.name == name && entry.number == number) {
				if (entry.usage != usage) {
					throw new IllegalOperationError ("Cannot use register in multiple ways yet (mat4/vec4)");
				}
				return;
			}
		}


		var entry = new RegisterMapEntry ();
		entry.type = type;
		entry.name = name;
		entry.number = number;
		entry.usage = usage;
		mEntries.push(entry);

	}

	public function ToGLSL(tempRegsOnly:Bool):String
	{
		mEntries.sort(function(a:RegisterMapEntry, b:RegisterMapEntry):Int
		{
			if (a.type != b.type) {
				return cast(a.type, Int) - cast(b.type, Int);
			} else {
				return a.number - b.number;
			}
		});

		var sb = new StringBuf ();
		for (i in 0...mEntries.length) {
			var entry:RegisterMapEntry = mEntries [i];

			// only emit temporary registers based on Boolean passed in
			// this is so temp registers can be grouped in the main() block
			if (
			(tempRegsOnly && entry.type != RegType.Temporary) ||
			(!tempRegsOnly && entry.type == RegType.Temporary)
			) {
				continue;
			}


			// dont emit output registers
			if (entry.type == RegType.Output) {
				continue;
			}

			switch (entry.type)
			{
				case RegType.Attribute:
					// sb.AppendFormat("layout(location = {0}) ", entry.number);
					sb.add("attribute ");

				case RegType.Constant:
					//sb.AppendFormat("layout(location = {0}) ", entry.number);
					sb.add("uniform ");

				case RegType.Temporary:
					sb.add("\t");

				case RegType.Output:

				case RegType.Varying:
					sb.add("varying ");

				case RegType.Sampler:
					sb.add("uniform ");

				default:
					throw new IllegalOperationError();
			}

			switch (entry.usage)
			{
				case RegisterUsage.Vector4:
					sb.add("vec4 ");

				case RegisterUsage.Vector4Array:
					sb.add("vec4 ");

				case RegisterUsage.Matrix44:
					sb.add("mat4 ");

				case RegisterUsage.Sampler2D:
					sb.add("sampler2D ");

				case RegisterUsage.SamplerCube:
					sb.add("samplerCube ");

				case RegisterUsage.Unused:
					trace("Missing switch patten: RegisterUsage.Unused");

				case RegisterUsage.Sampler2DAlpha:
					trace("Missing switch patten: RegisterUsage.Sampler2DAlpha");
			}

			if (entry.usage == RegisterUsage.Sampler2DAlpha) {
				sb.add("sampler2D ");
				sb.add(entry.name);
				sb.add(";\n");

				sb.add("uniform ");
				sb.add("sampler2D ");
				sb.add(entry.name + "_alpha");
				sb.add(";\n");
			} else if (entry.usage == RegisterUsage.Vector4Array) {
				var count:Int = 128;
				if (i < mEntries.length - 1) //find how many registers based on the next entry.
					count = mEntries [i + 1].number - entry.number;
				sb.add(entry.name + "[" + count + "]");// this is an array of "count" elements.
				sb.add(";\n");
			} else {
				sb.add(entry.name);
				sb.add(";\n");
			}
		}
		return sb.toString();
	}


	private var mEntries:Array<RegisterMapEntry> = new Array<RegisterMapEntry>();
}

class AGALConverter {

	public static function PrefixFromType(t:RegType, pt:ProgramType):String
	{
		switch (t) {
			case RegType.Attribute: return "va";
			case RegType.Constant: return (pt == ProgramType.Vertex) ? "vc" : "fc";
			case RegType.Temporary: return (pt == ProgramType.Vertex) ? "vt" : "ft";
			case RegType.Output: return "output_";
			case RegType.Varying: return "v";
			case RegType.Sampler: return "sampler";
			default: throw new IllegalOperationError("Invalid data!");
		}
	}


	private static function ReadUInt64(ba:ByteArray):Int64 //ulong
	{
		var lo:Int = ba.readInt();
		var hi:Int = ba.readInt();
		return Int64.make(hi, lo);
	}

	public static function ConvertToGLSL(agal:ByteArray, outSamplers:Array<SamplerState>):String
	{
		agal.position = 0;

		var magic:Int = agal.readByte() & 0xFF;
		if (magic == 0xB0) {
			// use embedded GLSL shader instead
			return agal.readUTF();
		}


		if (magic != 0xA0) {
			throw new IllegalOperationError ("Magic value must be 0xA0, may not be AGAL");
		}

		var version:Int = agal.readInt();
		if (version != 1) {
			throw new IllegalOperationError ("Version must be 1");
		}

		var shaderTypeId:Int = agal.readByte() & 0xFF;
		if (shaderTypeId != 0xA1) {
			throw new IllegalOperationError ("Shader type id must be 0xA1");
		}

		var programType:ProgramType = (agal.readByte() & 0xFF == 0) ? ProgramType.Vertex : ProgramType.Fragment;

		var map = new RegisterMap();
		var sb = new StringBuf();
		while (cast(agal.position, Int) < agal.length) {

			// fetch instruction info
			var opcode:Int = agal.readInt();
			var dest:UInt = /*(UInt)*/agal.readInt();
			var source1 = ReadUInt64(agal);
			var source2 = ReadUInt64(agal);
//				sb.Append("\t");
//				sb.AppendFormat("// opcode:{0:X} dest:{1:X} source1:{2:X} source2:{3:X}\n", opcode,
//								dest, source1, source2);

			// parse registers
			var dr = DestReg.Parse(dest, programType);
			var sr1 = SourceReg.Parse(source1, programType, dr.mask);
			var sr2 = SourceReg.Parse(source2, programType, dr.mask);

			// switch on opcode and emit GLSL
			sb.add("\t");
			switch (opcode)
			{
				case 0x00: // mov
					sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + "; // mov");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x01: // add
					sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " + " + sr2.ToGLSL() + "; // add");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x02: // sub
					sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " - " + sr2.ToGLSL() + "; // sub");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x03: // mul
					sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " * " + sr2.ToGLSL() + "; // mul");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x04: // div
					sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " / " + sr2.ToGLSL() + "; // div");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x05: // rcp
					sb.add(dr.ToGLSL() + " = vec4(1) / " + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "; // rcp (untested)");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x06: // min
					sb.add(dr.ToGLSL() + " = min(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "); // min");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x07: // max
					sb.add(dr.ToGLSL() + " = max(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "); // max");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x08: // frc
					sb.add(dr.ToGLSL() + " = fract(" + sr1.ToGLSL() + "); // frc");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x09: // sqrt
					sb.add(dr.ToGLSL() + " = sqrt(" + sr1.ToGLSL() + "); // sqrt");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x0A: // rsq
					sb.add(dr.ToGLSL() + " = inversesqrt(" + sr1.ToGLSL() + "); // rsq");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x0B: // pow
					sb.add(dr.ToGLSL() + " = pow(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "); // pow");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x0C: // log
					sb.add(dr.ToGLSL() + " = log2(" + sr1.ToGLSL() + "); // log");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x0D: // exp
					sb.add(dr.ToGLSL() + " = exp2(" + sr1.ToGLSL() + "); // exp");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x0E: // normalize
					sb.add(dr.ToGLSL() + " = normalize(" + sr1.ToGLSL() + "); // normalize");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x0F: // sin
					sb.add(dr.ToGLSL() + " = sin(" + sr1.ToGLSL() + "); // sin");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x10: // cos
					sb.add(dr.ToGLSL() + " = cos(" + sr1.ToGLSL() + "); // cos");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x11: // crs
					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.ToGLSL() + " = cross(vec3(" + sr1.ToGLSL() + "), vec3(" + sr2.ToGLSL() + ")); // crs");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x12: // dp3
					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.ToGLSL() + " = vec4(dot(vec3(" + sr1.ToGLSL() + "), vec3(" + sr2.ToGLSL() + ")))" + dr.GetWriteMask() + "; // dp3");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x13: // dp4
					sr1.sourceMask = sr2.sourceMask = 0xF; // adjust source mask for xyzw input to dot product
					sb.add(dr.ToGLSL() + " = vec4(dot(vec4(" + sr1.ToGLSL() + "), vec4(" + sr2.ToGLSL() + ")))" + dr.GetWriteMask() + "; // dp4");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x14: // abs
					sb.add(dr.ToGLSL() + " = abs(" + sr1.ToGLSL() + "); // abs");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x15: // neg
					sb.add(dr.ToGLSL() + " = -" + sr1.ToGLSL() + "; // neg");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x16: // saturate
					sb.add(dr.ToGLSL() + " = clamp(" + sr1.ToGLSL() + ", 0.0, 1.0); // saturate");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

				case 0x17: // m33
					//destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)
					//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)
					//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)
					{
						var existingUsage = map.GetRegisterUsage(sr2);
						if (existingUsage != RegisterUsage.Vector4 && existingUsage != RegisterUsage.Vector4Array) {
							sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " * mat3(" + sr2.ToGLSL(false) + "); // m33");
							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Matrix44); // 33?
						}
						else {
							// compose the matrix multiply from dot products
							sr1.sourceMask = sr2.sourceMask = 7;
							sb.add(dr.ToGLSL() + " = vec3(" +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 0) + "), " +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 1) + ")," +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 2) + ")); // m33");

							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Vector4, 0);
							map.AddSR(sr2, RegisterUsage.Vector4, 1);
							map.AddSR(sr2, RegisterUsage.Vector4, 2);
						}
					}

				case 0x18: // m44
					//multiply matrix 4x4
					//destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)+ (source1.w * source2[0].w)
					//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)+ (source1.w * source2[1].w)
					//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)+ (source1.w * source2[2].w)
					//destination.w = (source1.x * source2[3].x) + (source1.y * source2[3].y) + (source1.z * source2[3].z)+ (source1.w * source2[3].w)
					{
						var existingUsage = map.GetRegisterUsage(sr2);
						if (existingUsage != RegisterUsage.Vector4 && existingUsage != RegisterUsage.Vector4Array) {
							sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " * " + sr2.ToGLSL(false) + "; // m44");
							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Matrix44);
						}
						else {
							// compose the matrix multiply from dot products
							sr1.sourceMask = sr2.sourceMask = 0xF;
							sb.add(dr.ToGLSL() + " = vec4(" +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 0) + "), " +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 1) + "), " +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 2) + "), " +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 3) + ")); // m44");

							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Vector4, 0);
							map.AddSR(sr2, RegisterUsage.Vector4, 1);
							map.AddSR(sr2, RegisterUsage.Vector4, 2);
							map.AddSR(sr2, RegisterUsage.Vector4, 3);
						}
					}

				case 0x19: // m34
					//m34 0x19 multiply matrix 3x4
					//destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)+ (source1.w * source2[0].w)
					//destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)+ (source1.w * source2[1].w)
					//destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)+ (source1.w * source2[2].w)
					{
						// prevent w from being written for a m34
						dr.mask &= 7;

						var existingUsage = map.GetRegisterUsage(sr2);
						if (existingUsage != RegisterUsage.Vector4 && existingUsage != RegisterUsage.Vector4Array) {
							sb.add(dr.ToGLSL() + " = " + sr1.ToGLSL() + " * " + sr2.ToGLSL(false) + "; // m34");
							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Matrix44);
						}
						else {
							// compose the matrix multiply from dot products
							sr1.sourceMask = sr2.sourceMask = 0xF;
							sb.add(dr.ToGLSL() + " = vec3(" +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 0) + "), " +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 1) + ")," +
								   "dot(" + sr1.ToGLSL(true) + "," + sr2.ToGLSL(true, 2) + ")); // m34");

							map.AddDR(dr, RegisterUsage.Vector4);
							map.AddSR(sr1, RegisterUsage.Vector4);
							map.AddSR(sr2, RegisterUsage.Vector4, 0);
							map.AddSR(sr2, RegisterUsage.Vector4, 1);
							map.AddSR(sr2, RegisterUsage.Vector4, 2);
						}
					}

				case 0x27: // kill /  discard
					if (true) { //(openfl.display.Stage3D.allowDiscard) {
						// ensure we have a full source mask since there is no destination register
						sr1.sourceMask = 0xF;
						sb.add("if (any(lessThan(" + sr1.ToGLSL() + ", vec4(0)))) discard;");
						map.AddSR(sr1, RegisterUsage.Vector4);
					}

				case 0x28: // tex
					var sampler:SamplerReg = SamplerReg.Parse(source2, programType);

					switch (sampler.d)
					{
						case 0: // 2d texture

							sr1.sourceMask = 0x3;
							map.AddSaR(sampler, RegisterUsage.Sampler2D);
//#if (neko || cpp)
							//sb.add(dr.ToGLSL() + " = texture2D(" + sampler.ToGLSL() + ", " + sr1.ToGLSL() + ").zxyw; // tex");
//#else
							sb.add(dr.ToGLSL() + " = texture2D(" + sampler.ToGLSL() + ", " + sr1.ToGLSL() + "); // tex");
//#end

						case 1: // cube texture
							sr1.sourceMask = 0x7;
							sb.add(dr.ToGLSL() + " = textureCube(" + sampler.ToGLSL() + ", " + sr1.ToGLSL() + "); // tex");
							map.AddSaR(sampler, RegisterUsage.SamplerCube);
					}
					//sb.AppendFormat("{0} = vec4(0,1,0,1);", dr.ToGLSL() );
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);

					if (outSamplers != null) {
						// add sampler state to output list for caller
						outSamplers[sampler.n] = sampler.ToSamplerState();
					}

				case 0x29: // sge
					sr1.sourceMask = sr2.sourceMask = 0xF; // sge only supports vec4
					sb.add(dr.ToGLSL() + " = vec4(greaterThanEqual(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "))" + dr.GetWriteMask() + "; // ste");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x2A: // slt
					sr1.sourceMask = sr2.sourceMask = 0xF; // slt only supports vec4
					sb.add(dr.ToGLSL() + " = vec4(lessThan(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "))" + dr.GetWriteMask() + "; // slt");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x2C: // seq
					sr1.sourceMask = sr2.sourceMask = 0xF; // seq only supports vec4
					sb.add(dr.ToGLSL() + " = vec4(equal(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "))" + dr.GetWriteMask() + "; // seq");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				case 0x2D: // sne
					sr1.sourceMask = sr2.sourceMask = 0xF; // sne only supports vec4
					sb.add(dr.ToGLSL() + " = vec4(notEqual(" + sr1.ToGLSL() + ", " + sr2.ToGLSL() + "))" + dr.GetWriteMask() + "; // sne");
					map.AddDR(dr, RegisterUsage.Vector4);
					map.AddSR(sr1, RegisterUsage.Vector4);
					map.AddSR(sr2, RegisterUsage.Vector4);

				default:
					//sb.AppendFormat ("unsupported opcode" + opcode);
					throw new IllegalOperationError("Opcode " + opcode);
			}

			sb.add("\n");
		}


		var glslVersion = 100;
		// combine parts Into final progam
		var glsl = new StringBuf();
		glsl.add("// AGAL " + ((programType == ProgramType.Vertex) ? "vertex" : "fragment") + " shader\n");
		glsl.add("#version " + glslVersion + "\n");
		// Required to set the default precision of vectors
		glsl.add("precision highp float;\n");
		glsl.add(map.ToGLSL(false));
		if (programType == ProgramType.Vertex) {
			// this is needed for flipping render textures upside down
			glsl.add("uniform vec4 vcPositionScale;\n");
		}
		glsl.add("void main() {\n");
		glsl.add(map.ToGLSL(true));
		glsl.add(sb.toString());

		if (programType == ProgramType.Vertex) {
			// this is needed for flipping render textures upside down
			glsl.add("\tgl_Position *= vcPositionScale;\n");
		}
		glsl.add("}\n");
		// System.Console.WriteLine(glsl);
		return glsl.toString();
	}
}

