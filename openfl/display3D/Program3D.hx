package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;


@:final class Program3D {
	
	
	private var __context:Context3D;
	private var __glProgram:GLProgram;
	
	/*#! Haxiomic Addition for performance improvements */
	private var __glFCLocationMap:Array<GLUniformLocation>;
	private var __glVCLocationMap:Array<GLUniformLocation>;
	private var __glFSLocationMap:Array<GLUniformLocation>; // sampler
	private var __glVALocationMap:Array<Int>;
	
	private var __yFlip:Null<GLUniformLocation>;
	
	
	private function new (context:Context3D, program:GLProgram) {
		
		__context = context;
		__glProgram = program;
		__glFCLocationMap = new Array<GLUniformLocation> ();
		__glVCLocationMap = new Array<GLUniformLocation> ();
		__glFSLocationMap = new Array<GLUniformLocation> ();
		__glVALocationMap = new Array<Int> ();
		
	}
	
	
	public function dispose ():Void {
		
		__context.__deleteProgram (this);
		
	}
	
	
	public function upload (vertexProgram:Dynamic, fragmentProgram:Dynamic):Void {
		
		GL.attachShader (__glProgram, vertexProgram);
		GL.attachShader (__glProgram, fragmentProgram);
		GL.linkProgram (__glProgram);
		
		if (GL.getProgramParameter (__glProgram, GL.LINK_STATUS) == 0) {
			
			var result = GL.getProgramInfoLog (__glProgram);
			if (result != "") throw result;
			
		}
		
		for (i in 0 ... GL.getProgramParameter (__glProgram, GL.ACTIVE_UNIFORMS)) {
			
			var info = GL.getActiveUniform (__glProgram, i);
			var loc = GL.getUniformLocation (__glProgram, info.name);
			
			if (__yFlip == null && info.name == "yflip") {
				
				__yFlip = loc;
				
			} else {
				
				var name = info.name.substr (0, 2);
				var idx = Std.parseInt (info.name.substr (2));
				
				switch (info.name.substr (0, 2)) {
					
					case "fc": __glFCLocationMap[idx] = loc;
					case "vc": __glVCLocationMap[idx] = loc;
					case "fs": __glFSLocationMap[idx] = loc;
					
				}
				
			}
			
		}
		
		var info, name, idx;
		
		for (i in 0 ... GL.getProgramParameter (__glProgram, GL.ACTIVE_ATTRIBUTES)) {
			
			info = GL.getActiveAttrib (__glProgram, i);
			name = info.name.substr (0, 2);
			idx = Std.parseInt (info.name.substr (2));
			
			if (name == "va") {
				
				__glVALocationMap[idx] = i;
				
			}
			
		}
		
	}
	
	
	private inline function __constUniformLocationFromAgal (type:Context3DProgramType, i:Int):GLUniformLocation {
		
		if (type == Context3DProgramType.VERTEX) {
			
			return __vsUniformLocationFromAgal (i);
			
		} else {
			
			return __fsUniformLocationFromAgal (i);
			
		}
		
	}
	
	
	private inline function __fsampUniformLocationFromAgal (i:Int):GLUniformLocation {
		
		return __glFSLocationMap[i];
		
	}
	
	
	private inline function __fsUniformLocationFromAgal (i:Int):GLUniformLocation {
		
		return __glFCLocationMap[i];
		
	}
	
	
	private inline function __vaUniformLocationFromAgal (i:Int):Int {
		
		return __glVALocationMap[i];
		
	}
	
	
	private inline function __vsUniformLocationFromAgal (i:Int):GLUniformLocation {
		
		return __glVCLocationMap[i];
		
	}
	
	
	private inline function __yFlipLoc ():GLUniformLocation {
		
		return __yFlip;
		
	}
	
	
}