package openfl._internal.data;


import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.IBitmapDrawable;
import openfl.errors.IOError;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

#if js
import js.html.CanvasElement;
import js.html.Image;
import js.html.Uint8ClampedArray;
import js.Browser;
#end

@:access(openfl.display.BitmapData)


class CanvasBitmapData {
	
	
	private static var __base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var __base64Encoder:BaseCode;
	
	
	public static inline function applyFilter (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		#if js
		if (!bitmapData.__isValid || sourceBitmapData == null || !sourceBitmapData.__isValid) return;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		convertToCanvas (sourceBitmapData);
		createImageData (sourceBitmapData);
		
		filter.__applyFilter (bitmapData.__sourceImageData, sourceBitmapData.__sourceImageData, sourceRect, destPoint);
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	private static function base64Encode (bytes:ByteArray):String {
		
		#if js
		var extension = switch (bytes.length % 3) {
			
			case 1: "==";
			case 2: "=";
			default: "";
			
		}
		
		if (__base64Encoder == null) {
			
			__base64Encoder = new BaseCode (Bytes.ofString (__base64Chars));
			
		}
		
		return __base64Encoder.encodeBytes (Bytes.ofData (cast bytes.byteView)).toString () + extension;
		#else
		return "";
		#end
		
	}
	
	
	private static function clipRect (bitmapData:BitmapData, r:Rectangle):Rectangle {
		
		if (r == null) return null;
		
		if (r.x < 0) {
			
			r.width -= -r.x;
			r.x = 0;
			
			if (r.x + r.width <= 0) return null;
			
		}
		
		if (r.y < 0) {
			
			r.height -= -r.y;
			r.y = 0;
			
			if (r.y + r.height <= 0) return null;
			
		}
		
		if (r.x + r.width >= bitmapData.width) {
			
			r.width -= r.x + r.width - bitmapData.width;
			
			if (r.width <= 0) return null;
			
		}
		
		if (r.y + r.height >= bitmapData.height) {
			
			r.height -= r.y + r.height - bitmapData.height;
			
			if (r.height <= 0) return null;
			
		}
		
		return r;
		
	}
	
	
	public static inline function clone (bitmapData:BitmapData):BitmapData {
		
		#if js
		syncImageData (bitmapData);
		
		if (!bitmapData.__isValid) {
			
			return new BitmapData (bitmapData.width, bitmapData.height, bitmapData.transparent);
			
		} else if (bitmapData.__sourceImage != null) {
			
			return BitmapData.fromImage (new lime.graphics.Image (bitmapData.__sourceImage, bitmapData.width, bitmapData.height), bitmapData.transparent);
			
		} else {
			
			return BitmapData.fromCanvas (bitmapData.__sourceCanvas, bitmapData.transparent);
			
		}
		#else
		return null;
		#end
		
	}
	
	
	public static inline function colorTransform (bitmapData:BitmapData, rect:Rectangle, colorTransform:ColorTransform):Void {
		
		// TODO, could we handle this with 'destination-atop' or 'source-atop' composition modes instead?
		
		#if js
		rect = clipRect (bitmapData, rect);
		if (!bitmapData.__isValid || rect == null) return;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var data = bitmapData.__sourceImageData.data;
		var stride = bitmapData.width * 4;
		var offset:Int;
		
		for (row in Std.int (rect.y)...Std.int (rect.height)) {
			
			for (column in Std.int (rect.x)...Std.int (rect.width)) {
				
				offset = (row * stride) + (column * 4);
				
				data[offset] = Std.int ((data[offset] * colorTransform.redMultiplier) + colorTransform.redOffset);
				data[offset + 1] = Std.int ((data[offset + 1] * colorTransform.greenMultiplier) + colorTransform.greenOffset);
				data[offset + 2] = Std.int ((data[offset + 2] * colorTransform.blueMultiplier) + colorTransform.blueOffset);
				data[offset + 3] = Std.int ((data[offset + 3] * colorTransform.alphaMultiplier) + colorTransform.alphaOffset);
				
			}
			
		}
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static function convertToCanvas (bitmapData:BitmapData):Void {
		
		#if js
		if (bitmapData.__loading) return;
		
		if (bitmapData.__sourceImage != null) {
			
			if (bitmapData.__sourceCanvas == null) {
				
				createCanvas (bitmapData, bitmapData.__sourceImage.width, bitmapData.__sourceImage.height);
				bitmapData.__sourceContext.drawImage (bitmapData.__sourceImage, 0, 0);
				
			}
			
			bitmapData.__sourceImage = null;
			
		}
		#end
		
	}
	
	
	public static inline function copyChannel (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:Int, destChannel:Int):Void {
		
		#if js
		sourceRect = clipRect (bitmapData, sourceRect);
		if (!bitmapData.__isValid || sourceRect == null) return;
		
		if (destChannel == BitmapDataChannel.ALPHA && !bitmapData.transparent) return;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		if (sourceRect.x + sourceRect.width > sourceBitmapData.width) sourceRect.width = sourceBitmapData.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceBitmapData.height) sourceRect.height = sourceBitmapData.height - sourceRect.y;
		
		var destIdx = -1;
		
		if (destChannel == BitmapDataChannel.ALPHA) { 
			
			destIdx = 3;
			
		} else if (destChannel == BitmapDataChannel.BLUE) {
			
			destIdx = 2;
			
		} else if (destChannel == BitmapDataChannel.GREEN) {
			
			destIdx = 1;
			
		} else if (destChannel == BitmapDataChannel.RED) {
			
			destIdx = 0;
			
		} else {
			
			throw "Invalid destination BitmapDataChannel passed to BitmapData::copyChannel.";
			
		}
		
		var srcIdx = -1;
		
		if (sourceChannel == BitmapDataChannel.ALPHA) {
			
			srcIdx = 3;
			
		} else if (sourceChannel == BitmapDataChannel.BLUE) {
			
			srcIdx = 2;
			
		} else if (sourceChannel == BitmapDataChannel.GREEN) {
			
			srcIdx = 1;
			
		} else if (sourceChannel == BitmapDataChannel.RED) {
			
			srcIdx = 0;
			
		} else {
			
			throw "Invalid source BitmapDataChannel passed to BitmapData::copyChannel.";
			
		}
		
		convertToCanvas (sourceBitmapData);
		createImageData (sourceBitmapData);
		
		var srcData = sourceBitmapData.__sourceImageData.data;
		var srcStride = Std.int (sourceBitmapData.width * 4);
		var srcPosition = Std.int ((sourceRect.x * 4) + (srcStride * sourceRect.y) + srcIdx);
		var srcRowOffset = srcStride - Std.int (4 * sourceRect.width);
		var srcRowEnd = Std.int (4 * (sourceRect.x + sourceRect.width));
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var destData = bitmapData.__sourceImageData.data;
		var destStride = Std.int (bitmapData.width * 4);
		var destPosition = Std.int ((destPoint.x * 4) + (destStride * destPoint.y) + destIdx);
		var destRowOffset = destStride - Std.int (4 * sourceRect.width);
		var destRowEnd = Std.int (4 * (destPoint.x + sourceRect.width));
		
		var length = Std.int (sourceRect.width * sourceRect.height);
		
		for (i in 0...length) {
			
			destData[destPosition] = srcData[srcPosition];
			
			srcPosition += 4;
			destPosition += 4;
			
			if ((srcPosition % srcStride) > srcRowEnd) {
				
				srcPosition += srcRowOffset;
				
			}
			
			if ((destPosition % destStride) > destRowEnd) {
				
				destPosition += destRowOffset;
				
			}
			
		}
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static inline function copyPixels (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		#if js
		if (!bitmapData.__isValid || sourceBitmapData == null) return;
		
		if (sourceRect.x + sourceRect.width > sourceBitmapData.width) sourceRect.width = sourceBitmapData.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceBitmapData.height) sourceRect.height = sourceBitmapData.height - sourceRect.y;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		
		if (alphaBitmapData != null && alphaBitmapData.transparent) {
			
			if (alphaPoint == null) alphaPoint = new Point ();
			
			var tempData = clone (bitmapData);
			tempData.copyChannel (alphaBitmapData, new Rectangle (alphaPoint.x, alphaPoint.y, sourceRect.width, sourceRect.height), new Point (sourceRect.x, sourceRect.y), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			sourceBitmapData = tempData;
			
		}
		
		syncImageData (bitmapData);
		
		if (!mergeAlpha) {
			
			if (bitmapData.transparent && sourceBitmapData.transparent) {
				
				bitmapData.__sourceContext.clearRect (destPoint.x, destPoint.y, sourceRect.width, sourceRect.height);
				
			}
			
		}
		
		syncImageData (sourceBitmapData);
		
		if (sourceBitmapData.__sourceImage != null) {
			
			bitmapData.__sourceContext.drawImage (sourceBitmapData.__sourceImage, Std.int (sourceRect.x), Std.int (sourceRect.y), Std.int (sourceRect.width), Std.int (sourceRect.height), Std.int (destPoint.x), Std.int (destPoint.y), Std.int (sourceRect.width), Std.int (sourceRect.height));
			
		} else if (sourceBitmapData.__sourceCanvas != null) {
			
			bitmapData.__sourceContext.drawImage (sourceBitmapData.__sourceCanvas, Std.int (sourceRect.x), Std.int (sourceRect.y), Std.int (sourceRect.width), Std.int (sourceRect.height), Std.int (destPoint.x), Std.int (destPoint.y), Std.int (sourceRect.width), Std.int (sourceRect.height));
			
		}
		#end
		
	}
	
	
	public static inline function create (bitmapData:BitmapData, fillColor:Int):Void {
		
		#if js
		createCanvas (bitmapData, bitmapData.width, bitmapData.height);
		#end
		
		if (!bitmapData.transparent) {
			
			fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
			
		}
		
		__fillRect (bitmapData, new Rectangle (0, 0, bitmapData.width, bitmapData.height), fillColor);
		
	}
	
	
	private static inline function createCanvas (bitmapData:BitmapData, width:Int, height:Int):Void {
		
		#if js
		if (bitmapData.__sourceCanvas == null) {
			
			bitmapData.__sourceCanvas = cast Browser.document.createElement ("canvas");		
			bitmapData.__sourceCanvas.width = bitmapData.width;
			bitmapData.__sourceCanvas.height = bitmapData.height;
			
			if (!bitmapData.transparent) {
				
				if (!bitmapData.transparent) bitmapData.__sourceCanvas.setAttribute ("moz-opaque", "true");
				bitmapData.__sourceContext = untyped __js__ ('bitmapData.__sourceCanvas.getContext ("2d", { alpha: false })');
				
			} else {
				
				bitmapData.__sourceContext = bitmapData.__sourceCanvas.getContext ("2d");
				
			}
			
			untyped (bitmapData.__sourceContext).mozImageSmoothingEnabled = false;
			untyped (bitmapData.__sourceContext).webkitImageSmoothingEnabled = false;
			bitmapData.__sourceContext.imageSmoothingEnabled = false;
			bitmapData.__isValid = true;
			
		}
		#end
		
	}
	
	
	private static inline function createImageData (bitmapData:BitmapData):Void {
		
		#if js
		if (bitmapData.__sourceImageData == null) {
			
			bitmapData.__sourceImageData = bitmapData.__sourceContext.getImageData (0, 0, bitmapData.width, bitmapData.height);
			
		}
		#end
		
	}
	
	
	public static inline function dispose (bitmapData:BitmapData):Void {
		
		#if js
		bitmapData.__sourceImage = null;
		bitmapData.__sourceCanvas = null;
		bitmapData.__sourceContext = null;
		#end
		
	}
	
	
	public static inline function draw (bitmapData:BitmapData, source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		#if js
		if (!bitmapData.__isValid) return;
		
		convertToCanvas (bitmapData);
		syncImageData (bitmapData);
		
		var renderSession = new RenderSession ();
		renderSession.context = bitmapData.__sourceContext;
		renderSession.roundPixels = true;
		
		if (!smoothing) {
			
			untyped (bitmapData.__sourceContext).mozImageSmoothingEnabled = false;
			untyped (bitmapData.__sourceContext).webkitImageSmoothingEnabled = false;
			bitmapData.__sourceContext.imageSmoothingEnabled = false;
			
		}
		
		var matrixCache = source.__worldTransform;
		source.__worldTransform = matrix != null ? matrix : new Matrix ();
		source.__updateChildren (false);
		source.__renderCanvas (renderSession);
		source.__worldTransform = matrixCache;
		source.__updateChildren (true);
		
		if (!smoothing) {
			
			untyped (bitmapData.__sourceContext).mozImageSmoothingEnabled = true;
			untyped (bitmapData.__sourceContext).webkitImageSmoothingEnabled = true;
			bitmapData.__sourceContext.imageSmoothingEnabled = true;
			
		}
		
		bitmapData.__sourceContext.setTransform (1, 0, 0, 1, 0, 0);
		#end
		
	}
	
	
	public static inline function fillRect (bitmapData:BitmapData, rect:Rectangle, color:Int):Void {
		
		#if js
		rect = clipRect (bitmapData, rect);
		if (!bitmapData.__isValid || rect == null) return;
		
		convertToCanvas (bitmapData);
		syncImageData (bitmapData);
		
		var fill = true;
		
		if (rect.x == 0 && rect.y == 0 && rect.width == bitmapData.width && rect.height == bitmapData.height) {
			
			if (bitmapData.transparent && ((color & 0xFF000000) == 0)) {
				
				bitmapData.__sourceCanvas.width = bitmapData.width;
				fill = false;
				
			}
			
		}
		
		if (fill)
		__fillRect (bitmapData, rect, color);
		#end
		
	}
	
	
	private static inline function flipPixel (pixel:Int):Int {
		
		return (pixel & 0xFF) << 24 | (pixel >>  8 & 0xFF) << 16 | (pixel >> 16 & 0xFF) <<  8 | (pixel >> 24 & 0xFF);
		
	}
	
	
	public static inline function floodFill (bitmapData:BitmapData, x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!bitmapData.__isValid) return;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var data = bitmapData.__sourceImageData.data;
		
		var offset = ((y * (bitmapData.width * 4)) + (x * 4));
		var hitColorR = data[offset + 0];
		var hitColorG = data[offset + 1];
		var hitColorB = data[offset + 2];
		var hitColorA = bitmapData.transparent ? data[offset + 3] : 0xFF;
		
		var r = (color & 0xFF0000) >>> 16;
		var g = (color & 0x00FF00) >>> 8;
		var b = (color & 0x0000FF);
		var a = bitmapData.transparent ? (color & 0xFF000000) >>> 24 : 0xFF;
		
		if (hitColorR == r && hitColorG == g && hitColorB == b && hitColorA == a) return;
		
		var dx = [ 0, -1, 1, 0 ];
		var dy = [ -1, 0, 0, 1 ];
		
		var queue = new Array<Int> ();
		queue.push (x);
		queue.push (y);
		
		while (queue.length > 0) {
			
			var curPointY = queue.pop ();
			var curPointX = queue.pop ();
			
			for (i in 0...4) {
				
				var nextPointX = curPointX + dx[i];
				var nextPointY = curPointY + dy[i];
				
				if (nextPointX < 0 || nextPointY < 0 || nextPointX >= bitmapData.width || nextPointY >= bitmapData.height) {
					
					continue;
					
				}
				
				var nextPointOffset = (nextPointY * bitmapData.width + nextPointX) * 4;
				
				if (data[nextPointOffset + 0] == hitColorR && data[nextPointOffset + 1] == hitColorG && data[nextPointOffset + 2] == hitColorB && data[nextPointOffset + 3] == hitColorA) {
					
					data[nextPointOffset + 0] = r;
					data[nextPointOffset + 1] = g;
					data[nextPointOffset + 2] = b;
					data[nextPointOffset + 3] = a;
					
					queue.push(nextPointX);
					queue.push(nextPointY);
					
				}
				
			}
			
		}
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static inline function fromBase64 (base64:String, type:String, onload:BitmapData -> Void):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		loadFromBase64 (bitmapData, base64, type, onload);
		return bitmapData;
		
	}
	
	
	public static inline function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null, onload:BitmapData -> Void):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		loadFromBytes (bitmapData, bytes, rawAlpha, onload);
		return bitmapData;
		
	}
	
	
	public static inline function fromFile (path:String, onload:BitmapData -> Void = null, onfail:Void -> Void = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true);
		
		#if js
		bitmapData.__sourceImage = new Image ();	
		bitmapData.__sourceImage.onload = function (_) {
			
			bitmapData.width = bitmapData.__sourceImage.width;
			bitmapData.height = bitmapData.__sourceImage.height;
			bitmapData.rect = new Rectangle (0, 0, bitmapData.__sourceImage.width, bitmapData.__sourceImage.height);
			bitmapData.__isValid = true;
			
			if (onload != null) {
				
				onload (bitmapData);
				
			}
			
		}
		
		bitmapData.__sourceImage.onerror = function (_) {
			
			bitmapData.__isValid = false;
			if (onfail != null) {
				
				onfail ();
				
			}
		}
		
		bitmapData.__sourceImage.src = path;
		
		// Another IE9 bug: loading 20+ images fails unless this line is added.
		// (issue #1019768)
		if (bitmapData.__sourceImage.complete) { }
		#end
		
		return bitmapData;
		
	}
	
	
	public static inline function fromImage (image:lime.graphics.Image, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		#if js
		bitmapData.__sourceImage = image.src;
		#else
		image.premultiplyAlpha ();
		bitmapData.__sourceBytes = image.data;
		#end
		bitmapData.width = image.width;
		bitmapData.height = image.height;
		bitmapData.rect = new Rectangle (0, 0, image.width, image.height);
		bitmapData.__isValid = true;
		return bitmapData;
		
	}
	
	
	#if js
	public static inline function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, transparent);
		bitmapData.width = canvas.width;
		bitmapData.height = canvas.height;
		bitmapData.rect = new Rectangle (0, 0, canvas.width, canvas.height);
		createCanvas (bitmapData, canvas.width, canvas.height);
		bitmapData.__sourceContext.drawImage (canvas, 0, 0);
		return bitmapData;
		
	}
	#end
	
	
	#if js
	private static inline function getInt32 (bitmapData:BitmapData, offset:Int, data:Uint8ClampedArray) {
		
		return (bitmapData.transparent ? data[offset + 3] : 0xFF) << 24 | data[offset] << 16 | data[offset + 1] << 8 | data[offset + 2]; 
		
	}
	#end
	
	
	public static inline function getPixel (bitmapData:BitmapData, x:Int, y:Int):Int {
		
		#if js
		if (!bitmapData.__isValid || x < 0 || y < 0 || x >= bitmapData.width || y >= bitmapData.height) return 0;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var offset = (4 * y * bitmapData.width + x * 4);
		return (bitmapData.__sourceImageData.data[offset] << 16) | (bitmapData.__sourceImageData.data[offset + 1] << 8) | (bitmapData.__sourceImageData.data[offset + 2]);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getPixel32 (bitmapData:BitmapData, x:Int, y:Int):Int {
		
		#if js
		if (!bitmapData.__isValid || x < 0 || y < 0 || x >= bitmapData.width || y >= bitmapData.height) return 0;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		return getInt32 (bitmapData, (4 * y * bitmapData.width + x * 4), bitmapData.__sourceImageData.data);
		#else
		return 0;
		#end
		
	}
	
	
	public static inline function getPixels (bitmapData:BitmapData, rect:Rectangle):ByteArray {
		
		#if js
		if (!bitmapData.__isValid) return null;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var byteArray = new ByteArray ();
		
		if (rect == null || rect.equals (bitmapData.rect)) {
			
			byteArray.length = bitmapData.__sourceImageData.data.length;
			byteArray.byteView.set (bitmapData.__sourceImageData.data);
			
		} else {
			
			var srcData = bitmapData.__sourceImageData.data;
			var srcStride = Std.int (bitmapData.width * 4);
			var srcPosition = Std.int ((rect.x * 4) + (srcStride * rect.y));
			var srcRowOffset = srcStride - Std.int (4 * rect.width);
			var srcRowEnd = Std.int (4 * (rect.x + rect.width));
			
			var length = Std.int (4 * rect.width * rect.height);
			byteArray.length = length;
			
			for (i in 0...length) {
				
				byteArray.__set (i, srcData[srcPosition++]);
				
				if ((srcPosition % srcStride) > srcRowEnd) {
					
					srcPosition += srcRowOffset;
					
				}
				
			}
			
		}
		
		byteArray.position = 0;
		
		return byteArray;
		#else
		return null;
		#end
		
	}
	
	
	private static function isJPG (bytes:ByteArray) {
		
		bytes.position = 0;
		return bytes.readByte () == 0xFF && bytes.readByte () == 0xD8;
		
	}
	
	
	private static function isPNG (bytes:ByteArray) {
		
		bytes.position = 0;
		return (bytes.readByte () == 0x89 && bytes.readByte () == 0x50 && bytes.readByte () == 0x4E && bytes.readByte () == 0x47 && bytes.readByte () == 0x0D && bytes.readByte () == 0x0A && bytes.readByte () == 0x1A && bytes.readByte () == 0x0A);
		
	}
	
	private static function isGIF (bytes:ByteArray) {
		
		bytes.position = 0;
		
		if (bytes.readByte () == 0x47 && bytes.readByte () == 0x49 && bytes.readByte () == 0x46 && bytes.readByte () == 38) {
			
			var b = bytes.readByte ();
			return ((b == 7 || b == 9) && bytes.readByte () == 0x61);
			
		}
		
		return false;
		
	}
	
	
	private inline static inline function loadFromBase64 (bitmapData:BitmapData, base64:String, type:String, ?onload:BitmapData -> Void):Void {
		
		#if js
		bitmapData.__sourceImage = cast Browser.document.createElement ("img");
		
		var image_onLoaded = function (event) {
			
			if (bitmapData.__sourceImage == null) {
				
				bitmapData.__sourceImage = event.target;
				
			}
			
			bitmapData.width = bitmapData.__sourceImage.width;
			bitmapData.height = bitmapData.__sourceImage.height;
			bitmapData.rect = new Rectangle (0, 0, bitmapData.width, bitmapData.height);
			
			bitmapData.__isValid = true;
			
			if (onload != null) {
				
				onload (bitmapData);
				
			}
			
		}
		
		bitmapData.__sourceImage.addEventListener ("load", image_onLoaded, false);
		bitmapData.__sourceImage.src = "data:" + type + ";base64," + base64;
		#end
		
	}
	
	
	private inline static inline function loadFromBytes (bitmapData:BitmapData, bytes:ByteArray, rawAlpha:ByteArray = null, ?onload:BitmapData -> Void):Void {
		
		#if js
		var type = "";
		
		if (isPNG (bytes)) {
			
			type = "image/png";
			
		} else if (isJPG (bytes)) {
			
			type = "image/jpeg";
			
		} else if (isGIF (bytes)) {
			
			type = "image/gif";
			
		} else {
			
			throw new IOError ("BitmapData tried to read a PNG/JPG ByteArray, but found an invalid header.");
			
		}
		
		if (rawAlpha != null) {
			
			loadFromBase64 (bitmapData, base64Encode (bytes), type, function (_) {
				
				convertToCanvas (bitmapData);
				createImageData (bitmapData);
				
				var data = bitmapData.__sourceImageData.data;
				
				for (i in 0...rawAlpha.length) {
					
					data[i * 4 + 3] = rawAlpha.readUnsignedByte ();
					
				}
				
				bitmapData.__sourceImageDataChanged = true;
				
				if (onload != null) {
					
					onload (bitmapData);
					
				}
				
			});
			
		} else {
			
			loadFromBase64 (bitmapData, base64Encode (bytes), type, onload);
			
		}
		#end
		
	}
	
	
	public static inline function paletteMap (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, ?redArray:Array<Int>, ?greenArray:Array<Int>, ?blueArray:Array<Int>, ?alphaArray:Array<Int>):Void {
		
		#if js
		var memory = new ByteArray ();
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		memory.length = ((sw * sh) * 4);
		memory = bitmapData.getPixels (sourceRect);
		memory.position = 0;
		Memory.select (memory);
		
		var position:Int, pixelValue:Int, r:Int, g:Int, b:Int, color:Int;
		
		for (i in 0...(sh * sw)) {
			
			position = i * 4;
			pixelValue = cast Memory.getI32 (position);
			
			r = (pixelValue >> 8) & 0xFF;
			g = (pixelValue >> 16) & 0xFF;
			b = (pixelValue >> 24) & 0xFF;
			
			color = flipPixel ((0xff << 24) |
				redArray[r] | 
				greenArray[g] | 
				blueArray[b]);
			
			Memory.setI32 (position, color);
			
		}
		
		memory.position = 0;
		var destRect = new Rectangle (destPoint.x, destPoint.y, sw, sh);
		bitmapData.setPixels (destRect, memory);
		Memory.select (null);
		#end
		
	}
	
	
	public static inline function setPixel (bitmapData:BitmapData, x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!bitmapData.__isValid || x < 0 || y < 0 || x >= bitmapData.width || y >= bitmapData.height) return;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var offset = (4 * y * bitmapData.width + x * 4);
		
		bitmapData.__sourceImageData.data[offset] = (color & 0xFF0000) >>> 16;
		bitmapData.__sourceImageData.data[offset + 1] = (color & 0x00FF00) >>> 8;
		bitmapData.__sourceImageData.data[offset + 2] = (color & 0x0000FF);
		if (bitmapData.transparent) bitmapData.__sourceImageData.data[offset + 3] = (0xFF);
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static inline function setPixel32 (bitmapData:BitmapData, x:Int, y:Int, color:Int):Void {
		
		#if js
		if (!bitmapData.__isValid || x < 0 || y < 0 || x >= bitmapData.width || y >= bitmapData.height) return;
		
		convertToCanvas (bitmapData);
		createImageData (bitmapData);
		
		var offset = (4 * y * bitmapData.width + x * 4);
		
		bitmapData.__sourceImageData.data[offset] = (color & 0x00FF0000) >>> 16;
		bitmapData.__sourceImageData.data[offset + 1] = (color & 0x0000FF00) >>> 8;
		bitmapData.__sourceImageData.data[offset + 2] = (color & 0x000000FF);
		
		if (bitmapData.transparent) {
			
			bitmapData.__sourceImageData.data[offset + 3] = (color & 0xFF000000) >>> 24;
			
		} else {
			
			bitmapData.__sourceImageData.data[offset + 3] = (0xFF);
			
		}
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static inline function setPixels (bitmapData:BitmapData, rect:Rectangle, byteArray:ByteArray):Void {
		
		#if js
		rect = clipRect (bitmapData, rect);
		if (!bitmapData.__isValid || rect == null) return;
		
		convertToCanvas (bitmapData);
		
		var len = Math.round (4 * rect.width * rect.height);
		
		if (rect.x == 0 && rect.y == 0 && rect.width == bitmapData.width && rect.height == bitmapData.height) {
			
			if (bitmapData.__sourceImageData == null) {
				
				bitmapData.__sourceImageData = bitmapData.__sourceContext.createImageData (bitmapData.width, bitmapData.height);
				
			}
			
			bitmapData.__sourceImageData.data.set (byteArray.byteView);
			
		} else {
			
			createImageData (bitmapData);
			
			var offset = Math.round (4 * bitmapData.width * rect.y + rect.x * 4);
			var pos = offset;
			var boundR = Math.round (4 * (rect.x + rect.width));
			var data = bitmapData.__sourceImageData.data;
			
			for (i in 0...len) {
				
				if (((pos) % (bitmapData.width * 4)) > boundR - 1) {
					
					pos += bitmapData.width * 4 - boundR;
					
				}
				
				data[pos] = byteArray.readByte ();
				pos++;
				
			}
			
		}
		
		bitmapData.__sourceImageDataChanged = true;
		#end
		
	}
	
	
	public static inline function setVector (bitmapData:BitmapData, rect:Rectangle, inputVector:Vector<UInt>) {
		
		#if js
		var byteArray = new ByteArray ();
		byteArray.length = inputVector.length * 4;
		
		for (color in inputVector) {
			
			byteArray.writeUnsignedInt (color);
			
		}
		
		byteArray.position = 0;
		bitmapData.setPixels (rect, byteArray);
		#end
		
	}
	
	
	public static inline function syncImageData (bitmapData:BitmapData):Void {
		
		#if js
		if (bitmapData.__sourceImageDataChanged) {
			
			bitmapData.__sourceContext.putImageData (bitmapData.__sourceImageData, 0, 0);
			bitmapData.__sourceImageData = null;
			bitmapData.__sourceImageDataChanged = false;
			
		}
		#end
		
	}
	
	
	public static inline function threshold (bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		#if js
		if (sourceBitmapData == bitmapData && sourceRect.equals (bitmapData.rect) && destPoint.x == 0 && destPoint.y == 0) {
			
			var hits = 0;
			
			threshold = flipPixel (threshold);
			color = flipPixel (color);
			
			var memory = new ByteArray ();
			memory.length  = bitmapData.width * bitmapData.height * 4;
			memory = bitmapData.getPixels (bitmapData.rect);
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;
			
			var width_yy:Int, position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...bitmapData.height) {
				
				width_yy = bitmapData.width * yy;
				
				for (xx in 0...bitmapData.width) {
					
					position = (width_yy + xx) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					}
					
				}
				
			}
			
			memory.position = 0;
			bitmapData.setPixels (bitmapData.rect, memory);
			Memory.select (null);
			return hits;
			
		} else {
			
			var sx = Std.int (sourceRect.x);
			var sy = Std.int (sourceRect.y);
			var sw = Std.int (sourceBitmapData.width);
			var sh = Std.int (sourceBitmapData.height);
			
			var dx = Std.int (destPoint.x);
			var dy = Std.int (destPoint.y);
			
			var bw:Int = bitmapData.width - sw - dx;
			var bh:Int = bitmapData.height - sh - dy;
			
			var dw:Int = (bw < 0) ? sw + (bitmapData.width - sw - dx) : sw;
			var dh:Int = (bw < 0) ? sh + (bitmapData.height - sh - dy) : sh;
			
			var hits = 0;
			
			threshold = flipPixel (threshold);
			color = flipPixel (color);
			
			var canvasMemory = (sw * sh) * 4;
			var sourceMemory = 0;
			
			if (copySource) {
				
				sourceMemory = (sw * sh) * 4;
				
			}
			
			var totalMemory = (canvasMemory + sourceMemory);
			var memory = new ByteArray ();
			memory.length = totalMemory;
			memory.position = 0;
			var sourceData = sourceBitmapData.clone ();
			var pixels = sourceData.getPixels (sourceRect);
			memory.writeBytes (pixels);
			memory.position = canvasMemory;
			
			if (copySource) {
				
				memory.writeBytes (pixels);
				
			}
			
			memory.position = 0;
			Memory.select (memory);
			
			var thresholdMask:Int = cast threshold & mask;
			
			var position:Int, pixelMask:Int, pixelValue, i, test;
			
			for (yy in 0...dh) {
				
				for (xx in 0...dw) {
					
					position = ((xx + sx) + (yy + sy) * sw) * 4;
					pixelValue = Memory.getI32 (position);
					pixelMask = cast pixelValue & mask;
					
					i = ucompare (pixelMask, thresholdMask);
					test = false;
					
					if (operation == "==") { test = (i == 0); }
					else if (operation == "<") { test = (i == -1);}
					else if (operation == ">") { test = (i == 1); }
					else if (operation == "!=") { test = (i != 0); }
					else if (operation == "<=") { test = (i == 0 || i == -1); }
					else if (operation == ">=") { test = (i == 0 || i == 1); }
					
					if (test) {
						
						Memory.setI32 (position, color);
						hits++;
						
					} else if (copySource) {
						
						Memory.setI32 (position, Memory.getI32 (canvasMemory + position));
						
					}
					
				}
				
			}
			
			memory.position = 0;	
			sourceData.setPixels (sourceRect, memory);
			bitmapData.copyPixels (sourceData, sourceData.rect, destPoint);
			Memory.select (null);
			return hits;
			
		}
		#else
		return 0;
		#end
		
	}
	
	
	private static function ucompare (n1:Int, n2:Int) : Int {
		
		var tmp1 : Int;
		var tmp2 : Int;
		
		tmp1 = (n1 >> 24) & 0x000000FF;
		tmp2 = (n2 >> 24) & 0x000000FF;
		
		if (tmp1 != tmp2) {
			
			return (tmp1 > tmp2 ? 1 : -1);
			
		} else {
			
			tmp1 = (n1 >> 16) & 0x000000FF;
			tmp2 = (n2 >> 16) & 0x000000FF;
			
			if (tmp1 != tmp2) {
				
				return (tmp1 > tmp2 ? 1 : -1);
				
			} else {
				
				tmp1 = (n1 >> 8) & 0x000000FF;
				tmp2 = (n2 >> 8) & 0x000000FF;
				
				if (tmp1 != tmp2) {
					
					return (tmp1 > tmp2 ? 1 : -1);
					
				} else {
					
					tmp1 = n1 & 0x000000FF;
					tmp2 = n2 & 0x000000FF;
					
					if (tmp1 != tmp2) {
						
						return (tmp1 > tmp2 ? 1 : -1);
						
					} else {
						
						return 0;
						
					}
					
				}
				
			}
			
		}
		
	}
	
	
	private static inline function __fillRect (bitmapData:BitmapData, rect:Rectangle, color:Int) {
		
		#if js
		var a = (bitmapData.transparent) ? ((color & 0xFF000000) >>> 24) : 0xFF;
		var r = (color & 0x00FF0000) >>> 16;
		var g = (color & 0x0000FF00) >>> 8;
		var b = (color & 0x000000FF);
		
		bitmapData.__sourceContext.fillStyle = 'rgba(' + r + ', ' + g + ', ' + b + ', ' + (a / 255) + ')';
		bitmapData.__sourceContext.fillRect (rect.x, rect.y, rect.width, rect.height);
		#end
		
	}
	
	
	public static inline function __renderCanvas (bitmapData:BitmapData, renderSession:RenderSession):Void {
		
		#if js
		if (!bitmapData.__isValid) return;
		
		syncImageData (bitmapData);
		
		var context = renderSession.context;
		
		if (bitmapData.__worldTransform == null) bitmapData.__worldTransform = new Matrix ();
		
		context.globalAlpha = 1;
		var transform = bitmapData.__worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		if (bitmapData.__sourceImage != null) {
			
			context.drawImage (bitmapData.__sourceImage, 0, 0);
			
		} else {
			
			context.drawImage (bitmapData.__sourceCanvas, 0, 0);
			
		}
		#end
		
	}
	
	
	public static inline function __updateChildren (transformOnly:Bool):Void {
		
		
		
	}
	
	
}