/**
	The SecurityDomain class represents the current security "sandbox," also
	known as a security domain. By passing an instance of this class to
	`Loader.load()`, you can request that loaded media be placed in a
	particular sandbox.
**/
export default class SecurityDomain
{
	protected static __currentDomain: SecurityDomain = new SecurityDomain();

	// /** @hidden */ @:dox(hide) @:require(flash11_3) public domainID (default, null):String;
	protected constructor() { }

	// Get & Set Methods

	/**
		Gets the current security domain.
	**/
	public static get currentDomain(): SecurityDomain
	{
		return SecurityDomain.__currentDomain;
	}
}
