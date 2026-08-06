package openfl.xml;

#if !flash
import openfl.errors.ArgumentError;

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

	/**
		Specifies information about the XML document's `DOCTYPE` declaration.
		After the XML text has been parsed into an XMLDocument object, the
		`XMLDocument.docTypeDecl` property of the XMLDocument object is set to
		the text of the XML document's `DOCTYPE` declaration (for example,
		`<!DOCTYPE greeting SYSTEM "hello.dtd">`). This property is set using a
		string representation of the `DOCTYPE` declaration, not an XMLNode
		object.

		The legacy ActionScript XML parser is not a validating parser. The
		`DOCTYPE` declaration is read by the parser and stored in the
		`XMLDocument.docTypeDecl` property, but no DTD validation is performed.

		If no `DOCTYPE` declaration was encountered during a parse operation,
		the `XMLDocument.docTypeDecl` property is set to `null`. The
		`XML.toString()` method outputs the contents of `XML.docTypeDecl`
		immediately after the XML declaration stored in `XML.xmlDecl`, and
		before any other text in the XML object. If `XMLDocument.docTypeDecl` is
		null, no `DOCTYPE` declaration is output.
	**/
	public var docTypeDecl:Dynamic = null;

	/**
		A string that specifies information about a document's XML declaration.
		After the XML document is parsed into an XMLDocument object, this
		property is set to the text of the document's XML declaration. This
		property is set using a string representation of the XML declaration,
		not an XMLNode object. If no XML declaration is encountered during a
		parse operation, the property is set to null. The
		`XMLDocument.toString()` method outputs the contents of the
		`XML.xmlDecl` property before any other text in the XML object. If the
		`XML.xmlDecl` property contains `null`, no XML declaration is output.
	**/
	public var xmlDecl:Dynamic = null;

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
		xmlDecl = null;
		docTypeDecl = null;
		#if haxe4
		__childNodes.resize(0);
		#else
		__childNodes = [];
		#end

		for (xml in xml.iterator())
		{
			switch (xml.nodeType)
			{
				case Element:
					var elementNode = parseElement(xml);
					appendChild(elementNode);
				case PCData:
					var textNode = new XMLNode(TEXT_NODE, xml.nodeValue);
					appendChild(textNode);
				case CData:
					var textNode = new XMLNode(TEXT_NODE, xml.nodeValue);
					appendChild(textNode);
				case DocType:
					// replace any previous values
					docTypeDecl = "<!DOCTYPE " + xml.nodeValue + ">";
				case ProcessingInstruction:
					var instrValue = xml.nodeValue;
					// ignore all other processing instructions
					// they don't even appear in the result of toString()
					if (StringTools.startsWith(instrValue, "xml "))
					{
						if (xmlDecl == null)
						{
							xmlDecl = "<?" + instrValue + "?>";
						}
						else
						{
							// append to any previous values
							xmlDecl += "<?" + instrValue + "?>";
						}
					}
				case Comment:
					// ignore all comments
					// they don't even appear in the result of toString()
				default:
					throw new ArgumentError();
			}
		}
	}

	/**
		Returns a string representation of the XML object.
	**/
	override public function toString():String
	{
		var result = "";
		if (xmlDecl != null)
		{
			result += xmlDecl;
		}
		if (docTypeDecl != null)
		{
			result += docTypeDecl;
		}
		if (firstChild == null && __childNodes.length == 0)
		{
			return result + "<>";
		}
		for (xmlNode in __childNodes)
		{
			result += xmlNode.toString();
		}
		if (firstChild == null)
		{
			return result + "<>";
		}
		return result;
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
