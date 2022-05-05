package openfl.utils;

#if !flash
/**
	The Namespace class contains methods and properties for defining and working
	with namespaces. There are three scenarios for using namespaces:
	- Namespaces of XML objects Namespaces associate a namespace prefix with a
	Uniform Resource Identifier (URI) that identifies the namespace. The prefix
	is a string used to reference the namespace within an XML object. If the
	prefix is undefined, when the XML is converted to a string, a prefix is
	automatically generated.
	- Namespace to differentiate methods Namespaces can differentiate methods
	with the same name to perform different tasks. If two methods have the same
	name but separate namespaces, they can perform different tasks.
	- Namespaces for access control Namespaces can be used to control access to
	a group of properties and methods in a class. If you place the properties
	and methods into a private namespace, they are inaccessible to any code that
	does not have access to that namespace. You can grant access to the group of
	properties and methods by passing the namespace to other classes, methods or
	functions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Namespace
{
	/**
		The prefix of the namespace.
	**/
	public var prefix(get, never):String;

	/**
		The Uniform Resource Identifier (URI) of the namespace.
	**/
	public var uri(get, never):String;

	@:noCompletion private var __prefix:String;
	@:noCompletion private var __uri:String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(QName.prototype, {
			"uri": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_uri (); }")
			},
			"prefix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_prefix (); }")
			}
		});
	}
	#end

	/**
		Creates a Namespace object. The values assigned to the uri and prefix
		properties of the new Namespace object depend on the type of value
		passed for the `prefixValue` and `uriValue` parameters.

		If two parameters are passed, the value of the prefixValue parameter is
		assigned to the prefix property as follows:

		- If undefined is passed, prefix is set to undefined.
		- If the value is a valid XML name, as determined by the isXMLName() function, it is converted to a string and assigned to the prefix property.
		- If the value is not a valid XML name, the prefix property is set to undefined.

		If **two parameters** are passed, the value of the uriValue parameter is
		assigned to the uri property as follows:

		- If a QName object is passed, the uri property is set to the value of
		the QName object's uri property.
		- Otherwise, the uriValue parameter is converted to a string and
		assigned to the uri property.

		If **one parameter** is passed, the value is assigned to the uri and
		prefix properties of the new Namespace object depending on the type of
		the value:

		- If no value is passed, the prefix and uri properties are set to an
		empty string.
		- If the value is a Namespace object, a copy of the object is created.
		- If the value is a QName object, the uri property is set to the uri
		property of the QName object.
	**/
	public function new(?prefixValue:Dynamic, ?uriValue:Dynamic):Void
	{
		if (prefixValue == null && uriValue == null)
		{
			__prefix = "";
			__uri = "";
		}
		else if (prefixValue != null && uriValue == null)
		{
			if ((prefixValue is Namespace))
			{
				var ns = cast(prefixValue, Namespace);
				__prefix = ns.prefix;
				__uri = ns.uri;
			}
			else if ((prefixValue is QName))
			{
				var qname = cast(prefixValue, QName);
				__prefix = null;
				__uri = qname.uri;
			}
			else
			{
				__prefix = null;
				__uri = Std.string(prefixValue);
			}
		}
		else
		{
			if (prefixValue == null)
			{
				__prefix = null;
			}
			else
			{
				__prefix = Std.string(prefixValue);
				if (__prefix.length > 0 && !Lib.isXMLName(__prefix))
				{
					__prefix = null;
				}
			}
			if ((uriValue is QName))
			{
				var qname = cast(uriValue, QName);
				__uri = qname.uri;
			}
			else
			{
				__uri = Std.string(uriValue);
			}
		}
	}

	// Getters & Setters
	@:noCompletion private function get_uri():String
	{
		return __uri;
	}

	@:noCompletion private function get_prefix():String
	{
		return __prefix;
	}
}
#else
typedef Namespace = flash.utils.Namespace;
#end
