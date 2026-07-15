package;

import openfl.xml.XMLDocument;
import openfl.xml.XMLNode;
import openfl.xml.XMLNodeType;
import utest.Assert;
import utest.Test;
#if lime
import lime.system.System;
#end

class XMLDocumentTest extends Test
{
	public function test_new():Void
	{
		var xmlDocument = new XMLDocument();
		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isFalse(xmlDocument.hasChildNodes());
		Assert.equals(0, xmlDocument.childNodes.length);
		Assert.isNull(xmlDocument.firstChild);
		Assert.isNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("<>", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);
	}

	public function test_new_withElement():Void
	{
		var xmlDocument = new XMLDocument("<root/>");
		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isTrue(xmlDocument.hasChildNodes());
		Assert.equals(1, xmlDocument.childNodes.length);
		Assert.notNull(xmlDocument.firstChild);
		Assert.notNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("<root />", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);

		var firstChild = xmlDocument.firstChild;
		Assert.equals(ELEMENT_NODE, firstChild.nodeType);
		Assert.equals("root", firstChild.nodeName);
		Assert.equals("root", firstChild.localName);
		Assert.equals("", firstChild.prefix);
		Assert.isNull(firstChild.namespaceURI);
		Assert.isNull(firstChild.nodeValue);
		Assert.equals(xmlDocument, firstChild.parentNode);
		Assert.isFalse(firstChild.hasChildNodes());
		Assert.equals(0, firstChild.childNodes.length);
		Assert.isNull(firstChild.firstChild);
		Assert.isNull(firstChild.lastChild);
		Assert.isNull(firstChild.previousSibling);
		Assert.isNull(firstChild.nextSibling);
		Assert.equals(0, Reflect.fields(firstChild.attributes).length);
		Assert.equals("<root />", firstChild.toString());

		Assert.equals(xmlDocument.firstChild, xmlDocument.lastChild);
	}

	public function test_new_withElement_withPrefix():Void
	{
		var xmlDocument = new XMLDocument("<z:root/>");
		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isTrue(xmlDocument.hasChildNodes());
		Assert.equals(1, xmlDocument.childNodes.length);
		Assert.notNull(xmlDocument.firstChild);
		Assert.notNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("<z:root />", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);

		var firstChild = xmlDocument.firstChild;
		Assert.equals(ELEMENT_NODE, firstChild.nodeType);
		Assert.equals("z:root", firstChild.nodeName);
		Assert.equals("root", firstChild.localName);
		Assert.equals("z", firstChild.prefix);
		Assert.isNull(firstChild.namespaceURI);
		Assert.isNull(firstChild.nodeValue);
		Assert.equals(xmlDocument, firstChild.parentNode);
		Assert.isFalse(firstChild.hasChildNodes());
		Assert.equals(0, firstChild.childNodes.length);
		Assert.isNull(firstChild.firstChild);
		Assert.isNull(firstChild.lastChild);
		Assert.isNull(firstChild.previousSibling);
		Assert.isNull(firstChild.nextSibling);
		Assert.equals(0, Reflect.fields(firstChild.attributes).length);
		Assert.equals("<z:root />", firstChild.toString());

		Assert.equals(xmlDocument.firstChild, xmlDocument.lastChild);
	}

	public function test_new_withElement_withPrefixAndXmlns():Void
	{
		var xmlDocument = new XMLDocument("<z:root xmlns:z=\"https://ns.example.com/\"/>");
		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isTrue(xmlDocument.hasChildNodes());
		Assert.equals(1, xmlDocument.childNodes.length);
		Assert.notNull(xmlDocument.firstChild);
		Assert.notNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("<z:root xmlns:z=\"https://ns.example.com/\" />", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);

		var firstChild = xmlDocument.firstChild;
		Assert.equals(ELEMENT_NODE, firstChild.nodeType);
		Assert.equals("z:root", firstChild.nodeName);
		Assert.equals("root", firstChild.localName);
		Assert.equals("z", firstChild.prefix);
		Assert.equals("https://ns.example.com/", firstChild.namespaceURI);
		Assert.isNull(firstChild.nodeValue);
		Assert.equals(xmlDocument, firstChild.parentNode);
		Assert.isFalse(firstChild.hasChildNodes());
		Assert.equals(0, firstChild.childNodes.length);
		Assert.isNull(firstChild.firstChild);
		Assert.isNull(firstChild.lastChild);
		Assert.isNull(firstChild.previousSibling);
		Assert.isNull(firstChild.nextSibling);
		Assert.equals(1, Reflect.fields(firstChild.attributes).length);
		Assert.isTrue(Reflect.hasField(firstChild.attributes, "xmlns:z"));
		Assert.equals("https://ns.example.com/", Reflect.field(firstChild.attributes, "xmlns:z"));
		Assert.equals("<z:root xmlns:z=\"https://ns.example.com/\" />", firstChild.toString());

		Assert.equals(xmlDocument.firstChild, xmlDocument.lastChild);
	}

