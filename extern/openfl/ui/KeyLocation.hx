package openfl.ui;


@:enum abstract KeyLocation(Int) from Int to Int {
	
	#if (flash && !doc_gen)
	@:noCompletion @:dox(hide) public static inline var D_PAD = 4;
	#end
	
	public var LEFT = 1;
	public var NUM_PAD = 3;
	public var RIGHT = 2;
	public var STANDARD = 0;
	
}