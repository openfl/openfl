import SamplerState from "../../../_internal/renderer/SamplerState";
import Context3DMipFilter from "../../../display3D/Context3DMipFilter";
import Context3DTextureFilter from "../../../display3D/Context3DTextureFilter";
import Context3DWrapMode from "../../../display3D/Context3DWrapMode";
import Program3D from "../../../display3D/Program3D";
import IllegalOperationError from "../../../errors/IllegalOperationError";
import ByteArray from "../../../utils/ByteArray";
import Endian from "../../../utils/Endian";

export default class AGALConverter
{
	private static limitedProfile: null | boolean = true;

	public static prefixFromType(regType: RegisterType, programType: ProgramType): string
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

	private static readUInt64(byteArray: ByteArray): number64
	{
		var low = byteArray.readInt();
		var high = byteArray.readInt();
		return Int64.make(high, low);
	}

	public static convertToGLSL(program: Program3D, agal: ByteArray, samplerState: Array<SamplerState>): string
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

		var programType = ((agal.readByte() & 0xFF) == 0) ? ProgramType.VERTEX : ProgramType.FRAGMENT;

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
					break;

				case 0x01: // add

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " + " + sr2.toGLSL() + "; // add");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x02: // sub

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " - " + sr2.toGLSL() + "; // sub");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x03: // mul

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " * " + sr2.toGLSL() + "; // mul");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x04: // div

					sb.add(dr.toGLSL() + " = " + sr1.toGLSL() + " / " + sr2.toGLSL() + "; // div");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

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
					break;

				case 0x06: // min

					sb.add(dr.toGLSL() + " = min(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // min");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x07: // max

					sb.add(dr.toGLSL() + " = max(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // max");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x08: // frc

					sb.add(dr.toGLSL() + " = fract(" + sr1.toGLSL() + "); // frc");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x09: // sqrt

					sb.add(dr.toGLSL() + " = sqrt(" + sr1.toGLSL() + "); // sqrt");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x0A: // rsq

					sb.add(dr.toGLSL() + " = inversesqrt(" + sr1.toGLSL() + "); // rsq");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x0B: // pow

					sb.add(dr.toGLSL() + " = pow(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "); // pow");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x0C: // log

					sb.add(dr.toGLSL() + " = log2(" + sr1.toGLSL() + "); // log");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x0D: // exp

					sb.add(dr.toGLSL() + " = exp2(" + sr1.toGLSL() + "); // exp");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x0E: // normalize

					sb.add(dr.toGLSL() + " = normalize(" + sr1.toGLSL() + "); // normalize");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x0F: // sin

					sb.add(dr.toGLSL() + " = sin(" + sr1.toGLSL() + "); // sin");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x10: // cos

					sb.add(dr.toGLSL() + " = cos(" + sr1.toGLSL() + "); // cos");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x11: // crs

					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.toGLSL() + " = cross(vec3(" + sr1.toGLSL() + "), vec3(" + sr2.toGLSL() + ")); // crs");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x12: // dp3

					sr1.sourceMask = sr2.sourceMask = 7; // adjust source mask for xyz input to dot product
					sb.add(dr.toGLSL() + " = vec4(dot(vec3(" + sr1.toGLSL() + "), vec3(" + sr2.toGLSL() + ")))" + dr.getWriteMask() + "; // dp3");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x13: // dp4

					sr1.sourceMask = sr2.sourceMask = 0xF; // adjust source mask for xyzw input to dot product
					sb.add(dr.toGLSL() + " = vec4(dot(vec4(" + sr1.toGLSL() + "), vec4(" + sr2.toGLSL() + ")))" + dr.getWriteMask() + "; // dp4");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x14: // abs

					sb.add(dr.toGLSL() + " = abs(" + sr1.toGLSL() + "); // abs");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x15: // neg

					sb.add(dr.toGLSL() + " = -" + sr1.toGLSL() + "; // neg");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

				case 0x16: // saturate

					sb.add(dr.toGLSL() + " = clamp(" + sr1.toGLSL() + ", 0.0, 1.0); // saturate");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					break;

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
					break;

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
					break;

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
					break;

				case 0x27: // kill /  discard

					if (true)
					{
						// (openfl.display.Stage3D.allowDiscard) {

						// ensure we have a full source mask since there is no destination register
						sr1.sourceMask = 0xF;
						sb.add("if (any(lessThan(" + sr1.toGLSL() + ", vec4(0)))) discard;");
						map.addSR(sr1, RegisterUsage.VECTOR_4);
					}
					break;

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
							break;

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
							break;
					}

					// sb.AppendFormat("{0} = vec4(0,1,0,1);", dr.toGLSL () );
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);

					if (samplerState != null)
					{
						// add sampler state to output list for caller
						samplerState[sampler.n] = sampler.toSamplerState();
					}
					break;

				case 0x29: // sge

					sr1.sourceMask = sr2.sourceMask = 0xF; // sge only supports vec4
					sb.add(dr.toGLSL() + " = vec4(greaterThanEqual(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // ste");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x2A: // slt

					sr1.sourceMask = sr2.sourceMask = 0xF; // slt only supports vec4
					sb.add(dr.toGLSL() + " = vec4(lessThan(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // slt");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x2C: // seq

					sr1.sourceMask = sr2.sourceMask = 0xF; // seq only supports vec4
					sb.add(dr.toGLSL() + " = vec4(equal(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // seq");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				case 0x2D: // sne

					sr1.sourceMask = sr2.sourceMask = 0xF; // sne only supports vec4
					sb.add(dr.toGLSL() + " = vec4(notEqual(" + sr1.toGLSL() + ", " + sr2.toGLSL() + "))" + dr.getWriteMask() + "; // sne");
					map.addDR(dr, RegisterUsage.VECTOR_4);
					map.addSR(sr1, RegisterUsage.VECTOR_4);
					map.addSR(sr2, RegisterUsage.VECTOR_4);
					break;

				default:
					// sb.AppendFormat ("unsupported opcode" + opcode);
					throw new IllegalOperationError("Opcode " + opcode);
			}

			sb.add("\n");
		}

		// if (this.limitedProfile == null)
		// {
		// var gl = (<internal.Context3D><any>(<internal.Program3D><any>program).__context).__gl;
		// var version: string = gl.getParameter(GL.VERSION);
		// this.limitedProfile = (version.indexOf("OpenGL ES") > -1 || version.indexOf("WebGL") > -1);
		// }

		// combine parts into final progam
		var glsl = new StringBuf();
		glsl.add("// AGAL " + ((programType == ProgramType.VERTEX) ? "vertex" : "fragment") + " shader\n");

		if (this.limitedProfile)
		{
			glsl.add("#version 100\n");

			// Required to set the default precision of vectors
			glsl.add("precision highp float;\n");
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

class DestRegister
{
	public mask: number;
	public n: number;
	public programType: ProgramType;
	public type: RegisterType;

	public constructor() { }

	public getWriteMask(): string
	{
		var str: string = ".";
		if ((this.mask & 1) != 0) str += "x";
		if ((this.mask & 2) != 0) str += "y";
		if ((this.mask & 4) != 0) str += "z";
		if ((this.mask & 8) != 0) str += "w";
		return str;
	}

	public static parse(v: number, programType: ProgramType): DestRegister
	{
		var dr = new DestRegister();
		dr.programType = programType;
		dr.type = ((v >> 24) & 0xF);
		dr.mask = ((v >> 16) & 0xF);
		dr.n = (v & 0xFFFF);
		return dr;
	}

	public toGLSL(useMask: boolean = true): string
	{
		var str: string;

		if (this.type == RegisterType.OUTPUT)
		{
			str = this.programType == ProgramType.VERTEX ? "gl_Position" : "gl_FragColor";
		}
		else
		{
			str = AGALConverter.prefixFromType(this.type, this.programType) + this.n;
		}

		if (useMask && this.mask != 0xF)
		{
			str += this.getWriteMask();
		}

		return str;
	}
}

enum ProgramType
{
	VERTEX,
	FRAGMENT
}

class RegisterMap
{
	private mEntries: Array<RegisterMapEntry> = new Array();

	public constructor()
	{
		// Stub.
	}

	public add(type: RegisterType, name: string, number: number, usage: RegisterUsage): void
	{
		for (let entry of this.mEntries)
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
		this.mEntries.push(entry);
	}

	public addDR(dr: DestRegister, usage: RegisterUsage): void
	{
		this.add(dr.type, dr.toGLSL(false), dr.n, usage);
	}

	public addSaR(sr: SamplerRegister, usage: RegisterUsage): void
	{
		this.add(sr.type, sr.toGLSL(), sr.n, usage);
	}

	public addSR(sr: SourceRegister, usage: RegisterUsage, offset: number = 0): void
	{
		if (sr.d != 0)
		{
			this.add(sr.itype, AGALConverter.prefixFromType(sr.itype, sr.programType) + sr.n, sr.n, RegisterUsage.VECTOR_4);
			this.add(sr.type, AGALConverter.prefixFromType(sr.type, sr.programType) + sr.o, sr.o, RegisterUsage.VECTOR_4_ARRAY);
			return;
		}

		this.add(sr.type, sr.toGLSL(false, offset), sr.n + offset, usage);
	}

	public getRegisterUsage(sr: SourceRegister): RegisterUsage
	{
		if (sr.d != 0)
		{
			return RegisterUsage.VECTOR_4_ARRAY;
		}

		return this.getUsage(sr.type, sr.toGLSL(false), sr.n);
	}

	public getUsage(type: RegisterType, name: string, number: number): RegisterUsage
	{
		for (let entry of this.mEntries)
		{
			if (entry.type == type && entry.name == name && entry.number == number)
			{
				return entry.usage;
			}
		}

		return RegisterUsage.UNUSED;
	}

	public toGLSL(tempRegistersOnly: boolean): string
	{
		this.mEntries.sort(function (a: RegisterMapEntry, b: RegisterMapEntry): number
		{
			return a.number - b.number;
		});

		var entry: RegisterMapEntry;

		this.mEntries.sort(function (a: RegisterMapEntry, b: RegisterMapEntry): number
		{
			return a.type - b.type;
		});

		var sb = new StringBuf();

		for (let i = 0; i < this.mEntries.length; i++)
		{
			entry = this.mEntries[i];

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
					break;

				case RegisterType.CONSTANT:
					// sb.AppendFormat("layout(location = {0}) ", entry.number);
					sb.add("uniform ");
					break;

				case RegisterType.TEMPORARY:
					sb.add("\t");
					break;

				case RegisterType.OUTPUT:
					break;

				case RegisterType.VARYING:
					sb.add("varying ");
					break;

				case RegisterType.SAMPLER:
					sb.add("uniform ");
					break;

				default:
					throw new IllegalOperationError();
			}

			switch (entry.usage)
			{
				case RegisterUsage.VECTOR_4:
					sb.add("vec4 ");
					break;

				case RegisterUsage.VECTOR_4_ARRAY:
					sb.add("vec4 ");
					break;

				case RegisterUsage.MATRIX_4_4:
					sb.add("mat4 ");
					break;

				case RegisterUsage.SAMPLER_2D:
					sb.add("sampler2D ");
					break;

				case RegisterUsage.SAMPLER_CUBE:
					sb.add("samplerCube ");
					break;

				case RegisterUsage.UNUSED:
					console.info("Missing switch patten: RegisterUsage.UNUSED");
					break;

				case RegisterUsage.SAMPLER_2D_ALPHA:
					break;

				// trace ("Missing switch patten: RegisterUsage.SAMPLER_2D_ALPHA");

				case RegisterUsage.SAMPLER_CUBE_ALPHA:
					break;
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

class RegisterMapEntry
{
	public name: string;
	public number: number;
	public type: RegisterType;
	public usage: RegisterUsage;

	public constructor() { }
}

enum RegisterType
{
	ATTRIBUTE = 0,
	CONSTANT = 1,
	TEMPORARY = 2,
	OUTPUT = 3,
	VARYING = 4,
	SAMPLER = 5
}

enum RegisterUsage
{
	UNUSED,
	VECTOR_4,
	MATRIX_4_4,
	SAMPLER_2D,
	SAMPLER_2D_ALPHA,
	SAMPLER_CUBE,
	SAMPLER_CUBE_ALPHA,
	VECTOR_4_ARRAY
}

class SamplerRegister
{
	public b: number; // lod bias
	public d: number; // dimension 0=2d 1=cube
	public f: number; // Filter (0=nearest,1=linear) (4 bits)
	public m: number; // Mipmap (0=disable,1=nearest, 2=linear)
	public n: number; // number
	public programType: ProgramType;
	public s: number; // special flags bit
	public t: number; // texture format (0=none, dxt1=1, dxt5=2)
	public type: RegisterType;
	public w: number; // wrap (0=clamp 1=repeat)

	public constructor() { }

	public static parse(v: number64, programType: ProgramType): SamplerRegister
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

	public toGLSL(): string
	{
		var str = AGALConverter.prefixFromType(this.type, this.programType) + this.n;
		return str;
	}

	public toSamplerState(): SamplerState
	{
		var wrap: Context3DWrapMode;
		var filter: Context3DTextureFilter;
		var mipfilter: Context3DMipFilter;

		// TODO: anisotropic support?

		// translate texture filter
		switch (this.f)
		{
			case 0:
				filter = Context3DTextureFilter.NEAREST;
				break;
			case 1:
				filter = Context3DTextureFilter.LINEAR;
				break;
			default:
				throw new IllegalOperationError();
		}

		// translate min filter
		switch (this.m)
		{
			// disable
			case 0:
				mipfilter = Context3DMipFilter.MIPNONE;
				break;
			// nearest
			case 1:
				mipfilter = Context3DMipFilter.MIPNEAREST;
				break;
			// linear
			case 2:
				mipfilter = Context3DMipFilter.MIPLINEAR;
				break;
			default:
				throw new IllegalOperationError();
		}

		// TODO: Clamp + repeat modes?

		// translate wrapping mode
		switch (this.w)
		{
			case 0:
				wrap = Context3DWrapMode.CLAMP;
				break;
			case 1:
				wrap = Context3DWrapMode.REPEAT;
				break;
			default:
				throw new IllegalOperationError();
		}

		var ignoreSampler = ((this.s & 4) == 4);
		var centroid = ((this.s & 1) == 1);
		var textureAlpha = (this.t == 2);

		// translate lod bias, sign extend and /8
		var lodBias: number = ((this.b << 24) >> 24) / 8.0;

		return new SamplerState(wrap, filter, mipfilter, lodBias, ignoreSampler, centroid, textureAlpha);
	}
}

class SourceRegister
{
	public d: number;
	public itype: RegisterType;
	public n: number;
	public o: number;
	public programType: ProgramType;
	public q: number;
	public s: number;
	public sourceMask: number;
	public type: RegisterType;

	public constructor() { }

	public static parse(v: number64, programType: ProgramType, sourceMask: number): SourceRegister
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

	public toGLSL(emitSwizzle: boolean = true, offset: number = 0): string
	{
		if (this.type == RegisterType.OUTPUT)
		{
			return this.programType == ProgramType.VERTEX ? "gl_Position" : "gl_FragColor";
		}

		var fullxyzw = (this.s == 228) && (this.sourceMask == 0xF);
		var swizzle = "";

		if (this.type != RegisterType.SAMPLER && !fullxyzw)
		{
			for (let i = 0; i < 4; i++)
			{
				// only output swizzles for each source mask
				if ((this.sourceMask & (1 << i)) != 0)
				{
					switch ((this.s >> (i * 2)) & 3)
					{
						case 0:
							swizzle += "x";
							break;
						case 1:
							swizzle += "y";
							break;
						case 2:
							swizzle += "z";
							break;
						case 3:
							swizzle += "w";
							break;
					}
				}
			}
		}

		var str = AGALConverter.prefixFromType(this.type, this.programType);

		if (this.d == 0)
		{
			// direct register
			str += (this.n + offset);
		}
		else
		{
			// indirect register
			str += this.o;
			var indexComponent = "";
			switch (this.q)
			{
				case 0:
					indexComponent = "x";
					break;
				case 1:
					indexComponent = "y";
					break;
				case 2:
					indexComponent = "z";
					break;
				case 3:
					indexComponent = "w";
					break;
			}
			var indexRegister = AGALConverter.prefixFromType(this.itype, this.programType) + this.n + "." + indexComponent;
			str += "[ int(" + indexRegister + ") +" + offset + "]";
		}

		if (emitSwizzle && swizzle != "")
		{
			str += "." + swizzle;
		}

		return str;
	}
}
