package openfl.text;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class StageTextInitOptions
{
	/**
		Specifies whether the StageText object displays multiple lines of text.
	**/
	public var multiline:Bool;

	/**
		Creates a StageTextInitOptions object.

		@param	multiline		set to `true` to create multiline StageText objects
	**/
	public function new(multiline:Bool = false) {}
}
