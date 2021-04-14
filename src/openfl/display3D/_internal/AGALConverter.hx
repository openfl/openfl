package openfl.display3D._internal;

import haxe.Int64;
import openfl.display._internal.SamplerState;
import openfl.utils._internal.Log;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
#if lime
import lime.graphics.opengl.GL;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class AGALConverter
{
	private static var limitedProfile:Null<Bool>#if !desktop = true #end;

	public static function prefixFromType(regType:RegisterType, programType:ProgramType):String
	{
		switch (regType)
		{
			case RegisterType.ATTRIBUTE:
				return "va";
			case RegisterType.CONSTANT:
				return (programType == ProgramType.VERTEX) ? "vc" : "fc";
			case RegisterType.TEMPORARY:
				return (programType == ProgramType.VERTEX) ? "vt" : "ft";
			case RegisterType.OUTPUT:
				return "output_";
			case RegisterType.VARYING:
				return "v";
			case RegisterType.SAMPLER:
				return "sampler";
			default:
				throw new IllegalOperationError("Invalid data!");
		}
	}

	private static function readUInt64(byteArray:ByteArray):Int64
	{
		var low = byteArray.readInt();
		var high = byteArray.readInt();
		return Int64.make(high, low);
	}

	public static function convertToGLSL(agal:ByteArray, samplerState:Array<SamplerState>):String
	{
		agal.position = 0;
		agal.endian = Endian.LITTLE_ENDIAN;

		var magic = agal.readByte() & 0xFF;

		if (magic == 0xB0)
		{
			// use embedded GLSL shader instead
			return agal.readUTF();
		}

		if (magic != 0xA0)
		{
			throw new IllegalOperationError("Magic value must be 0xA0, may not be AGAL");
		}

		var version = agal.readInt();

		if (version != 1)
		{
			throw new IllegalOperationError("Version must be 1");
		}

		var shaderTypeID = agal.readByte() & 0xFF;

		if (shaderTypeID != 0xA1)
		{
			throw new IllegalOperationError("Shader type ID must be 0xA1");
		}

		var programType = (agal.readByte() & 0xFF == 0) ? ProgramType.VERTEX : ProgramType.FRAGMENT;

		var map = new RegisterMap();
		var sb = new StringBuf();

		while (agal.position < agal.length)
		{
			// fetch instruction info
			var opcode = agal.readInt();
			var dest = agal.readUnsignedInt();
			var source1 = readUInt64(agal);
			var source2 = readUInt64(agal);

			// parse registers
			var dr = DestRegister.parse(dest, programType);
			var sr1 = SourceRegister.parse(source1, programType, dr.mask);
			var sr2 = SourceRegister.parse(source2, programType, dr.mask);

			// switch on opcode and emit GLSL
			sb.add("\t");

			switch (opcode)
			{
				case 0x00: // mov

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + "; // mov");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x01: // add

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " + " + sr2.toGLSL() + "; // add");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x02: // sub

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " - " + sr2.toGLSL() + "; // sub");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x03: // mul

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " * " + sr2.toGLSL() + "; // mul");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x04: // div

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " / " + sr2.toGLSL() + "; // div");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x05: // rcp

					var sr = sr1.toGLSL();

					if (sr.indexOf(".") > -1)
					{
						// swizzle
						sb.add(dr.toGLSL() + " = 1.0 / " + sr1.toGLSL() + "; // rcp");
					}
					else
					{
						sb.add(dr.toGLSL() + " = vec4(1) / " + sr1.toGLSL() + "; // rcp");
					}

					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x06: // min

					sb.add(dr.toGLSL() + " = min(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // min");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x07: // max

					sb.add(dr.toGLSL() + " = max(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // max");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x08: // frc

					sb.add(dr.toGLSL() + " = fract(" + sr1.toGLSL() + "); // frc");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x09: // sqrt

					sb.add(dr.toGLSL() + " = sqrt(" + sr1.toGLSL() + "); // sqrt");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x0A: // rsq

					sb.add(dr.toGLSL() + " = inversesqrt(" + sr1.toGLSL() + "); // rsq");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x0B: // pow

					sb.add(dr.toGLSL() + " = pow(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // pow");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x0C: // log

					sb.add(dr.toGLSL() + " = log2(" + sr1.toGLSL() + "); // log");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x0D: // exp

					sb.add(dr.toGLSL() + " = exp2(" + sr1.toGLSL() + "); // exp");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x0E: // normalize

					sb.add(dr.toGLSL() + " = normalize(" + sr1.toGLSL() + "); // normalize");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x0F: // sin

					sb.add(dr.toGLSL() + " = sin(" + sr1.toGLSL() + "); // sin");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x10: // cos

					sb.add(dr.toGLSL() + " = cos(" + sr1.toGLSL() + "); // cos");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x11: // crs

					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.toGLSL() + " = cross(vec3(" + sr1.toGLSL() + "), vec3(" + sr2.toGLSL() + ")); // crs");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x12: // dp3

					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.toGLSL() + " = vec4(dot(vec3(" + sr1.toGLSL() + "), vec3(" + sr2.toGLSL() + ")))" + dr.getWriteMask() + "; // dp3");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x13: // dp4

					sr1.sourceMask = sr2.sourceMask = 0xF; // adjust source mask for xyzw input to dot product
					sb.add(dr.toGLSL() + " = vec4(dot(vec4(" + sr1.toGLSL() + "), vec4(" + sr2.toGLSL() + ")))" + dr.getWriteMask() + "; // dp4");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x14: // abs

					sb.add(dr.toGLSL() + " = abs(" + sr1.toGLSL() + "); // abs");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x15: // neg

					sb.add(dr.toGLSL() + " = -" + sr1.toGLSL() + "; // neg");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x16: // saturate

					sb.add(dr.toGLSL() + " = clamp(" + sr1.toGLSL() + ", 0.0, 1.0); // saturate");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

				case 0x17: // m33

					// destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)
					// destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)
					// destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)

					var existingUsage = map.getRegisterUsage(sr2);

					if (existingUsage != RegisterUsage.VECTOR_4 && existingUsage != RegisterUsage.VECTOR_4_ARRAY)
					{
						sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " * mat3(" + sr2.toGLSL(false) + "); // m33");
						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.MATRIX_4_4); // 33?
					}
					else
					{
						// compose the matrix multiply from dot products
						sr1.sourceMask = sr2.sourceMask = 7;
						sb.add(dr.toGLSL() + " = vec3(" + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 0) + "), " + "dot(" + sr1.toGLSL(true) + ","
							+ sr2.toGLSL(true, 1) + ")," + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 2) + ")); // m33");

						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 0);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 1);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 2);
					}

				case 0x18: // m44

					// multiply matrix 4x4
					// destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)+ (source1.w * source2[0].w)
					// destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)+ (source1.w * source2[1].w)
					// destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)+ (source1.w * source2[2].w)
					// destination.w = (source1.x * source2[3].x) + (source1.y * source2[3].y) + (source1.z * source2[3].z)+ (source1.w * source2[3].w)

					var existingUsage = map.getRegisterUsage(sr2);

					if (existingUsage != RegisterUsage.VECTOR_4 && existingUsage != RegisterUsage.VECTOR_4_ARRAY)
					{
						sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " * " + sr2.toGLSL(false) + "; // m44");
						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.MATRIX_4_4);
					}
					else
					{
						// compose the matrix multiply from dot products
						sr1.sourceMask = sr2.sourceMask = 0xF;
						sb.add(dr.toGLSL() + " = vec4(" + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 0) + "), " + "dot(" + sr1.toGLSL(true) + ","
							+ sr2.toGLSL(true, 1) + "), " + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 2) + "), " + "dot(" + sr1.toGLSL(true) + ","
							+ sr2.toGLSL(true, 3) + ")); // m44");

						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 0);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 1);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 2);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 3);
					}

				case 0x19: // m34

					// m34 0x19 multiply matrix 3x4
					// destination.x = (source1.x * source2[0].x) + (source1.y * source2[0].y) + (source1.z * source2[0].z)+ (source1.w * source2[0].w)
					// destination.y = (source1.x * source2[1].x) + (source1.y * source2[1].y) + (source1.z * source2[1].z)+ (source1.w * source2[1].w)
					// destination.z = (source1.x * source2[2].x) + (source1.y * source2[2].y) + (source1.z * source2[2].z)+ (source1.w * source2[2].w)

					// prevent w from being written for a m34
					dr.mask &= 7;

					var existingUsage = map.getRegisterUsage(sr2);

					if (existingUsage != RegisterUsage.VECTOR_4 && existingUsage != RegisterUsage.VECTOR_4_ARRAY)
					{
						sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " * " + sr2.toGLSL(false) + "; // m34");
						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.MATRIX_4_4);
					}
					else
					{
						// compose the matrix multiply from dot products
						sr1.sourceMask = sr2.sourceMask = 0xF;
						sb.add(dr.toGLSL() + " = vec3(" + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 0) + "), " + "dot(" + sr1.toGLSL(true) + ","
							+ sr2.toGLSL(true, 1) + ")," + "dot(" + sr1.toGLSL(true) + "," + sr2.toGLSL(true, 2) + ")); // m34");

						map.addDR(dr, RegisterUsage.VECTOR_4);
						map.addSR(sr1, RegisterUsage.VECTOR_4);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 0);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 1);
						map.addSR(sr2, RegisterUsage.VECTOR_4, 2);
					}

				case 0x27: // kill /  discard

					if (true)
					{
						// (openfl.display.Stage3D.allowDiscard) {

						// ensure we have a full source mask since there is no destination register
						sr1.sourceMask = 0xF;
						sb.add("if (any(lessThan(" + sr1.toGLSL() + ", vec4(0)))) discard;");
						map.addSR(sr1, RegisterUsage.VECTOR_4);
					}

				case 0x28: // tex

					var sampler = SamplerRegister.parse(source2, programType);

					switch (sampler.d)
					{
						case 0: // 2d texture

							if (sampler.t == 2)
							{ // dxt5, sampler alpha

								sr1.sourceMask = 0x3;
								map.addSaR(sampler, RegisterUsage.SAMPLER_2D_ALPHA);
								sb.add("if (" + sampler.toGLSL() + "_alphaEnabled) {\n");
								sb.add("\t\t" + dr.toGLSL() + " = vec4(texture2D(" + sampler.toGLSL() + ", " + sr1.toGLSL() + ").xyz, texture2D("
									+ sampler.toGLSL() + "_alpha, " + sr1.toGLSL() + ").x); // tex + alpha\n");
								sb.add("\t} else {\n");
								sb.add("\t\t" + dr.toGLSL() + " = texture2D(" + sampler.toGLSL() + ", " + sr1.toGLSL() + "); // tex\n");
								sb.add("\t}");
							}
							else
							{
								sr1.sourceMask = 0x3;
								map.addSaR(sampler, RegisterUsage.SAMPLER_2D);
								sb.add(dr.toGLSL() + " = texture2D(" + sampler.toGLSL() + ", " + sr1.toGLSL() + "); // tex");
							}

						case 1: // cube texture

							if (sampler.t == 2)
							{ // dxt5, sampler alpha

								sr1.sourceMask = 0x7;
								map.addSaR(sampler, RegisterUsage.SAMPLER_CUBE_ALPHA);
								sb.add("if (" + sampler.toGLSL() + "_alphaEnabled) {\n");
								sb.add("\t\t" + dr.toGLSL() + " = vec4(textureCube(" + sampler.toGLSL() + ", " + sr1.toGLSL() + ").xyz, textureCube("
									+ sampler.toGLSL() + "_alpha, " + sr1.toGLSL() + ").x); // tex + alpha\n");
								sb.add("\t} else {\n");
								sb.add("\t\t" + dr.toGLSL() + " = textureCube(" + sampler.toGLSL() + ", " + sr1.toGLSL() + "); // tex");
								sb.add("\t}");
							}
							else
							{
								sr1.sourceMask = 0x7;
								sb.add(dr.toGLSL() + " = textureCube(" + sampler.toGLSL() + ", " + sr1.toGLSL() + "); // tex");
								map.addSaR(sampler, RegisterUsage.SAMPLER_CUBE);
							}
					}

					// sb.AppendFormat("{0} = vec4(0,1,0,1);", dr.toGLSL () );
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

					if (samplerState != null)
					{
						// add sampler state to output list for caller
						samplerState[sampler.n] = sampler.toSamplerState();
					}

				case 0x29: // sge

					sr1.sourceMask = sr2.sourceMask = 0xF; // sge only supports vec4
					sb.add(dr.toGLSL() + " = vec4(greaterThanEqual(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // ste");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x2A: // slt

					sr1.sourceMask = sr2.sourceMask = 0xF; // slt only supports vec4
					sb.add(dr.toGLSL() + " = vec4(lessThan(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // slt");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x2C: // seq

					sr1.sourceMask = sr2.sourceMask = 0xF; // seq only supports vec4
					sb.add(dr.toGLSL() + " = vec4(equal(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // seq");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				case 0x2D: // sne

					sr1.sourceMask = sr2.sourceMask = 0xF; // sne only supports vec4
					sb.add(dr.toGLSL() + " = vec4(notEqual(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // sne");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);

				default:
					// sb.AppendFormat ("unsupported opcode" + opcode);
					throw new IllegalOperationError("Opcode " + opcode);
			}

			sb.add("\n");
		}

		#if lime
		if (limitedProfile == null)
		{
			var version:String = GL.getParameter(GL.VERSION);
			limitedProfile = (version.indexOf("OpenGL ES") > -1 || version.indexOf("WebGL") > -1);
		}
		#end

		// combine parts into final progam
		var glsl = new StringBuf();
		glsl.add("// AGAL " + ((programType == ProgramType.VERTEX) ? "vertex" : "fragment") + " shader\n");

		if (limitedProfile)
		{
			glsl.add("#version 100\n");

			// Required to set the default precision of vectors
			glsl.add("#ifdef GL_FRAGMENT_PRECISION_HIGH\n");
			glsl.add("precision highp float;\n");
			glsl.add("#else\n");
			glsl.add("precision mediump float;\n");
			glsl.add("#endif\n");
		}
		else
		{
			glsl.add("#version 120\n");
		}

		glsl.add(map.toGLSL(false));

		if (programType == ProgramType.VERTEX)
		{
			// this is needed for flipping render textures upside down
			glsl.add("uniform vec4 vcPositionScale;\n");
		}

		glsl.add("void main() {\n");
		glsl.add(map.toGLSL(true));
		glsl.add(sb.toString());

		if (programType == ProgramType.VERTEX)
		{
			// this is needed for flipping render textures upside down
			glsl.add("\tgl_Position *= vcPositionScale;\n");
		}

		glsl.add("}\n");

		// System.Console.WriteLine(glsl);
		return glsl.toString();
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class DestRegister
{
	public var mask:Int;
	public var n:Int;
	public var programType:ProgramType;
	public var type:RegisterType;

	public function new() {}

	public function getWriteMask():String
	{
		var str:String = ".";
		if ((mask & 1) != 0) str += "x";
		if ((mask & 2) != 0) str += "y";
		if ((mask & 4) != 0) str += "z";
		if ((mask & 8) != 0) str += "w";
		return str;
	}

	public static function parse(v:UInt, programType:ProgramType):DestRegister
	{
		var dr = new DestRegister();
		dr.programType = programType;
		dr.type = cast((v >> 24) & 0xF);
		dr.mask = ((v >> 16) & 0xF);
		dr.n = (v & 0xFFFF);
		return dr;
	}

	public function toGLSL(useMask:Bool = true):String
	{
		var str:String;

		if (type == RegisterType.OUTPUT)
		{
			str = programType == ProgramType.VERTEX ? "gl_Position" : "gl_FragColor";
		}
		else
		{
			str = AGALConverter.prefixFromType(type, programType) + n;
		}

		if (useMask && mask != 0xF)
		{
			str += getWriteMask();
		}

		return str;
	}
}

