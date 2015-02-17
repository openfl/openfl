package openfl._internal.aglsl;


import openfl.utils.ByteArray;


class AGALTokenizer {
	
	
	public function new () {
		
		
		
	}
	
	
	public function decribeAGALByteArray (bytes:ByteArray):Description {
		
		var header = new Header ();
		bytes.position = 0;
		
		if (bytes.readUnsignedByte () != 0xa0)  {
			
			throw "Bad AGAL: Missing 0xa0 magic byte.";
			
		}
		
		header.version = bytes.readUnsignedInt ();
		
		if (header.version >= 0x10) {
			
			bytes.readUnsignedByte ();
			header.version >>= 1;
			
		}
		
		if (bytes.readUnsignedByte () != 0xa1) {
			
			throw "Bad AGAL: Missing 0xa1 magic byte.";
			
		}
		
		header.progid = bytes.readUnsignedByte ();
		var _sw0_ = (header.progid);
		
		header.type = switch (_sw0_) {
			
			case 1: "fragment";
			case 0: "vertex";
			case 2: "cpu";
			default: "";
			
		}
		
		var desc = new Description();
		var tokens = new Array<Dynamic>();
		var agal2glsllut:Array<Dynamic> = Mapping.agal2glsllut;
		
		while (bytes.position < bytes.length) {
			
			var token = new Token ();
			token.opcode = bytes.readUnsignedInt ();
			var lutentry:OpLUT = Mapping.agal2glsllut[token.opcode];
			
			if (lutentry == null)  {
				
				throw "Opcode not valid or not implemented yet: " + token.opcode;
				
			}
			
			if (lutentry.matrixheight == 0)  {
				
				desc.hasmatrix = true;
				
			}
			
			if (lutentry.dest) {
				
				token.dest.regnum = bytes.readUnsignedShort ();
				token.dest.mask = bytes.readUnsignedByte ();
				token.dest.regtype = bytes.readUnsignedByte ();
				
				if (desc.regwrite[token.dest.regtype][token.dest.regnum] == null) {
					
					desc.regwrite[token.dest.regtype][token.dest.regnum] = token.dest.mask;
					
				} else {
					
					desc.regwrite[token.dest.regtype][token.dest.regnum] |= token.dest.mask;
					
				}
				
			} else {
				
				token.dest = null;
				bytes.readUnsignedInt ();
				
			}
			
			if (lutentry.a) {
				
				this.readReg (token.a, 1, desc, bytes);
				
			} else {
				
				token.a = null;
				bytes.readUnsignedInt ();
				bytes.readUnsignedInt ();
				
			}
			
			if (lutentry.b)  {
				
				this.readReg (token.b, lutentry.matrixheight | 0, desc, bytes);
				
			} else {
				
				token.b = null;
				bytes.readUnsignedInt ();
				bytes.readUnsignedInt ();
				
			}
			
			tokens.push (token);
			
		}
		
		desc.header = header;
		desc.tokens = tokens;
		return desc;
		
	}
	
	
	public function readReg (s:Destination, mh:Int, desc:Description, bytes:ByteArray):Void {
		
		s.regnum = bytes.readUnsignedShort ();
		s.indexoffset = bytes.readByte ();
		s.swizzle = bytes.readUnsignedByte ();
		s.regtype = bytes.readUnsignedByte ();
		desc.regread[s.regtype][s.regnum] = 0xf;
		// sould be swizzle to mask? should be |=
		
		if (s.regtype == 0x5) {
			
			// sampler
			s.lodbiad = s.indexoffset;
			//why
			s.indexoffset = 0;
			s.swizzle = 0;
			// sampler
			s.readmode = bytes.readUnsignedByte ();
			s.dim = s.readmode >> 4;
			s.readmode &= 0xf;
			s.special = bytes.readUnsignedByte ();
			s.wrap = s.special >> 4;
			s.special &= 0xf;
			s.mipmap = bytes.readUnsignedByte ();
			s.filter = s.mipmap >> 4;
			s.mipmap &= 0xf;
			desc.samplers[s.regnum] = s;
			
		} else {
			
			s.indexregtype = bytes.readUnsignedByte ();
			s.indexselect = bytes.readUnsignedByte ();
			s.indirectflag = bytes.readUnsignedByte ();
			
		}
		
		if (s.indirectflag == 1) {
			
			desc.hasindirect = true;
			
		}
		
		if (s.indirectflag == 0 && mh > 0) {
			
			var mhi:Int = 0;
			
			while (mhi < mh) {
				
				//TODO wrong, should be |=  
				desc.regread[s.regtype][s.regnum + mhi] = desc.regread[s.regtype][s.regnum];
				mhi++;
				
			}
			
		}
		
	}
	
	
}