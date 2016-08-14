package openfl._internal.stage3D;


class SamplerState {
	
	
	public var lodBias:Float;
	public var magFilter:Int;
	public var maxAniso:Float;
	public var minFilter:Int;
	public var wrapModeS:Int;
	public var wrapModeT:Int;
	
	
	public function new (minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int, lodBias:Float = 0.0, maxAniso:Float = 0.0) {
		
		this.minFilter = minFilter;
		this.magFilter = magFilter;
		this.wrapModeS = wrapModeS;
		this.wrapModeT = wrapModeT;
		this.lodBias = lodBias;
		this.maxAniso = maxAniso;
		
	}
	
	
	public function equals (other:SamplerState):Bool {
		
		if (this == other) {
			
			return true;
			
		}
		
		if (other == null) {
			
			return false;
			
		}
		
		return this.minFilter == other.minFilter &&
				this.magFilter == other.magFilter &&
				this.wrapModeS == other.wrapModeS &&
				this.wrapModeT == other.wrapModeT &&
				this.lodBias == other.lodBias &&
				maxAniso == other.maxAniso;
		
	}
	
	
}