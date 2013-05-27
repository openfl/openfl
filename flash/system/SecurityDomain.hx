package flash.system;

extern class SecurityDomain {
	#if !display
	@:require(flash11_3) var domainID(default,null) : String;
	#end
	static var currentDomain(default,null) : SecurityDomain;
}
