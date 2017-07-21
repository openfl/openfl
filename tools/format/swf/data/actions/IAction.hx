package format.swf.data.actions;

import format.swf.SWFData;

interface IAction
{
	var code(default, null):Int;
	var length(default, null):Int;
	var lengthWithHeader(get, null):Int;
	var pos(default, null):Int;
	
	function parse(data:SWFData):Void;
	function publish(data:SWFData):Void;
	function clone():IAction;
	function toString(indent:Int = 0):String;
}