package openfl.utils; #if !openfl_legacy


import openfl.utils.ByteArray;


interface IMemoryRange {
	
	public function getByteBuffer ():ByteArray;
	public function getStart ():Int;
	public function getLength ():Int;
   
}


#else
typedef IMemoryRange = openfl._legacy.utils.IMemoryRange;
#end