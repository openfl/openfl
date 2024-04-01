package flash.display;

#if flash
import lime.app.Application in LimeApplication;
import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Touch;
import lime.ui.Window;
import openfl.display3D.Context3D;
import openfl.display.Application;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.Vector;

extern class Stage extends DisplayObjectContainer implements IModule
{
	#if (haxe_ver < 4.3)
	public var align:StageAlign;
	@:require(flash10_2) public var allowsFullScreen(default, never):Bool;
	@:require(flash11_3) public var allowsFullScreenInteractive(default, never):Bool;
	@:require(flash15) public var browserZoomFactor(default, never):Float;
	@:require(flash10_2) public var color:UInt;
	@:require(flash10) public var colorCorrection:flash.display.ColorCorrection;
	@:require(flash10) public var colorCorrectionSupport(default, never):flash.display.ColorCorrectionSupport;
	@:require(flash11_4) public var contentsScaleFactor(default, never):Float;
	@:require(flash11) public var displayContextInfo(default, never):String;
	public var displayState:StageDisplayState;
	public var focus:InteractiveObject;
	public var frameRate:Float;
	public var fullScreenHeight(default, never):UInt;
	public var fullScreenSourceRect:Rectangle;
	public var fullScreenWidth(default, never):UInt;
	@:require(flash11_2) public var mouseLock:Bool;
	public var quality:StageQuality;
	public var scaleMode:StageScaleMode;
	public var showDefaultContextMenu:Bool;
	@:require(flash11) public var softKeyboardRect(default, never):Rectangle;
	public var stage3Ds(default, never):Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight(default, never):Int;
	@:require(flash10_2) public var stageVideos(default, never):Vector<flash.media.StageVideo>;
	public var stageWidth(default, never):Int;
	@:require(flash10_1) public var wmodeGPU(default, never):Bool;
	#if air
	public static var supportsOrientationChange(default, never):Bool;
	public var autoOrients:Bool;
	public var deviceOrientation(default, never):StageOrientation;
	public var nativeWindow(default, never):NativeWindow;
	public var orientation(default, never):StageOrientation;
	public var supportedOrientations(default, never):Vector<StageOrientation>;
	public var vsyncEnabled:Bool;
	#end
	#else
	@:flash.property var align(get, set):StageAlign;
	@:flash.property var allowsFullScreen(get, never):Bool;
	@:flash.property @:require(flash11_3) var allowsFullScreenInteractive(get, never):Bool;
	@:flash.property var browserZoomFactor(get, never):Float;
	@:flash.property @:require(flash10_2) var color(get, set):UInt;
	@:flash.property @:require(flash10) var colorCorrection(get, set):ColorCorrection;
	@:flash.property @:require(flash10) var colorCorrectionSupport(get, never):ColorCorrectionSupport;
	@:flash.property @:require(flash11_4) var contentsScaleFactor(get, never):Float;
	@:flash.property @:require(flash11) var displayContextInfo(get, never):String;
	@:flash.property var displayState(get, set):StageDisplayState;
	@:flash.property var focus(get, set):InteractiveObject;
	@:flash.property var frameRate(get, set):Float;
	@:flash.property var fullScreenHeight(get, never):UInt;
	@:flash.property var fullScreenSourceRect(get, set):Rectangle;
	@:flash.property var fullScreenWidth(get, never):UInt;
	@:flash.property @:require(flash11_2) var mouseLock(get, set):Bool;
	@:flash.property var quality(get, set):StageQuality;
	@:flash.property var scaleMode(get, set):StageScaleMode;
	@:flash.property var showDefaultContextMenu(get, set):Bool;
	@:flash.property @:require(flash11) var softKeyboardRect(get, never):Rectangle;
	@:flash.property @:require(flash11) var stage3Ds(get, never):Vector<Stage3D>;
	@:flash.property var stageFocusRect(get, set):Bool;
	@:flash.property var stageHeight(get, set):Int;
	@:flash.property @:require(flash10_2) var stageVideos(get, never):Vector<flash.media.StageVideo>;
	@:flash.property var stageWidth(get, set):Int;
	@:flash.property @:require(flash10_1) var wmodeGPU(get, never):Bool;
	#if air
	@:flash.property public static var supportsOrientationChange(get, never):Bool;
	@:flash.property public var autoOrients(get, set):Bool;
	@:flash.property public var deviceOrientation(get, never):StageOrientation;
	@:flash.property public var nativeWindow(get, never):NativeWindow;
	@:flash.property public var orientation(get, never):StageOrientation;
	@:flash.property public var supportedOrientations(get, never):Vector<StageOrientation>;
	@:flash.property public var vsyncEnabled(get, set):Bool;
	#end
	#end
	public var application(get, never):Application;
	@:noCompletion private inline function get_application():Application
	{
		return Lib.application;
	}
	@:require(flash11) public var context3D(get, never):Context3D;
	@:noCompletion private inline function get_context3D():Context3D
	{
		return null;
	}
	public var window(get, never):Window;
	@:noCompletion private inline function get_window():Window
	{
		return Lib.application.window;
	}

	#if !flash
	public function new(window:Window, color:Null<Int> = null);
	#end
	#if air
	public function assignFocus(objectToFocus:InteractiveObject, direction:FocusDirection):Void;
	#end
	// public function invalidate():Void;
	public function isFocusInaccessible():Bool;
	#if air
	public function setAspectRatio(newAspectRatio:StageAspectRatio):Void;
	public function setOrientation(newOrientation:StageOrientation):Void;
	#end
	private function __registerLimeModule(application:LimeApplication):Void;
	private function __unregisterLimeModule(application:LimeApplication):Void;
	public function onRenderContextLost():Void;
	public function onRenderContextRestored(context:RenderContext):Void;
	public function render(context:RenderContext):Void;
	public function onGamepadAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void;
	public function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton):Void;
	public function onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton):Void;
	public function onGamepadConnect(gamepad:Gamepad):Void;
	public function onGamepadDisconnect(gamepad:Gamepad):Void;
	public function onJoystickAxisMove(joystick:Joystick, axis:Int, value:Float):Void;
	public function onJoystickButtonDown(joystick:Joystick, button:Int):Void;
	public function onJoystickButtonUp(joystick:Joystick, button:Int):Void;
	public function onJoystickConnect(joystick:Joystick):Void;
	public function onJoystickDisconnect(joystick:Joystick):Void;
	public function onJoystickHatMove(joystick:Joystick, hat:Int, position:JoystickHatPosition):Void;
	public function onJoystickTrackballMove(joystick:Joystick, trackball:Int, value:Float):Void;
	public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void;
	public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void;
	public function onModuleExit(code:Int):Void;
	public function onMouseDown(x:Float, y:Float, button:Int):Void;
	public function onMouseMove(x:Float, y:Float):Void;
	public function onMouseMoveRelative(x:Float, y:Float):Void;
	public function onMouseUp(x:Float, y:Float, button:Int):Void;
	public function onMouseWheel(deltaX:Float, deltaY:Float):Void;
	public function onPreloadComplete():Void;
	public function onPreloadProgress(loaded:Int, total:Int):Void;
	public function onTextEdit(text:String, start:Int, length:Int):Void;
	public function onTextInput(text:String):Void;
	public function onTouchMove(touch:Touch):Void;
	public function onTouchEnd(touch:Touch):Void;
	public function onTouchStart(touch:Touch):Void;
	public function onWindowActivate():Void;
	public function onWindowClose():Void;
	public function onWindowCreate():Void;
	public function onWindowDeactivate():Void;
	public function onWindowDropFile(file:String):Void;
	public function onWindowEnter():Void;
	public function onWindowFocusIn():Void;
	public function onWindowFocusOut():Void;
	public function onWindowFullscreen():Void;
	public function onWindowLeave():Void;
	public function onWindowMinimize():Void;
	public function onWindowMove(x:Float, y:Float):Void;
	public function onWindowResize(width:Int, height:Int):Void;
	public function onWindowRestore():Void;
	public function update(deltaTime:Int):Void;

	#if (haxe_ver >= 4.3)
	private function get_align():StageAlign;
	private function get_allowsFullScreen():Bool;
	private function get_allowsFullScreenInteractive():Bool;
	private function get_browserZoomFactor():Float;
	private function get_color():UInt;
	private function get_colorCorrection():ColorCorrection;
	private function get_colorCorrectionSupport():ColorCorrectionSupport;
	private function get_constructor():Dynamic;
	private function get_contentsScaleFactor():Float;
	private function get_displayContextInfo():String;
	private function get_displayState():StageDisplayState;
	private function get_focus():InteractiveObject;
	private function get_frameRate():Float;
	private function get_fullScreenHeight():UInt;
	private function get_fullScreenSourceRect():Rectangle;
	private function get_fullScreenWidth():UInt;
	private function get_mouseLock():Bool;
	private function get_quality():StageQuality;
	private function get_scaleMode():StageScaleMode;
	private function get_showDefaultContextMenu():Bool;
	private function get_softKeyboardRect():Rectangle;
	private function get_stage3Ds():Vector<Stage3D>;
	private function get_stageFocusRect():Bool;
	private function get_stageHeight():Int;
	private function get_stageVideos():Vector<flash.media.StageVideo>;
	private function get_stageWidth():Int;
	private function get_wmodeGPU():Bool;
	private function set_align(value:StageAlign):StageAlign;
	private function set_color(value:UInt):UInt;
	private function set_colorCorrection(value:ColorCorrection):ColorCorrection;
	private function set_constructor(value:Dynamic):Dynamic;
	private function set_displayState(value:StageDisplayState):StageDisplayState;
	private function set_focus(value:InteractiveObject):InteractiveObject;
	private function set_frameRate(value:Float):Float;
	private function set_fullScreenSourceRect(value:Rectangle):Rectangle;
	private function set_mouseLock(value:Bool):Bool;
	private function set_quality(value:StageQuality):StageQuality;
	private function set_scaleMode(value:StageScaleMode):StageScaleMode;
	private function set_showDefaultContextMenu(value:Bool):Bool;
	private function set_stageFocusRect(value:Bool):Bool;
	private function set_stageHeight(value:Int):Int;
	private function set_stageWidth(value:Int):Int;
	#if air
	private static function get_supportsOrientationChange():Bool;
	private function get_autoOrients():Bool;
	private function get_deviceOrientation():StageOrientation;
	private function get_nativeWindow():NativeWindow;
	private function get_orientation():StageOrientation;
	private function get_supportedOrientations():Vector<StageOrientation>;
	private function get_vsyncEnabled():Bool;
	private function set_autoOrients(value:Bool):Bool;
	private function set_vsyncEnabled(value:Bool):Bool;
	#end
	#end
	#if (mute || mute_sound)
	private static function __init__():Void
	{
		flash.media.SoundMixer.soundTransform = new flash.media.SoundTransform(0);
	}
	#end
}
#else
typedef Stage = openfl.display.Stage;
#end
