package openfl._internal.aglsl;


using StringTools;


class AGLSLParser {
	
	
	public function new () {
		
		
		
	}
	
	
	public function parse (desc:Description):String {
		
		var header:String = "";
		var body:String = "";
		var i:Int = 0;
		
		#if html5
		header += "precision highp float;\n";
		#end
		
		var tag = desc.header.type.charAt (0); //TODO
		
		// declare uniforms
		if (desc.header.type == "vertex") {
			
			header += "uniform float yflip;\n";
			
		}
		
		if (!desc.hasindirect) {
			
			i  = 0;
			while (i < desc.regread[0x1].length) {
				
				if (desc.regread[0x1][i] > 0) {
					
					header += "uniform vec4 " + tag + "c" + i + ";\n";
					
				}
				i++;
				
			}
			
		} else {
			
			header += "uniform vec4 " + tag + "carrr[" + Context3D.maxvertexconstants + "];\n"; // use max const count instead
			
		}
		
		// declare temps
		i = 0;
		while (i < desc.regread[0x2].length || i < desc.regwrite[0x2].length) {
			
			if (desc.regread[0x2][i] > 0 || desc.regwrite[0x2][i] > 0) { // duh, have to check write only also... 
				
				header += "vec4 " + tag + "t" + i + ";\n";
				
			}
			i++;
			
		}
		
		// declare streams
		i = 0;
		while (i < desc.regread[0x0].length) {
			
			if (desc.regread[0x0][i] > 0) {
				
				header += "attribute vec4 va" + i + ";\n";
				
			}
			i++;
			
		}
		
		// declare interpolated
		i = 0;
		while (i < desc.regread[0x4].length || i < desc.regwrite[0x4].length) {
			
			if (desc.regread[0x4][i] > 0 || desc.regwrite[0x4][i] > 0) {
				
				header += "varying vec4 vi" + i + ";\n";
				
			}
			i++;
			
		}
		
		// declare samplers
		var samptype = ["2D", "Cube", "3D", ""];
		i = 0;
		while (i < desc.samplers.length) {
		 	
			if (desc.samplers[i] != null) {
				
				header += "uniform sampler" + samptype[desc.samplers[i].dim & 3] + " fs" + i + ";\n";
				
			}
			i++;
			
		}
		
		// extra gl fluff: setup position and depth adjust temps
		if (desc.header.type == "vertex") {
			
			header += "vec4 outpos;\n";
			
		}
		
		if (desc.writedepth) {
			
			header += "vec4 tmp_FragDepth;\n";
			
		}
		//if ( desc.hasmatrix )
		//    header += "vec4 tmp_matrix;\n";
		
		// start body of code
		body += "void main() {\n";
		i  = 0;
		while (i < desc.tokens.length) {
			
			var lutentry = Mapping.agal2glsllut[desc.tokens[i].opcode];
			
			if (lutentry == null) {
				
				throw "Opcode not valid or not implemented yet: ";
				/*+token.opcode;*/
				
			}
			
			var sublines = Std.int (Math.max (lutentry.matrixheight, 1));
			
			for (sl in 0...sublines) {
				
				var line = "  " + lutentry.s;
				var destregstring:String;
				var destcaststring:String;
				var destmaskstring:String;
				
				if (desc.tokens[i].dest != null) {
					
					if (lutentry.matrixheight > 0) {
						
						if (((desc.tokens[i].dest.mask >> sl) & 1) != 1) {
							
							continue;
							
						}
						
						destregstring = this.regtostring (desc.tokens[i].dest.regtype, desc.tokens[i].dest.regnum, desc, tag);
						destcaststring = "float";
						destmaskstring = [ "x", "y", "z", "w" ][sl];
						destregstring += "." + destmaskstring;
						
					} else {
						
						destregstring = this.regtostring (desc.tokens[i].dest.regtype, desc.tokens[i].dest.regnum, desc, tag);
						
						if (desc.tokens[i].dest.mask != 0xf) {
							
							var ndest = 0;
							destmaskstring = "";
							//why
							
							if (desc.tokens[i].dest.mask & 1 != 0) {
								
								ndest++;
								destmaskstring += "x";
								
							}
							
							if (desc.tokens[i].dest.mask & 2 != 0) {
								
								ndest++;
								destmaskstring += "y";
								
							}
							
							if (desc.tokens[i].dest.mask & 4 != 0) {
								
								ndest++;
								destmaskstring += "z";
								
							}
							
							if (desc.tokens[i].dest.mask & 8 != 0) {
								
								ndest++;
								destmaskstring += "w";
								
							}
							
							destregstring += "." + destmaskstring;
							
							switch (ndest) {
								
								case 1:
									
									destcaststring = "float";
								
								case 2:
									
									destcaststring = "vec2";
								
								case 3:
									
									destcaststring = "vec3";
								
								default:
									
									throw "Unexpected destination mask" + desc.tokens[i].dest.mask;
								
							}
							
						} else {
							
							destcaststring = "vec4";
							destmaskstring = "xyzw";
							
						}
						
					}
					
					line = line.replace ("%dest", destregstring);
					line = line.replace ("%cast", destcaststring);
					line = line.replace ("%dm", destmaskstring);
					
				}
				
				var dwm:Int = 0xf;
				
				if (!lutentry.ndwm && lutentry.dest && desc.tokens[i].dest != null) {
					
					dwm = desc.tokens[i].dest.mask;
					
				}
				
				if (desc.tokens[i].a != null) {
					
					line = line.replace ("%a", this.sourcetostring (desc.tokens[i].a, 0, dwm, lutentry.scalar, desc, tag));
					
				}
				
				if (desc.tokens[i].b != null) {
					
					line = line.replace ("%b", this.sourcetostring (desc.tokens[i].b, sl, dwm, lutentry.scalar, desc, tag));
					
					if (desc.tokens[i].b.regtype == 0x5) {
						
						// sampler dim
						var texdim = [ "2D", "Cube", "3D" ][desc.tokens[i].b.dim];
						var texsize = [ "vec2", "vec3", "vec3" ][desc.tokens[i].b.dim];
						line = line.replace ("%texdim", texdim);
						line = line.replace ("%texsize", texsize);
						var texlod = "";
						line = line.replace ("%lod", texlod);
						
					}
					
				}
				
				body += line;
				
			}
			
			i++;
			
		}
		
		// adjust z from opengl range of -1..1 to 0..1 as in d3d, this also enforces a left handed coordinate system
		if (desc.header.type == "vertex") {
			
			body += "  gl_Position = vec4(outpos.x, yflip*outpos.y, outpos.z*2.0 - outpos.w, outpos.w);\n";
			
		}
		
		// clamp fragment depth
		if (desc.writedepth) {
			
			body += "  gl_FragDepth = clamp(tmp_FragDepth,0.0,1.0);\n";
			
		}
		
		// close main
		body += "}\n";
		
		return header + body;
		
	}
	
	
	public function regtostring (regtype:Int, regnum:Int, desc, tag):String {
		
		switch (regtype) {
			
			case 0x0:
				
				return "va" + regnum;
			
			case 0x1:
				
				if (desc.hasindirect && desc.header.type == "vertex")  {
					
					return "vcarrr[" + regnum + "]";
					
				} else {
					
					return tag + "c" + regnum;
					
				}
			
			case 0x2:
				
				return tag + "t" + regnum;
			
			case 0x3:
				
				return desc.header.type == ("vertex") ? "outpos" : "gl_FragColor";
			
			case 0x4:
				
				return "vi" + regnum;
			
			case 0x5:
				
				return "fs" + regnum;
			
			case 0x6:
				
				return "tmp_FragDepth";
			
			default:
				
				throw "Unknown register type";
			
		}
		
	}
	
	
	public function sourcetostring (s:Destination, subline, dwm, isscalar, desc, tag):String {
		
		var swiz = [ "x", "y", "z", "w" ];
		var r;
		
		if (s.indirectflag == 1) {
			
			r = "vcarrr[int(" + this.regtostring (s.indexregtype, s.regnum, desc, tag) + "." + swiz[s.indexselect] + ")";
			var realofs = subline + s.indexoffset;
			if(realofs < 0) r += Std.string (realofs);
			if(realofs > 0) r += "+" + Std.string (realofs);
			r += "]";
			
		} else {
			
			r = this.regtostring (s.regtype, s.regnum + subline, desc, tag);
			
		}
		
		// samplers never add swizzle
		if (s.regtype == 0x5) {
			
			return r;
			
		}
		
		if (isscalar) {
			
			return r + "." + swiz[(s.swizzle >> 0) & 3];
			
		}
		
		if (s.swizzle == 0xe4 && dwm == 0xf) {
			
			return r;
			
		}
		
		r += ".";
		
		//why
		if (dwm & 1!=0) r += swiz[(s.swizzle >> 0) & 3];
		if (dwm & 2!=0) r += swiz[(s.swizzle >> 2) & 3];
		if (dwm & 4!=0) r += swiz[(s.swizzle >> 4) & 3];
		if (dwm & 8!=0) r += swiz[(s.swizzle >> 6) & 3];
		return r;
		
	}
	
	
}