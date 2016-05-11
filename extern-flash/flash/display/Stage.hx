package flash.display; #if (!display && flash)


import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.graphics.Renderer;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Touch;
import lime.ui.Window;
import openfl.display.Application;
import openfl.geom.Rectangle;
import openfl.Lib;


extern class Stage extends DisplayObjectContainer implements IModule {
	
	
	public var align:StageAlign;
	@:require(flash10_2) public var allowsFullScreen (default, null):Bool;
	@:require(flash11_3) public var allowsFullScreenInteractive (default, null):Bool;
	public var application (get, never):Application;
	
	@:noCompletion private inline function get_application ():Application { return Lib.application; }
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash15) public var browserZoomFactor (default, null):Float;
	#end
	
	@:require(flash10_2) public var color:UInt;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var colorCorrection:flash.display.ColorCorrection;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var colorCorrectionSupport (default, null):flash.display.ColorCorrectionSupport;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_4) public var contentsScaleFactor (default, null):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var displayContextInfo (default, null):String;
	#end
	
	public var displayState:StageDisplayState;
	public var focus:InteractiveObject;
	public var frameRate:Float;
	
	#if flash
	@:noCompletion @:dox(hide) public var fullScreenHeight (default, null):UInt;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var fullScreenSourceRect:Rectangle;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public var fullScreenWidth (default, null):UInt;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_2) public var mouseLock:Bool;
	#end
	
	public var quality:StageQuality;
	public var scaleMode:StageScaleMode;
	
	#if flash
	@:noCompletion @:dox(hide) public var showDefaultContextMenu:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var softKeyboardRect (default, null):Rectangle;
	#end
	
	public var stage3Ds (default, null):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight:Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_2) public var stageVideos (default, null):Vector<flash.media.StageVideo>;
	#end
	
	public var stageWidth:Int;
	public var window (get, never):Window;
	
	@:noCompletion private inline function get_window ():Window { return Lib.application.window; }
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var wmodeGPU (default, null):Bool;
	#end
	
	
	#if !flash
	public function new (window:Window, color:Null<Int> = null);
	#end
	
	
	public function invalidate ():Void;
	
	
	#if flash
	@:noCompletion @:dox(hide) public function isFocusInaccessible ():Bool;
	#end
	
	
	@:noCompletion @:dox(hide) public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void;
	@:noCompletion @:dox(hide) public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void;
	@:noCompletion @:dox(hide) public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void;
	@:noCompletion @:dox(hide) public function onGamepadConnect (gamepad:Gamepad):Void;
	@:noCompletion @:dox(hide) public function onGamepadDisconnect (gamepad:Gamepad):Void;
	@:noCompletion @:dox(hide) public function onJoystickAxisMove (joystick:Joystick, axis:Int, value:Float):Void;
	@:noCompletion @:dox(hide) public function onJoystickButtonDown (joystick:Joystick, button:Int):Void;
	@:noCompletion @:dox(hide) public function onJoystickButtonUp (joystick:Joystick, button:Int):Void;
	@:noCompletion @:dox(hide) public function onJoystickConnect (joystick:Joystick):Void;
	@:noCompletion @:dox(hide) public function onJoystickDisconnect (joystick:Joystick):Void;
	@:noCompletion @:dox(hide) public function onJoystickHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void;
	@:noCompletion @:dox(hide) public function onJoystickTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void;
	@:noCompletion @:dox(hide) public function onKeyDown (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
	@:noCompletion @:dox(hide) public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
	@:noCompletion @:dox(hide) public function onModuleExit (code:Int):Void;
	@:noCompletion @:dox(hide) public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void;
	@:noCompletion @:dox(hide) public function onMouseMove (window:Window, x:Float, y:Float):Void;
	@:noCompletion @:dox(hide) public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void;
	@:noCompletion @:dox(hide) public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void;
	@:noCompletion @:dox(hide) public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void;
	@:noCompletion @:dox(hide) public function onPreloadComplete ():Void;
	@:noCompletion @:dox(hide) public function onPreloadProgress (loaded:Int, total:Int):Void;
	@:noCompletion @:dox(hide) public function onRenderContextLost (renderer:Renderer):Void;
	@:noCompletion @:dox(hide) public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void;
	@:noCompletion @:dox(hide) public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void;
	@:noCompletion @:dox(hide) public function onTextInput (window:Window, text:String):Void;
	@:noCompletion @:dox(hide) public function onTouchMove (touch:Touch):Void;
	@:noCompletion @:dox(hide) public function onTouchEnd (touch:Touch):Void;
	@:noCompletion @:dox(hide) public function onTouchStart (touch:Touch):Void;
	@:noCompletion @:dox(hide) public function onWindowActivate (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowClose (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowCreate (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowDeactivate (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowDropFile (window:Window, file:String):Void;
	@:noCompletion @:dox(hide) public function onWindowEnter (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowFocusIn (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowFocusOut (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowFullscreen (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowLeave (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowMinimize (window:Window):Void;
	@:noCompletion @:dox(hide) public function onWindowMove (window:Window, x:Float, y:Float):Void;
	@:noCompletion @:dox(hide) public function onWindowResize (window:Window, width:Int, height:Int):Void;
	@:noCompletion @:dox(hide) public function onWindowRestore (window:Window):Void;
	@:noCompletion @:dox(hide) public function render (renderer:Renderer):Void;
	@:noCompletion @:dox(hide) public function update (deltaTime:Int):Void;
	
	
}


#else
typedef Stage = openfl.display.Stage;
#end