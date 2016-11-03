package format.swf.data;

import flash.geom.ColorTransform;
import format.swf.SWFData;

class SWFColorTransform
{
	public var colorTransform(get_colorTransform, null):ColorTransform;
	public var rMult:Int = 0xFF;
	public var gMult:Int = 0xFF;
	public var bMult:Int = 0xFF;
	public var rAdd:Int = 0;
	public var gAdd:Int = 0;
	public var bAdd:Int = 0;

	public var aMult:Int = 0xFF;
	public var aAdd:Int = 0;
	
	public var hasMultTerms:Bool;
	public var hasAddTerms:Bool;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	private function get_colorTransform():ColorTransform {
		return new ColorTransform(rMult / 0xFF, gMult / 0xFF, bMult / 0xFF, aMult / 0xFF, rAdd, gAdd, bAdd, aAdd);
	}
	
	public function parse(data:SWFData):Void {
		data.resetBitsPending();
		hasAddTerms = (data.readUB(1) == 1);
		hasMultTerms = (data.readUB(1) == 1);
		var bits:Int = data.readUB(4);
		rMult = 0xFF;
		gMult = 0xFF;
		bMult = 0xFF;
		if (hasMultTerms) {
			rMult = data.readSB(bits);
			gMult = data.readSB(bits);
			bMult = data.readSB(bits);
		}
		rAdd = 0;
		gAdd = 0;
		bAdd = 0;
		if (hasAddTerms) {
			rAdd = data.readSB(bits);
			gAdd = data.readSB(bits);
			bAdd = data.readSB(bits);
		}
	}
	
	public function publish(data:SWFData):Void {
		data.resetBitsPending();
		data.writeUB(1, hasAddTerms ? 1 : 0);
		data.writeUB(1, hasMultTerms ? 1 : 0);
		var values:Array<Int> = [];
		if (hasMultTerms) { values.push(rMult); values.push(gMult); values.push(bMult); }
		if (hasAddTerms) { values.push(rAdd); values.push(gAdd); values.push(bAdd); }
		var bits:Int = data.calculateMaxBits(true, values);
		data.writeUB(4, bits);
		if (hasMultTerms) {
			data.writeSB(bits, rMult);
			data.writeSB(bits, gMult);
			data.writeSB(bits, bMult);
		}
		if (hasAddTerms) {
			data.writeSB(bits, rAdd);
			data.writeSB(bits, gAdd);
			data.writeSB(bits, bAdd);
		}
	}
	
	public function clone():SWFColorTransform {
		var colorTransform:SWFColorTransform = new SWFColorTransform();
		colorTransform.hasAddTerms = hasAddTerms;
		colorTransform.hasMultTerms = hasMultTerms;
		colorTransform.rMult = rMult;
		colorTransform.gMult = gMult;
		colorTransform.bMult = bMult;
		colorTransform.rAdd = rAdd;
		colorTransform.gAdd = gAdd;
		colorTransform.bAdd = bAdd;
		return colorTransform;
	}
	
	public function isIdentity():Bool {
		return (rMult == 1 && gMult == 1 && bMult == 1 && aMult == 1)
			&& (rAdd == 0 && gAdd == 0 && bAdd == 0 && aAdd == 0);
	}
	
	public function toString():String {
		return ("(redMultiplier=" + rMult + ", greenMultiplier=" + gMult + ", blueMultiplier=" + bMult + ", alphaMultiplier=" + aMult + ", redOffset=" + rAdd + ", greenOffset=" + gAdd + ", blueOffset=" + bAdd + ", alphaOffset=" + aAdd +")");
	}
}
