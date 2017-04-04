package format.swf.timeline;

class LayerStrip
{
	public static inline var TYPE_EMPTY:Int = 0;
	public static inline var TYPE_SPACER:Int = 1;
	public static inline var TYPE_STATIC:Int = 2;
	public static inline var TYPE_MOTIONTWEEN:Int = 3;
	public static inline var TYPE_SHAPETWEEN:Int = 4;
	
	public var type:Int = TYPE_EMPTY;
	public var startFrameIndex:Int = 0;
	public var endFrameIndex:Int = 0;
	
	public function new(type:Int, startFrameIndex:Int, endFrameIndex:Int)
	{
		this.type = type;
		this.startFrameIndex = startFrameIndex;
		this.endFrameIndex = endFrameIndex;
	}
	
	public function toString():String {
		var str:String;
		if(startFrameIndex == endFrameIndex) {
			str = "Frame: " + startFrameIndex;
		} else {
			str = "Frames: " + startFrameIndex + "-" + endFrameIndex;
		}
		str += ", Type: ";
		switch(type) {
			case TYPE_EMPTY: str += "EMPTY";
			case TYPE_SPACER: str += "SPACER";
			case TYPE_STATIC: str += "STATIC";
			case TYPE_MOTIONTWEEN: str += "MOTIONTWEEN";
			case TYPE_SHAPETWEEN: str += "SHAPETWEEN";
			default: str += "unknown";
		}
		return str;
	}
}