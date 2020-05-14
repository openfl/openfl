package openfl.system;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _LoaderContext
{
	public var allowCodeImport:Bool;
	public var allowLoadBytesCodeExecution:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;
	public var securityDomain:SecurityDomain;

	private var loaderContext:LoaderContext;

	public function new(loaderContext:LoaderContext, checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null,
			securityDomain:SecurityDomain = null):Void
	{
		this.loaderContext = loaderContext;

		this.checkPolicyFile = checkPolicyFile;
		this.securityDomain = securityDomain;
		this.applicationDomain = applicationDomain;

		allowCodeImport = true;
		allowLoadBytesCodeExecution = true;
	}
}
