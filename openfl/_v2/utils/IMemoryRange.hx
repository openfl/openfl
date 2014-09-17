package openfl._v2.utils;


import openfl.utils.ByteArray;


interface IMemoryRange {
	
	
	public function getByteBuffer ():ByteArray;
	public function getStart ():Int;
	public function getLength ():Int;
	
	
}