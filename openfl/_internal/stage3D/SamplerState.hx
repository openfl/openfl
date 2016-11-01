package openfl._internal.stage3D;


class SamplerState {
	
	
	public var centroid:Bool;
	public var ignoreSampler:Bool;
	public var lodBias:Float;
	public var magFilter:Int;
	public var maxAniso:Float;
	public var minFilter:Int;
	public var wrapModeS:Int;
	public var wrapModeT:Int;
	
	
	public function new (minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int, lodBias:Float = 0.0, maxAniso:Float = 0.0, ignoreSampler:Bool = false, centroid:Bool = false) {
		
		this.minFilter = minFilter;
		this.magFilter = magFilter;
		this.wrapModeS = wrapModeS;
		this.wrapModeT = wrapModeT;
		this.lodBias = lodBias;
		this.maxAniso = maxAniso;
		this.ignoreSampler = ignoreSampler;
		this.centroid = centroid;
		
	}
	
	
	public function copyFrom (other:SamplerState):Void {
		
		if (other == null || other.ignoreSampler) return;
		
		this.minFilter = other.minFilter;
		this.magFilter = other.magFilter;
		this.wrapModeS = other.wrapModeS;
		this.wrapModeT = other.wrapModeT;
		this.lodBias = other.lodBias;
		this.maxAniso = other.maxAniso;
		this.centroid = other.centroid;
		
	}
	
	
	public function equals (other:SamplerState):Bool {
		
		if (this == other) {
			
			return true;
			
		}
		
		if (other == null) {
			
			return false;
			
		}
		
		return (minFilter == other.minFilter && magFilter == other.magFilter && wrapModeS == other.wrapModeS && wrapModeT == other.wrapModeT && lodBias == other.lodBias && maxAniso == other.maxAniso);
		
	}
	
	
}