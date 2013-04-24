package pazu.display3D;
#if display
#if flash


import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;


extern class Shader3D extends ByteArray {
	
	var info:AGALInfo;
	var type:Context3DProgramType;
	function new (source:Dynamic, type:Context3DProgramType);
	function getAGALRegisterIndex (name:String):Int;
	function setAGALConstants (context3D:Context3D):Void;
	
}


#else


import pazu.gl.GLShader;


extern class Shader3D extends GLShader {
	
	function new (source:Dynamic, type:Context3DProgramType);
	
}


#end
#elseif flash


import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.utils.ByteArray;
import flash.Vector;
import haxe.Json;


class Shader3D extends ByteArray {
	
	
	public var type:Context3DProgramType;
	
	public var info:AGALInfo;
	private var sourceType:Shader3DSourceType;
	
	
	public function new (source:Dynamic, type:Context3DProgramType, sourceType:Shader3DSourceType = null) {
		
		super ();
		
		this.sourceType = sourceType;
		this.type = type;
		
		if (!validateSource (source)) return;
		
		var agal = "";
		
		if (this.sourceType == Shader3DSourceType.GLSL) {
			
			var glsl2agal = new nme.display3D.shaders.GlslToAgal (cast (source, String), Std.string (type));
			var data = glsl2agal.compile ();
			info = new AGALInfo (Json.parse (data));
			agal = info.agalasm;
			
		} else if (this.sourceType == Shader3DSourceType.AGAL) {
			
			agal = cast (source, String);
			
		}
		
		var data = null;
		
		if (this.sourceType != Shader3DSourceType.AGAL_BYTECODE) {
			
			var assembler = new com.adobe.utils.AGALMiniAssembler ();
			assembler.assemble (Std.string (type), info.agalasm);
			data = assembler.agalcode;
			
		} else {
			
			data = cast (source, ByteArray);
			
		}
		
		data.position = 0;
		data.readBytes (this, 0, data.length);
		endian = data.endian;
		
	}
	
	
	public function getAGALRegisterIndex (name:String):Int {
		
		if (sourceType == Shader3DSourceType.GLSL) {
			
			var registerName = info.varnames.get (name);
			
			if (registerName == null) {
				
				registerName = name;
				
			}
			
			return Std.parseInt (registerName.substr (2));
			
		}
		
		return -1;
		
	}
	
	
	public function setAGALConstants (context3D:Context3D):Void {
		
		if (sourceType == Shader3DSourceType.GLSL) {
			
			for (name in info.consts.keys ()) {
				
				context3D.setProgramConstantsFromVector (type, getAGALRegisterIndex (name), Vector.ofArray (info.consts.get (name)));
				
			}
			
		}
		
	}
	
	
	private function validateSource (source:Dynamic):Bool {
		
		if (sourceType == Shader3DSourceType.AGAL && Std.is (source, String)) return true;
		if (sourceType == Shader3DSourceType.AGAL_BYTECODE && Std.is (source, ByteArray)) return true;
		if (sourceType == Shader3DSourceType.GLSL && Std.is (source, String)) return true;
		
		if (sourceType == null) {
			
			if (Std.is (source, ByteArray)) {
				
				sourceType = Shader3DSourceType.AGAL_BYTECODE;
				return true;
				
			} else if (Std.is (source, String)) {
				
				if (cast (source, String).indexOf ("void main") > -1) {
					
					sourceType = Shader3DSourceType.GLSL;
					
				} else {
					
					sourceType = Shader3DSourceType.AGAL;
					
				}
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
}


#end


class AGALInfo {
	
	
    public var types:Map<String, String>;
    public var consts:Map<String, Array<Float>>;
    public var storage:Map<String, String>;
    public var varnames:Map<String, String>;
    public var info:String;
    public var agalasm:String;
	
	
    public function new (json:Dynamic) {
		
        types = populate (json.types);
        consts = populate (json.consts);
        storage = populate (json.storage);
        varnames = populate (json.varnames);
        info = json.info;
        agalasm = json.agalasm;
		
    }
	
	
    private function populate<T>(data):Map <String, T> {
		
        var hash = new Map<String, T> ();
		
        for (key in Reflect.fields (data)) {
			
            hash.set (key, Reflect.field (data, key));
			
        }
		
        return hash;
		
    }
	
	
}


enum Shader3DSourceType {
	
	AGAL;
	AGAL_BYTECODE;
	GLSL;
	
}