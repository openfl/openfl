package openfl.ui; #if !flash


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
typedef KeyLocation = flash.ui.KeyLocation;
#end