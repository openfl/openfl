package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.NumberUtils;

import flash.geom.Rectangle;

class SWFRectangle
{
	public var xmin:Int;
	public var xmax:Int;
	public var ymin:Int;
	public var ymax:Int;
	
	public var rect (get_rect, null):Rectangle;
	private var _rectangle:Rectangle;
	
	public function new(data:SWFData = null) {
		xmax = 11000;
		ymax = 8000;
		_rectangle = new Rectangle();
		if (data != null) {
			parse(data);
		}
	}

	public function parse(data:SWFData):Void {
		data.resetBitsPending();
		var bits:Int = data.readUB(5);
		xmin = data.readSB(bits);
		xmax = data.readSB(bits);
		ymin = data.readSB(bits);
		ymax = data.readSB(bits);
	}
	
	public function publish(data:SWFData):Void {
		var numBits:Int = data.calculateMaxBits(true, [xmin, xmax, ymin, ymax]);
		data.resetBitsPending();
		data.writeUB(5, numBits);
		data.writeSB(numBits, xmin);
		data.writeSB(numBits, xmax);
		data.writeSB(numBits, ymin);
		data.writeSB(numBits, ymax);
	}
	
	public function clone():SWFRectangle {
		var rect:SWFRectangle = new SWFRectangle();
		rect.xmin = xmin;
		rect.xmax = xmax;
		rect.ymin = ymin;
		rect.ymax = ymax;
		return rect;
	}
	
	private function get_rect():Rectangle {
		_rectangle.left = NumberUtils.roundPixels20(xmin / 20);
		_rectangle.right = NumberUtils.roundPixels20(xmax / 20);
		_rectangle.top = NumberUtils.roundPixels20(ymin / 20);
		_rectangle.bottom = NumberUtils.roundPixels20(ymax / 20);
		return _rectangle;
	}
	
	public function toString():String {
		return "(" + xmin + "," + xmax + "," + ymin + "," + ymax + ")";
	}
	
	public function toStringSize():String {
		return "(" + (xmax / 20 - xmin / 20) + "," + (ymax / 20 - ymin / 20) + ")";
	}
}