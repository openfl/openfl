package flash.ui;

#if flash
import openfl.utils.ByteArray;

@:require(flash11_8)
@:final extern class GameInputDevice
{
	#if (haxe_ver < 4.3)
	public static var MAX_BUFFER_SIZE(default, never):Int;
	public var enabled:Bool;
	public var id(default, never):String;
	public var name(default, never):String;
	public var numControls(default, never):Int;
	public var sampleInterval:Int;
	#else
	static final MAX_BUFFER_SIZE:Int;
	@:flash.property var enabled(get, set):Bool;
	@:flash.property var id(get, never):String;
	@:flash.property var name(get, never):String;
	@:flash.property var numControls(get, never):Int;
	@:flash.property var sampleInterval(get, set):Int;
	#end
	public function getCachedSamples(data:ByteArray, append:Bool = false):Int;
	public function getControlAt(i:Int):GameInputControl;
	public function startCachingSamples(numSamples:Int, controls:Vector<String>):Void;
	public function stopCachingSamples():Void;

	#if (haxe_ver >= 4.3)
	private function get_enabled():Bool;
	private function get_id():String;
	private function get_name():String;
	private function get_numControls():Int;
	private function get_sampleInterval():Int;
	private function set_enabled(value:Bool):Bool;
	private function set_sampleInterval(value:Int):Int;
	#end
}
#else
typedef GameInputDevice = openfl.ui.GameInputDevice;
#end
