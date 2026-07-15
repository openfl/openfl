package openfl.xml;

import openfl.errors.TypeError;

#if !flash
/**
	The XMLNode class represents the legacy XML object that was present in
	ActionScript 2.0 and that was renamed in ActionScript 3.0. In Haxe, consider
	consider using the top-level `Xml` class and related classes instead. The
	XMLNode class is present for backward compatibility.

	**Warning!** These legacy `openfl.xml` classes should be avoided in new
	OpenFL projects. Developers should prefer Haxe's `Xml` class to parse and
	generate XML data. The classes in the `openfl.xml` package are provided as a
	convenience to assist developers porting legacy code from either
	ActionScript 2.0 or ActionScript 3.0 to OpenFL and Haxe.

	@see [Haxe Manual: Getting started with Xml](https://haxe.org/manual/std-Xml-getting-started.html)
	@see https://api.haxe.org/Xml.html
**/
class XMLNode
{
	/**
		Creates a new XMLNode object. You must use the constructor to create an
		XMLNode object before you call any of the methods of the XMLNode class.

		Note: Use the `createElement()` and `createTextNode()` methods to add
		elements and text nodes to an XML document tree.
	**/
	public function new(type:XMLNodeType, value:String)
	{
		nodeType = type;
		switch (type)
		{
			case XMLNodeType.ELEMENT_NODE:
				nodeName = value;
				nodeValue = null;

				if (nodeName != null)
				{
					var nameParts = nodeName.split(":");
					__localName = nameParts.length == 2 ? nameParts[1] : nodeName;
					__prefix = nameParts.length == 2 ? nameParts[0] : "";
				}
			default:
				nodeName = null;
				nodeValue = value;
		}

		__childNodes = [];
		__attributes = {};
	}

	@:noCompletion private var __localName:String;

	/**
		The local name portion of the XML node's name. This is the element name
		without the namespace prefix. For example, the node
		`<contact:mailbox/>bob@example.com</contact:mailbox>` has the local name
		"mailbox", and the prefix "contact", which comprise the full element
		name "contact.mailbox".

		You can access the namespace prefix through the `prefix` property of the
		XML node object. The `nodeName` property returns the full name
		(including the prefix and the local name).
	**/
	public var localName(get, never):String;

	@:noCompletion private function get_localName():String
	{
		return __localName;
	}

	/**
		If the XML node has a prefix, `namespaceURI` is the value of the `xmlns`
		declaration for that prefix (the URI), which is typically called the
		namespace URI. The `xmlns` declaration is in the current node or in a
		node higher in the XML hierarchy.

		If the XML node does not have a prefix, the value of the `namespaceURI`
		property depends on whether there is a default namespace defined (as in
		`xmlns="http://www.example.com/"`). If there is a default namespace, the
		value of the `namespaceURI` property is the value of the default
		namespace. If there is no default namespace, the `namespaceURI` property
		for that node is an empty string ("").

		You can use the `getNamespaceForPrefix()` method to identify the
		namespace associated with a specific prefix. The `namespaceURI` property
		returns the prefix associated with the node name.
	**/
	public var namespaceURI(get, never):String;

	@:noCompletion private function get_namespaceURI():String
	{
		if (__prefix == null)
		{
			return null;
		}
		return getNamespaceForPrefix(__prefix);
	}

	@:noCompletion private var __prefix:String;

	/**
		The prefix portion of the XML node name. For example, the node
		`<contact:mailbox/>bob@example.com</contact:mailbox>` prefix "contact"
		and the local name "mailbox", which comprise the full element name
		"contact.mailbox".

		The `nodeName` property of an XML node object returns the full name
		(including the prefix and the local name). You can access the local name
		portion of the element's name via the `localName` property.
	**/
	public var prefix(get, never):String;

	@:noCompletion private function get_prefix():String
	{
		return __prefix;
	}

	@:noCompletion private var __attributes:Dynamic;

	/**
		An object containing all of the attributes of the specified XMLNode
		instance. The `XMLNode.attributes` object contains one variable for each
		attribute of the XMLNode instance. Because these variables are defined
		as part of the object, they are generally referred to as properties of
		the object. The value of each attribute is stored in the corresponding
		property as a string. For example, if you have an attribute named
		`color`, you would retrieve that attribute's value by specifying `color`
		as the property name, as the following code shows:

		```haxe
		var myColor:String = doc.firstChild.attributes.color;
		```

	**/
	public var attributes(get, set):Dynamic;

