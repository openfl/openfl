package openfl._legacy.display; #if openfl_legacy


import openfl.display.Stage;
import openfl.Lib;


class ManagedStage extends Stage {
	
	
	public static inline var efLeftDown = 0x0001;
	public static inline var efShiftDown = 0x0002;
	public static inline var efCtrlDown = 0x0004;
	public static inline var efAltDown = 0x0008;
	public static inline var efCommandDown = 0x0010;
	public static inline var efMiddleDown = 0x0020;
	public static inline var efRightDown = 0x0040;
	public static inline var efLocationRight = 0x4000;
	public static inline var efPrimaryTouch = 0x8000;
	
	public static inline var etUnknown = 0;
	public static inline var etKeyDown = 1;
	public static inline var etChar = 2;
	public static inline var etKeyUp = 3;
	public static inline var etMouseMove = 4;
	public static inline var etMouseDown = 5;
	public static inline var etMouseClick = 6;
	public static inline var etMouseUp = 7;
	public static inline var etResize = 8;
	public static inline var etPoll = 9;
	public static inline var etQuit = 10;
	public static inline var etFocus = 11;
	public static inline var etShouldRotate = 12;
	public static inline var etDestroyHandler = 13;
	public static inline var etRedraw = 14;
	public static inline var etTouchBegin = 15;
	public static inline var etTouchMove = 16;
	public static inline var etTouchEnd = 17;
	public static inline var etTouchTap = 18;
	public static inline var etChange = 19;
	public static inline var etActivate = 20;
	public static inline var etDeactivate = 21;
	public static inline var etGotInputFocus = 22;
	public static inline var etLostInputFocus = 23;
	public static inline var etJoyAxisMove = 24;
	public static inline var etJoyBallMove = 25;
	public static inline var etJoyHatMove = 26;
	public static inline var etJoyButtonDown = 27;
	public static inline var etJoyButtonUp = 28;
	public static inline var etJoyDeviceAdded = 29;
	public static inline var etJoyDeviceRemoved = 30;
	public static inline var etSysWM = 31;
	public static inline var etRenderContextLost = 32;
	public static inline var etRenderContextRestored = 33;
	
	
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
	
	
	
	
	private static var lime_managed_stage_create = Lib.load ("lime-legacy", "lime_legacy_managed_stage_create", 3);
	private static var lime_managed_stage_pump_event = Lib.load ("lime-legacy", "lime_legacy_managed_stage_pump_event", 2);
	
	
}


#end