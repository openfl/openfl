package openfl._internal.aglsl.assembler;


class Sampler {
	
	
	public var mask:Int;
	public var shift:Int;
	public var value:Int;
	
	
	public function new (shift:Int, mask:Int, value:Int) {
		
		this.shift = shift;
		this.mask = mask;
		this.value = value;
		
	}
	
	
}