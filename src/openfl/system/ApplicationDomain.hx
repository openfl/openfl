package openfl.system;

#if !flash
/**
	The ApplicationDomain class is a container for discrete groups of class
	definitions. Application domains are used to partition classes that are in
	the same security domain. They allow multiple definitions of the same
	class to exist and allow children to reuse parent definitions.
	Application domains are used when an external SWF file is loaded through
	the Loader class. All ActionScript 3.0 definitions in the loaded SWF file
	are stored in the application domain, which is specified by the
	`applicationDomain` property of the LoaderContext object that you pass as
	a `context` parameter of the Loader object's `load()` or `loadBytes()`
	method. The LoaderInfo object also contains an `applicationDomain`
	property, which is read-only.

	All code in a SWF file is defined to exist in an application domain. The
	current application domain is where your main application runs. The system
	domain contains all application domains, including the current domain,
	which means that it contains all Flash Player classes.

	Every application domain, except the system domain, has an associated
	parent domain. The parent domain of your main application's application
	domain is the system domain. Loaded classes are defined only when their
	parent doesn't already define them. You cannot override a loaded class
	definition with a newer definition.

	For usage examples of application domains, see the _ActionScript 3.0
	Developer's Guide_.

	The `ApplicationDomain()` constructor function allows you to create an
	ApplicationDomain object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class ApplicationDomain
{
	#if false
	/**
		Gets the minimum memory object length required to be used as
		ApplicationDomain.domainMemory.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
	#end

	/**
		Gets the current application domain in which your code is executing.
	**/
	public static var currentDomain(default, null) = new ApplicationDomain(null);

	#if false
	/**
		Gets and sets the object on which domain-global memory operations will
		operate within this ApplicationDomain.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
	#end

	/**
		Gets the parent domain of this application domain.
	**/
	public var parentDomain(default, null):ApplicationDomain;

	/**
		Creates a new application domain.

		@param parentDomain If no parent domain is passed in, this application
							domain takes the system domain as its parent.
	**/
	public function new(parentDomain:ApplicationDomain = null)
	{
		if (parentDomain != null)
		{
			this.parentDomain = parentDomain;
		}
		else
		{
			this.parentDomain = currentDomain;
		}
	}

	/**
		Gets a public definition from the specified application domain. The
		definition can be that of a class, a namespace, or a function.

		@param name The name of the definition.
		@return The object associated with the definition.
		@throws ReferenceError No public definition exists with the specified
							   name.
	**/
	public function getDefinition(name:String):Class<Dynamic>
	{
		return Type.resolveClass(name);
	}

	// @:noCompletion @:dox(hide) @:require(flash11_3) function getQualifiedDefinitionNames() : openfl.Vector<String>;

	/**
		Checks to see if a public definition exists within the specified
		application domain. The definition can be that of a class, a
		namespace, or a function.

		@param name The name of the definition.
		@return A value of `true` if the specified definition exists;
				otherwise, `false`.
	**/
	public function hasDefinition(name:String):Bool
	{
		return (Type.resolveClass(name) != null);
	}
}
#else
typedef ApplicationDomain = flash.system.ApplicationDomain;
#end
