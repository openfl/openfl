package openfl.ui;


#if flash
@:native("flash.ui.KeyLocation")
#end


@:fakeEnum(UInt) extern enum KeyLocation {
	
	#if (flash && !doc_gen)
	@:noCompletion @:dox(hide) D_PAD;
	#end
	
	LEFT;
	NUM_PAD;
	RIGHT;
	STANDARD;
	
}