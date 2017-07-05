package format.swf.data.etc;

import flash.geom.Point;

class StraightEdge extends Edge
{
	public function new(aFrom:Point, aTo:Point, aLineStyleIdx:Int = 0, aFillStyleIdx:Int = 0)
	{
		super();
		from = aFrom;
		to = aTo;
		lineStyleIdx = aLineStyleIdx;
		fillStyleIdx = aFillStyleIdx;
	}

	public override function reverseWithNewFillStyle(newFillStyleIdx:Int):Edge {
		return new StraightEdge(to, from, lineStyleIdx, newFillStyleIdx);
	}

	public function toString():String {
		return "stroke:" + lineStyleIdx + ", fill:" + fillStyleIdx + ", start:" + from.toString() + ", end:" + to.toString();
	}
}