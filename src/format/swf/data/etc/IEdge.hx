package format.swf.data.etc;

import flash.geom.Point;

interface IEdge
{
	var from(default, null):Point;
	var to(default, null):Point;
	var lineStyleIdx(default, null):Int;
	var fillStyleIdx(default, null):Int;
	
	function reverseWithNewFillStyle(newFillStyleIdx:Int):IEdge;
}