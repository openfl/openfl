package format.swf.data;

import format.swf.SWFData;

import flash.geom.Matrix;
import flash.geom.Point;

class SWFMatrix
{
	public var matrix(get_matrix, null):Matrix;
	public var scaleX:Float = 1.0;
	public var scaleY:Float = 1.0;
	public var rotateSkew0:Float = 0.0;
	public var rotateSkew1:Float = 0.0;
	public var translateX:Int = 0;
	public var translateY:Int = 0;
	
	public var xscale:Float;
	public var yscale:Float;
	public var rotation:Float;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	private function get_matrix():Matrix {
		return new Matrix(scaleX, rotateSkew0, rotateSkew1, scaleY, translateX, translateY);
	}
	
	public function parse(data:SWFData):Void {
		data.resetBitsPending();
		scaleX = 1.0;
		scaleY = 1.0;
		if (data.readUB(1) == 1) {
			var scaleBits:Int = data.readUB(5);
			scaleX = data.readFB(scaleBits);
			scaleY = data.readFB(scaleBits);
		}
		rotateSkew0 = 0.0;
		rotateSkew1 = 0.0;
		if (data.readUB(1) == 1) {
			var rotateBits:Int = data.readUB(5);
			rotateSkew0 = data.readFB(rotateBits);
			rotateSkew1 = data.readFB(rotateBits);
		}
		var translateBits:Int = data.readUB(5);
		translateX = data.readSB(translateBits);
		translateY = data.readSB(translateBits);
		// conversion to rotation, xscale, yscale
		var px:Point = matrix.deltaTransformPoint(new Point(0, 1));
		rotation = ((180 / Math.PI) * Math.atan2(px.y, px.x) - 90);
		if(rotation < 0) { rotation = 360 + rotation; }
		xscale = Math.sqrt(scaleX * scaleX + rotateSkew0 * rotateSkew0) * (scaleX < 0 ? -1 : 1);
		yscale = Math.sqrt(rotateSkew1 * rotateSkew1 + scaleY * scaleY) * (scaleY < 0 ? -1 : 1);
	}
	
	public function clone():SWFMatrix {
		var matrix:SWFMatrix = new SWFMatrix();
		matrix.scaleX = scaleX;
		matrix.scaleY = scaleY;
		matrix.rotateSkew0 = rotateSkew0;
		matrix.rotateSkew1 = rotateSkew1;
		matrix.translateX = translateX;
		matrix.translateY = translateY;
		return matrix;
	}
	
	public function isIdentity():Bool {
		return (scaleX == 1 && scaleY == 1 && rotateSkew0 == 0 && rotateSkew1 == 0 && translateX == 0 && translateY == 0);
	}
	
	public function toString():String {
		return "(" + scaleX + "," + rotateSkew0 + "," + rotateSkew1 + "," + scaleY + "," + translateX + "," + translateY + ")";
	}
}
