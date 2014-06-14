package openfl.system; #if !flash


class LoaderContext {
	
	
	public var allowCodeImport:Bool;
	public var allowLoadBytesCodeExecution:Bool;
	public var applicationDomain:ApplicationDomain;
	public var checkPolicyFile:Bool;
	public var securityDomain:SecurityDomain;
	
	
	public function new (checkPolicyFile:Bool = false, applicationDomain:ApplicationDomain = null, securityDomain:SecurityDomain = null):Void {
		
		this.checkPolicyFile = checkPolicyFile;
		this.securityDomain = securityDomain;
		this.applicationDomain = applicationDomain;
		
		allowCodeImport = true;
		allowLoadBytesCodeExecution = true;
		
	}
	
	
}


#else
typedef LoaderContext = flash.system.LoaderContext;
#end