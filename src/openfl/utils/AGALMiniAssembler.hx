/*
	Copyright (c) 2015, Adobe Systems Incorporated
	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:
	* Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.
	* Neither the name of Adobe Systems Incorporated nor the names of its
	contributors may be used to endorse or promote products derived from
	this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
	PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

package openfl.utils;

import openfl.utils._internal.Log;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings(["checkstyle:ConstantName", "checkstyle:FieldDocComment"])
class AGALMiniAssembler
{
	@:noCompletion private static var OPMAP:Map<String, OpCode> = new Map();
	@:noCompletion private static var REGMAP:Map<String, Register> = new Map();
	@:noCompletion private static var SAMPLEMAP:Map<String, Sampler> = new Map();
	@:noCompletion private static inline var MAX_NESTING:Int = 4;
	@:noCompletion private static inline var MAX_OPCODES:Int = 4096;
	@:noCompletion private static inline var FRAGMENT:String = "fragment";
	@:noCompletion private static inline var VERTEX:String = "vertex";
	// masks and shifts
	@:noCompletion private static inline var SAMPLER_TYPE_SHIFT:Int = 8;
	@:noCompletion private static inline var SAMPLER_DIM_SHIFT:Int = 12;
	@:noCompletion private static inline var SAMPLER_SPECIAL_SHIFT:Int = 16;
	@:noCompletion private static inline var SAMPLER_REPEAT_SHIFT:Int = 20;
	@:noCompletion private static inline var SAMPLER_MIPMAP_SHIFT:Int = 24;
	@:noCompletion private static inline var SAMPLER_FILTER_SHIFT:Int = 28;
	// regmap flags
	@:noCompletion private static inline var REG_WRITE:Int = 0x1;
	@:noCompletion private static inline var REG_READ:Int = 0x2;
	@:noCompletion private static inline var REG_FRAG:Int = 0x20;
	@:noCompletion private static inline var REG_VERT:Int = 0x40;
	// opmap flags
	@:noCompletion private static inline var OP_SCALAR:Int = 0x1;
	@:noCompletion private static inline var OP_SPECIAL_TEX:Int = 0x8;
	@:noCompletion private static inline var OP_SPECIAL_MATRIX:Int = 0x10;
	@:noCompletion private static inline var OP_FRAG_ONLY:Int = 0x20;
	@:noCompletion private static inline var OP_VERT_ONLY:Int = 0x40;
	@:noCompletion private static inline var OP_NO_DEST:Int = 0x80;
	@:noCompletion private static inline var OP_VERSION2:Int = 0x100;
	@:noCompletion private static inline var OP_INCNEST:Int = 0x200;
	@:noCompletion private static inline var OP_DECNEST:Int = 0x400;
	// opcodes
	@:noCompletion private static inline var MOV:String = "mov";
	@:noCompletion private static inline var ADD:String = "add";
	@:noCompletion private static inline var SUB:String = "sub";
	@:noCompletion private static inline var MUL:String = "mul";
	@:noCompletion private static inline var DIV:String = "div";
	@:noCompletion private static inline var RCP:String = "rcp";
	@:noCompletion private static inline var MIN:String = "min";
	@:noCompletion private static inline var MAX:String = "max";
	@:noCompletion private static inline var FRC:String = "frc";
	@:noCompletion private static inline var SQT:String = "sqt";
	@:noCompletion private static inline var RSQ:String = "rsq";
	@:noCompletion private static inline var POW:String = "pow";
	@:noCompletion private static inline var LOG:String = "log";
	@:noCompletion private static inline var EXP:String = "exp";
	@:noCompletion private static inline var NRM:String = "nrm";
	@:noCompletion private static inline var SIN:String = "sin";
	@:noCompletion private static inline var COS:String = "cos";
	@:noCompletion private static inline var CRS:String = "crs";
	@:noCompletion private static inline var DP3:String = "dp3";
	@:noCompletion private static inline var DP4:String = "dp4";
	@:noCompletion private static inline var ABS:String = "abs";
	@:noCompletion private static inline var NEG:String = "neg";
	@:noCompletion private static inline var SAT:String = "sat";
	@:noCompletion private static inline var M33:String = "m33";
	@:noCompletion private static inline var M44:String = "m44";
	@:noCompletion private static inline var M34:String = "m34";
	@:noCompletion private static inline var DDX:String = "ddx";
	@:noCompletion private static inline var DDY:String = "ddy";
	@:noCompletion private static inline var IFE:String = "ife";
	@:noCompletion private static inline var INE:String = "ine";
	@:noCompletion private static inline var IFG:String = "ifg";
	@:noCompletion private static inline var IFL:String = "ifl";
	@:noCompletion private static inline var IEG:String = "ieg";
	@:noCompletion private static inline var IEL:String = "iel";
	@:noCompletion private static inline var ELS:String = "els";
	@:noCompletion private static inline var EIF:String = "eif";
	@:noCompletion private static inline var TED:String = "ted";
	@:noCompletion private static inline var KIL:String = "kil";
	@:noCompletion private static inline var TEX:String = "tex";
	@:noCompletion private static inline var SGE:String = "sge";
	@:noCompletion private static inline var SLT:String = "slt";
	@:noCompletion private static inline var SGN:String = "sgn";
	@:noCompletion private static inline var SEQ:String = "seq";
	@:noCompletion private static inline var SNE:String = "sne";
	// registers
	@:noCompletion private static inline var VA:String = "va";
	@:noCompletion private static inline var VC:String = "vc";
	@:noCompletion private static inline var VT:String = "vt";
	@:noCompletion private static inline var VO:String = "vo";
	@:noCompletion private static inline var VI:String = "vi";
	@:noCompletion private static inline var FC:String = "fc";
	@:noCompletion private static inline var FT:String = "ft";
	@:noCompletion private static inline var FS:String = "fs";
	@:noCompletion private static inline var FO:String = "fo";
	@:noCompletion private static inline var FD:String = "fd";
	@:noCompletion private static inline var IID:String = "iid";
	// samplers
	@:noCompletion private static inline var D2:String = "2d";
	@:noCompletion private static inline var D3:String = "3d";
	@:noCompletion private static inline var CUBE:String = "cube";
	@:noCompletion private static inline var MIPNEAREST:String = "mipnearest";
	@:noCompletion private static inline var MIPLINEAR:String = "miplinear";
	@:noCompletion private static inline var MIPNONE:String = "mipnone";
	@:noCompletion private static inline var NOMIP:String = "nomip";
	@:noCompletion private static inline var NEAREST:String = "nearest";
	@:noCompletion private static inline var LINEAR:String = "linear";
	@:noCompletion private static inline var ANISOTROPIC2X:String = "anisotropic2x"; // Introduced by Flash 14
	@:noCompletion private static inline var ANISOTROPIC4X:String = "anisotropic4x"; // Introduced by Flash 14
	@:noCompletion private static inline var ANISOTROPIC8X:String = "anisotropic8x"; // Introduced by Flash 14
	@:noCompletion private static inline var ANISOTROPIC16X:String = "anisotropic16x"; // Introduced by Flash 14
	@:noCompletion private static inline var CENTROID:String = "centroid";
	@:noCompletion private static inline var SINGLE:String = "single";
	@:noCompletion private static inline var IGNORESAMPLER:String = "ignoresampler";
	@:noCompletion private static inline var REPEAT:String = "repeat";
	@:noCompletion private static inline var WRAP:String = "wrap";
	@:noCompletion private static inline var CLAMP:String = "clamp";
	@:noCompletion private static inline var REPEAT_U_CLAMP_V:String = "repeat_u_clamp_v"; // Introduced by Flash 13
	@:noCompletion private static inline var CLAMP_U_REPEAT_V:String = "clamp_u_repeat_v"; // Introduced by Flash 13
	@:noCompletion private static inline var RGBA:String = "rgba";
	@:noCompletion private static inline var COMPRESSED:String = "compressed";
	@:noCompletion private static inline var COMPRESSEDALPHA:String = "compressedalpha";
	@:noCompletion private static inline var DXT1:String = "dxt1";
	@:noCompletion private static inline var DXT5:String = "dxt5";
	@:noCompletion private static inline var VIDEO:String = "video";
	@:noCompletion private static var initialized:Bool = false;

	public var agalcode(default, null):ByteArray;
	public var error(default, null):String;
	public var verbose:Bool;

	@:noCompletion private var debugEnabled:Bool = false;

	public function new(debugging:Bool = false)
	{
		debugEnabled = debugging;

		if (!initialized)
		{
			init();
		}
	}

	public function assemble2(context3D:Context3D, version:Int, vertexSource:String, fragmentSource:String):Program3D
	{
		var agalVertex = assemble(VERTEX, vertexSource, version);
		var agalFragment = assemble(FRAGMENT, fragmentSource, version);
		var program = context3D.createProgram();
		program.upload(agalVertex, agalFragment);
		return program;
	}

	public function assemble(mode:String, source:String, version:Int = 1, ignoreLimits:Bool = false):ByteArray
	{
		var start = Lib.getTimer();

		agalcode = new ByteArray();
		error = "";

		var isFrag = false;

		if (mode == FRAGMENT)
		{
			isFrag = true;
		}
		else if (mode != VERTEX)
		{
			error = 'ERROR: mode needs to be "' + FRAGMENT + '" or "' + VERTEX + '" but is "' + mode + '".';
		}

		agalcode.endian = Endian.LITTLE_ENDIAN;
		agalcode.writeByte(0xa0); // tag version
		agalcode.writeUnsignedInt(version); // AGAL version, big endian, bit pattern will be 0x01000000
		agalcode.writeByte(0xa1); // tag program id
		agalcode.writeByte(isFrag ? 1 : 0); // vertex or fragment

		initregmap(version, ignoreLimits);

		var lines = StringTools.replace(source, "\r", "\n").split("\n");
		var nops = 0;
		var lng = lines.length;

		var reg1 = ~/<.*>/g;
		var reg2 = ~/([\w\.\-\+]+)/gi;
		var reg3 = ~/^\w{3}/ig;
		var reg4 = ~/vc\[([vofi][acostdip]?[d]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vofi][acostdip]?[d]?)(\d*)?(\.[xyzw]{1,4})?/gi;
		var reg5 = ~/\[.*\]/ig;
		var reg6 = ~/^\b[A-Za-z]{1,3}/ig;
		var reg7 = ~/\d+/;
		var reg8 = ~/(\.[xyzw]{1,4})/;
		var reg9 = ~/[A-Za-z]{1,3}/ig;
		var reg10 = ~/(\.[xyzw]{1,1})/;
		var reg11 = ~/\+\d{1,3}/ig;

		var i = 0;

		while (i < lng && error == "")
		{
			var line = StringTools.trim(lines[i]);

			// remove comments
			var startcomment = line.indexOf("//");
			if (startcomment != -1)
			{
				line = line.substr(0, startcomment);
			}

			// grab options
			var optsi = reg1.match(line) ? reg1.matchedPos().pos : -1;
			var opts = null;

			if (optsi != -1)
			{
				opts = match(line.substr(optsi), reg2);
				line = line.substr(0, optsi);
			}

			// find opcode
			var opCode = null;
			var opFound = null;

			if (reg3.match(line))
			{
				opCode = reg3.matched(0);
				opFound = OPMAP[opCode];
			}

			if (opFound == null)
			{
				if (line.length >= 3)
				{
					Log.warn("warning: bad line " + i + ": " + lines[i]);
				}

				i++;
				continue;
			}

			// if debug is enabled, output the opcodes
			if (debugEnabled)
			{
				Log.info(opFound);
			}

			if (opFound == null)
			{
				if (line.length >= 3)
				{
					Log.warn("warning: bad line " + i + ": " + lines[i]);
				}

				i++;
				continue;
			}

			line = line.substr(line.indexOf(opFound.name) + opFound.name.length);

			if ((opFound.flags & OP_VERSION2 != 0) && version < 2)
			{
				error = "error: opcode requires version 2.";
				break;
			}

			if ((opFound.flags & OP_VERT_ONLY != 0) && isFrag)
			{
				error = "error: opcode is only allowed in vertex programs.";
				break;
			}

			if ((opFound.flags & OP_FRAG_ONLY != 0) && !isFrag)
			{
				error = "error: opcode is only allowed in fragment programs.";
				break;
			}

			if (verbose)
			{
				Log.info("emit opcode=" + opFound);
			}

			agalcode.writeUnsignedInt(opFound.emitCode);
			nops++;

			if (nops > MAX_OPCODES)
			{
				error = "error: too many opcodes. maximum is " + MAX_OPCODES + ".";
				break;
			}

			// get operands, use regexp
			var regs = match(line, reg4);

			if (regs.length != opFound.numRegister)
			{
				error = "error: wrong number of operands. found " + regs.length + " but expected " + opFound.numRegister + ".";
				break;
			}

			var badreg:Bool = false;
			var pad = 64 + 64 + 32;
			var regLength = regs.length;

			for (j in 0...regLength)
			{
				var isRelative = false;
				var relreg = match(regs[j], reg5);

				if (relreg.length > 0)
				{
					regs[j] = StringTools.replace(regs[j], relreg[0], "0");

					if (verbose)
					{
						Log.info("IS REL");
					}

					isRelative = true;
				}

				var res = match(regs[j], reg6);
				if (res.length == 0)
				{
					error = "error: could not parse operand " + j + " (" + regs[j] + ").";
					badreg = true;
					break;
				}

				var regFound:Register = REGMAP[res[0]];

				// if debug is enabled, output the registers
				if (debugEnabled)
				{
					Log.info(regFound);
				}

				if (regFound == null)
				{
					error = "error: could not find register name for operand " + j + " (" + regs[j] + ").";
					badreg = true;
					break;
				}

				if (isFrag)
				{
					if (regFound.flags & REG_FRAG == 0)
					{
						error = "error: register operand " + j + " (" + regs[j] + ") only allowed in vertex programs.";
						badreg = true;
						break;
					}

					if (isRelative)
					{
						error = "error: register operand " + j + " (" + regs[j] + ") relative adressing not allowed in fragment programs.";
						badreg = true;
						break;
					}
				}
				else
				{
					if (regFound.flags & REG_VERT == 0)
					{
						error = "error: register operand " + j + " (" + regs[j] + ") only allowed in fragment programs.";
						badreg = true;
						break;
					}
				}

				regs[j] = regs[j].substr(regs[j].indexOf(regFound.name) + regFound.name.length);
				// Log.info ("REGNUM: " + regs[j]);
				var idxmatch = isRelative ? match(relreg[0], reg7) : match(regs[j], reg7);
				var regidx:UInt = 0;

				if (idxmatch.length > 0)
				{
					regidx = Std.parseInt(idxmatch[0]);
				}

				if (regFound.range < regidx)
				{
					error = "error: register operand " + j + " (" + regs[j] + ") index exceeds limit of " + (regFound.range + 1) + ".";
					badreg = true;
					break;
				}

				var regmask = 0;
				var maskmatch = match(regs[j], reg8);
				var isDest = (j == 0 && (opFound.flags & OP_NO_DEST == 0));
				var isSampler = (j == 2 && (opFound.flags & OP_SPECIAL_TEX != 0));
				var reltype = 0;
				var relsel:UInt = 0;
				var reloffset = 0;

				if (isDest && isRelative)
				{
					error = "error: relative can not be destination";
					badreg = true;
					break;
				}

				if (maskmatch.length > 0)
				{
					regmask = 0;
					var cv:UInt = 0;
					var maskLength = maskmatch[0].length;
					var k = 1;

					while (k < maskLength)
					{
						cv = maskmatch[0].charCodeAt(k) - "x".code;

						if (cv > 2)
						{
							cv = 3;
						}

						if (isDest)
						{
							regmask |= 1 << cv;
						}
						else
						{
							regmask |= cv << ((k - 1) << 1);
						}

						k++;
					}

					if (!isDest)
					{
						while (k <= 4)
						{
							regmask |= cv << ((k - 1) << 1); // repeat last
							k++;
						}
					}
				}
				else
				{
					regmask = isDest ? 0xf : 0xe4; // id swizzle or mask
				}

				if (isRelative)
				{
					var relname = match(relreg[0], reg9);
					var regFoundRel:Register = REGMAP[relname[0]];

					if (regFoundRel == null)
					{
						error = "error: bad index register";
						badreg = true;
						break;
					}

					reltype = regFoundRel.emitCode;
					var selmatch = match(relreg[0], reg10);

					if (selmatch.length == 0)
					{
						error = "error: bad index register select";
						badreg = true;
						break;
					}

					relsel = selmatch[0].charCodeAt(1) - "x".code;

					if (relsel > 2)
					{
						relsel = 3;
					}

					var relofs = match(relreg[0], reg11);

					if (relofs.length > 0)
					{
						reloffset = Std.parseInt(relofs[0]);
					}

					if (reloffset < 0 || reloffset > 255)
					{
						error = "error: index offset " + reloffset + " out of bounds. [0..255]";
						badreg = true;
						break;
					}

					if (verbose)
					{
						Log.info("RELATIVE: type=" + reltype + "==" + relname[0] + " sel=" + relsel + "==" + selmatch[0] + " idx=" + regidx + " offset="
							+ reloffset);
					}
				}

				if (verbose)
				{
					Log.info("  emit argcode=" + regFound + "[" + regidx + "][" + regmask + "]");
				}

				if (isDest)
				{
					agalcode.writeShort(regidx);
					agalcode.writeByte(regmask);
					agalcode.writeByte(regFound.emitCode);
					pad -= 32;
				}
				else
				{
					if (isSampler)
					{
						if (verbose)
						{
							Log.info("  emit sampler");
						}

						var samplerbits = 5; // type 5
						var optsLength = opts == null ? 0 : opts.length;
						var bias = 0.0;

						for (k in 0...optsLength)
						{
							if (verbose)
							{
								Log.info("    opt: " + opts[k]);
							}

							var optfound:Sampler = SAMPLEMAP[opts[k]];

							if (optfound == null)
							{
								// todo check that it's a number...
								// Log.info ("Warning, unknown sampler option: " + opts[k]);
								bias = Std.parseFloat(opts[k]);

								if (verbose)
								{
									Log.info("    bias: " + bias);
								}
							}
							else
							{
								if (optfound.flag != SAMPLER_SPECIAL_SHIFT)
								{
									samplerbits &= ~(0xf << optfound.flag);
								}

								samplerbits |= optfound.mask << optfound.flag;
							}
						}

						agalcode.writeShort(regidx);
						agalcode.writeByte(Std.int(bias * 8.0));
						agalcode.writeByte(0);
						agalcode.writeUnsignedInt(samplerbits);

						if (verbose)
						{
							Log.info("    bits: " + (samplerbits - 5));
						}

						pad -= 64;
					}
					else
					{
						if (j == 0)
						{
							agalcode.writeUnsignedInt(0);
							pad -= 32;
						}

						agalcode.writeShort(regidx);
						agalcode.writeByte(reloffset);
						agalcode.writeByte(regmask);
						agalcode.writeByte(regFound.emitCode);
						agalcode.writeByte(reltype);
						agalcode.writeShort(isRelative ? (relsel | (1 << 15)) : 0);

						pad -= 64;
					}
				}
			}

			// pad unused regs
			var j = 0;
			while (j < pad)
			{
				agalcode.writeByte(0);
				j += 8;
			}

			if (badreg)
			{
				break;
			}

			i++;
		}

		if (error != "")
		{
			error += "\n  at line " + i + " " + lines[i];
			agalcode.length = 0;
			Log.info(error);
		}

		// Log.info the bytecode bytes if debugging is enabled
		if (debugEnabled)
		{
			var dbgLine:String = "generated bytecode:";
			var agalLength = agalcode.length;

			for (index in 0...agalLength)
			{
				if (index % 16 == 0)
				{
					dbgLine += "\n";
				}

				if (index % 4 == 0)
				{
					dbgLine += " ";
				}

				var byteStr = StringTools.hex(agalcode[index], 2);

				if (byteStr.length < 2)
				{
					byteStr = "0" + byteStr;
				}

				dbgLine += byteStr;
			}

			Log.info(dbgLine);
		}

		if (verbose)
		{
			Log.info("AGALMiniAssembler.assemble time: " + ((Lib.getTimer() - start) / 1000) + "s");
		}

		return agalcode;
	}

	@:noCompletion private function initregmap(version:Int, ignorelimits:Bool):Void
	{
		REGMAP[VA] = new Register(VA, "vertex attribute", 0x0, ignorelimits ? 1024 : ((version == 1 || version == 2) ? 7 : 15), REG_VERT | REG_READ);
		REGMAP[VC] = new Register(VC, "vertex constant", 0x1, ignorelimits ? 1024 : (version == 1 ? 127 : 249), REG_VERT | REG_READ);
		REGMAP[VT] = new Register(VT, "vertex temporary", 0x2, ignorelimits ? 1024 : (version == 1 ? 7 : 25), REG_VERT | REG_WRITE | REG_READ);
		REGMAP[VO] = new Register(VO, "vertex output", 0x3, ignorelimits ? 1024 : 0, REG_VERT | REG_WRITE);
		REGMAP[VI] = new Register(VI, "varying", 0x4, ignorelimits ? 1024 : (version == 1 ? 7 : 9), REG_VERT | REG_FRAG | REG_READ | REG_WRITE);
		REGMAP[FC] = new Register(FC, "fragment constant", 0x1, ignorelimits ? 1024 : (version == 1 ? 27 : ((version == 2) ? 63 : 199)), REG_FRAG | REG_READ);
		REGMAP[FT] = new Register(FT, "fragment temporary", 0x2, ignorelimits ? 1024 : (version == 1 ? 7 : 25), REG_FRAG | REG_WRITE | REG_READ);
		REGMAP[FS] = new Register(FS, "texture sampler", 0x5, ignorelimits ? 1024 : 7, REG_FRAG | REG_READ);
		REGMAP[FO] = new Register(FO, "fragment output", 0x3, ignorelimits ? 1024 : (version == 1 ? 0 : 3), REG_FRAG | REG_WRITE);
		REGMAP[FD] = new Register(FD, "fragment depth output", 0x6, ignorelimits ? 1024 : (version == 1 ? -1 : 0), REG_FRAG | REG_WRITE);
		REGMAP[IID] = new Register(IID, "instance id", 0x7, ignorelimits ? 1024 : 0, REG_VERT | REG_READ);

		// aliases
		REGMAP["op"] = REGMAP[VO];
		REGMAP["i"] = REGMAP[VI];
		REGMAP["v"] = REGMAP[VI];
		REGMAP["oc"] = REGMAP[FO];
		REGMAP["od"] = REGMAP[FD];
		REGMAP["fi"] = REGMAP[VI];
	}

	@:noCompletion private static function init():Void
	{
		initialized = true;

		// Fill the dictionaries with opcodes and registers
		OPMAP[MOV] = new OpCode(MOV, 2, 0x00, 0);
		OPMAP[ADD] = new OpCode(ADD, 3, 0x01, 0);
		OPMAP[SUB] = new OpCode(SUB, 3, 0x02, 0);
		OPMAP[MUL] = new OpCode(MUL, 3, 0x03, 0);
		OPMAP[DIV] = new OpCode(DIV, 3, 0x04, 0);
		OPMAP[RCP] = new OpCode(RCP, 2, 0x05, 0);
		OPMAP[MIN] = new OpCode(MIN, 3, 0x06, 0);
		OPMAP[MAX] = new OpCode(MAX, 3, 0x07, 0);
		OPMAP[FRC] = new OpCode(FRC, 2, 0x08, 0);
		OPMAP[SQT] = new OpCode(SQT, 2, 0x09, 0);
		OPMAP[RSQ] = new OpCode(RSQ, 2, 0x0a, 0);
		OPMAP[POW] = new OpCode(POW, 3, 0x0b, 0);
		OPMAP[LOG] = new OpCode(LOG, 2, 0x0c, 0);
		OPMAP[EXP] = new OpCode(EXP, 2, 0x0d, 0);
		OPMAP[NRM] = new OpCode(NRM, 2, 0x0e, 0);
		OPMAP[SIN] = new OpCode(SIN, 2, 0x0f, 0);
		OPMAP[COS] = new OpCode(COS, 2, 0x10, 0);
		OPMAP[CRS] = new OpCode(CRS, 3, 0x11, 0);
		OPMAP[DP3] = new OpCode(DP3, 3, 0x12, 0);
		OPMAP[DP4] = new OpCode(DP4, 3, 0x13, 0);
		OPMAP[ABS] = new OpCode(ABS, 2, 0x14, 0);
		OPMAP[NEG] = new OpCode(NEG, 2, 0x15, 0);
		OPMAP[SAT] = new OpCode(SAT, 2, 0x16, 0);
		OPMAP[M33] = new OpCode(M33, 3, 0x17, OP_SPECIAL_MATRIX);
		OPMAP[M44] = new OpCode(M44, 3, 0x18, OP_SPECIAL_MATRIX);
		OPMAP[M34] = new OpCode(M34, 3, 0x19, OP_SPECIAL_MATRIX);
		OPMAP[DDX] = new OpCode(DDX, 2, 0x1a, OP_VERSION2 | OP_FRAG_ONLY);
		OPMAP[DDY] = new OpCode(DDY, 2, 0x1b, OP_VERSION2 | OP_FRAG_ONLY);
		OPMAP[IFE] = new OpCode(IFE, 2, 0x1c, OP_NO_DEST | OP_VERSION2 | OP_INCNEST | OP_SCALAR);
		OPMAP[INE] = new OpCode(INE, 2, 0x1d, OP_NO_DEST | OP_VERSION2 | OP_INCNEST | OP_SCALAR);
		OPMAP[IFG] = new OpCode(IFG, 2, 0x1e, OP_NO_DEST | OP_VERSION2 | OP_INCNEST | OP_SCALAR);
		OPMAP[IFL] = new OpCode(IFL, 2, 0x1f, OP_NO_DEST | OP_VERSION2 | OP_INCNEST | OP_SCALAR);
		OPMAP[ELS] = new OpCode(ELS, 0, 0x20, OP_NO_DEST | OP_VERSION2 | OP_INCNEST | OP_DECNEST | OP_SCALAR);
		OPMAP[EIF] = new OpCode(EIF, 0, 0x21, OP_NO_DEST | OP_VERSION2 | OP_DECNEST | OP_SCALAR);
		// space
		// OPMAP[TED] = new OpCode (TED, 3, 0x26, OP_FRAG_ONLY | OP_SPECIAL_TEX | OP_VERSION2); //ted is not available in AGAL2
		OPMAP[KIL] = new OpCode(KIL, 1, 0x27, OP_NO_DEST | OP_FRAG_ONLY);
		OPMAP[TEX] = new OpCode(TEX, 3, 0x28, OP_FRAG_ONLY | OP_SPECIAL_TEX);
		OPMAP[SGE] = new OpCode(SGE, 3, 0x29, 0);
		OPMAP[SLT] = new OpCode(SLT, 3, 0x2a, 0);
		OPMAP[SGN] = new OpCode(SGN, 2, 0x2b, 0);
		OPMAP[SEQ] = new OpCode(SEQ, 3, 0x2c, 0);
		OPMAP[SNE] = new OpCode(SNE, 3, 0x2d, 0);

		SAMPLEMAP[RGBA] = new Sampler(RGBA, SAMPLER_TYPE_SHIFT, 0);
		SAMPLEMAP[COMPRESSED] = new Sampler(COMPRESSED, SAMPLER_TYPE_SHIFT, 1);
		SAMPLEMAP[COMPRESSEDALPHA] = new Sampler(COMPRESSEDALPHA, SAMPLER_TYPE_SHIFT, 2);
		SAMPLEMAP[DXT1] = new Sampler(DXT1, SAMPLER_TYPE_SHIFT, 1);
		SAMPLEMAP[DXT5] = new Sampler(DXT5, SAMPLER_TYPE_SHIFT, 2);
		SAMPLEMAP[VIDEO] = new Sampler(VIDEO, SAMPLER_TYPE_SHIFT, 3);
		SAMPLEMAP[D2] = new Sampler(D2, SAMPLER_DIM_SHIFT, 0);
		SAMPLEMAP[D3] = new Sampler(D3, SAMPLER_DIM_SHIFT, 2);
		SAMPLEMAP[CUBE] = new Sampler(CUBE, SAMPLER_DIM_SHIFT, 1);
		SAMPLEMAP[MIPNEAREST] = new Sampler(MIPNEAREST, SAMPLER_MIPMAP_SHIFT, 1);
		SAMPLEMAP[MIPLINEAR] = new Sampler(MIPLINEAR, SAMPLER_MIPMAP_SHIFT, 2);
		SAMPLEMAP[MIPNONE] = new Sampler(MIPNONE, SAMPLER_MIPMAP_SHIFT, 0);
		SAMPLEMAP[NOMIP] = new Sampler(NOMIP, SAMPLER_MIPMAP_SHIFT, 0);
		SAMPLEMAP[NEAREST] = new Sampler(NEAREST, SAMPLER_FILTER_SHIFT, 0);
		SAMPLEMAP[LINEAR] = new Sampler(LINEAR, SAMPLER_FILTER_SHIFT, 1);
		SAMPLEMAP[ANISOTROPIC2X] = new Sampler(ANISOTROPIC2X, SAMPLER_FILTER_SHIFT, 2);
		SAMPLEMAP[ANISOTROPIC4X] = new Sampler(ANISOTROPIC4X, SAMPLER_FILTER_SHIFT, 3);
		SAMPLEMAP[ANISOTROPIC8X] = new Sampler(ANISOTROPIC8X, SAMPLER_FILTER_SHIFT, 4);
		SAMPLEMAP[ANISOTROPIC16X] = new Sampler(ANISOTROPIC16X, SAMPLER_FILTER_SHIFT, 5);
		SAMPLEMAP[CENTROID] = new Sampler(CENTROID, SAMPLER_SPECIAL_SHIFT, 1 << 0);
		SAMPLEMAP[SINGLE] = new Sampler(SINGLE, SAMPLER_SPECIAL_SHIFT, 1 << 1);
		SAMPLEMAP[IGNORESAMPLER] = new Sampler(IGNORESAMPLER, SAMPLER_SPECIAL_SHIFT, 1 << 2);
		SAMPLEMAP[REPEAT] = new Sampler(REPEAT, SAMPLER_REPEAT_SHIFT, 1);
		SAMPLEMAP[WRAP] = new Sampler(WRAP, SAMPLER_REPEAT_SHIFT, 1);
		SAMPLEMAP[CLAMP] = new Sampler(CLAMP, SAMPLER_REPEAT_SHIFT, 0);
		SAMPLEMAP[CLAMP_U_REPEAT_V] = new Sampler(CLAMP_U_REPEAT_V, SAMPLER_REPEAT_SHIFT, 2);
		SAMPLEMAP[REPEAT_U_CLAMP_V] = new Sampler(REPEAT_U_CLAMP_V, SAMPLER_REPEAT_SHIFT, 3);
	}

	@:noCompletion private function match(value:String, reg:EReg):Array<String>
	{
		var matches = [];
		var index = 0;
		var match;

		while (reg.matchSub(value, index))
		{
			match = reg.matched(0);
			matches.push(match);
			index = reg.matchedPos().pos + match.length;
		}

		return matches;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class OpCode
{
	public var emitCode(default, null):Int;
	public var flags(default, null):Int;
	public var name(default, null):String;
	public var numRegister(default, null):Int;

	public function new(name:String, numRegister:Int, emitCode:Int, flags:Int)
	{
		this.name = name;
		this.numRegister = numRegister;
		this.emitCode = emitCode;
		this.flags = flags;
	}

	public function toString():String
	{
		return "[OpCode name=\"" + name + "\", numRegister=" + numRegister + ", emitCode=" + emitCode + ", flags=" + flags + "]";
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class Register
{
	public var emitCode(default, null):UInt;
	public var name(default, null):String;
	public var longName(default, null):String;
	public var flags(default, null):UInt;
	public var range(default, null):UInt;

	public function new(name:String, longName:String, emitCode:UInt, range:UInt, flags:UInt)
	{
		this.name = name;
		this.longName = longName;
		this.emitCode = emitCode;
		this.range = range;
		this.flags = flags;
	}

	public function toString():String
	{
		return "[Register name=\""
			+ name
			+ "\", longName=\""
			+ longName
			+ "\", emitCode="
			+ emitCode
			+ ", range="
			+ range
			+ ", flags="
			+ flags
			+ "]";
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class Sampler
{
	public var flag(default, null):UInt;
	public var mask(default, null):UInt;
	public var name(default, null):String;

	public function new(name:String, flag:UInt, mask:UInt)
	{
		this.name = name;
		this.flag = flag;
		this.mask = mask;
	}

	public function toString():String
	{
		return "[Sampler name=\"" + name + "\", flag=\"" + flag + "\", mask=" + mask + "]";
	}
}
