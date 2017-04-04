package format.swf.data;

import format.swf.SWFData;

class SWFColorTransformWithAlpha extends SWFColorTransform
{
	public function new(data:SWFData = null) {
		super(data);
	}
	
	override public function parse(data:SWFData):Void {
		data.resetBitsPending();
		hasAddTerms = (data.readUB(1) == 1);
		hasMultTerms = (data.readUB(1) == 1);
		var bits:Int = data.readUB(4);
		rMult = 0xFF;
		gMult = 0xFF;
		bMult = 0xFF;
		aMult = 0xFF;
		if (hasMultTerms) {
			rMult = data.readSB(bits);
			gMult = data.readSB(bits);
			bMult = data.readSB(bits);
			aMult = data.readSB(bits);
		}
		rAdd = 0;
		gAdd = 0;
		bAdd = 0;
		aAdd = 0;
		if (hasAddTerms) {
			rAdd = data.readSB(bits);
			gAdd = data.readSB(bits);
			bAdd = data.readSB(bits);
			aAdd = data.readSB(bits);
		}
	}
	
	override public function publish(data:SWFData):Void {
		data.resetBitsPending();
		data.writeUB(1, hasAddTerms ? 1 : 0);
		data.writeUB(1, hasMultTerms ? 1 : 0);
		var values:Array<Int> = [];
		if (hasMultTerms) { values.push(rMult); values.push(gMult); values.push(bMult); values.push(aMult); }
		if (hasAddTerms) { values.push(rAdd); values.push(gAdd); values.push(bAdd); values.push(aAdd); }
		var bits:Int = (hasMultTerms || hasAddTerms) ? data.calculateMaxBits(true, values) : 1;
		data.writeUB(4, bits);
		if (hasMultTerms) {
			data.writeSB(bits, rMult);
			data.writeSB(bits, gMult);
			data.writeSB(bits, bMult);
			data.writeSB(bits, aMult);
		}
		if (hasAddTerms) {
			data.writeSB(bits, rAdd);
			data.writeSB(bits, gAdd);
			data.writeSB(bits, bAdd);
			data.writeSB(bits, aAdd);
		}
	}
	
	override public function clone():SWFColorTransform {
		var colorTransform:SWFColorTransformWithAlpha = new SWFColorTransformWithAlpha();
		colorTransform.hasAddTerms = hasAddTerms;
		colorTransform.hasMultTerms = hasMultTerms;
		colorTransform.rMult = rMult;
		colorTransform.gMult = gMult;
		colorTransform.bMult = bMult;
		colorTransform.aMult = aMult;
		colorTransform.rAdd = rAdd;
		colorTransform.gAdd = gAdd;
		colorTransform.bAdd = bAdd;
		colorTransform.aAdd = aAdd;
		return colorTransform;
	}
	
	override public function toString():String {
		return ("(redMultiplier=" + rMult + ", greenMultiplier=" + gMult + ", blueMultiplier=" + bMult + ", alphaMultiplier=" + aMult + ", redOffset=" + rAdd + ", greenOffset=" + gAdd + ", blueOffset=" + bAdd + ", alphaOffset=" + aAdd +")");
	}
}