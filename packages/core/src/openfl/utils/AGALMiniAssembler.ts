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

import Context3D from "../display3D/Context3D";
import Program3D from "../display3D/Program3D";
import ByteArray from "../utils/ByteArray";
import Endian from "../utils/Endian";
import Lib from "../Lib";

export default class AGALMiniAssembler
{
	private static readonly OPMAP: Map<string, OpCode> = new Map();
	private static readonly REGMAP: Map<string, Register> = new Map();
	private static readonly SAMPLEMAP: Map<string, Sampler> = new Map();
	private static readonly MAX_NESTING: number = 4;
	private static readonly MAX_OPCODES: number = 4096;
	private static readonly FRAGMENT: string = "fragment";
	private static readonly VERTEX: string = "vertex";
	// masks and shifts
	private static readonly SAMPLER_TYPE_SHIFT: number = 8;
	private static readonly SAMPLER_DIM_SHIFT: number = 12;
	private static readonly SAMPLER_SPECIAL_SHIFT: number = 16;
	private static readonly SAMPLER_REPEAT_SHIFT: number = 20;
	private static readonly SAMPLER_MIPMAP_SHIFT: number = 24;
	private static readonly SAMPLER_FILTER_SHIFT: number = 28;
	// regmap flags
	private static readonly REG_WRITE: number = 0x1;
	private static readonly REG_READ: number = 0x2;
	private static readonly REG_FRAG: number = 0x20;
	private static readonly REG_VERT: number = 0x40;
	// opmap flags
	private static readonly OP_SCALAR: number = 0x1;
	private static readonly OP_SPECIAL_TEX: number = 0x8;
	private static readonly OP_SPECIAL_MATRIX: number = 0x10;
	private static readonly OP_FRAG_ONLY: number = 0x20;
	private static readonly OP_VERT_ONLY: number = 0x40;
	private static readonly OP_NO_DEST: number = 0x80;
	private static readonly OP_VERSION2: number = 0x100;
	private static readonly OP_INCNEST: number = 0x200;
	private static readonly OP_DECNEST: number = 0x400;
	// opcodes
	private static readonly MOV: string = "mov";
	private static readonly ADD: string = "add";
	private static readonly SUB: string = "sub";
	private static readonly MUL: string = "mul";
	private static readonly DIV: string = "div";
	private static readonly RCP: string = "rcp";
	private static readonly MIN: string = "min";
	private static readonly MAX: string = "max";
	private static readonly FRC: string = "frc";
	private static readonly SQT: string = "sqt";
	private static readonly RSQ: string = "rsq";
	private static readonly POW: string = "pow";
	private static readonly LOG: string = "log";
	private static readonly EXP: string = "exp";
	private static readonly NRM: string = "nrm";
	private static readonly SIN: string = "sin";
	private static readonly COS: string = "cos";
	private static readonly CRS: string = "crs";
	private static readonly DP3: string = "dp3";
	private static readonly DP4: string = "dp4";
	private static readonly ABS: string = "abs";
	private static readonly NEG: string = "neg";
	private static readonly SAT: string = "sat";
	private static readonly M33: string = "m33";
	private static readonly M44: string = "m44";
	private static readonly M34: string = "m34";
	private static readonly DDX: string = "ddx";
	private static readonly DDY: string = "ddy";
	private static readonly IFE: string = "ife";
	private static readonly INE: string = "ine";
	private static readonly IFG: string = "ifg";
	private static readonly IFL: string = "ifl";
	private static readonly IEG: string = "ieg";
	private static readonly IEL: string = "iel";
	private static readonly ELS: string = "els";
	private static readonly EIF: string = "eif";
	private static readonly TED: string = "ted";
	private static readonly KIL: string = "kil";
	private static readonly TEX: string = "tex";
	private static readonly SGE: string = "sge";
	private static readonly SLT: string = "slt";
	private static readonly SGN: string = "sgn";
	private static readonly SEQ: string = "seq";
	private static readonly SNE: string = "sne";
	// registers
	private static readonly VA: string = "va";
	private static readonly VC: string = "vc";
	private static readonly VT: string = "vt";
	private static readonly VO: string = "vo";
	private static readonly VI: string = "vi";
	private static readonly FC: string = "fc";
	private static readonly FT: string = "ft";
	private static readonly FS: string = "fs";
	private static readonly FO: string = "fo";
	private static readonly FD: string = "fd";
	private static readonly IID: string = "iid";
	// samplers
	private static readonly D2: string = "2d";
	private static readonly D3: string = "3d";
	private static readonly CUBE: string = "cube";
	private static readonly MIPNEAREST: string = "mipnearest";
	private static readonly MIPLINEAR: string = "miplinear";
	private static readonly MIPNONE: string = "mipnone";
	private static readonly NOMIP: string = "nomip";
	private static readonly NEAREST: string = "nearest";
	private static readonly LINEAR: string = "linear";
	private static readonly ANISOTROPIC2X: string = "anisotropic2x"; // Introduced by Flash 14
	private static readonly ANISOTROPIC4X: string = "anisotropic4x"; // Introduced by Flash 14
	private static readonly ANISOTROPIC8X: string = "anisotropic8x"; // Introduced by Flash 14
	private static readonly ANISOTROPIC16X: string = "anisotropic16x"; // Introduced by Flash 14
	private static readonly CENTROID: string = "centroid";
	private static readonly SINGLE: string = "single";
	private static readonly IGNORESAMPLER: string = "ignoresampler";
	private static readonly REPEAT: string = "repeat";
	private static readonly WRAP: string = "wrap";
	private static readonly CLAMP: string = "clamp";
	private static readonly REPEAT_U_CLAMP_V: string = "repeat_u_clamp_v"; // Introduced by Flash 13
	private static readonly CLAMP_U_REPEAT_V: string = "clamp_u_repeat_v"; // Introduced by Flash 13
	private static readonly RGBA: string = "rgba";
	private static readonly COMPRESSED: string = "compressed";
	private static readonly COMPRESSEDALPHA: string = "compressedalpha";
	private static readonly DXT1: string = "dxt1";
	private static readonly DXT5: string = "dxt5";
	private static readonly VIDEO: string = "video";

