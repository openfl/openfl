package format.swf.data.etc;

import flash.geom.Point;

class StraightEdge implements IEdge
{
	public var from(default, null):Point;
	public var to(default, null):Point;
	public var lineStyleIdx(default, null):Int;
	public var fillStyleIdx(default, null):Int;
	
	public function new(aFrom:Point, aTo:Point, aLineStyleIdx:Int = 0, aFillStyleIdx:Int = 0)
	{
		from = aFrom;
		to = aTo;
		lineStyleIdx = aLineStyleIdx;
		fillStyleIdx = aFillStyleIdx;
	}
	
	public function reverseWithNewFillStyle(newFillStyleIdx:Int):IEdge {
		return new StraightEdge(to, from, lineStyleIdx, newFillStyleIdx);
	}
	
	public function toString():String {
		return "stroke:" + lineStyleIdx + ", fill:" + fillStyleIdx + ", start:" + from.toString() + ", end:" + to.toString();
	}
}