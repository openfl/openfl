package flash.events; #if (!display && flash)


import openfl.utils.ByteArray;


extern class SampleDataEvent extends Event {
	
	
	public static var SAMPLE_DATA (default, never):String;
	
	public var data:ByteArray;
	public var position:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false);
	
	
}


#else
typedef SampleDataEvent = openfl.events.SampleDataEvent;
#end