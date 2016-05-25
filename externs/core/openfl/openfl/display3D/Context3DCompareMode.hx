package openfl.display3D;


#if flash
@:native("flash.display3D.Context3DCompareMode")
#end


@:fakeEnum(String) extern enum Context3DCompareMode {
	
	ALWAYS;
	EQUAL;
	GREATER;
	GREATER_EQUAL;
	LESS;
	LESS_EQUAL;
	NEVER;
	NOT_EQUAL;
	
}