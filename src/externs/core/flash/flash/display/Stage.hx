package flash.display; #if (!display && flash)


import lime.app.Application in LimeApplication;
import lime.app.IModule;
import lime.app.Preloader;
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
	@:require(flash10_2) public var allowsFullScreen (default, never):Bool;
	@:require(flash11_3) public var allowsFullScreenInteractive (default, never):Bool;
	public var application (get, never):Application;
	
	private inline function get_application ():Application { return Lib.application; }
	
	#if air
	public var autoOrients:Bool;
	#end
	
	#if flash
	@:require(flash15) public var browserZoomFactor (default, never):Float;
	#end
	
	@:require(flash10_2) public var color:UInt;
	
	#if flash
	@:require(flash10) public var colorCorrection:flash.display.ColorCorrection;
	#end
	
	#if flash
	@:require(flash10) public var colorCorrectionSupport (default, never):flash.display.ColorCorrectionSupport;
	#end
	
	@:require(flash11_4) public var contentsScaleFactor (default, never):Float;
	
	#if flash
	@:require(flash11) public var displayContextInfo (default, never):String;
	#end
	
	public var displayState:StageDisplayState;
	public var focus:InteractiveObject;
	public var frameRate:Float;
	public var fullScreenHeight (default, never):UInt;
	
	#if flash
	public var fullScreenSourceRect:Rectangle;
	#end
	
	public var fullScreenWidth (default, never):UInt;
	
	#if flash
	@:require(flash11_2) public var mouseLock:Bool;
	#end
	
	#if air
	public var nativeWindow (default, never):NativeWindow;
	public var orientation (default, never):StageOrientation;
	#end
	
	public var quality:StageQuality;
	public var scaleMode:StageScaleMode;
	public var showDefaultContextMenu:Bool;
	
	#if flash
	@:require(flash11) public var softKeyboardRect (default, never):Rectangle;
	#end
	
	public var stage3Ds (default, never):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight (default, never):Int;
	
	#if flash
	@:require(flash10_2) public var stageVideos (default, never):Vector<flash.media.StageVideo>;
	#end
	
	public var stageWidth (default, never):Int;
	
	#if air
	public var supportedOrientations (default, never):Vector<StageOrientation>;
	#end
	
	public var window (get, never):Window;
	
	private inline function get_window ():Window { return Lib.application.window; }
	
	#if flash
	@:require(flash10_1) public var wmodeGPU (default, never):Bool;
	#end
	
	
	#if !flash
	public function new (window:Window, color:Null<Int> = null);
	#end
	
	
	#if air
	public function assignFocus (objectToFocus:InteractiveObject, direction:FocusDirection):Void;
	#end
	
	public function invalidate ():Void;
	
	#if flash
	public function isFocusInaccessible ():Bool;
	#end
	
	#if air
	public function setAspectRatio (newAspectRatio:StageAspectRatio):Void;
	public function setOrientation (newOrientation:StageOrientation):Void;
	public static var supportsOrientationChange (default, never):Bool;
	#end
	
	
	
	public function addRenderer (renderer:Renderer):Void;
	public function addWindow (window:Window):Void;
	public function registerModule (application:LimeApplication):Void;
	public function removeRenderer (renderer:Renderer):Void;
	public function removeWindow (window:Window):Void;
	public function setPreloader (preloader:Preloader):Void;
	public function unregisterModule (application:LimeApplication):Void;
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void;
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void;
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void;
	public function onGamepadConnect (gamepad:Gamepad):Void;
	public function onGamepadDisconnect (gamepad:Gamepad):Void;
	public function onJoystickAxisMove (joystick:Joystick, axis:Int, value:Float):Void;
	public function onJoystickButtonDown (joystick:Joystick, button:Int):Void;
	public function onJoystickButtonUp (joystick:Joystick, button:Int):Void;
	public function onJoystickConnect (joystick:Joystick):Void;
	public function onJoystickDisconnect (joystick:Joystick):Void;
	public function onJoystickHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void;
	public function onJoystickTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void;
	public function onKeyDown (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
	public function onKeyUp (window:Window, keyCode:KeyCode, modifier:KeyModifier):Void;
	public function onModuleExit (code:Int):Void;
	public function onMouseDown (window:Window, x:Float, y:Float, button:Int):Void;
	public function onMouseMove (window:Window, x:Float, y:Float):Void;
	public function onMouseMoveRelative (window:Window, x:Float, y:Float):Void;
	public function onMouseUp (window:Window, x:Float, y:Float, button:Int):Void;
	public function onMouseWheel (window:Window, deltaX:Float, deltaY:Float):Void;
	public function onPreloadComplete ():Void;
	public function onPreloadProgress (loaded:Int, total:Int):Void;
	public function onRenderContextLost (renderer:Renderer):Void;
	public function onRenderContextRestored (renderer:Renderer, context:RenderContext):Void;
	public function onTextEdit (window:Window, text:String, start:Int, length:Int):Void;
	public function onTextInput (window:Window, text:String):Void;
	public function onTouchMove (touch:Touch):Void;
	public function onTouchEnd (touch:Touch):Void;
	public function onTouchStart (touch:Touch):Void;
	public function onWindowActivate (window:Window):Void;
	public function onWindowClose (window:Window):Void;
	public function onWindowCreate (window:Window):Void;
	public function onWindowDeactivate (window:Window):Void;
	public function onWindowDropFile (window:Window, file:String):Void;
	public function onWindowEnter (window:Window):Void;
	public function onWindowFocusIn (window:Window):Void;
	public function onWindowFocusOut (window:Window):Void;
	public function onWindowFullscreen (window:Window):Void;
	public function onWindowLeave (window:Window):Void;
	public function onWindowMinimize (window:Window):Void;
	public function onWindowMove (window:Window, x:Float, y:Float):Void;
	public function onWindowResize (window:Window, width:Int, height:Int):Void;
	public function onWindowRestore (window:Window):Void;
	public function render (renderer:Renderer):Void;
	public function update (deltaTime:Int):Void;
	
	
}


#else
typedef Stage = openfl.display.Stage;
#end