private enum ProgramType
{
	VERTEX;
	FRAGMENT;
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class RegisterMap
{
	private var mEntries:Array<RegisterMapEntry> = new Array();

	public function new()
	{
		// Stub.
	}

	public function add(type:RegisterType, name:String, number:Int, usage:RegisterUsage):Void
	{
		for (entry in mEntries)
		{
			if (entry.type == type && entry.name == name && entry.number == number)
			{
				if (entry.usage != usage)
				{
					throw new IllegalOperationError("Cannot use register in multiple ways yet (mat4/vec4)");
				}

				return;
			}
		}

		var entry = new RegisterMapEntry();
		entry.type = type;
		entry.name = name;
		entry.number = number;
		entry.usage = usage;
		mEntries.push(entry);
	}

	public function addDR(dr:DestRegister, usage:RegisterUsage):Void
	{
		add(dr.type, dr.toGLSL(false), dr.n, usage);
	}

	public function addSaR(sr:SamplerRegister, usage:RegisterUsage):Void
	{
		add(sr.type, sr.toGLSL(), sr.n, usage);
	}

	public function addSR(sr:SourceRegister, usage:RegisterUsage, offset:Int = 0):Void
	{
		if (sr.d != 0)
		{
			add(sr.itype, AGALConverter.prefixFromType(sr.itype, sr.programType) + sr.n, sr.n, RegisterUsage.VECTOR_4);
			add(sr.type, AGALConverter.prefixFromType(sr.type, sr.programType) + sr.o, sr.o, RegisterUsage.VECTOR_4_ARRAY);
			return;
		}

		add(sr.type, sr.toGLSL(false, offset), sr.n + offset, usage);
	}

	public function getRegisterUsage(sr:SourceRegister):RegisterUsage
	{
		if (sr.d != 0)
		{
			return RegisterUsage.VECTOR_4_ARRAY;
		}

		return getUsage(sr.type, sr.toGLSL(false), sr.n);
	}

	public function getUsage(type:RegisterType, name:String, number:Int):RegisterUsage
	{
		for (entry in mEntries)
		{
			if (entry.type == type && entry.name == name && entry.number == number)
			{
				return entry.usage;
			}
		}

		return RegisterUsage.UNUSED;
	}

	public function toGLSL(tempRegistersOnly:Bool):String
	{
		mEntries.sort(function(a:RegisterMapEntry, b:RegisterMapEntry):Int
		{
			return a.number - b.number;
		});

		var entry:RegisterMapEntry;

		mEntries.sort(function(a:RegisterMapEntry, b:RegisterMapEntry):Int
		{
			return cast(a.type, Int) - cast(b.type, Int);
		});

		var sb = new StringBuf();

		for (i in 0...mEntries.length)
		{
			entry = mEntries[i];

			// only emit temporary registers based on Boolean passed in
			// this is so temp registers can be grouped in the main() block
			if ((tempRegistersOnly && entry.type != RegisterType.TEMPORARY)
				|| (!tempRegistersOnly && entry.type == RegisterType.TEMPORARY))
			{
				continue;
			}

			// dont emit output registers
			if (entry.type == RegisterType.OUTPUT)
			{
				continue;
			}

			switch (entry.type)
			{
				case RegisterType.ATTRIBUTE:
					// sb.AppendFormat("layout(location = {0}) ", entry.number);
					sb.add("attribute ");

				case RegisterType.CONSTANT:
					// sb.AppendFormat("layout(location = {0}) ", entry.number);
					sb.add("uniform ");

				case RegisterType.TEMPORARY:
					sb.add("\t");

				case RegisterType.OUTPUT:

				case RegisterType.VARYING:
					sb.add("varying ");

				case RegisterType.SAMPLER:
					sb.add("uniform ");

				default:
					throw new IllegalOperationError();
			}

			switch (entry.usage)
			{
				case RegisterUsage.VECTOR_4:
					sb.add("vec4 ");

				case RegisterUsage.VECTOR_4_ARRAY:
					sb.add("vec4 ");

				case RegisterUsage.MATRIX_4_4:
					sb.add("mat4 ");

				case RegisterUsage.SAMPLER_2D:
					sb.add("sampler2D ");

				case RegisterUsage.SAMPLER_CUBE:
					sb.add("samplerCube ");

				case RegisterUsage.UNUSED:
					Log.info("Missing switch patten: RegisterUsage.UNUSED");

				case RegisterUsage.SAMPLER_2D_ALPHA:

				// trace ("Missing switch patten: RegisterUsage.SAMPLER_2D_ALPHA");

				case RegisterUsage.SAMPLER_CUBE_ALPHA:
			}

			if (entry.usage == RegisterUsage.SAMPLER_2D_ALPHA)
			{
				sb.add("sampler2D ");
				sb.add(entry.name);
				sb.add(";\n");

				sb.add("uniform ");
				sb.add("sampler2D ");
				sb.add(entry.name + "_alpha");
				sb.add(";\n");

				sb.add("uniform ");
				sb.add("bool ");
				sb.add(entry.name + "_alphaEnabled");
				sb.add(";\n");
			}
			else if (entry.usage == RegisterUsage.SAMPLER_CUBE_ALPHA)
			{
				sb.add("samplerCube ");
				sb.add(entry.name);
				sb.add(";\n");

				sb.add("uniform ");
				sb.add("samplerCube ");
				sb.add(entry.name + "_alpha");
				sb.add(";\n");

				sb.add("uniform ");
				sb.add("bool ");
				sb.add(entry.name + "_alphaEnabled");
				sb.add(";\n");
			}
			else if (entry.usage == RegisterUsage.VECTOR_4_ARRAY)
			{
				sb.add(entry.name + "[128]"); // this is an array of "count" elements.
				sb.add(";\n");
			}
			else
			{
				sb.add(entry.name);
				sb.add(";\n");
			}
		}

		return sb.toString();
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class RegisterMapEntry
{
	public var name:String;
	public var number:Int;
	public var type:RegisterType;
	public var usage:RegisterUsage;

	public function new() {}
}

@:enum abstract RegisterType(Int)
{
	public var ATTRIBUTE = 0;
	public var CONSTANT = 1;
	public var TEMPORARY = 2;
	public var OUTPUT = 3;
	public var VARYING = 4;
	public var SAMPLER = 5;
}

private enum RegisterUsage
{
	UNUSED;
	VECTOR_4;
	MATRIX_4_4;
	SAMPLER_2D;
	SAMPLER_2D_ALPHA;
	SAMPLER_CUBE;
	SAMPLER_CUBE_ALPHA;
	VECTOR_4_ARRAY;
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class SamplerRegister
{
	public var b:Int; // lod bias
	public var d:Int; // dimension 0=2d 1=cube
	public var f:Int; // Filter (0=nearest,1=linear) (4 bits)
	public var m:Int; // Mipmap (0=disable,1=nearest, 2=linear)
	public var n:Int; // number
	public var programType:ProgramType;
	public var s:Int; // special flags bit
	public var t:Int; // texture format (0=none, dxt1=1, dxt5=2)
	public var type:RegisterType;
	public var w:Int; // wrap (0=clamp 1=repeat)

	public function new() {}

	public static function parse(v:Int64, programType:ProgramType):SamplerRegister
	{
		var sr = new SamplerRegister();
		sr.programType = programType;
		sr.f = ((v >> 60) & 0xF).low; // filter
		sr.m = ((v >> 56) & 0xF).low; // mipmap
		sr.w = ((v >> 52) & 0xF).low; // wrap
		sr.s = ((v >> 48) & 0xF).low; // special
		sr.d = ((v >> 44) & 0xF).low; // dimension
		sr.t = ((v >> 40) & 0xF).low; // texture
		sr.type = cast((v >> 32) & 0xF).low; // type
		sr.b = ((v >> 16) & 0xFF).low; // TODO: should this be .low?
		sr.n = (v & 0xFFFF).low; // number
		return sr;
	}

	public function toGLSL():String
	{
		var str = AGALConverter.prefixFromType(type, programType) + n;
		return str;
	}

	public function toSamplerState():SamplerState
	{
		var wrap:Context3DWrapMode;
		var filter:Context3DTextureFilter;
		var mipfilter:Context3DMipFilter;

		// TODO: anisotropic support?

		// translate texture filter
		switch (f)
		{
			case 0:
				filter = NEAREST;
			case 1:
				filter = LINEAR;
			default:
				throw new IllegalOperationError();
		}

		// translate min filter
		switch (m)
		{
			// disable
			case 0:
				mipfilter = MIPNONE;
			// nearest
			case 1:
				mipfilter = MIPNEAREST;
			// linear
			case 2:
				mipfilter = MIPLINEAR;
			default:
				throw new IllegalOperationError();
		}

		// TODO: Clamp + repeat modes?

		// translate wrapping mode
		switch (w)
		{
			case 0:
				wrap = CLAMP;
			case 1:
				wrap = REPEAT;
			default:
				throw new IllegalOperationError();
		}

		var ignoreSampler = (s & 4 == 4);
		var centroid = (s & 1 == 1);
		var textureAlpha = (t == 2);

		// translate lod bias, sign extend and /8
		var lodBias:Float = ((b << 24) >> 24) / 8.0;

		return new SamplerState(wrap, filter, mipfilter, lodBias, ignoreSampler, centroid, textureAlpha);
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class SourceRegister
{
	public var d:Int;
	public var itype:RegisterType;
	public var n:Int;
	public var o:Int;
	public var programType:ProgramType;
	public var q:Int;
	public var s:Int;
	public var sourceMask:Int;
	public var type:RegisterType;

	public function new() {}

	public static function parse(v:Int64, programType:ProgramType, sourceMask:Int):SourceRegister
	{
		var sr = new SourceRegister();
		sr.programType = programType;
		sr.d = ((v >> 63) & 1).low; // Direct=0/Indirect=1 for direct Q and I are ignored, 1bit
		sr.q = ((v >> 48) & 0x3).low; // index register component select
		sr.itype = cast((v >> 40) & 0xF).low; // index register type
		sr.type = cast((v >> 32) & 0xF).low; // type
		sr.s = ((v >> 24) & 0xFF).low; // swizzle
		sr.o = ((v >> 16) & 0xFF).low; // indirect offset
		sr.n = (v & 0xFFFF).low; // number
		sr.sourceMask = sourceMask;
		return sr;
	}

	public function toGLSL(emitSwizzle:Bool = true, offset:Int = 0):String
	{
		if (type == RegisterType.OUTPUT)
		{
			return programType == ProgramType.VERTEX ? "gl_Position" : "gl_FragColor";
		}

		var fullxyzw = (s == 228) && (sourceMask == 0xF);
		var swizzle = "";

		if (type != RegisterType.SAMPLER && !fullxyzw)
		{
			for (i in 0...4)
			{
				// only output swizzles for each source mask
				if ((sourceMask & (1 << i)) != 0)
				{
					switch ((s >> (i * 2)) & 3)
					{
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

		var str = AGALConverter.prefixFromType(type, programType);

		if (d == 0)
		{
			// direct register
			str += (n + offset);
		}
		else
		{
			// indirect register
			str += o;
			var indexComponent = "";
			switch (q)
			{
				case 0:
					indexComponent = "x";
				case 1:
					indexComponent = "y";
				case 2:
					indexComponent = "z";
				case 3:
					indexComponent = "w";
			}
			var indexRegister = AGALConverter.prefixFromType(itype, programType) + this.n + "." + indexComponent;
			str += "[ int(" + indexRegister + ") +" + offset + "]";
		}

		if (emitSwizzle && swizzle != "")
		{
			str += "." + swizzle;
		}

		return str;
	}
}
