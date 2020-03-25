/**
		The SecurityDomain class represents the current security "sandbox," also
		known as a security domain. By passing an instance of this class to
		`Loader.load()`, you can request that loaded media be placed in a
		particular sandbox.
	**/
export default class SecurityDomain
{
	/**
		Gets the current security domain.
	**/
	public static currentDomain(default , null) = new SecurityDomain();

		// /** @hidden */ @:dox(hide) @:require(flash11_3) public domainID (default, null):String;
		protected constructor() { }
}
