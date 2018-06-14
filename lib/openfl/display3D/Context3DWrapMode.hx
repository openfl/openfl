package openfl.display3D;


@:enum abstract Context3DWrapMode(String) from String to String {
	
	public var CLAMP = "clamp";
	public var CLAMP_U_REPEAT_V = "clamp_u_repeat_y";
	public var REPEAT = "repeat";
	public var REPEAT_U_CLAMP_V = "repeat_u_clamp_y";
	
}