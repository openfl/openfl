package openfl.filters;

import lime.utils.UInt8Array;
import openfl.geom.Rectangle;

class FilterUtils {

	private static inline function fromPreMult( col:Float, alpha:Float, strength:Float ) : Int {
        var col = Std.int(col * strength / alpha * 255) ;
		return col < 0 ? 0 : (col > 255 ? 255 : col);
	}

	public static function GaussianBlur ( imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, bx:Float, by:Float, quality:Int, strength:Float = 1, oX:Int = 0, oY:Int = 0) {
		var n = (quality * 2) - 1;
		var rng = Math.pow(2, quality) * 0.125;
		
		var bxs = boxesForGauss(bx * rng, n);
		var bys = boxesForGauss(by * rng, n);
        var offset:Int = Std.int( (w * oY + oX) * 4 );

        boxBlur (imgA, imgB, w, h, (bxs[0]-1)/2, (bys[0]-1)/2);
		boxBlur (imgB, imgA, w, h, (bxs[1]-1)/2, (bys[1]-1)/2);
		boxBlur (imgA, imgB, w, h, (bxs[2]-1)/2, (bys[2]-1)/2);
		
		var i:Int = 0;
        if (offset < 0) {
            while (i < imgA.length) {
                imgB[ i + offset] = fromPreMult( imgB[ i ], imgB[ i + 3 ], strength);
                imgB[ i + 1 + offset] = fromPreMult( imgB[ i + 1 ], imgB[ i + 3 ], strength);
                imgB[ i + 2 + offset] = fromPreMult( imgB[ i + 2 ], imgB[ i + 3 ], strength);
                imgB[ i + 3 + offset] = imgB[ i + 3 ];
                i += 4;
            }
        } else {
            i = imgA.length - 4;
            while (i >= 0) {
                imgB[ i + offset] = fromPreMult( imgB[ i ], imgB[ i + 3 ], strength);
                imgB[ i + 1 + offset] = fromPreMult( imgB[ i + 1 ], imgB[ i + 3 ], strength);
                imgB[ i + 2 + offset] = fromPreMult( imgB[ i + 2 ], imgB[ i + 3 ], strength);
                imgB[ i + 3 + offset] = imgB[ i + 3 ];
                i -= 4;
            }
        }
	}

	// standard deviation, number of boxes
	private static function boxesForGauss( sigma:Float, n:Int ):Array<Float>
	{
		var wIdeal = Math.sqrt((12*sigma*sigma/n)+1);  // Ideal averaging filter width 
		var wl = Math.floor(wIdeal);
		if (wl % 2 == 0) wl--;
		var wu = wl+2;
					
		var mIdeal = (12*sigma*sigma - n*wl*wl - 4*n*wl - 3*n)/(-4*wl - 4);
		var m = Math.round(mIdeal);			
		var sizes:Array<Float> = [];
		for (i in 0...n)
			sizes.push( i < m ? wl : wu);

		return sizes;
	}

	private static function boxBlur ( imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, bx:Float, by:Float ) {
		for(i in 0...imgA.length)
			imgB[i] = imgA[i];

		boxBlurH(imgB, imgA, w, h, Std.int(bx), 0);
		boxBlurH(imgB, imgA, w, h, Std.int(bx), 1);
		boxBlurH(imgB, imgA, w, h, Std.int(bx), 2);
		boxBlurH(imgB, imgA, w, h, Std.int(bx), 3);
		
		boxBlurT(imgA, imgB, w, h, Std.int(by), 0);
		boxBlurT(imgA, imgB, w, h, Std.int(by), 1);
		boxBlurT(imgA, imgB, w, h, Std.int(by), 2);
		boxBlurT(imgA, imgB, w, h, Std.int(by), 3);
	}
	
	private static function boxBlurH ( imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, r:Int, off:Int ) {
		var iarr = 1 / (r+r+1);
        for (i in 0...h) {
			var ti = i*w, li = ti, ri = ti+r;
			var fv = imgA[ti * 4 + off], lv = imgA[(ti+w-1) * 4 + off], val = (r+1)*fv;
			
			for (j in 0...r)
				val += imgA[(ti+j) * 4 + off];

			for (j in 0...r+1) {
				val += imgA[ri * 4 + off] - fv;
				imgB[ti * 4 + off] = Math.round(val*iarr);
				ri++;
				ti++;
			}

			for (j in r+1...w-r) {
				val += imgA[ri * 4 + off] - imgA[li * 4 + off];
				imgB[ti * 4 + off] = Math.round(val*iarr);
				ri++;
				li++;
				ti++;
			}

			for (j in w-r...w) {
				val += lv - imgA[li * 4 + off];
				imgB[ti * 4 + off] = Math.round(val*iarr);
				li++;
				ti++;
			}
		}
	}
	
	private static function boxBlurT ( imgA:UInt8Array, imgB:UInt8Array, w:Int, h:Int, r:Int, off:Int ) {
		var iarr = 1 / (r+r+1);
		var ws = w * 4;
        for (i in 0...w) {
			var ti = i * 4 + off, li = ti, ri = ti+(r*ws);
			var fv = imgA[ti], lv = imgA[ti+(ws*(h-1))], val = (r+1)*fv;
			for (j in 0...r)
				val += imgA[ti+j*ws];

			for (j in 0...r+1) {
				val += imgA[ri] - fv;
				imgB[ti] = Math.round(val*iarr);
				ri+=ws; ti+=ws;
			}

			for (j in r+1...h-r) {
				val += imgA[ri] - imgA[li];
				imgB[ti] = Math.round(val*iarr);
				li+=ws;
				ri+=ws;
				ti+=ws;
			}

			for (j in h-r...h) {
				val += lv - imgA[li];
				imgB[ti] = Math.round(val*iarr);
				li+=ws;
				ti+=ws;
			}
		}
	}
}