package format.swf.tags;

import format.swf.utils.StringUtils;

class Tag
{
	public static function toStringCommon(type:Int, name:String, indent:Int = 0):String {
		return StringUtils.repeat(indent) + "[" + StringUtils.printf("%02d", [type]) + ":" + name + "] ";
	}
}