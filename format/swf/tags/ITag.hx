package format.swf.tags;

import format.swf.SWFData;

interface ITag
{
	var type(default, null):Int;
	var name(default, null):String;
	var version(default, null):Int;
	var level(default, null):Int;
	
	function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void;
	function publish(data:SWFData, version:Int):Void;
	function toString(indent:Int = 0):String;
}