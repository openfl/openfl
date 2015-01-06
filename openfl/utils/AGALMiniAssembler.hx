package openfl.utils;


import haxe.ds.StringMap;
import openfl._internal.aglsl.assembler.FS;
import openfl._internal.aglsl.assembler.Part;
import openfl._internal.aglsl.assembler.Opcode;
import openfl._internal.aglsl.assembler.OpcodeMap;
import openfl._internal.aglsl.assembler.RegMap;
import openfl._internal.aglsl.assembler.Sampler;
import openfl._internal.aglsl.assembler.SamplerMap;
import openfl.errors.Error;


class AGALMiniAssembler {
	
	
	public var cur:Part;
	public var r:StringMap<Part>;
	
	
	public function new () {
		
		this.r = new StringMap<Part> ();
		this.cur = new Part ();
		
	}
	
	
	public function addHeader (partname:String, version:Int) {
		
		if (version == 0) {
			
			version = 1;
			
		}
		
		if (!this.r.exists (partname)) {
			
			this.r.set (partname, new Part (partname, version));
			this.emitHeader (this.r.get (partname));
			
		} else if (this.r.get (partname).version != Std.int (version)) {
			
			throw "Multiple versions for part " + partname;
			
		}
		
		this.cur = this.r.get (partname);
		
	}
	
	
	public function assemble (source:String, ext_part = null, ext_version = null):Dynamic {
		
		if (ext_version == 0) {
			
			ext_version = 1;
			
		}
		
		if (ext_part != null) {
			
			this.addHeader (ext_part, ext_version);
			
		}
		
		var reg = ~/[\n\r]+/g;
		var lines = reg.split (source); // handle breaks, then split into lines        
		
		var i:UInt;
		
		for (i in 0...lines.length) {
			
			this.processLine (lines[i], i);
			
		}
		
		return this.r;
		
	}
	
	
	public function emitDest (pr:Part, token:String, opdest:String):Bool {
		
		var reg = getGroupMatches (~/([fov]?[tpocidavs])(\d*)(\.[xyzw]{1,4})?/i, token, 3); // g1: regname, g2:regnum, g3:mask
		
		if (RegMap.map.get (reg[1]) == null) {
			
			return false;
			
		}
		
		if (Std.parseInt (reg[2]) == null) {
			
			reg[2] = "0";
			
		}
		
		var em = { num: reg[2] != null ? reg[2] : "0", code: RegMap.map.get (reg[1]).code, mask: this.stringToMask (reg[3]) };
		
		pr.data.writeShort (Std.parseInt (em.num));
		pr.data.writeByte (em.mask);
		pr.data.writeByte (em.code);
		
		return true;
		
	}
	
	
	public function emitHeader (pr:Part):Void {
		
		pr.data.writeByte (0xa0); // tag version
		pr.data.writeUnsignedInt (pr.version);
		 
		if (pr.version >= 0x10) {
			
			pr.data.writeByte (0); // align, for higher versions
			
		}
		
		pr.data.writeByte (0xa1); // tag program id
		
		switch (pr.name) {
			
			case "fragment": pr.data.writeByte (1);
			case "vertex": pr.data.writeByte (0);
			case "cpu": pr.data.writeByte (2);
			default: pr.data.writeByte (0xff); // unknown/comment
			
		}
		
	}
	
	
	public function emitOpcode (pr:Part, opcode) {
		
		pr.data.writeUnsignedInt (opcode);
		
	}
	
	
	public function emitSampler (pr:Part, token:String, opsrc:FS, opts:Array<String>):Bool {
		
		var reg = getGroupMatches (~/fs(\d*)/i, token, 1); // g1:regnum
		
		if (reg.length < 1) {
			
			return false;
			
		}
		
		pr.data.writeShort (Std.parseInt (reg[1]));
		pr.data.writeByte (0); // bias
		pr.data.writeByte (0);
		/*
		pr.data.writeByte (0x5); 
		pr.data.writeByte (0); // readmode, dim
		pr.data.writeByte (0); // special, wrap
		pr.data.writeByte (0); // mip, filter
		*/
		var samplerbits:UInt = 0x5;
		var sampleroptset:UInt = 0;
		
		for (i in 0...opts.length) {
			
			var o:Sampler = SamplerMap.map.get (opts[i].toLowerCase ());
			
			if (o != null) {
				
				if (((sampleroptset >> o.shift) & o.mask) != 0) {
					
					trace ("Warning, duplicate sampler option");
					
				}
				
				sampleroptset |= o.mask << o.shift;
				samplerbits &= ~(o.mask << o.shift);
				samplerbits |= o.value << o.shift;
				
			} else {
				
				// todo bias
				
			}
			
		}
		
		pr.data.writeUnsignedInt (samplerbits);             
	 	//pr.data.writeUnsignedInt (0x5000000);
        //var bC = 0;
        //pr.data.position = 0;
        //
        //while (bC++ < pr.data.length) {
        //	
        //	trace ("byte-" + bC + "=0x" + StringTools.hex (pr.data.readUnsignedByte (), 1).toLowerCase ());
        //	
        //}
        
	 	return true;
	 	
	}
	
	
	public function emitSource (pr:Part, token:String, opsrc):Bool {
		
		//trace ("emitSource:" + token);
		
		var indexed = getGroupMatches (~/vc\[(v[tcai])(\d+)\.([xyzw])([\+\-]\d+)?\](\.[xyzw]{1,4})?/i, token, 5); // g1: indexregname, g2:indexregnum, g3:select, [g4:offset], [g5:swizzle]
		var reg;
		
		if (indexed.length > 0) {
			
			if (RegMap.map.get (indexed[1]) == null) {
				
				return false;
				
			}
			
			var selindex = { x: 0, y: 1, z: 2, w: 3 };
			var em:Dynamic = { num: Std.parseInt (indexed[2]) | 0, code: RegMap.map.get (indexed[1]).code, swizzle: this.stringToSwizzle (indexed[5]), select: Reflect.getProperty (selindex, indexed[3]), offset: Std.parseInt (indexed[4]) | 0 };
			
			pr.data.writeShort (em.num);
			pr.data.writeByte (em.offset);
			pr.data.writeByte (em.swizzle);
			pr.data.writeByte (0x1); // constant reg
			pr.data.writeByte (em.code);
			pr.data.writeByte (em.select);
			pr.data.writeByte (1 << 7);
			
		} else {
			
			reg = getGroupMatches (~/([fov]?[tpocidavs])(\d*)(\.[xyzw]{1,4})?/i, token, 3); // g1: regname, g2:regnum, g3:swizzle
			
			if (RegMap.map.get (reg[1]) == null) {
				
				return false;
				
			}
			
			if (reg.length < 4) reg.push ("");
			var em:Dynamic = { num: Std.parseInt (reg[2]) | 0, code: RegMap.map.get (reg[1]).code, swizzle: this.stringToSwizzle (reg[3]) };
			
			pr.data.writeShort (em.num);
			pr.data.writeByte (0);
			pr.data.writeByte (em.swizzle);
			pr.data.writeByte (em.code);
			pr.data.writeByte (0);
			pr.data.writeByte (0);
			pr.data.writeByte (0);
			
		}
		
		return true;
		
	}
	
	
	public function emitZeroDword (pr:Part) {
		
		pr.data.writeUnsignedInt (0);
		
	}
	
	
	public function emitZeroQword (pr) {
		
		pr.data.writeUnsignedInt (0);
		pr.data.writeUnsignedInt (0);
		
	}
	
	
	public function getGroupMatches (ereg:EReg, text:String, groupCount:UInt = 0):Array<String> {
		
		var matches:Array<String> = [];
		if (!ereg.match (text)) return matches;
		
		var m:UInt = 0;
		var t;
		var completed:Bool = false;
		
		while (!completed && (t = ereg.matched (m++)) != null) {
			
			matches.push (t);
			if (groupCount != 0 && m > groupCount) completed = true;
			
		}
		
		return matches;
		
	}
	
	
	public function getMatches (ereg:EReg, text:String):Array<String> {
		
		var matches:Array<String> = [];
		
		while (ereg.match (text)) {
			
			var t = ereg.matched (1);
			matches.push (t);
			text = ereg.matchedRight ();
			
		}
		
		return matches;
		
	}
	
	
	private function processLine (line:String, linenr:UInt):Void {
		
		var startcomment = line.indexOf ("//");  // remove comments
		
		if (startcomment != -1) {
			
			line = line.substring (0, startcomment);
			
		}
		
		var r = ~/^\s+|\s+$/g;
		line = r.replace (line, ""); // remove outer space
		
		if (!(line.length > 0 )) {
			
			return;
			
		}
		
		r = ~/<.*>/g;
		var optsb = r.match (line); // split of options part <*> if there
		var opts = null;
		
		if (optsb) {
			
			var optsi = r.matchedPos ().pos;
			opts = getMatches (~/([\w\.\-\+]+)/gi, line.substring (optsi));
			line = line.substring (0, optsi);
			
		}
		
		// get opcode/command
		var tokens = getMatches (~/([\w\.\+\[\]]+)/gi, line);			            
		if (tokens.length == 0) {
			
			if (line.length >= 3) {
				
				trace ("Warning: bad line " + linenr + ": " + line);
				
			}
			
			return;
			
		}
		
		//trace ( linenr, line, cur, tokens ); 
		switch (tokens[0]) {
			
			case "part":
				
				this.addHeader (tokens[1], Std.parseInt (tokens[2]));
			
			case "endpart":
				
				if (this.cur == null) {
					
					throw "Unexpected endpart";
					
				}
				
				this.cur.data.position = 0;
				this.cur = null; 
				return;
			
			default:
				
				if (this.cur == null) {
					
					trace ("Warning: bad line " + linenr + ": " + line + " (Outside of any part definition)");
					return;
					
				}
				
				if (this.cur.name == "comment") {
					
					return;
					
				}
				
				var op:Opcode = OpcodeMap.map.get (tokens[0]);
				
				if (op == null) {
					
					throw "Bad opcode " + tokens[0] + " " + linenr + ": " + line;
					
				}
				
				this.emitOpcode (this.cur, op.opcode);
				var ti:Int = 1;
				
				if (op.dest != null && op.dest != "none") {
					
					if (!this.emitDest (this.cur, tokens[ti++], op.dest)) {
						
						throw "Bad destination register " + tokens[ti - 1] + " " + linenr + ": " + line;
						
					}
					
				} else {
					
					this.emitZeroDword (this.cur);
					
				}
				
				if (op.a != null && op.a.format != "none") {
					
					if (!this.emitSource (this.cur, tokens[ti++], op.a)) throw "Bad source register " + tokens[ti - 1] + " " + linenr + ": " + line;
					
				} else {
					
					this.emitZeroQword (this.cur);
					 
				}
				
				if (op.b != null && op.b.format != "none") {
					
					if (op.b.format == "sampler") {
						
						if (!this.emitSampler (this.cur, tokens[ti++], op.b, opts)) {
							
							throw "Bad sampler register " + tokens[ti - 1] + " " + linenr + ": " + line;
							
						}
						
					} else {
						
						if (!this.emitSource (this.cur, tokens[ti++], op.b)) {
							
							throw "Bad source register " + tokens[ti - 1] + " " + linenr + ": " + line;
							
						}
						
					}
					
				} else {
					
					this.emitZeroQword (this.cur);
					
				}
			
		}
		
	}
	
	
	public function stringToMask (s:String = null):UInt {
		
		if (s == null) return 0xf;
		
		var r = 0;
		if (s.indexOf ("x") != -1) r|=1;
		if (s.indexOf ("y") != -1) r|=2;
		if (s.indexOf ("z") != -1) r|=4;
		if (s.indexOf ("w") != -1) r|=8;
		return r;
		
	}
	
	
	public function stringToSwizzle (s:String) {
		
		if (s == "") {
			
			return 0xe4;
			
		}
		
		var chartoindex = { x: 0, y: 1, z: 2, w: 3 };
		var sw = 0;
		
		if (s.charAt (0) != ".") {
			
			throw "Missing . for swizzle";
			
		}
		
		if (s.length > 1) {
			
			sw |= Reflect.field (chartoindex, s.charAt (1));
			
		}
		
		if (s.length > 2) {
			
			sw |= Reflect.field (chartoindex, s.charAt (2)) << 2;
			
		} else {
			
			sw |= (sw & 3) << 2;
			
		}
		
		if (s.length > 3) {
			
			sw |= Reflect.field (chartoindex, s.charAt (3)) << 4;
			
		} else {
			
			sw |= (sw & (3 << 2)) << 2;
			
		}
		
		if (s.length > 4) {
			
			sw |= Reflect.field (chartoindex, s.charAt (4)) << 6;
			
		} else {
			
			sw |= (sw & (3 << 4)) << 2;
			
		}
		
		return sw;
		
	}
	
	
}