	public function test_new_withText():Void
	{
		var xmlDocument = new XMLDocument("hello");
		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isTrue(xmlDocument.hasChildNodes());
		Assert.equals(1, xmlDocument.childNodes.length);
		Assert.notNull(xmlDocument.firstChild);
		Assert.notNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("hello", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);

		var firstChild = xmlDocument.firstChild;
		Assert.equals(TEXT_NODE, firstChild.nodeType);
		Assert.isNull(firstChild.nodeName);
		Assert.isNull(firstChild.localName);
		Assert.isNull(firstChild.prefix);
		Assert.isNull(firstChild.namespaceURI);
		Assert.equals("hello", firstChild.nodeValue);
		Assert.equals(xmlDocument, firstChild.parentNode);
		Assert.isFalse(firstChild.hasChildNodes());
		Assert.equals(0, firstChild.childNodes.length);
		Assert.isNull(firstChild.firstChild);
		Assert.isNull(firstChild.lastChild);
		Assert.isNull(firstChild.previousSibling);
		Assert.isNull(firstChild.nextSibling);
		Assert.equals(0, Reflect.fields(firstChild.attributes).length);
		Assert.equals("hello", firstChild.toString());

		Assert.equals(xmlDocument.firstChild, xmlDocument.lastChild);
	}

	public function test_attributes():Void
	{
		var xmlDocument = new XMLDocument("<root attr1=\"abc\" attr2=\"xyz\"/>");
		var rootElement = xmlDocument.firstChild;
		Assert.notNull(rootElement);
		Assert.equals(2, Reflect.fields(rootElement.attributes).length);
		Assert.equals("abc", Reflect.field(rootElement.attributes, "attr1"));
		Assert.equals("xyz", Reflect.field(rootElement.attributes, "attr2"));
		Assert.isNull(Reflect.field(rootElement.attributes, "attr3"));
	}

	public function test_createElement():Void
	{
		var xmlDocument = new XMLDocument();

		var elementNode = xmlDocument.createElement("abc");
		Assert.notNull(elementNode);
		Assert.equals(ELEMENT_NODE, elementNode.nodeType);
		Assert.equals("abc", elementNode.nodeName);
		Assert.equals("abc", elementNode.localName);
		Assert.equals("", elementNode.prefix);
		Assert.isNull(elementNode.namespaceURI);
		Assert.isNull(elementNode.nodeValue);
		Assert.isNull(elementNode.parentNode);
		Assert.isFalse(elementNode.hasChildNodes());
		Assert.equals(0, elementNode.childNodes.length);
		Assert.isNull(elementNode.firstChild);
		Assert.isNull(elementNode.lastChild);
		Assert.isNull(elementNode.previousSibling);
		Assert.isNull(elementNode.nextSibling);
		Assert.equals(0, Reflect.fields(elementNode.attributes).length);
		Assert.equals("<abc />", elementNode.toString());

		// not added to the document
		Assert.isNull(xmlDocument.firstChild);
		Assert.isNull(xmlDocument.lastChild);
		Assert.equals(0, xmlDocument.childNodes.length);
	}

	public function test_createTextNode():Void
	{
		var xmlDocument = new XMLDocument();

		var textNode = xmlDocument.createTextNode("abc");
		Assert.notNull(textNode);
		Assert.equals(TEXT_NODE, textNode.nodeType);
		Assert.isNull(textNode.nodeName);
		Assert.isNull(textNode.localName);
		Assert.isNull(textNode.prefix);
		Assert.isNull(textNode.namespaceURI);
		Assert.equals("abc", textNode.nodeValue);
		Assert.isNull(textNode.parentNode);
		Assert.isFalse(textNode.hasChildNodes());
		Assert.equals(0, textNode.childNodes.length);
		Assert.isNull(textNode.firstChild);
		Assert.isNull(textNode.lastChild);
		Assert.isNull(textNode.previousSibling);
		Assert.isNull(textNode.nextSibling);
		Assert.equals(0, Reflect.fields(textNode.attributes).length);
		Assert.equals("abc", textNode.toString());

		// not added to the document
		Assert.isNull(xmlDocument.firstChild);
		Assert.isNull(xmlDocument.lastChild);
		Assert.equals(0, xmlDocument.childNodes.length);
	}

