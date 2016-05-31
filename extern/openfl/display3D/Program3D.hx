package openfl.display3D; #if (display || !flash)


import openfl.utils.ByteArray;


@:final extern class Program3D {
	
	
	public function dispose () : Void;
	public function upload (vertexProgram:Dynamic, fragmentProgram:Dynamic):Void;
	
	
}


#else
typedef Program3D = flash.display3D.Program3D;
#end