	@:noCompletion private function get_attributes():Dynamic
	{
		return __attributes;
	}

	@:noCompletion public function set_attributes(value:Dynamic):Dynamic
	{
		return __attributes = value;
	}

	private var __childNodes:Array<XMLNode>;

	/**
		An array of the specified XMLNode object's children. Each element in th
		array is a reference to an XMLNode object that represents a child node.
		This is a read-only property and cannot be used to manipulate child
		nodes. Use the `appendChild()`, `insertBefore()`, and `removeNode()`
		methods to manipulate child nodes.

		This property is undefined for text nodes (`nodeType == 3`).
	**/
	public var childNodes(get, never):Array<XMLNode>;

	@:noCompletion private function get_childNodes():Array<XMLNode>
	{
		var current = firstChild;
		var i = 0;
		var len = __childNodes.length;
		while (current != null)
		{
			if (i >= len)
			{
				__childNodes.push(current);
				len++;
			}
			current = current.nextSibling;
			i++;
		}
		return __childNodes;
	}

	/**
		Evaluates the specified XMLDocument object and references the first
		child in the parent node's child list. This property is `null` if the
		node does not have children or is a text node. This is a read-only
		property and cannot be used to manipulate child nodes; use the
		`appendChild()`, `insertBefore()`, and `removeNode()` methods to
		manipulate child nodes.
	**/
	public var firstChild:XMLNode;

	/**
		An XMLNode value that references the last child in the node's child
		list. The `XMLNode.lastChild` property is `null` if the node does not
		have children. This property cannot be used to manipulate child nodes;
		use the `appendChild()`, `insertBefore()`, and `removeNode()` methods to
		manipulate child nodes.
	**/
	public var lastChild:XMLNode;

	/**
		An XMLNode value that references the previous sibling in the parent
		node's child list. The property has a value of `null` if the node does
		not have a previous sibling node. This property cannot be used to
		manipulate child nodes; use the `appendChild()`, `insertBefore()`, and
		`removeNode()` methods to manipulate child nodes.
	**/
	public var previousSibling:XMLNode;

	/**
		An XMLNode value that references the next sibling in the parent node's
		child list. This property is `null` if the node does not have a next
		sibling node. This property cannot be used to manipulate child nodes;
		use the `appendChild()`, `insertBefore()`, and `removeNode()` methods to
		manipulate child nodes.
	**/
	public var nextSibling:XMLNode;

	/**
		A string representing the node name of the XMLNode object. If the
		XMLNode object is an XML element (`nodeType == 1`), `nodeName` is the
		name of the tag that represents the node in the XML file. For example,
		`TITLE` is the `nodeName` of an HTML `TITLE` tag. If the XMLNode object
		is a text node (`nodeType == 3`), `nodeName` is `null`.
	**/
	public var nodeName:String;

	/**
		A `nodeType` constant value, either `XMLNodeType.ELEMENT_NODE` for an
		XML element or `XMLNodeType.TEXT_NODE` for a text node.

		The `nodeType` is a numeric value from the NodeType enumeration in the
		W3C DOM Level 1 recommendation:
		https://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html.

		The following table lists the values:

		| Integer value | Defined constant            |
		| ------------- | --------------------------- |
		| 1             | ELEMENT_NODE                |
		| 2             | ATTRIBUTE_NODE              |
		| 3             | TEXT_NODE                   |
		| 4             | CDATA_SECTION_NODE          |
		| 5             | ENTITY_REFERENCE_NODE       |
		| 6             | ENTITY_NODE                 |
		| 7             | PROCESSING_INSTRUCTION_NODE |
		| 8             | COMMENT_NODE                |
		| 9             | DOCUMENT_NODE               |
		| 10            | DOCUMENT_TYPE_NODE          |
		| 11            | DOCUMENT_FRAGMENT_NODE      |
		| 12            | NOTATION_NODE               |

		In OpenFL, the XMLNode class only supports `XMLNodeType.ELEMENT_NODE`
		and `XMLNodeType.TEXT_NODE`.
	**/
	public var nodeType:XMLNodeType;

	/**
		The node value of the XMLDocument object. If the XMLDocument object is a
		text node, the `nodeType` is `3`, and the `nodeValue` is the text of the
		node. If the XMLDocument object is an XML element (`nodeType` is `1`),
		`nodeValue` is `null` and read-only.
	**/
	public var nodeValue:String;