	private static initialized: boolean = false;

	public get agalcode(): ByteArray { return this._agalcode; }
	public get error(): string { return this._error; }
	public verbose: boolean;

	private debugEnabled: boolean = false;
	private _agalcode: ByteArray;
	private _error: string;

	public constructor(debugging: boolean = false)
	{
		this.debugEnabled = debugging;

		if (!AGALMiniAssembler.initialized)
		{
			AGALMiniAssembler.init();
		}
	}

	public assemble2(context3D: Context3D, version: number, vertexSource: string, fragmentSource: string): Program3D
	{
		var agalVertex = this.assemble(AGALMiniAssembler.VERTEX, vertexSource, version);
		var agalFragment = this.assemble(AGALMiniAssembler.FRAGMENT, fragmentSource, version);
		var program = context3D.createProgram();
		program.upload(agalVertex, agalFragment);
		return program;
	}

	public assemble(mode: string, source: string, version: number = 1, ignoreLimits: boolean = false): ByteArray
	{
		var start = Lib.getTimer();

		this._agalcode = new ByteArray();
		this._error = "";

		var isFrag = false;

		if (mode == AGALMiniAssembler.FRAGMENT)
		{
			isFrag = true;
		}
		else if (mode != AGALMiniAssembler.VERTEX)
		{
			this._error = 'ERROR: mode needs to be "' + AGALMiniAssembler.FRAGMENT + '" or "' + AGALMiniAssembler.VERTEX + '" but is "' + mode + '".';
		}

		this._agalcode.endian = Endian.LITTLE_ENDIAN;
		this._agalcode.writeByte(0xa0); // tag version
		this._agalcode.writeUnsignedInt(version); // AGAL version, big endian, bit pattern will be 0x01000000
		this._agalcode.writeByte(0xa1); // tag program id
		this._agalcode.writeByte(isFrag ? 1 : 0); // vertex or fragment

		this.initregmap(version, ignoreLimits);

		var lines = source.replace(/\r/g, "\n").split("\n");
		var nops = 0;
		var lng = lines.length;

		var reg1 = /<.*>/g;
		var reg2 = /([\w\.\-\+]+)/gi;
		var reg3 = /^\w{3}/ig;
		var reg4 = /vc\[([vofi][acostdip]?[d]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vofi][acostdip]?[d]?)(\d*)?(\.[xyzw]{1,4})?/gi;
		var reg5 = /\[.*\]/ig;
		var reg6 = /^\b[A-Za-z]{1,3}/ig;
		var reg7 = /\d+/;
		var reg8 = /(\.[xyzw]{1,4})/;
		var reg9 = /[A-Za-z]{1,3}/ig;
		var reg10 = /(\.[xyzw]{1,1})/;
		var reg11 = /\+\d{1,3}/ig;

		var i = 0;

		while (i < lng && this._error == "")
		{
			var line = lines[i].trim();

			// remove comments
			var startcomment = line.indexOf("//");
			if (startcomment != -1)
			{
				line = line.substr(0, startcomment);
			}

			// grab options
			var optsi = reg1.test(line) ? reg1.lastIndex : -1;
			var opts = null;

			if (optsi != -1)
			{
				opts = this.match(line.substr(optsi), reg2);
				line = line.substr(0, optsi);
			}

			// find opcode
			var opCode = null;
			var opFound = null;
			var result = reg3.exec(line);

			if (result != null)
			{
				opCode = result[0];
				opFound = AGALMiniAssembler.OPMAP[opCode];
			}

			if (opFound == null)
			{
				if (line.length >= 3)
				{
					console.warn("warning: bad line " + i + ": " + lines[i]);
				}

				i++;
				continue;
			}

			// if debug is enabled, output the opcodes
			if (this.debugEnabled)
			{
				console.info(opFound);
			}

			if (opFound == null)
			{
				if (line.length >= 3)
				{
					console.warn("warning: bad line " + i + ": " + lines[i]);
				}

				i++;
				continue;
			}

			line = line.substr(line.indexOf(opFound.name) + opFound.name.length);

			if ((opFound.flags & AGALMiniAssembler.OP_VERSION2) != 0 && version < 2)
			{
				this._error = "error: opcode requires version 2.";
				break;
			}

			if ((opFound.flags & AGALMiniAssembler.OP_VERT_ONLY) != 0 && isFrag)
			{
				this._error = "error: opcode is only allowed in vertex programs.";
				break;
			}

			if ((opFound.flags & AGALMiniAssembler.OP_FRAG_ONLY) != 0 && !isFrag)
			{
				this._error = "error: opcode is only allowed in fragment programs.";
				break;
			}

			if (this.verbose)
			{
				console.info("emit opcode=" + opFound);
			}

			this._agalcode.writeUnsignedInt(opFound.emitCode);
			nops++;

			if (nops > AGALMiniAssembler.MAX_OPCODES)
			{
				this._error = "error: too many opcodes. maximum is " + AGALMiniAssembler.MAX_OPCODES + ".";
				break;
			}

			// get operands, use regexp
			var regs = this.match(line, reg4);

			if (regs.length != opFound.numRegister)
			{
				this._error = "error: wrong number of operands. found " + regs.length + " but expected " + opFound.numRegister + ".";
				break;
			}

			var badreg: boolean = false;
			var pad = 64 + 64 + 32;
			var regLength = regs.length;

			for (let j = 0; j < regLength; j++)
			{
				var isRelative = false;
				var relreg = this.match(regs[j], reg5);

				if (relreg.length > 0)
				{
					regs[j] = regs[j].replace(relreg[0], "0");

					if (this.verbose)
					{
						console.info("IS REL");
					}

					isRelative = true;
				}

				var res = this.match(regs[j], reg6);
				if (res.length == 0)
				{
					this._error = "error: could not parse operand " + j + " (" + regs[j] + ").";
					badreg = true;
					break;
				}

				var regFound: Register = AGALMiniAssembler.REGMAP[res[0]];

				// if debug is enabled, output the registers
				if (this.debugEnabled)
				{
					console.info(regFound);
				}

				if (regFound == null)
				{
					this._error = "error: could not find register name for operand " + j + " (" + regs[j] + ").";
					badreg = true;
					break;
				}

				if (isFrag)
				{
					if ((regFound.flags & AGALMiniAssembler.REG_FRAG) == 0)
					{
						this._error = "error: register operand " + j + " (" + regs[j] + ") only allowed in vertex programs.";
						badreg = true;
						break;
					}

					if (isRelative)
					{
						this._error = "error: register operand " + j + " (" + regs[j] + ") relative adressing not allowed in fragment programs.";
						badreg = true;
						break;
					}
				}
				else
				{
					if ((regFound.flags & AGALMiniAssembler.REG_VERT) == 0)
					{
						this._error = "error: register operand " + j + " (" + regs[j] + ") only allowed in fragment programs.";
						badreg = true;
						break;
					}
				}

				regs[j] = regs[j].substr(regs[j].indexOf(regFound.name) + regFound.name.length);
				// Log.info ("REGNUM: " + regs[j]);
				var idxmatch = isRelative ? this.match(relreg[0], reg7) : this.match(regs[j], reg7);
				var regidx: number = 0;

				if (idxmatch.length > 0)
				{
					regidx = parseInt(idxmatch[0]);
				}

				if (regFound.range < regidx)
				{
					this._error = "error: register operand " + j + " (" + regs[j] + ") index exceeds limit of " + (regFound.range + 1) + ".";
					badreg = true;
					break;
				}

				var regmask = 0;
				var maskmatch = this.match(regs[j], reg8);
				var isDest = (j == 0 && (opFound.flags & AGALMiniAssembler.OP_NO_DEST) == 0);
				var isSampler = (j == 2 && (opFound.flags & AGALMiniAssembler.OP_SPECIAL_TEX) != 0);
				var reltype = 0;
				var relsel: number = 0;
				var reloffset = 0;

				if (isDest && isRelative)
				{
					this._error = "error: relative can not be destination";
					badreg = true;
					break;
				}

				if (maskmatch.length > 0)
				{
					regmask = 0;
					var cv: number = 0;
					var maskLength = maskmatch[0].length;
					var k = 1;

					while (k < maskLength)
					{
						cv = maskmatch[0].charCodeAt(k) - "x".charCodeAt(0);

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
					var relname = this.match(relreg[0], reg9);
					var regFoundRel: Register = AGALMiniAssembler.REGMAP[relname[0]];

					if (regFoundRel == null)
					{
						this._error = "error: bad index register";
						badreg = true;
						break;
					}

					reltype = regFoundRel.emitCode;
					var selmatch = this.match(relreg[0], reg10);

					if (selmatch.length == 0)
					{
						this._error = "error: bad index register select";
						badreg = true;
						break;
					}

					relsel = selmatch[0].charCodeAt(1) - "x".charCodeAt(0);

					if (relsel > 2)
					{
						relsel = 3;
					}

					var relofs = this.match(relreg[0], reg11);

					if (relofs.length > 0)
					{
						reloffset = parseInt(relofs[0]);
					}

					if (reloffset < 0 || reloffset > 255)
					{
						this._error = "error: index offset " + reloffset + " out of bounds. [0..255]";
						badreg = true;
						break;
					}

					if (this.verbose)
					{
						console.info("RELATIVE: type=" + reltype + "==" + relname[0] + " sel=" + relsel + "==" + selmatch[0] + " idx=" + regidx + " offset="
							+ reloffset);
					}
				}

				if (this.verbose)
				{
					console.info("  emit argcode=" + regFound + "[" + regidx + "][" + regmask + "]");
				}

				if (isDest)
				{
					this._agalcode.writeShort(regidx);
					this._agalcode.writeByte(regmask);
					this._agalcode.writeByte(regFound.emitCode);
					pad -= 32;
				}
				else
				{
					if (isSampler)
					{
						if (this.verbose)
						{
							console.info("  emit sampler");
						}

						var samplerbits = 5; // type 5
						var optsLength = opts == null ? 0 : opts.length;
						var bias = 0.0;

						for (let k = 0; k < optsLength; k++)
						{
							if (this.verbose)
							{
								console.info("    opt: " + opts[k]);
							}

							var optfound: Sampler = AGALMiniAssembler.SAMPLEMAP[opts[k]];

							if (optfound == null)
							{
								// todo check that it's a number...
								// Log.info ("Warning, unknown sampler option: " + opts[k]);
								bias = parseInt(opts[k]);

								if (this.verbose)
								{
									console.info("    bias: " + bias);
								}
							}
							else
							{
								if (optfound.flag != AGALMiniAssembler.SAMPLER_SPECIAL_SHIFT)
								{
									samplerbits &= ~(0xf << optfound.flag);
								}

								samplerbits |= optfound.mask << optfound.flag;
							}
						}

						this._agalcode.writeShort(regidx);
						this._agalcode.writeByte(Math.floor(bias * 8.0));
						this._agalcode.writeByte(0);
						this._agalcode.writeUnsignedInt(samplerbits);

						if (this.verbose)
						{
							console.info("    bits: " + (samplerbits - 5));
						}

						pad -= 64;
					}
					else
					{
						if (j == 0)
						{
							this._agalcode.writeUnsignedInt(0);
							pad -= 32;
						}

						this._agalcode.writeShort(regidx);
						this._agalcode.writeByte(reloffset);
						this._agalcode.writeByte(regmask);
						this._agalcode.writeByte(regFound.emitCode);
						this._agalcode.writeByte(reltype);
						this._agalcode.writeShort(isRelative ? (relsel | (1 << 15)) : 0);

						pad -= 64;
					}
				}
			}

			// pad unused regs
			var j = 0;
			while (j < pad)
			{
				this._agalcode.writeByte(0);
				j += 8;
			}

			if (badreg)
			{
				break;
			}

			i++;
		}

		if (this._error != "")
		{
			this._error += "\n  at line " + i + " " + lines[i];
			this._agalcode.length = 0;
			console.info(this._error);
		}

		// Log.info the bytecode bytes if debugging is enabled
		if (this.debugEnabled)
		{
			var dbgLine: string = "generated bytecode:";
			var agalLength = this._agalcode.length;

			for (let index = 0; i < agalLength; index++)
			{
				if (index % 16 == 0)
				{
					dbgLine += "\n";
				}

				if (index % 4 == 0)
				{
					dbgLine += " ";
				}

				var byteStr = (this._agalcode[index] & 0xFF).toString(16);

				if (byteStr.length < 2)
				{
					byteStr = "0" + byteStr;
				}

				dbgLine += byteStr;
			}

			console.info(dbgLine);
		}

		if (this.verbose)
		{
			console.info("AGALMiniAssembler.assemble time: " + ((Lib.getTimer() - start) / 1000) + "s");
		}

		return this._agalcode;
	}

	private initregmap(version: number, ignorelimits: boolean): void
	{
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.VA] = new Register(AGALMiniAssembler.VA, "vertex attribute", 0x0, ignorelimits ? 1024 : ((version == 1 || version == 2) ? 7 : 15), AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.VC] = new Register(AGALMiniAssembler.VC, "vertex constant", 0x1, ignorelimits ? 1024 : (version == 1 ? 127 : 249), AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.VT] = new Register(AGALMiniAssembler.VT, "vertex temporary", 0x2, ignorelimits ? 1024 : (version == 1 ? 7 : 25), AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_WRITE | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.VO] = new Register(AGALMiniAssembler.VO, "vertex output", 0x3, ignorelimits ? 1024 : 0, AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_WRITE);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.VI] = new Register(AGALMiniAssembler.VI, "varying", 0x4, ignorelimits ? 1024 : (version == 1 ? 7 : 9), AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_READ | AGALMiniAssembler.REG_WRITE);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.FC] = new Register(AGALMiniAssembler.FC, "fragment constant", 0x1, ignorelimits ? 1024 : (version == 1 ? 27 : ((version == 2) ? 63 : 199)), AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.FT] = new Register(AGALMiniAssembler.FT, "fragment temporary", 0x2, ignorelimits ? 1024 : (version == 1 ? 7 : 25), AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_WRITE | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.FS] = new Register(AGALMiniAssembler.FS, "texture sampler", 0x5, ignorelimits ? 1024 : 7, AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_READ);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.FO] = new Register(AGALMiniAssembler.FO, "fragment output", 0x3, ignorelimits ? 1024 : (version == 1 ? 0 : 3), AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_WRITE);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.FD] = new Register(AGALMiniAssembler.FD, "fragment depth output", 0x6, ignorelimits ? 1024 : (version == 1 ? -1 : 0), AGALMiniAssembler.REG_FRAG | AGALMiniAssembler.REG_WRITE);
		AGALMiniAssembler.REGMAP[AGALMiniAssembler.IID] = new Register(AGALMiniAssembler.IID, "instance id", 0x7, ignorelimits ? 1024 : 0, AGALMiniAssembler.REG_VERT | AGALMiniAssembler.REG_READ);

		// aliases
		AGALMiniAssembler.REGMAP["op"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.VO];
		AGALMiniAssembler.REGMAP["i"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.VI];
		AGALMiniAssembler.REGMAP["v"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.VI];
		AGALMiniAssembler.REGMAP["oc"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.FO];
		AGALMiniAssembler.REGMAP["od"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.FD];
		AGALMiniAssembler.REGMAP["fi"] = AGALMiniAssembler.REGMAP[AGALMiniAssembler.VI];
	}

	private static init(): void
	{
		AGALMiniAssembler.initialized = true;

		// Fill the dictionaries with opcodes and registers
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.MOV] = new OpCode(AGALMiniAssembler.MOV, 2, 0x00, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.ADD] = new OpCode(AGALMiniAssembler.ADD, 3, 0x01, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SUB] = new OpCode(AGALMiniAssembler.SUB, 3, 0x02, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.MUL] = new OpCode(AGALMiniAssembler.MUL, 3, 0x03, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.DIV] = new OpCode(AGALMiniAssembler.DIV, 3, 0x04, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.RCP] = new OpCode(AGALMiniAssembler.RCP, 2, 0x05, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.MIN] = new OpCode(AGALMiniAssembler.MIN, 3, 0x06, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.MAX] = new OpCode(AGALMiniAssembler.MAX, 3, 0x07, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.FRC] = new OpCode(AGALMiniAssembler.FRC, 2, 0x08, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SQT] = new OpCode(AGALMiniAssembler.SQT, 2, 0x09, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.RSQ] = new OpCode(AGALMiniAssembler.RSQ, 2, 0x0a, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.POW] = new OpCode(AGALMiniAssembler.POW, 3, 0x0b, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.LOG] = new OpCode(AGALMiniAssembler.LOG, 2, 0x0c, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.EXP] = new OpCode(AGALMiniAssembler.EXP, 2, 0x0d, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.NRM] = new OpCode(AGALMiniAssembler.NRM, 2, 0x0e, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SIN] = new OpCode(AGALMiniAssembler.SIN, 2, 0x0f, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.COS] = new OpCode(AGALMiniAssembler.COS, 2, 0x10, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.CRS] = new OpCode(AGALMiniAssembler.CRS, 3, 0x11, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.DP3] = new OpCode(AGALMiniAssembler.DP3, 3, 0x12, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.DP4] = new OpCode(AGALMiniAssembler.DP4, 3, 0x13, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.ABS] = new OpCode(AGALMiniAssembler.ABS, 2, 0x14, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.NEG] = new OpCode(AGALMiniAssembler.NEG, 2, 0x15, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SAT] = new OpCode(AGALMiniAssembler.SAT, 2, 0x16, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.M33] = new OpCode(AGALMiniAssembler.M33, 3, 0x17, AGALMiniAssembler.OP_SPECIAL_MATRIX);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.M44] = new OpCode(AGALMiniAssembler.M44, 3, 0x18, AGALMiniAssembler.OP_SPECIAL_MATRIX);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.M34] = new OpCode(AGALMiniAssembler.M34, 3, 0x19, AGALMiniAssembler.OP_SPECIAL_MATRIX);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.DDX] = new OpCode(AGALMiniAssembler.DDX, 2, 0x1a, AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_FRAG_ONLY);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.DDY] = new OpCode(AGALMiniAssembler.DDY, 2, 0x1b, AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_FRAG_ONLY);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.IFE] = new OpCode(AGALMiniAssembler.IFE, 2, 0x1c, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_INCNEST | AGALMiniAssembler.OP_SCALAR);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.INE] = new OpCode(AGALMiniAssembler.INE, 2, 0x1d, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_INCNEST | AGALMiniAssembler.OP_SCALAR);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.IFG] = new OpCode(AGALMiniAssembler.IFG, 2, 0x1e, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_INCNEST | AGALMiniAssembler.OP_SCALAR);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.IFL] = new OpCode(AGALMiniAssembler.IFL, 2, 0x1f, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_INCNEST | AGALMiniAssembler.OP_SCALAR);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.ELS] = new OpCode(AGALMiniAssembler.ELS, 0, 0x20, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_INCNEST | AGALMiniAssembler.OP_DECNEST | AGALMiniAssembler.OP_SCALAR);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.EIF] = new OpCode(AGALMiniAssembler.EIF, 0, 0x21, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_VERSION2 | AGALMiniAssembler.OP_DECNEST | AGALMiniAssembler.OP_SCALAR);
		// space
		// OPMAP[TED] = new OpCode (TED, 3, 0x26, OP_FRAG_ONLY | OP_SPECIAL_TEX | OP_VERSION2); //ted is not available in AGAL2
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.KIL] = new OpCode(AGALMiniAssembler.KIL, 1, 0x27, AGALMiniAssembler.OP_NO_DEST | AGALMiniAssembler.OP_FRAG_ONLY);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.TEX] = new OpCode(AGALMiniAssembler.TEX, 3, 0x28, AGALMiniAssembler.OP_FRAG_ONLY | AGALMiniAssembler.OP_SPECIAL_TEX);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SGE] = new OpCode(AGALMiniAssembler.SGE, 3, 0x29, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SLT] = new OpCode(AGALMiniAssembler.SLT, 3, 0x2a, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SGN] = new OpCode(AGALMiniAssembler.SGN, 2, 0x2b, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SEQ] = new OpCode(AGALMiniAssembler.SEQ, 3, 0x2c, 0);
		AGALMiniAssembler.OPMAP[AGALMiniAssembler.SNE] = new OpCode(AGALMiniAssembler.SNE, 3, 0x2d, 0);

		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.RGBA] = new Sampler(AGALMiniAssembler.RGBA, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.COMPRESSED] = new Sampler(AGALMiniAssembler.COMPRESSED, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.COMPRESSEDALPHA] = new Sampler(AGALMiniAssembler.COMPRESSEDALPHA, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.DXT1] = new Sampler(AGALMiniAssembler.DXT1, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.DXT5] = new Sampler(AGALMiniAssembler.DXT5, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.VIDEO] = new Sampler(AGALMiniAssembler.VIDEO, AGALMiniAssembler.SAMPLER_TYPE_SHIFT, 3);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.D2] = new Sampler(AGALMiniAssembler.D2, AGALMiniAssembler.SAMPLER_DIM_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.D3] = new Sampler(AGALMiniAssembler.D3, AGALMiniAssembler.SAMPLER_DIM_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.CUBE] = new Sampler(AGALMiniAssembler.CUBE, AGALMiniAssembler.SAMPLER_DIM_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.MIPNEAREST] = new Sampler(AGALMiniAssembler.MIPNEAREST, AGALMiniAssembler.SAMPLER_MIPMAP_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.MIPLINEAR] = new Sampler(AGALMiniAssembler.MIPLINEAR, AGALMiniAssembler.SAMPLER_MIPMAP_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.MIPNONE] = new Sampler(AGALMiniAssembler.MIPNONE, AGALMiniAssembler.SAMPLER_MIPMAP_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.NOMIP] = new Sampler(AGALMiniAssembler.NOMIP, AGALMiniAssembler.SAMPLER_MIPMAP_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.NEAREST] = new Sampler(AGALMiniAssembler.NEAREST, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.LINEAR] = new Sampler(AGALMiniAssembler.LINEAR, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.ANISOTROPIC2X] = new Sampler(AGALMiniAssembler.ANISOTROPIC2X, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.ANISOTROPIC4X] = new Sampler(AGALMiniAssembler.ANISOTROPIC4X, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 3);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.ANISOTROPIC8X] = new Sampler(AGALMiniAssembler.ANISOTROPIC8X, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 4);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.ANISOTROPIC16X] = new Sampler(AGALMiniAssembler.ANISOTROPIC16X, AGALMiniAssembler.SAMPLER_FILTER_SHIFT, 5);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.CENTROID] = new Sampler(AGALMiniAssembler.CENTROID, AGALMiniAssembler.SAMPLER_SPECIAL_SHIFT, 1 << 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.SINGLE] = new Sampler(AGALMiniAssembler.SINGLE, AGALMiniAssembler.SAMPLER_SPECIAL_SHIFT, 1 << 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.IGNORESAMPLER] = new Sampler(AGALMiniAssembler.IGNORESAMPLER, AGALMiniAssembler.SAMPLER_SPECIAL_SHIFT, 1 << 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.REPEAT] = new Sampler(AGALMiniAssembler.REPEAT, AGALMiniAssembler.SAMPLER_REPEAT_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.WRAP] = new Sampler(AGALMiniAssembler.WRAP, AGALMiniAssembler.SAMPLER_REPEAT_SHIFT, 1);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.CLAMP] = new Sampler(AGALMiniAssembler.CLAMP, AGALMiniAssembler.SAMPLER_REPEAT_SHIFT, 0);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.CLAMP_U_REPEAT_V] = new Sampler(AGALMiniAssembler.CLAMP_U_REPEAT_V, AGALMiniAssembler.SAMPLER_REPEAT_SHIFT, 2);
		AGALMiniAssembler.SAMPLEMAP[AGALMiniAssembler.REPEAT_U_CLAMP_V] = new Sampler(AGALMiniAssembler.REPEAT_U_CLAMP_V, AGALMiniAssembler.SAMPLER_REPEAT_SHIFT, 3);
	}

	private match(value: string, reg: RegExp): Array<string>
	{
		var matches = [];
		var index = 0;
		var match;

		var result = null;

		while ((result = reg.exec(value)) != null)
		{
			match = result[0]
			matches.push(match);
			index = reg.lastIndex + match.length;
		}

		return matches;
	}
}