	public function test_idMap():Void
	{
		var xmlDocument = new XMLDocument("<root id=\"abc\"><child id=\"def\"/><child/><child id=\"ghi\"/><child/></root>");

		Assert.equals(3, Reflect.fields(xmlDocument.idMap).length);
		Assert.equals(xmlDocument.firstChild, xmlDocument.idMap.abc);
		Assert.equals(xmlDocument.firstChild.childNodes[0], xmlDocument.idMap.def);
		Assert.equals(xmlDocument.firstChild.childNodes[2], xmlDocument.idMap.ghi);
		Assert.isNull(xmlDocument.idMap.xyz);
	}

	public function test_parseXML():Void
	{
		var xmlDocument = new XMLDocument("<root attr=\"abc\">text text<child/>\n123</root>");
		xmlDocument.parseXML("<root/>");

		Assert.equals(ELEMENT_NODE, xmlDocument.nodeType);
		Assert.isNull(xmlDocument.nodeName);
		Assert.isNull(xmlDocument.localName);
		Assert.isNull(xmlDocument.prefix);
		Assert.isNull(xmlDocument.namespaceURI);
		Assert.isNull(xmlDocument.nodeValue);
		Assert.isNull(xmlDocument.parentNode);
		Assert.isTrue(xmlDocument.hasChildNodes());
		Assert.equals(1, xmlDocument.childNodes.length);
		Assert.notNull(xmlDocument.firstChild);
		Assert.notNull(xmlDocument.lastChild);
		Assert.isNull(xmlDocument.previousSibling);
		Assert.isNull(xmlDocument.nextSibling);
		Assert.equals(0, Reflect.fields(xmlDocument.attributes).length);
		Assert.equals("<root />", xmlDocument.toString());
		Assert.equals(0, Reflect.fields(xmlDocument.idMap).length);

		var firstChild = xmlDocument.firstChild;
		Assert.equals(ELEMENT_NODE, firstChild.nodeType);
		Assert.equals("root", firstChild.nodeName);
		Assert.equals("root", firstChild.localName);
		Assert.equals("", firstChild.prefix);
		Assert.isNull(firstChild.namespaceURI);
		Assert.isNull(firstChild.nodeValue);
		Assert.equals(xmlDocument, firstChild.parentNode);
		Assert.isFalse(firstChild.hasChildNodes());
		Assert.equals(0, firstChild.childNodes.length);
		Assert.isNull(firstChild.firstChild);
		Assert.isNull(firstChild.lastChild);
		Assert.isNull(firstChild.previousSibling);
		Assert.isNull(firstChild.nextSibling);
		Assert.equals(0, Reflect.fields(firstChild.attributes).length);
		Assert.equals("<root />", firstChild.toString());

		Assert.equals(xmlDocument.firstChild, xmlDocument.lastChild);
	}

	public function test_ignoreWhite():Void
	{
		var xmlDocument = new XMLDocument();
		xmlDocument.ignoreWhite = true;
		xmlDocument.parseXML("<root>   </root>");

		var rootElement = xmlDocument.firstChild;
		Assert.equals(0, rootElement.childNodes.length);
		Assert.isNull(rootElement.firstChild);
		Assert.isNull(rootElement.lastChild);

		var xmlDocument = new XMLDocument();
		xmlDocument.ignoreWhite = false;
		xmlDocument.parseXML("<root>   </root>");

		var rootElement = xmlDocument.firstChild;
		Assert.equals(1, rootElement.childNodes.length);
		Assert.notNull(rootElement.firstChild);
		Assert.notNull(rootElement.lastChild);

		var textNode = rootElement.firstChild;
		Assert.equals(TEXT_NODE, textNode.nodeType);
		Assert.isNull(textNode.nodeName);
		Assert.isNull(textNode.localName);
		Assert.isNull(textNode.prefix);
		Assert.isNull(textNode.namespaceURI);
		Assert.equals("   ", textNode.nodeValue);
		Assert.equals(rootElement, textNode.parentNode);
		Assert.isFalse(textNode.hasChildNodes());
		Assert.equals(0, textNode.childNodes.length);
		Assert.isNull(textNode.firstChild);
		Assert.isNull(textNode.lastChild);
		Assert.isNull(textNode.previousSibling);
		Assert.isNull(textNode.nextSibling);
		Assert.equals(0, Reflect.fields(textNode.attributes).length);
		Assert.equals("   ", textNode.toString());
	}
}
