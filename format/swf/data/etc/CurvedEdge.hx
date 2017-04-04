package format.swf.data.etc;

import flash.geom.Point;

class CurvedEdge extends StraightEdge implements IEdge
{
	public var control(default, null):Point;
	
	public function new(aFrom:Point, aControl:Point, aTo:Point, aLineStyleIdx:Int = 0, aFillStyleIdx:Int = 0)
	{
		super(aFrom, aTo, aLineStyleIdx, aFillStyleIdx);
		control = aControl;
	}
	
	override public function reverseWithNewFillStyle(newFillStyleIdx:Int):IEdge {
		return new CurvedEdge(to, control, from, lineStyleIdx, newFillStyleIdx);
	}
	
	override public function toString():String {
		return "stroke:" + lineStyleIdx + ", fill:" + fillStyleIdx + ", start:" + from.toString() + ", control:" + control.toString() + ", end:" + to.toString();
	}
}