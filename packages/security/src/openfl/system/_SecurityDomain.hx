package openfl.system;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _SecurityDomain
{
	public static var currentDomain = new SecurityDomain();

	private var securityDomain:SecurityDomain;

	public function new(securityDomain:SecurityDomain)
	{
		this.securityDomain = securityDomain;
	}
}
