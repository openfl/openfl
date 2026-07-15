package openfl.xml;

import openfl.errors.ArgumentError;

#if !flash
/**
	The XMLDocument class represents the legacy XML object that was present in
	ActionScript 2.0. It was renamed in ActionScript 3.0 to XMLDocument to avoid
	name conflicts with the new XML class in ActionScript 3.0. In Haxe, it is
	recommmended that you use the `Xml` class.

	**Warning!** These legacy `openfl.xml` classes should be avoided in new
	OpenFL projects. Developers should prefer Haxe's `Xml` class to parse and
	generate XML data. The classes in the `openfl.xml` package are provided as a
	convenience to assist developers porting legacy code from either
	ActionScript 2.0 or ActionScript 3.0 to OpenFL and Haxe.

	@see [Haxe Manual: Getting started with Xml](https://haxe.org/manual/std-Xml-getting-started.html)
	@see https://api.haxe.org/Xml.html
**/
class XMLDocument extends XMLNode
{
	/**
		An Object containing the nodes of the XML that have an `id` attribute
		assigned. The names of the properties of the object (each containing a
		node) match the values of the `id` attributes.

		If there is more than one XMLNode with the same id value, the matching
		property of the `idNode` object is that of the last node parsed.
	**/
	public var idMap:Dynamic = {};

	/**
		When set to `true`, text nodes that contain only white space are
		discarded during the parsing process. Text nodes with leading or
		trailing white space are unaffected. The default setting is `false`.

		You can set the `ignoreWhite` property for individual XMLDocument
		objects, as the following code shows:

		```haxe
		my_xml.ignoreWhite = true;
		```
	**/
	public var ignoreWhite:Bool = false;

	// public var docTypeDecl:Dynamic = null;
	// public var xmlDecl:Dynamic = null;

	/**
		Creates a new XMLDocument object. You must use the constructor to create
		an XMLDocument object before you call any of the methods of the
		XMLDocument class.

		Note: Use the `createElement()` and `createTextNode()` methods to add
		elements and text nodes to an XML document tree.
	**/
	public function new(source:String = null)
	{
		super(ELEMENT_NODE, null);
		if (source != null)
		{
			parseXML(source);
		}
	}

	/**
		Creates a new XMLNode object with the name specified in the parameter.
		The new node initially has no parent, no children, and no siblings. Th
		method returns a reference to the newly created XMLNode object that
		represents the element. This method and the
		`XMLDocument.createTextNode()` method are the constructor methods for
		creating nodes for an XMLDocument object.
	**/
	public function createElement(name:String):XMLNode
	{
		return new XMLNode(ELEMENT_NODE, name);
	}

	/**
		Creates a new XML text node with the specified text. The new node
		initially has no parent, and text nodes cannot have children or
		siblings. This method returns a reference to the XMLDocument object that
		represents the new text node. This method and the
		`XMLDocument.createElement()` method are the constructor methods for
		creating nodes for an XMLDocument object.
	**/
	public function createTextNode(text:String):XMLNode
	{
		return new XMLNode(TEXT_NODE, text);
	}

	/**
		Parses the XML text specified in the value parameter and populates the
		specified XMLDocument object with the resulting XML tree. Any existing
		trees in the XMLDocument object are discarded.
	**/
	public function parseXML(source:String):Void
	{
		var xml = Xml.parse(source);

		idMap = {};
		firstChild = null;
		lastChild = null;
		previousSibling = null;
		nextSibling = null;
		parentNode = null;
		#if haxe4
		__childNodes.resize(0);
		#else
		__childNodes = [];
		#end

		xml = xml.firstChild();
		switch (xml.nodeType)
		{
			case Element:
				var elementNode = parseElement(xml);
				appendChild(elementNode);
			case PCData:
				var textNode = new XMLNode(TEXT_NODE, xml.nodeValue);
				appendChild(textNode);
			default:
				throw new ArgumentError();
		}
	}

	/**
		Returns a string representation of the XML object.
	**/
	override public function toString():String
	{
		if (firstChild == null)
		{
			return "<>";
		}
		return firstChild.toString();
	}

	@:noCompletion private function parseElement(element:Xml):XMLNode
	{
		var elementNode = createElement(element.nodeName);
		for (attribute in element.attributes())
		{
			var value = element.get(attribute);
			if (attribute == "id")
			{
				Reflect.setField(idMap, value, elementNode);
			}
			Reflect.setField(elementNode.attributes, attribute, value);
		}
		var prevSibling:XMLNode = null;
		for (child in element.iterator())
		{
			var childNode:XMLNode = null;
			switch (child.nodeType)
			{
				case Element:
					childNode = parseElement(child);
				case PCData:
					var text = child.nodeValue;
					if (!ignoreWhite || !~/^\s+$/.match(text))
					{
						childNode = createTextNode(text);
					}
				default:
					// ignore all other children
			}
			if (childNode != null)
			{
				elementNode.appendChild(childNode);
			}
		}
		return elementNode;
	}
}
#else
typedef XMLDocument = flash.xml.XMLDocument;
#end
