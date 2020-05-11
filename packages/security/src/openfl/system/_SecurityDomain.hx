package openfl.system;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _SecurityDomain
{
	public static var currentDomain = new SecurityDomain();

	public function new() {}
}
