package openfl.utils;


import openfl.utils.ByteArray;


@:deprecated interface IMemoryRange {
	
	public function getByteBuffer ():ByteArray;
	public function getStart ():Int;
	public function getLength ():Int;
	
}