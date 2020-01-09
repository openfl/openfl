package openfl._internal.backend.dummy;

import openfl.display3D.Context3D;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyShaderBackend
{
	public function new(parent:Shader) {}

	public function init(context3D:Context3D = null):Void {}

	public function update():Void {}
}
