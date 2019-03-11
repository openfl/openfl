package openfl._internal.formats.xfl.dom;

import haxe.xml.Fast;
import openfl._internal.formats.xfl.geom.MotionObject;

class DOMFrame
{
	public var name:String;
	public var duration:Int;
	public var elements:Array<Dynamic>;
	public var index:Int;
	public var motionObject:MotionObject;
	public var tweenType:String;

	public function new()
	{
		duration = 1;
		elements = new Array<Dynamic>();
	}

	private static function parseElements(elements:Iterator<haxe.xml.Fast>):Array<Dynamic>
	{
		var frameElements:Array<Dynamic> = [];
		for (childElement in elements)
		{
			switch (childElement.name)
			{
				case "DOMBitmapInstance":
					frameElements.push(DOMBitmapInstance.parse(childElement));
				case "DOMComponentInstance":
					frameElements.push(DOMComponentInstance.parse(childElement));
				case "DOMRectangleObject":
					frameElements.push(DOMRectangle.parse(childElement));
				case "DOMShape":
					frameElements.push(DOMShape.parse(childElement));
				case "DOMSymbolInstance":
					frameElements.push(DOMSymbolInstance.parse(childElement));
				case "DOMDynamicText":
					frameElements.push(DOMDynamicText.parse(childElement, DOMDynamicText.TYPE_DYNAMIC));
				case "DOMStaticText":
					frameElements.push(DOMStaticText.parse(childElement));
				case "DOMInputText":
					frameElements.push(DOMDynamicText.parse(childElement, DOMDynamicText.TYPE_INPUT));
				case "DOMGroup":
					for (frameElement in DOMFrame.parseElements(childElement.node.members.elements))
					{
						frameElements.push(frameElement);
					}
				case "DOMCompiledClipInstance":
				// no op
				default:
					trace("Warning: Unrecognized DOMFrame element '"
						+ childElement.name
						+ "' with name = '"
						+ (childElement.has.name ? childElement.att.name : "null" + "'"));
			}
		}
		return frameElements;
	}

	public static function parse(xml:Fast):DOMFrame
	{
		var frame:DOMFrame = new DOMFrame();
		frame.name = xml.has.name == true ? xml.att.name : null;
		frame.index = Std.parseInt(xml.att.index);
		frame.duration = xml.has.duration == true ? Std.parseInt(xml.att.duration) : 1;
		if (xml.has.tweenType) frame.tweenType = xml.att.tweenType;
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "DOMGroup":
					for (frameElement in DOMFrame.parseElements(element.node.members.elements))
					{
						frame.elements.push(frameElement);
					}
				case "elements":
					for (frameElement in DOMFrame.parseElements(element.elements))
					{
						frame.elements.push(frameElement);
					}
				case "motionObjectXML":
					frame.motionObject = MotionObject.parse(element);
			}
		}
		return frame;
	}
}
