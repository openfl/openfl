package openfl._internal.stage3D;


class SamplerState {
	
	
	private static var __interns = new List<SamplerState> ();
	
	public var lodBias (default, null):Float;
	public var magFilter (default, null):Int;
	public var maxAniso (default, null):Float;
	public var minFilter (default, null):Int;
	public var wrapModeS (default, null):Int;
	public var wrapModeT (default, null):Int;
	
	private var __isInterned:Bool;
	
	
	public function new (minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int, lodBias:Float = 0.0, maxAniso:Float = 0.0) {
		
		this.minFilter = minFilter;
		this.magFilter = magFilter;
		this.wrapModeS = wrapModeS;
		this.wrapModeT = wrapModeT;
		this.lodBias = lodBias;
		this.maxAniso = maxAniso;
		
		__isInterned = false;
		
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
	
	
	public function intern ():SamplerState {
		
		if (__isInterned) return this;
		
		for (i in __interns) {
			
			if (i.equals (this)) {
				
				return i;
				
			}
			
		}
		
		__interns.add(this);
		__isInterned = true;
		return this;
		
	}
	
	public function toString ():String {
		
		var result:String = "[SamplerState " +
							" min:" + minFilter +
							" mag:" + magFilter +
							" wrapS:" + wrapModeS +
							" wrapT:" + wrapModeT +
							" bias:" + lodBias +
							" aniso:" + maxAniso + "]]";
		return result;
		
	}
	
	
}