package flash.display3D; #if (!display && flash)


import openfl.utils.ByteArray;


@:final extern class Program3D {
	
	
	public function dispose () : Void;
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void;
	
	
}


#else
typedef Program3D = openfl.display3D.Program3D;
#end