	/**
		An XMLNode value that references the parent node of the specified XML
		object, or returns `null` if the node has no parent. This is a read-only
		property and cannot be used to manipulate child nodes; use the
		appendChild()`, `insertBefore()`, and `removeNode()` methods to
		manipulate child nodes.
	**/
	public var parentNode:XMLNode;

	/**
		Returns the namespace URI that is associated with the specified prefix
		for the node. To determine the URI, `getPrefixForNamespace()` searches
			up the XML hierarchy from the node, as necessary, and returns the
		namespace URI of the first `xmlns` declaration for the given `prefix`.

		If no namespace is defined for the specified prefix, the method returns
		`null`.

		If you specify an empty string (`""`) as the prefix and there is a
		default namespace defined for the node (as in
		`xmlns="http://www.example.com/"`), the method returns that default
		namespace URI.
	**/
	public function getNamespaceForPrefix(prefix:String):String
	{
		if (prefix == null)
		{
			throw new TypeError();
		}
		for (key in Reflect.fields(attributes))
		{
			if (prefix.length == 0 && key == "xmlns")
			{
				return Std.string(Reflect.field(attributes, key));
			}
			if (StringTools.startsWith(key, "xmlns:"))
			{
				var currentPrefix = key.substr(6);
				if (prefix == currentPrefix)
				{
					return Std.string(Reflect.field(attributes, key));
				}
			}
		}
		if (parentNode != null)
		{
			return parentNode.getNamespaceForPrefix(prefix);
		}
		return null;
	}

	/**
		Returns the prefix that is associated with the specified namespace URI
		for the node. To determine the prefix, `getPrefixForNamespace()`
		searches up the XML hierarchy from the node, as necessary, and returns
		the prefix of the first `xmlns` declaration with a namespace URI that
		matches `ns`.

		If there is no `xmlns` assignment for the given URI, the method returns
		`null`. If there is an `xmlns` assignment for the given URI but no
		prefix is associated with the assignment, the method returns an empty
		string (`""`).
	**/
	public function getPrefixForNamespace(ns:String):String
	{
		if (ns == null)
		{
			return null;
		}
		for (key in Reflect.fields(attributes))
		{
			if (key == "xmlns")
			{
				var currentNs:String = Reflect.field(attributes, key);
				if (currentNs == ns)
				{
					return "";
				}
			}
			if (StringTools.startsWith(key, "xmlns:"))
			{
				var currentNs:String = Reflect.field(attributes, key);
				if (currentNs == ns)
				{
					return key.substr(6);
				}
			}
		}
		if (parentNode != null)
		{
			return parentNode.getPrefixForNamespace(ns);
		}
		return null;
	}

	/**
		Inserts a new child node into the XML object's child list, before the
		`beforeNode` node. If the `beforeNode` parameter is `null`, the node is
		added using the `appendChild()` method. If `beforeNode` is not a child
		of `my_xml`, the insertion fails.
	**/
	public function insertBefore(node:XMLNode, before:XMLNode):Void
	{
		if (before == null)
		{
			appendChild(node);
			return;
		}

		if (node.parentNode != null)
		{
			node.removeNode();
		}

		var current = firstChild;
		while (current != null)
		{
			if (current == before)
			{
				node.parentNode = this;
				if (firstChild == before)
				{
					firstChild = node;
				}
				if (lastChild == null)
				{
					lastChild = node;
				}
				node.previousSibling = before.previousSibling;
				before.previousSibling = node;
				node.nextSibling = before;
				var index = __childNodes.indexOf(before);
				if (index != -1)
				{
					__childNodes.insert(index, node);
				}
				break;
			}
			current = current.nextSibling;
		}
	}

	/**
		Appends the specified node to the XML object's child list. This method
		operates directly on the node referenced by the `childNode` parameter;
		it does not append a copy of the node. If the node to be appended
		already exists in another tree structure, appending the node to the new
		location will remove it from its current location. If the `childNode`
		parameter refers to a node that already exists in another XML tree
		structure, the appended child node is placed in the new tree structure
		after it is removed from its existing parent node.
	**/
	public function appendChild(node:XMLNode):Void
	{
		if (node.parentNode != null)
		{
			node.removeNode();
		}

		node.parentNode = this;
		node.previousSibling = lastChild;
		node.nextSibling = null;
		if (firstChild == null)
		{
			firstChild = node;
		}
		if (lastChild != null)
		{
			lastChild.nextSibling = node;
		}
		lastChild = node;
		__childNodes.push(node);
	}

