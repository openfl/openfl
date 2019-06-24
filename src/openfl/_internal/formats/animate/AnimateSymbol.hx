package openfl._internal.formats.animate;

import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:keepSub class AnimateSymbol
{
	public var className:String;
	public var id:Int;

	public function new() {}

	private function __createObject(library:AnimateLibrary):DisplayObject
	{
		return null;
	}

	private function __initObject(library:AnimateLibrary, instance:DisplayObject):Void {}
}
