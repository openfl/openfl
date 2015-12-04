package openfl.events; #if (!display && !flash)


import openfl.utils.ByteArray;
import openfl.utils.Endian;


class SampleDataEvent extends Event {
	
	
	public static var SAMPLE_DATA = "sampleData";
	
	public var data:ByteArray;
	public var position:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false) {
		
		super (type, bubbles, cancelable);
		
		data = new ByteArray ();
		data.endian = Endian.LITTLE_ENDIAN;
		position = 0.0;
		
	}
	
	
	public override function clone ():Event {
		
		var event = new SampleDataEvent (type, bubbles, cancelable);
		event.target = target;
		event.currentTarget = currentTarget;
		#if !openfl_legacy
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("SampleDataEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
}


#else


import openfl.utils.ByteArray;

#if flash
@:native("flash.events.SampleDataEvent")
#end


extern class SampleDataEvent extends Event {
	
	
	public static var SAMPLE_DATA:String;
	
	public var data:ByteArray;
	public var position:Float;
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false);
	
	
}


#end