	/**
		Indicates whether the specified XMLNode object has child nodes. This
		property is `true` if the specified XMLNode object has child nodes;
		otherwise, it is `false`.
	**/
	public function hasChildNodes():Bool
	{
		return firstChild != null;
	}

	/**
		Removes the specified XML object from its parent. Also deletes all descendants of the node.
	**/
	public function removeNode():Void
	{
		if (parentNode == null)
		{
			return;
		}
		var current = parentNode.firstChild;
		while (current != null)
		{
			if (current == this)
			{
				var index = parentNode.__childNodes.indexOf(this);
				parentNode.__childNodes.splice(index, 1);
				if (previousSibling != null)
				{
					previousSibling.nextSibling = nextSibling;
				}
				if (nextSibling != null)
				{
					nextSibling.previousSibling = previousSibling;
				}
				if (parentNode.firstChild == this)
				{
					parentNode.firstChild = nextSibling;
				}
				if (parentNode.lastChild == this)
				{
					parentNode.lastChild = previousSibling;
				}
				previousSibling = null;
				nextSibling = null;
				parentNode = null;
				break;
			}
			current = current.nextSibling;
		}
	}

	/**
		Constructs and returns a new XML node of the same type, name, value, and
		attributes as the specified XML object. If `deep` is set to `true`, all
		child nodes are recursively cloned, resulting in an exact copy of the
		original object's document tree.

		The clone of the node that is returned is no longer associated with the
		tree of the cloned item. Consequently, `nextSibling`, `parentNode`, and
		`previousSibling` all have a value of `null`. If the `deep` parameter is
		set to `false`, or the `my_xml` node has no child nodes, `firstChild`
		and `lastChild` are also `null`.
	**/
	public function cloneNode(deep:Bool):XMLNode
	{
		var clonedNode:XMLNode = null;
		switch (nodeType)
		{
			case XMLNodeType.ELEMENT_NODE:
				clonedNode = new XMLNode(nodeType, nodeName);
			default:
				clonedNode = new XMLNode(nodeType, nodeValue);
		}
		for (key in Reflect.fields(__attributes))
		{
			Reflect.setField(clonedNode.__attributes, key, Reflect.field(__attributes, key));
		}
		if (deep)
		{
			var current = firstChild;
			while (current != null)
			{
				var clonedChild = current.cloneNode(deep);
				clonedNode.appendChild(clonedChild);
				current = current.nextSibling;
			}
		}
		return clonedNode;
	}

	/**
		Evaluates the specified XMLNode object, constructs a textual
		epresentation of the XML structure, including the node, children, and
		attributes, and returns the result as a string.

		For top-level XMLDocument objects (those created with the constructor),
		the `XMLDocument.toString()` method outputs the document's XML
		declaration (stored in the `XMLDocument.xmlDecl` property), followed by
		the document's `DOCTYPE` declaration (stored in the
		`XMLDocument.docTypeDecl` property), followed by the text representation
		of all XML nodes in the object. The XML declaration is not output if the
		`XMLDocument.xmlDecl` property is `null`. The `DOCTYPE` declaration is
		not output if the `XMLDocument.docTypeDecl` property is `null`.
	**/
	public function toString():String
	{
		switch (nodeType)
		{
			case XMLNodeType.ELEMENT_NODE:
				if (nodeName == null)
				{
					return "";
				}
				var attributes:String = "";
				for (key in Reflect.fields(__attributes))
				{
					var value:String = Reflect.field(__attributes, key);
					attributes += " " + key + "=\"" + value + "\"";
				}
				var elementString:String = "<" + nodeName + attributes;
				if (firstChild != null)
				{
					var childrenString:String = "";
					var current = firstChild;
					while (current != null)
					{
						childrenString += current.toString();
						current = current.nextSibling;
					}
					elementString += ">" + childrenString + "</" + nodeName + ">";
				}
				else
				{
					elementString += " />";
				}
				return elementString;
			default:
				if (nodeValue == null)
				{
					return "";
				}
				return nodeValue;
		}
		return "";
	}
}
#else
typedef XMLNode = flash.xml.XMLNode;
#end
