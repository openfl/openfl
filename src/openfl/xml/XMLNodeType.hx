package openfl.xml;

#if !flash
/**
	The XMLNodeType enum contains constants used with `XMLNode.nodeType`. The
	values are defined by the NodeType enumeration in the W3C DOM Level 1
	recommendation: https://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html

	**Warning!** These legacy `openfl.xml` classes should be avoided in new
	OpenFL projects. Developers should prefer Haxe's `Xml` class to parse and
	generate XML data. The classes in the `openfl.xml` package are provided as a
	convenience to assist developers porting legacy code from either
	ActionScript 2.0 or ActionScript 3.0 to OpenFL and Haxe.

	@see `flash.xml.XMLNode.nodeType`
	@see [Haxe Manual: Getting started with Xml](https://haxe.org/manual/std-Xml-getting-started.html)
	@see https://api.haxe.org/Xml.html
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract XMLNodeType(Null<UInt>)
{
	/**
		Specifies that the node is an element. This constant is used with
		`XMLNode.nodeType`. The value is defined by the NodeType enumeration in
		the W3C DOM Level 1 recommendation:
		https://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html
	**/
	public var ELEMENT_NODE = 1;

	/**
		Specifies that the node is a text node. This constant is used with
		`XMLNode.nodeType`. The value is defined by the NodeType enumeration in
		the W3C DOM Level 1 recommendation:
		https://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html
	**/
	public var TEXT_NODE = 3;
}
#else
typedef XMLNodeType = flash.xml.XMLNodeType;
#end
