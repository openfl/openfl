package openfl._internal.formats.xfl.geom;

import haxe.xml.Fast;

class MotionObject
{
	public var duration:Int;
	public var timeScale:Int;

	public function new() {}

	public static function parse(xml:Fast):MotionObject
	{
		var motionObject = new MotionObject();
		for (element in xml.elements)
		{
			switch (element.name)
			{
				case "AnimationCore":
					if (xml.has.TimeScale) motionObject.timeScale = Std.parseInt(xml.att.TimeScale);
					if (xml.has.duration) motionObject.duration = Std.parseInt(xml.att.duration);
					for (childElement in element.elements)
					{
						switch (childElement.name)
						{
							case "TimeMap":
							case "PropertyContainer":
						}
					}
			}
		}
		return motionObject;
	}
}
