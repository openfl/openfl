package format.swf.data.etc;

import flash.geom.Point;

class Edge implements IEdge implements hxbit.Serializable
{
	@:s public var from(default, null):Point;
	@:s public var to(default, null):Point;
	@:s public var lineStyleIdx(default, null):Int;
	@:s public var fillStyleIdx(default, null):Int;

	public function new()
	{

	}

    public function reverseWithNewFillStyle(newFillStyleIdx:Int):Edge {
		return new Edge();
	}
}