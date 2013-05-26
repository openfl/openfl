package openfl.gl;
#if display


extern class GLProgram extends GLObject {
	
	function new(inVersion:Int, inId:Dynamic):Void;
	function attach(s:GLShader):Void;
	function getShaders():Array<GLShader>;
	
}


#end