package openfl.events;


class NativeRenderEvent extends Event {
	
	
	public static inline var AFTER_NATIVE_RENDER = "afterNativeRender";
	public static inline var BEFORE_NATIVE_RENDER = "beforeNativeRender";
	public static inline var NATIVE_RENDER = "nativeRender";
	
	
	public function new (type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():Event {
		
		var event = new NativeRenderEvent (type, bubbles, cancelable);
		#if !flash
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		#end
		return event;
		
	}
	
	
	public override function toString ():String {
		
		#if flash
		return formatToString ("NativeRenderEvent", "type", "bubbles", "cancelable");
		#else
		return __formatToString ("NativeRenderEvent",  [ "type", "bubbles", "cancelable" ]);
		#end
		
	}
	
	
}