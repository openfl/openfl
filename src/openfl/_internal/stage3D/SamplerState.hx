package openfl._internal.stage3D;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class SamplerState {
	
	
	public var lodBias(default, set):Float;
	public var magFilter(default, set):Int;
	public var maxAniso(default, set):Float;
	public var minFilter(default, set):Int;
	public var wrapModeS(default, set):Int;
	public var wrapModeT(default, set):Int;
	
	public var centroid:Bool;
	public var ignoreSampler:Bool;
	public var mipmapGenerated:Bool;
	public var textureAlpha:Bool;
	
	private var __samplerDirty:Bool;
	
	
	public function new (minFilter:Int, magFilter:Int, wrapModeS:Int, wrapModeT:Int, lodBias:Float = 0.0, maxAniso:Float = 0.0, ignoreSampler:Bool = false, centroid:Bool = false, mipmapGenerated:Bool = false, textureAlpha:Bool = false) {
		
		this.minFilter = minFilter;
		this.magFilter = magFilter;
		this.wrapModeS = wrapModeS;
		this.wrapModeT = wrapModeT;
		this.lodBias = lodBias;
		this.maxAniso = maxAniso;
		this.ignoreSampler = ignoreSampler;
		this.centroid = centroid;
		this.mipmapGenerated = mipmapGenerated;
		this.textureAlpha = textureAlpha;
		
		__samplerDirty = true;
		
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
		this.mipmapGenerated = other.mipmapGenerated;
		this.textureAlpha = other.textureAlpha;
		
	}
	
	
	public function equals (other:SamplerState):Bool {
		
		if (this == other) {
			
			return !__samplerDirty;
			
		}
		
		if (other == null) {
			
			return false;
			
		}

		return (minFilter == other.minFilter && magFilter == other.magFilter && wrapModeS == other.wrapModeS && wrapModeT == other.wrapModeT && lodBias == other.lodBias && maxAniso == other.maxAniso && mipmapGenerated == other.mipmapGenerated && textureAlpha == other.textureAlpha);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_lodBias (value:Float):Float {
		
		if (lodBias != value) __samplerDirty = true;
		return lodBias = value;
		
	}
	
	
	private function set_magFilter (value:Int):Int {
		
		if (magFilter != value) __samplerDirty = true;
		return magFilter = value;
		
	}
	
	
	private function set_maxAniso (value:Float):Float {
		
		if (maxAniso != value) __samplerDirty = true;
		return maxAniso = value;
		
	}
	
	
	private function set_minFilter (value:Int):Int {
		
		if (minFilter != value) __samplerDirty = true;
		return minFilter = value;
		
	}
	
	
	private function set_wrapModeS (value:Int):Int {
		
		if (wrapModeS != value) __samplerDirty = true;
		return wrapModeS = value;
		
	}
	
	
	private function set_wrapModeT (value:Int):Int {
		
		if (wrapModeT != value) __samplerDirty = true;
		return wrapModeT = value;
		
	}
	
	
}