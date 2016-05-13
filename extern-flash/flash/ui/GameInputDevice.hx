package flash.ui; #if (!display && flash)


import openfl.utils.ByteArray;

@:require(flash11_8)


@:final extern class GameInputDevice {
	
	
	public static var MAX_BUFFER_SIZE (default, never):Int;
	
	public var enabled:Bool;
	public var id (default, null):String;
	public var name (default, null):String;
	public var numControls (default, null):Int;
	public var sampleInterval:Int;
	
	public function getCachedSamples (data:ByteArray, append:Bool = false):Int;
	public function getControlAt (i:Int):GameInputControl;
	public function startCachingSamples (numSamples:Int, controls:Vector<String>):Void;
	public function stopCachingSamples ():Void;
	
	
}


#else
typedef GameInputDevice = openfl.ui.GameInputDevice;
#end