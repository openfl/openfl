package openfl._v2.utils; #if (!flash && !html5 && !openfl_next)


import openfl.utils.ByteArray;


interface IMemoryRange {
	
	
	public function getByteBuffer ():ByteArray;
	public function getStart ():Int;
	public function getLength ():Int;
	
	
}


#end