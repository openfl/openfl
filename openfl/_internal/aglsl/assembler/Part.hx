package openfl._internal.aglsl.assembler;


import openfl.utils.ByteArray;
import openfl.utils.Endian;


class Part {
	
	
	public var data:ByteArray;
	public var name:String;
	public var version:Int;
	
	
	public function new (name:String = "", version:Int = 0) {
		
		this.name = name;
		this.version = version;
		
		this.data = new ByteArray ();
		data.endian = Endian.LITTLE_ENDIAN;
		
	}
	
	
}