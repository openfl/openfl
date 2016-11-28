package format.swf.data;

import format.swf.SWFData;

class SWFShapeRecord
{
	public static inline var TYPE_UNKNOWN:Int = 0;
	public static inline var TYPE_END:Int = 1;
	public static inline var TYPE_STYLECHANGE:Int = 2;
	public static inline var TYPE_STRAIGHTEDGE:Int = 3;
	public static inline var TYPE_CURVEDEDGE:Int = 4;
	
	public var type(get_type, null):Int;
	public var isEdgeRecord(get_isEdgeRecord, null):Bool;
	
	public function new(data:SWFData = null, level:Int = 1) {
		if (data != null) {
			parse(data, level);
		}
	}
	
	private function get_type():Int { return TYPE_UNKNOWN; }
	
	private function get_isEdgeRecord():Bool {
		return (type == TYPE_STRAIGHTEDGE || type == TYPE_CURVEDEDGE);
	}
	
	public function parse(data:SWFData = null, level:Int = 1):Void {}

	public function publish(data:SWFData = null, level:Int = 1):Void {}
	
	public function clone():SWFShapeRecord { return null; }
	
	public function toString(indent:Int = 0):String {
		return "[SWFShapeRecord]";
	}
}