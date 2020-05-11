package openfl.system;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Security
{
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	public static var sandboxType:String;

	public static function allowDomain(p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Void {}

	public static function allowInsecureDomain(p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Void {}

	public static function loadPolicyFile(url:String):Void
	{
		// var res = haxe.Http.requestUrl( url );
	}
}
