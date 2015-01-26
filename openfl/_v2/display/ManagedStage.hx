package openfl._v2.display; #if lime_legacy


import openfl.display.Stage;
import openfl.Lib;


class ManagedStage extends Stage {
	
	
	static inline public var etUnknown = 0;
	static inline public var etKeyDown = 1;
	static inline public var etChar = 2;
	static inline public var etKeyUp = 3;
	static inline public var etMouseMove = 4;
	static inline public var etMouseDown = 5;
	static inline public var etMouseClick = 6;
	static inline public var etMouseUp = 7;
	static inline public var etResize = 8;
	static inline public var etPoll = 9;
	static inline public var etQuit = 10;
	static inline public var etFocus = 11;
	static inline public var etShouldRotate = 12;
	static inline public var etDestroyHandler = 13;
	static inline public var etRedraw = 14;
	static inline public var etTouchBegin = 15;
	static inline public var etTouchMove = 16;
	static inline public var etTouchEnd = 17;
	static inline public var etTouchTap = 18;
	static inline public var etChange = 19;
	static inline public var efLeftDown = 0x0001;
	static inline public var efShiftDown = 0x0002;
	static inline public var efCtrlDown = 0x0004;
	static inline public var efAltDown = 0x0008;
	static inline public var efCommandDown = 0x0010;
	static inline public var efMiddleDown = 0x0020;
	static inline public var efRightDown = 0x0040;
	static inline public var efLocationRight = 0x4000;
	static inline public var efPrimaryTouch = 0x8000;
	
	
	public function new (width:Int, height:Int, flags:Int = 0) {
		
		super (lime_managed_stage_create (width, height, flags), width, height);
		
	}
	
	
	dynamic public function beginRender ():Void {
		
		
		
	}
	
	
	dynamic public function endRender ():Void {
		
		
		
	}
	

	public function pumpEvent (event:Dynamic):Void {
		
		lime_managed_stage_pump_event (__handle, event);
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		pumpEvent ( { type: etResize, x: width, y: height } );
		
	}
	
	
	public function sendQuit ():Void {
		
		pumpEvent ( { type: etQuit } );
		
	}
	
	
	dynamic public function setNextWake (delay:Float):Void {
		
		
		
	}
	
	
	@:noCompletion override function __doProcessStageEvent (event:Dynamic):Float {
		
		__pollTimers ();
		
		var wake = super.__doProcessStageEvent (event);
		setNextWake (wake);
		
		return wake;
		
	}
	
	
	@:noCompletion override public function __render (sendEnterFrame:Bool):Void {
		
		beginRender ();
		super.__render (sendEnterFrame);
		endRender ();
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_managed_stage_create = Lib.load ("lime", "lime_managed_stage_create", 3);
	private static var lime_managed_stage_pump_event = Lib.load ("lime", "lime_managed_stage_pump_event", 2);
	
	
}


#end