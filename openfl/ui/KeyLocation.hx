package openfl.ui; #if (!display && !flash)


#if (haxe_ver > 3.100)

@:enum abstract KeyLocation(Int) {
	
	var STANDARD = 0;
	var LEFT = 1;
	var RIGHT = 2;
	var NUM_PAD = 3;
	
}

#else

@:fakeEnum(Int) enum KeyLocation {
	
	STANDARD;
	LEFT;
	RIGHT;
	NUM_PAD;
	
}

#end


#else


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


#end