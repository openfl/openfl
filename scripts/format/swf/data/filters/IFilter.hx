package format.swf.data.filters;

import openfl._internal.formats.swf.FilterType;
import format.swf.SWFData;
import flash.filters.BitmapFilter;

interface IFilter
{
	var id(default, null):Int;
	var filter(get, null):BitmapFilter;
	var type(get, null):FilterType;
	function parse(data:SWFData):Void;
	function publish(data:SWFData):Void;
	function clone():IFilter;
	function toString(indent:Int = 0):String;
}
