package openfl.filters;

#if !flash
@:enum abstract DisplacementMapFilterMode(String) from String to String
{
	public var CLAMP = "clamp";
	public var COLOR = "color";
	public var IGNORE = "ignore";
	public var WRAP = "wrap";
}
#else
typedef DisplacementMapFilterMode = flash.filters.DisplacementMapFilterMode;
#end
