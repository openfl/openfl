package openfl.xml;

import openfl.Lib;
import openfl.utils.Object;
import haxe.xml.Parser;
import haxe.xml.Access;

abstract XML(Xml)
{
	public function new(value:Dynamic)
	{
		if (Std.is(value, String))
		{
			this = Parser.parse(value);
		}
		else if (Std.is(value, Xml))
		{
			this = value;
		}
		else
		{
			throw "Invalid XML initialization value";
		}
	}

	public function toString():String
	{
		return xml.firstChild() != null && xml.firstChild().nodeType == Xml.PCData ? xml.firstChild().nodeValue : xml.toString();
	}

	public function toXMLString():String
	{
		return xml.toString();
	}

	public function localName():String
	{
		var name = xml.nodeName;
		return name.indexOf(":") >= 0 ? name.split(":")[1] : name;
	}

	public function name():String
	{
		return xml.nodeName;
	}

	public function namespace(prefix:String = null):String
	{
		var nodeName = xml.nodeName;
		if (prefix == null)
		{
			if (nodeName.indexOf(":") >= 0)
			{
				var nsPrefix = nodeName.split(":")[0];
				return xml.getNodeName() == null ? "" : xml.getNodeName().split(":")[0];
			}
			else
			{
				// default namespace?
				return "";
			}
		}
		else
		{
			var current = xml;
			while (current != null)
			{
				for (attr in current.attributes())
				{
					if (attr == "xmlns:" + prefix || (prefix == "" && attr == "xmlns"))
					{
						return current.get(attr);
					}
				}
				current = current.parent;
			}
			// namespac not found
			return "";
		}
	}

	public function namespaceDeclarations():Array<String>
	{
		var declarations = [];
		for (attr in xml.attributes())
		{
			if (attr == "xmlns" || attr.indexOf("xmlns:") == 0)
			{
				declarations.push(xml.get(attr));
			}
		}
		return declarations;
	}

	/* public function attributes():XMLList {
			Lib.notImplemented("XML.attributes");
			return null;
		}


		public function attribute(attributeName:Dynamic):XMLList {
			Lib.notImplemented("XML.attribute");
			return null;
		}

		public function children():XMLList {
			Lib.notImplemented("XML.children");
			return null;
		}

		public function child(propertyName:Object):XMLList {
			Lib.notImplemented("XML.child");
			return null;
		}
	 */
	public function childIndex():Int
	{
		var parentNode = xml.parent;
		if (parentNode == null) return -1;

		var index = 0;
		for (child in parentNode.elements())
		{
			if (child == xml)
			{
				return index;
			}
			index++;
		}
		return -1;
	}

	/*
		public function comments():XMLList {
			Lib.notImplemented("XML.comments");
			return null;
		}
	 */
	public function contains(value:XML):Bool
	{
		for (descendant in xml.elements())
		{
			if (descendant == value.xml || new XML(descendant).contains(value))
			{
				return true;
			}
		}
		return false;
	}

	public function copy():XML
	{
		return new XML(xml.copy());
	}

	// Basic idea, requires XMLList
	public function descendants(name:String = "*"):Array<XML>
	{
		var result = [];
		for (descendant in xml.elements())
		{
			if (name == "*" || descendant.nodeName == name)
			{
				result.push(new XML(descendant));
			}
			// Recursively add all descendants of this child
			result = result.concat(new XML(descendant).descendants(name));
		}
		return result;
	}

	/*
		public function elements(name:Object = "*"):XMLList {
			Lib.notImplemented("XML.elements");
			return null;
		}
	 */
	public function hasComplexContent():Bool
	{
		return xml.elements().hasNext() || xml.firstChild() == null;
	}

	public function hasSimpleContent():Bool
	{
		return !xml.elements().hasNext() && xml.firstChild() != null;
	}

	public function inScopeNamespaces():Array<String>
	{
		var namespaces = [];
		var current = xml;

		while (current != null)
		{
			for (attr in current.attributes())
			{
				if (attr == "xmlns" || attr.indexOf("xmlns:") == 0)
				{
					namespaces.push(current.get(attr));
				}
			}
			current = current.parent;
		}

		return namespaces;
	}

	public function insertChildAfter(child1:Object, child2:Object):Dynamic
	{
		Lib.notImplemented("XML.insertChildAfter");
		return null;
	}

	public function insertChildBefore(child1:Object, child2:Object):Dynamic
	{
		Lib.notImplemented("XML.insertChildBefore");
		return null;
	}

	public function length():Int
	{
		Lib.notImplemented("XML.length");
		return 1;
	}

	public function nodeKind():String
	{
		Lib.notImplemented("XML.nodeKind");
		return "";
	}

	public function normalize():XML
	{
		Lib.notImplemented("XML.normalize");
		return this;
	}

	public function parent():XML
	{
		Lib.notImplemented("XML.parent");
		return null;
	}

	public function prependChild(value:Object):XML
	{
		Lib.notImplemented("XML.prependChild");
		return this;
	}

	public function processingInstructions(name:String = "*"):XMLList
	{
		Lib.notImplemented("XML.processingInstructions");
		return null;
	}

	public function removeNamespace(ns:Namespace):XML
	{
		Lib.notImplemented("XML.removeNamespace");
		return this;
	}

	public function replace(propertyName:Object, value:XML):XML
	{
		Lib.notImplemented("XML.replace");
		return this;
	}

	public function setChildren(value:Object):XML
	{
		Lib.notImplemented("XML.setChildren");
		return this;
	}

	public function setLocalName(name:String):Void
	{
		Lib.notImplemented("XML.setLocalName");
	}

	public function setName(name:String):Void
	{
		Lib.notImplemented("XML.setName");
	}

	public function setNamespace(ns:Namespace):Void
	{
		Lib.notImplemented("XML.setNamespace");
	}

	public static function defaultSettings():Object
	{
		Lib.notImplemented("XML.defaultSettings");
		return {};
	}

	public static function setSettings(...rest:Array<Dynamic>):Void
	{
		Lib.notImplemented("XML.setSettings");
	}

	public static function settings():Object
	{
		Lib.notImplemented("XML.settings");
		return {};
	}

	public static var ignoreComments:Bool;
	public static var ignoreProcessingInstructions:Bool;
	public static var ignoreWhitespace:Bool;
	public static var prettyIndent:Int;
	public static var prettyPrinting:Bool;

	public function text():XMLList
	{
		Lib.notImplemented("XML.text");
		return null;
	}

	public function toJSON(k:String):Dynamic
	{
		Lib.notImplemented("XML.toJSON");
		return null;
	}

	public function valueOf():XML
	{
		Lib.notImplemented("XML.valueOf");
		return this;
	}
}
