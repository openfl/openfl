package openfl.events;


import openfl.utils.ByteArray;
import openfl.utils.Endian;


class SampleDataEvent extends Event {
	
	
	public static inline var SAMPLE_DATA = "sampleData";
	
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
		event.eventPhase = eventPhase;
		return event;
		
	}
	
	
	public override function toString ():String {
		
		return __formatToString ("SampleDataEvent",  [ "type", "bubbles", "cancelable" ]);
		
	}
	
	
}