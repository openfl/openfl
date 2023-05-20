package openfl.utils;

#if !flash
/**
	QName objects represent qualified names of XML elements and attributes. Each
	QName object has a local name and a namespace Uniform Resource Identifier
	(URI). When the value of the namespace URI is `null`, the QName object
	matches any namespace. Use the QName constructor to create a new QName
	object that is either a copy of another QName object or a new QName object
	with a `uri` from a `Namespace` object and a `localName` from a QName
	object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class QName
{
	/**
		The Uniform Resource Identifier (URI) of the QName object.
	**/
	public var uri(get, never):String;

	/**
		The local name of the QName object.
	**/
	public var localName(get, never):String;

	@:noCompletion private var __uri:String;
	@:noCompletion private var __localName:String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped global.Object.defineProperties(QName.prototype, {
			"uri": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_uri (); }")
			},
			"localName": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_localName (); }")
			}
		});
	}
	#end

	/**
		Creates a QName object. The values assigned to the uri and localName
		properties of the new QName object depend on the type of value
		passed for the `namespace` and `name` parameters.

		If **two parameters** are passed, creates a QName object with a URI from
		a Namespace object and a localName from a QName object. If either
		parameter is not the expected data type, the parameter is converted to a
		string and assigned to the corresponding property of the new QName
		object. For example, if both parameters are strings, a new QName object
		is returned with a uri property set to the first parameter and a
		localName property set to the second parameter. In other words, the
		following permutations, along with many others, are valid forms of the
		constructor:

		- QName (uri:Namespace, localName:String);
		- QName (uri:String, localName: QName);
		- QName (uri:String, localName: String);

		If you pass null for the uri parameter, the uri property of the new
		QName object is set to null.

		If **one parameter** is passed, creates a QName object that is a copy of
		another QName object. If the parameter passed to the constructor is a
		QName object, a copy of the QName object is created. If the parameter is
		not a QName object, the parameter is converted to a string and assigned
		to the localName property of the new QName instance. If the parameter is
		undefined or unspecified, a new QName object is created with the
		localName property set to the empty string.
	**/
	public function new(?namespace:Dynamic, ?name:Dynamic):Void
	{
		if (namespace == null && name == null)
		{
			__uri = "";
			__localName = "";
		}
		else if (namespace != null && name == null)
		{
			if ((namespace is QName))
			{
				var other = cast(namespace, QName);
				__uri = other.uri;
				__localName = other.localName;
			}
			else
			{
				__uri = "";
				__localName = Std.string(namespace);
			}
		}
		else
		{
			if ((namespace is Namespace))
			{
				__uri = cast(namespace, Namespace).uri;
			}
			else if (namespace != null)
			{
				__uri = Std.string(namespace);
			}
			else
			{
				__uri = null;
			}
			if ((name is QName))
			{
				__localName = cast(name, QName).localName;
			}
			else
			{
				__localName = Std.string(name);
			}
		}
	}

	// Getters & Setters
	@:noCompletion private function get_uri():String
	{
		return __uri;
	}

	@:noCompletion private function get_localName():String
	{
		return __localName;
	}
}
#else
typedef QName = flash.utils.QName;
#end
