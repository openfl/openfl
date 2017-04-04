package format.swf.data;

class SWFShapeRecordEnd extends SWFShapeRecord
{
	public function new() {
		super ();
	}
	
	override public function clone():SWFShapeRecord { return new SWFShapeRecordEnd(); }
	
	override private function get_type():Int { return SWFShapeRecord.TYPE_END; }

	override public function toString(indent:Int = 0):String {
		return "[SWFShapeRecordEnd]";
	}
}