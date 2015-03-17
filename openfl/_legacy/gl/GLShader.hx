package openfl._legacy.gl; #if openfl_legacy


class GLShader extends GLObject {
	
	
	public function new (version:Int, id:Dynamic) {
		
		super (version, id);
		
	}
	
	
	override private function getType ():String {
		
		return "Shader";
		
	}
	
	
	public override function isValid ():Bool {
		
		return id != 0 && id != null && version == GL.version;
		
	}
	
	
}


#end