class OpCode
{
	public readonly emitCode: number;
	public readonly flags: number;
	public readonly name: string;
	public readonly numRegister: number;

	public constructor(name: string, numRegister: number, emitCode: number, flags: number)
	{
		this.name = name;
		this.numRegister = numRegister;
		this.emitCode = emitCode;
		this.flags = flags;
	}

	public toString(): string
	{
		return "[OpCode name=\"" + this.name + "\", numRegister=" + this.numRegister + ", emitCode=" + this.emitCode + ", flags=" + this.flags + "]";
	}
}

class Register
{
	public readonly emitCode: number;
	public readonly name: string;
	public readonly longName: string;
	public readonly flags: number;
	public readonly range: number;

	public constructor(name: string, longName: string, emitCode: number, range: number, flags: number)
	{
		this.name = name;
		this.longName = longName;
		this.emitCode = emitCode;
		this.range = range;
		this.flags = flags;
	}

	public toString(): string
	{
		return "[Register name=\""
			+ this.name
			+ "\", longName=\""
			+ this.longName
			+ "\", emitCode="
			+ this.emitCode
			+ ", range="
			+ this.range
			+ ", flags="
			+ this.flags
			+ "]";
	}
}

class Sampler
{
	public readonly flag: number;
	public readonly mask: number;
	public readonly name: string;

	public constructor(name: string, flag: number, mask: number)
	{
		this.name = name;
		this.flag = flag;
		this.mask = mask;
	}

	public toString(): string
	{
		return "[Sampler name=\"" + this.name + "\", flag=\"" + this.flag + "\", mask=" + this.mask + "]";
	}
}
