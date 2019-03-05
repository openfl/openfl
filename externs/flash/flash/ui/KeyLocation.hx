package flash.ui;

#if flash
@:enum abstract KeyLocation(Int) from Int to Int from UInt to UInt
{
	// #if (flash && !doc_gen)
	@:noCompletion @:dox(hide) public static inline var D_PAD = 4;
	// #end
	public var LEFT = 1;
	public var NUM_PAD = 3;
	public var RIGHT = 2;
	public var STANDARD = 0;
}
#else
typedef KeyLocation = openfl.ui.KeyLocation;
#end
