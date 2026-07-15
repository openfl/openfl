package;

import openfl.errors.TypeError;
import openfl.xml.XMLDocument;
import openfl.xml.XMLNode;
import openfl.xml.XMLNodeType;
import utest.Assert;
import utest.Test;
#if lime
import lime.system.System;
#end

class XMLNodeTest extends Test
{
	public function test_new_withElementNode_withName():Void
	{
		var xmlNode = new XMLNode(ELEMENT_NODE, "abc");
		Assert.equals(ELEMENT_NODE, xmlNode.nodeType);
		Assert.equals("abc", xmlNode.nodeName);
		Assert.equals("abc", xmlNode.localName);
		Assert.equals("", xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("<abc />", xmlNode.toString());
	}

	public function test_new_withElementNode_withoutName():Void
	{
		var xmlNode = new XMLNode(ELEMENT_NODE, null);
		Assert.equals(ELEMENT_NODE, xmlNode.nodeType);
		Assert.isNull(xmlNode.nodeName);
		Assert.isNull(xmlNode.localName);
		Assert.isNull(xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("", xmlNode.toString());
	}

	public function test_new_withElementNode_withNameIncludingPrefix():Void
	{
		var xmlNode = new XMLNode(ELEMENT_NODE, "z:abc");
		Assert.equals(ELEMENT_NODE, xmlNode.nodeType);
		Assert.equals("z:abc", xmlNode.nodeName);
		Assert.equals("abc", xmlNode.localName);
		Assert.equals("z", xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("<z:abc />", xmlNode.toString());
	}

	public function test_new_withTextNode_withValue():Void
	{
		var xmlNode = new XMLNode(TEXT_NODE, "hello");
		Assert.equals(TEXT_NODE, xmlNode.nodeType);
		Assert.isNull(xmlNode.nodeName);
		Assert.isNull(xmlNode.localName);
		Assert.isNull(xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.equals("hello", xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("hello", xmlNode.toString());
	}

	public function test_new_withTextNode_withoutValue():Void
	{
		var xmlNode = new XMLNode(TEXT_NODE, null);
		Assert.equals(TEXT_NODE, xmlNode.nodeType);
		Assert.isNull(xmlNode.nodeName);
		Assert.isNull(xmlNode.localName);
		Assert.isNull(xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("", xmlNode.toString());
	}

	public function test_new_withUnknownNodeType():Void
	{
		// other integer values are basically treated like TEXT_NODE
		var xmlNode = new XMLNode(cast 5, "abc");
		Assert.equals(5, xmlNode.nodeType);
		Assert.isNull(xmlNode.nodeName);
		Assert.isNull(xmlNode.localName);
		Assert.isNull(xmlNode.prefix);
		Assert.isNull(xmlNode.namespaceURI);
		Assert.equals("abc", xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(0, Reflect.fields(xmlNode.attributes).length);
		Assert.equals("abc", xmlNode.toString());
	}

	public function test_appendChild_withElementNode():Void
	{
		var parentElementNode1 = new XMLNode(ELEMENT_NODE, "abc");
		var childTextNode1 = new XMLNode(TEXT_NODE, "hello");
		parentElementNode1.appendChild(childTextNode1);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(1, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[0]);
		Assert.equals(childTextNode1, parentElementNode1.firstChild);
		Assert.equals(childTextNode1, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.equals("<abc>hello</abc>", parentElementNode1.toString());

		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode1.appendChild(childElementNode);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(2, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[0]);
		Assert.equals(childElementNode, parentElementNode1.childNodes[1]);
		Assert.equals(childTextNode1, parentElementNode1.firstChild);
		Assert.equals(childElementNode, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.isNull(childTextNode1.previousSibling);
		Assert.equals(childElementNode, childTextNode1.nextSibling);
		Assert.equals(parentElementNode1, childElementNode.parentNode);
		Assert.equals(childTextNode1, childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
		Assert.equals("<abc>hello<xyz /></abc>", parentElementNode1.toString());

		var childTextNode2 = new XMLNode(TEXT_NODE, "goodbye");
		parentElementNode1.appendChild(childTextNode2);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(3, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[0]);
		Assert.equals(childElementNode, parentElementNode1.childNodes[1]);
		Assert.equals(childTextNode2, parentElementNode1.childNodes[2]);
		Assert.equals(childTextNode1, parentElementNode1.firstChild);
		Assert.equals(childTextNode2, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.isNull(childTextNode1.previousSibling);
		Assert.equals(childElementNode, childTextNode1.nextSibling);
		Assert.equals(parentElementNode1, childElementNode.parentNode);
		Assert.equals(childTextNode1, childElementNode.previousSibling);
		Assert.equals(childTextNode2, childElementNode.nextSibling);
		Assert.equals(childElementNode, childTextNode2.previousSibling);
		Assert.isNull(childTextNode2.nextSibling);
		Assert.equals("<abc>hello<xyz />goodbye</abc>", parentElementNode1.toString());

		// append a child that already has a parent to a new parent

		var parentElementNode2 = new XMLNode(ELEMENT_NODE, "def");
		parentElementNode2.appendChild(childElementNode);

		Assert.isTrue(parentElementNode2.hasChildNodes());
		Assert.equals(1, parentElementNode2.childNodes.length);
		Assert.equals(childElementNode, parentElementNode2.childNodes[0]);
		Assert.equals(childElementNode, parentElementNode2.firstChild);
		Assert.equals(childElementNode, parentElementNode2.lastChild);
		Assert.equals(parentElementNode2, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
		Assert.equals("<def><xyz /></def>", parentElementNode2.toString());

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(2, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[0]);
		Assert.equals(childTextNode2, parentElementNode1.childNodes[1]);
		Assert.equals(childTextNode1, parentElementNode1.firstChild);
		Assert.equals(childTextNode2, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.isNull(childTextNode1.previousSibling);
		Assert.equals(childTextNode2, childTextNode1.nextSibling);
		Assert.equals(parentElementNode1, childTextNode2.parentNode);
		Assert.equals(childTextNode1, childTextNode2.previousSibling);
		Assert.isNull(childTextNode2.nextSibling);
		Assert.equals("<abc>hellogoodbye</abc>", parentElementNode1.toString());
	}

	public function test_appendChild_withTextNode():Void
	{
		var parentTextNode = new XMLNode(TEXT_NODE, "hello");
		var childTextNode = new XMLNode(TEXT_NODE, "goodbye");
		parentTextNode.appendChild(childTextNode);

		Assert.isTrue(parentTextNode.hasChildNodes());
		Assert.equals(1, parentTextNode.childNodes.length);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.equals(childTextNode, parentTextNode.firstChild);
		Assert.equals(childTextNode, parentTextNode.lastChild);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.isNull(childTextNode.previousSibling);
		Assert.isNull(childTextNode.nextSibling);
		Assert.equals("hello", parentTextNode.toString());

		var childElementNode = new XMLNode(ELEMENT_NODE, "abc");
		parentTextNode.appendChild(childElementNode);

		Assert.isTrue(parentTextNode.hasChildNodes());
		Assert.equals(2, parentTextNode.childNodes.length);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.equals(childTextNode, parentTextNode.firstChild);
		Assert.equals(childElementNode, parentTextNode.lastChild);
		Assert.equals(parentTextNode, childElementNode.parentNode);
		Assert.isNull(childTextNode.previousSibling);
		Assert.equals(childElementNode, childTextNode.nextSibling);
		Assert.equals(childTextNode, childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
		Assert.equals("hello", parentTextNode.toString());
	}

	public function test_insertBefore_withElementNode():Void
	{
		var parentElementNode1 = new XMLNode(ELEMENT_NODE, "abc");
		var childTextNode1 = new XMLNode(TEXT_NODE, "hello");
		parentElementNode1.insertBefore(childTextNode1, null);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(1, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[0]);
		Assert.equals(childTextNode1, parentElementNode1.firstChild);
		Assert.equals(childTextNode1, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.equals("<abc>hello</abc>", parentElementNode1.toString());

		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode1.insertBefore(childElementNode, childTextNode1);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(2, parentElementNode1.childNodes.length);
		Assert.equals(childElementNode, parentElementNode1.childNodes[0]);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[1]);
		Assert.equals(childElementNode, parentElementNode1.firstChild);
		Assert.equals(childTextNode1, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.equals(childTextNode1, childElementNode.nextSibling);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.equals(childElementNode, childTextNode1.previousSibling);
		Assert.isNull(childTextNode1.nextSibling);
		Assert.equals("<abc><xyz />hello</abc>", parentElementNode1.toString());

		var childTextNode2 = new XMLNode(TEXT_NODE, "goodbye");
		parentElementNode1.insertBefore(childTextNode2, childElementNode);

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(3, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode2, parentElementNode1.childNodes[0]);
		Assert.equals(childElementNode, parentElementNode1.childNodes[1]);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[2]);
		Assert.equals(childTextNode2, parentElementNode1.firstChild);
		Assert.equals(childTextNode1, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode2.parentNode);
		Assert.isNull(childTextNode2.previousSibling);
		Assert.equals(childElementNode, childTextNode2.nextSibling);
		Assert.equals(parentElementNode1, childElementNode.parentNode);
		Assert.equals(childTextNode2, childElementNode.previousSibling);
		Assert.equals(childTextNode1, childElementNode.nextSibling);
		Assert.equals(childElementNode, childTextNode1.previousSibling);
		Assert.isNull(childTextNode1.nextSibling);
		Assert.equals("<abc>goodbye<xyz />hello</abc>", parentElementNode1.toString());

		// insert a child that already has a parent to a new parent

		var parentElementNode2 = new XMLNode(ELEMENT_NODE, "def");
		var childTextNode3 = new XMLNode(TEXT_NODE, "yo");
		parentElementNode2.insertBefore(childTextNode3, null);
		parentElementNode2.insertBefore(childElementNode, childTextNode3);

		Assert.isTrue(parentElementNode2.hasChildNodes());
		Assert.equals(2, parentElementNode2.childNodes.length);
		Assert.equals(childElementNode, parentElementNode2.childNodes[0]);
		Assert.equals(childTextNode3, parentElementNode2.childNodes[1]);
		Assert.equals(childElementNode, parentElementNode2.firstChild);
		Assert.equals(childTextNode3, parentElementNode2.lastChild);
		Assert.equals(parentElementNode2, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.equals(childTextNode3, childElementNode.nextSibling);
		Assert.equals("<def><xyz />yo</def>", parentElementNode2.toString());

		Assert.isTrue(parentElementNode1.hasChildNodes());
		Assert.equals(2, parentElementNode1.childNodes.length);
		Assert.equals(childTextNode2, parentElementNode1.childNodes[0]);
		Assert.equals(childTextNode1, parentElementNode1.childNodes[1]);
		Assert.equals(childTextNode2, parentElementNode1.firstChild);
		Assert.equals(childTextNode1, parentElementNode1.lastChild);
		Assert.equals(parentElementNode1, childTextNode2.parentNode);
		Assert.isNull(childTextNode2.previousSibling);
		Assert.equals(childTextNode1, childTextNode2.nextSibling);
		Assert.equals(parentElementNode1, childTextNode1.parentNode);
		Assert.equals(childTextNode2, childTextNode1.previousSibling);
		Assert.isNull(childTextNode1.nextSibling);
		Assert.equals("<abc>goodbyehello</abc>", parentElementNode1.toString());
	}

	public function test_insertBefore_withTextNode():Void
	{
		var parentTextNode = new XMLNode(TEXT_NODE, "hello");
		var childTextNode = new XMLNode(TEXT_NODE, "goodbye");
		parentTextNode.insertBefore(childTextNode, null);

		Assert.isTrue(parentTextNode.hasChildNodes());
		Assert.equals(1, parentTextNode.childNodes.length);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.equals(childTextNode, parentTextNode.firstChild);
		Assert.equals(childTextNode, parentTextNode.lastChild);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.isNull(childTextNode.previousSibling);
		Assert.isNull(childTextNode.nextSibling);
		Assert.equals("hello", parentTextNode.toString());

		var childElementNode = new XMLNode(ELEMENT_NODE, "abc");
		parentTextNode.insertBefore(childElementNode, childTextNode);

		Assert.isTrue(parentTextNode.hasChildNodes());
		Assert.equals(2, parentTextNode.childNodes.length);
		Assert.equals(parentTextNode, childTextNode.parentNode);
		Assert.equals(childElementNode, parentTextNode.firstChild);
		Assert.equals(childTextNode, parentTextNode.lastChild);
		Assert.equals(parentTextNode, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.equals(childTextNode, childElementNode.nextSibling);
		Assert.equals(childElementNode, childTextNode.previousSibling);
		Assert.isNull(childTextNode.nextSibling);
		Assert.equals("hello", parentTextNode.toString());
	}

	public function test_removeNode():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childTextNode1 = new XMLNode(TEXT_NODE, "hello");
		parentElementNode.appendChild(childTextNode1);

		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.appendChild(childElementNode);

		var childTextNode2 = new XMLNode(TEXT_NODE, "goodbye");
		parentElementNode.appendChild(childTextNode2);

		childTextNode1.removeNode();

		Assert.isNull(childTextNode1.parentNode);
		Assert.isNull(childTextNode1.previousSibling);
		Assert.isNull(childTextNode1.nextSibling);
		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(2, parentElementNode.childNodes.length);
		Assert.equals(childElementNode, parentElementNode.childNodes[0]);
		Assert.equals(childTextNode2, parentElementNode.childNodes[1]);
		Assert.equals(childElementNode, parentElementNode.firstChild);
		Assert.equals(childTextNode2, parentElementNode.lastChild);
		Assert.equals(parentElementNode, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.equals(childTextNode2, childElementNode.nextSibling);
		Assert.equals(parentElementNode, childTextNode2.parentNode);
		Assert.equals(childElementNode, childTextNode2.previousSibling);
		Assert.isNull(childTextNode2.nextSibling);
		Assert.equals("<abc><xyz />goodbye</abc>", parentElementNode.toString());

		childTextNode2.removeNode();

		Assert.isNull(childTextNode2.parentNode);
		Assert.isNull(childTextNode2.previousSibling);
		Assert.isNull(childTextNode2.nextSibling);
		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(1, parentElementNode.childNodes.length);
		Assert.equals(childElementNode, parentElementNode.childNodes[0]);
		Assert.equals(childElementNode, parentElementNode.firstChild);
		Assert.equals(childElementNode, parentElementNode.lastChild);
		Assert.equals(parentElementNode, childElementNode.parentNode);
		Assert.equals("<abc><xyz /></abc>", parentElementNode.toString());
	}

	public function test_cloneNode_withTextNode():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childTextNode = new XMLNode(TEXT_NODE, "hello");
		parentElementNode.appendChild(childTextNode);

		var clonedNode = childTextNode.cloneNode(false);
		Assert.notEquals(childTextNode, clonedNode);

		Assert.equals(TEXT_NODE, clonedNode.nodeType);
		Assert.isNull(clonedNode.nodeName);
		Assert.isNull(clonedNode.localName);
		Assert.isNull(clonedNode.prefix);
		Assert.isNull(clonedNode.namespaceURI);
		Assert.equals("hello", clonedNode.nodeValue);
		Assert.isNull(clonedNode.parentNode);
		Assert.isFalse(clonedNode.hasChildNodes());
		Assert.equals(0, clonedNode.childNodes.length);
		Assert.isNull(clonedNode.firstChild);
		Assert.isNull(clonedNode.lastChild);
		Assert.isNull(clonedNode.previousSibling);
		Assert.isNull(clonedNode.nextSibling);
		Assert.equals(0, Reflect.fields(clonedNode.attributes).length);
		Assert.equals("hello", clonedNode.toString());

		var deepClonedNode = childTextNode.cloneNode(true);
		Assert.notEquals(childTextNode, deepClonedNode);
		Assert.notEquals(clonedNode, deepClonedNode);

		Assert.equals(TEXT_NODE, deepClonedNode.nodeType);
		Assert.isNull(deepClonedNode.nodeName);
		Assert.isNull(deepClonedNode.localName);
		Assert.isNull(deepClonedNode.prefix);
		Assert.isNull(deepClonedNode.namespaceURI);
		Assert.equals("hello", deepClonedNode.nodeValue);
		Assert.isNull(deepClonedNode.parentNode);
		Assert.isFalse(deepClonedNode.hasChildNodes());
		Assert.equals(0, deepClonedNode.childNodes.length);
		Assert.isNull(deepClonedNode.firstChild);
		Assert.isNull(deepClonedNode.lastChild);
		Assert.isNull(deepClonedNode.previousSibling);
		Assert.isNull(deepClonedNode.nextSibling);
		Assert.equals(0, Reflect.fields(deepClonedNode.attributes).length);
		Assert.equals("hello", deepClonedNode.toString());
	}

	public function test_cloneNode_withElementNode():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode = new XMLNode(ELEMENT_NODE, "w:xyz");
		childElementNode.attributes.one = "1";
		childElementNode.attributes.two = "2";
		parentElementNode.appendChild(childElementNode);
		var grandChildTextNode = new XMLNode(TEXT_NODE, "hello");
		childElementNode.appendChild(grandChildTextNode);

		var clonedNode = childElementNode.cloneNode(false);
		Assert.notEquals(childElementNode, clonedNode);

		Assert.equals(ELEMENT_NODE, clonedNode.nodeType);
		Assert.equals("w:xyz", clonedNode.nodeName);
		Assert.equals("xyz", clonedNode.localName);
		Assert.equals("w", clonedNode.prefix);
		Assert.isNull(clonedNode.namespaceURI);
		Assert.isNull(clonedNode.nodeValue);
		Assert.isNull(clonedNode.parentNode);
		Assert.isFalse(clonedNode.hasChildNodes());
		Assert.equals(0, clonedNode.childNodes.length);
		Assert.isNull(clonedNode.firstChild);
		Assert.isNull(clonedNode.lastChild);
		Assert.isNull(clonedNode.previousSibling);
		Assert.isNull(clonedNode.nextSibling);
		Assert.equals(2, Reflect.fields(clonedNode.attributes).length);
		Assert.isTrue(Reflect.hasField(clonedNode.attributes, "one"));
		Assert.isTrue(Reflect.hasField(clonedNode.attributes, "two"));
		Assert.equals("1", clonedNode.attributes.one);
		Assert.equals("2", clonedNode.attributes.two);
		Assert.equals("<w:xyz one=\"1\" two=\"2\" />", clonedNode.toString());

		var deepClonedNode = childElementNode.cloneNode(true);
		Assert.notEquals(childElementNode, deepClonedNode);
		Assert.notEquals(clonedNode, deepClonedNode);

		Assert.equals(ELEMENT_NODE, deepClonedNode.nodeType);
		Assert.equals("w:xyz", deepClonedNode.nodeName);
		Assert.equals("xyz", deepClonedNode.localName);
		Assert.equals("w", deepClonedNode.prefix);
		Assert.isNull(deepClonedNode.namespaceURI);
		Assert.isNull(deepClonedNode.nodeValue);
		Assert.isNull(deepClonedNode.parentNode);
		Assert.isTrue(deepClonedNode.hasChildNodes());
		Assert.equals(1, deepClonedNode.childNodes.length);
		Assert.notEquals(grandChildTextNode, deepClonedNode.childNodes[0]);
		Assert.notNull(deepClonedNode.firstChild);
		Assert.notNull(deepClonedNode.lastChild);
		Assert.notEquals(grandChildTextNode, deepClonedNode.firstChild);
		Assert.notEquals(grandChildTextNode, deepClonedNode.lastChild);
		Assert.isNull(deepClonedNode.previousSibling);
		Assert.isNull(deepClonedNode.nextSibling);
		Assert.equals(2, Reflect.fields(deepClonedNode.attributes).length);
		Assert.isTrue(Reflect.hasField(deepClonedNode.attributes, "one"));
		Assert.isTrue(Reflect.hasField(deepClonedNode.attributes, "two"));
		Assert.equals("1", deepClonedNode.attributes.one);
		Assert.equals("2", deepClonedNode.attributes.two);
		Assert.equals("<w:xyz one=\"1\" two=\"2\">hello</w:xyz>", deepClonedNode.toString());
	}

	public function test_attributes_withXmlns_withPrefix():Void
	{
		var xmlNode = new XMLNode(ELEMENT_NODE, "z:abc");
		Reflect.setField(xmlNode.attributes, "xmlns:z", "https://ns.example.com/");
		Assert.equals(ELEMENT_NODE, xmlNode.nodeType);
		Assert.equals("z:abc", xmlNode.nodeName);
		Assert.equals("abc", xmlNode.localName);
		Assert.equals("z", xmlNode.prefix);
		Assert.equals("https://ns.example.com/", xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(1, Reflect.fields(xmlNode.attributes).length);
		Assert.isTrue(Reflect.hasField(xmlNode.attributes, "xmlns:z"));
		Assert.equals("https://ns.example.com/", Reflect.field(xmlNode.attributes, "xmlns:z"));
		Assert.equals("<z:abc xmlns:z=\"https://ns.example.com/\" />", xmlNode.toString());
		Assert.equals("https://ns.example.com/", xmlNode.getNamespaceForPrefix("z"));
		Assert.equals("z", xmlNode.getPrefixForNamespace("https://ns.example.com/"));
	}

	public function test_attributes_withXmlns_withoutPrefix():Void
	{
		var xmlNode = new XMLNode(ELEMENT_NODE, "abc");
		Reflect.setField(xmlNode.attributes, "xmlns", "https://ns.example.com/");
		Assert.equals(ELEMENT_NODE, xmlNode.nodeType);
		Assert.equals("abc", xmlNode.nodeName);
		Assert.equals("abc", xmlNode.localName);
		Assert.equals("", xmlNode.prefix);
		Assert.equals("https://ns.example.com/", xmlNode.namespaceURI);
		Assert.isNull(xmlNode.nodeValue);
		Assert.isNull(xmlNode.parentNode);
		Assert.isFalse(xmlNode.hasChildNodes());
		Assert.equals(0, xmlNode.childNodes.length);
		Assert.isNull(xmlNode.firstChild);
		Assert.isNull(xmlNode.lastChild);
		Assert.isNull(xmlNode.previousSibling);
		Assert.isNull(xmlNode.nextSibling);
		Assert.equals(1, Reflect.fields(xmlNode.attributes).length);
		Assert.isTrue(Reflect.hasField(xmlNode.attributes, "xmlns"));
		Assert.equals("https://ns.example.com/", Reflect.field(xmlNode.attributes, "xmlns"));
		Assert.equals("<abc xmlns=\"https://ns.example.com/\" />", xmlNode.toString());
		Assert.equals("https://ns.example.com/", xmlNode.getNamespaceForPrefix(""));
		Assert.equals("", xmlNode.getPrefixForNamespace("https://ns.example.com/"));
	}

	public function test_getNamespaceForPrefix():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "z:abc");
		Reflect.setField(parentElementNode.attributes, "xmlns:z", "https://ns.example.com/a");
		Reflect.setField(parentElementNode.attributes, "xmlns", "https://ns.example.com/b");
		var childElementNode = new XMLNode(ELEMENT_NODE, "q:xyz");
		parentElementNode.appendChild(childElementNode);

		Assert.equals("https://ns.example.com/a", parentElementNode.getNamespaceForPrefix("z"));
		Assert.equals("https://ns.example.com/b", parentElementNode.getNamespaceForPrefix(""));
		Assert.isNull(parentElementNode.getNamespaceForPrefix("q"));
		Assert.isNull(parentElementNode.getNamespaceForPrefix("x"));
		Assert.raises(function():Void
		{
			parentElementNode.getNamespaceForPrefix(null);
		}, TypeError);

		Assert.equals("https://ns.example.com/a", childElementNode.getNamespaceForPrefix("z"));
		Assert.equals("https://ns.example.com/b", childElementNode.getNamespaceForPrefix(""));
		Assert.isNull(childElementNode.getNamespaceForPrefix("q"));
		Assert.isNull(childElementNode.getNamespaceForPrefix("x"));
		Assert.raises(function():Void
		{
			childElementNode.getNamespaceForPrefix(null);
		}, TypeError);
	}

	public function test_getPrefixForNamespace():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "z:abc");
		Reflect.setField(parentElementNode.attributes, "xmlns:z", "https://ns.example.com/a");
		Reflect.setField(parentElementNode.attributes, "xmlns", "https://ns.example.com/b");
		var childElementNode = new XMLNode(ELEMENT_NODE, "q:xyz");
		parentElementNode.appendChild(childElementNode);

		Assert.equals("z", parentElementNode.getPrefixForNamespace("https://ns.example.com/a"));
		Assert.equals("", parentElementNode.getPrefixForNamespace("https://ns.example.com/b"));
		Assert.isNull(parentElementNode.getPrefixForNamespace("https://ns.example.com/c"));
		Assert.isNull(parentElementNode.getPrefixForNamespace(null));

		Assert.equals("z", childElementNode.getPrefixForNamespace("https://ns.example.com/a"));
		Assert.equals("", childElementNode.getPrefixForNamespace("https://ns.example.com/b"));
		Assert.isNull(childElementNode.getPrefixForNamespace("https://ns.example.com/c"));
		Assert.isNull(childElementNode.getPrefixForNamespace(null));
	}

	public function test_firstChild():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.firstChild = childElementNode;

		Assert.equals(childElementNode, parentElementNode.firstChild);
		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(1, parentElementNode.childNodes.length);
		Assert.isNull(parentElementNode.lastChild);

		Assert.isNull(childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
	}

	public function test_lastChild():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.lastChild = childElementNode;

		Assert.isNull(parentElementNode.firstChild);
		Assert.equals(childElementNode, parentElementNode.lastChild);
		Assert.isFalse(parentElementNode.hasChildNodes());
		Assert.equals(0, parentElementNode.childNodes.length);

		Assert.isNull(childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
	}

	public function test_parentNode():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode = new XMLNode(ELEMENT_NODE, "xyz");
		childElementNode.parentNode = parentElementNode;

		Assert.isNull(parentElementNode.firstChild);
		Assert.isNull(parentElementNode.lastChild);
		Assert.isFalse(parentElementNode.hasChildNodes());
		Assert.equals(0, parentElementNode.childNodes.length);

		Assert.equals(parentElementNode, childElementNode.parentNode);
		Assert.isNull(childElementNode.previousSibling);
		Assert.isNull(childElementNode.nextSibling);
	}

	public function test_previousSibling():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode1 = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.appendChild(childElementNode1);
		var childElementNode2 = new XMLNode(ELEMENT_NODE, "def");
		childElementNode1.previousSibling = childElementNode2;

		Assert.equals(childElementNode1, parentElementNode.firstChild);
		Assert.equals(childElementNode1, parentElementNode.lastChild);

		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(1, parentElementNode.childNodes.length);

		Assert.equals(parentElementNode, childElementNode1.parentNode);
		Assert.equals(childElementNode2, childElementNode1.previousSibling);
		Assert.isNull(childElementNode1.nextSibling);

		Assert.isNull(childElementNode2.parentNode);
		Assert.isNull(childElementNode2.previousSibling);
		Assert.isNull(childElementNode2.nextSibling);
	}

	public function test_nextSibling():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode1 = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.appendChild(childElementNode1);
		var childElementNode2 = new XMLNode(ELEMENT_NODE, "def");
		childElementNode1.nextSibling = childElementNode2;

		Assert.equals(childElementNode1, parentElementNode.firstChild);
		Assert.equals(childElementNode1, parentElementNode.lastChild);

		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(2, parentElementNode.childNodes.length);

		Assert.equals(parentElementNode, childElementNode1.parentNode);
		Assert.isNull(childElementNode1.previousSibling);
		Assert.equals(childElementNode2, childElementNode1.nextSibling);

		Assert.isNull(childElementNode2.parentNode);
		Assert.isNull(childElementNode2.previousSibling);
		Assert.isNull(childElementNode2.nextSibling);
	}

	public function test_childNodes():Void
	{
		var parentElementNode = new XMLNode(ELEMENT_NODE, "abc");
		var childElementNode1 = new XMLNode(ELEMENT_NODE, "xyz");
		parentElementNode.childNodes.push(childElementNode1);

		Assert.isNull(parentElementNode.firstChild);
		Assert.isNull(parentElementNode.lastChild);
		Assert.isFalse(parentElementNode.hasChildNodes());
		Assert.equals(1, parentElementNode.childNodes.length);
		Assert.equals(childElementNode1, parentElementNode.childNodes[0]);

		Assert.isNull(childElementNode1.parentNode);
		Assert.isNull(childElementNode1.previousSibling);
		Assert.isNull(childElementNode1.nextSibling);

		var childElementNode2 = new XMLNode(ELEMENT_NODE, "def");
		parentElementNode.appendChild(childElementNode2);

		Assert.equals(childElementNode2, parentElementNode.firstChild);
		Assert.equals(childElementNode2, parentElementNode.lastChild);
		Assert.isTrue(parentElementNode.hasChildNodes());
		Assert.equals(2, parentElementNode.childNodes.length);
		Assert.equals(childElementNode1, parentElementNode.childNodes[0]);
		Assert.equals(childElementNode2, parentElementNode.childNodes[1]);

		Assert.isNull(childElementNode1.parentNode);
		Assert.isNull(childElementNode1.previousSibling);
		Assert.isNull(childElementNode1.nextSibling);

		Assert.equals(parentElementNode, childElementNode2.parentNode);
		Assert.isNull(childElementNode2.previousSibling);
		Assert.isNull(childElementNode2.nextSibling);
	}
}
