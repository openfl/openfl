package openfl._legacy.utils; #if openfl_legacy


import openfl.utils.ByteArray;


interface IMemoryRange {
	
	
	public function getByteBuffer ():ByteArray;
	public function getStart ():Int;
	public function getLength ():Int;
	
	
}


#end