package openfl._internal.backend.html5;

#if openfl_html5
class HTML5Context2DBackend
{
	private var parent:Context2D;

	public function new(parent:Context2D)
	{
		this.parent = parent;
	}

	public function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, counterClockwise:Bool = false):Void
	{
		// __backend.arc(x, y, radius, startAngle, endAngle, counterClockwise);
	}

	public function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void
	{
		// __backend.arcTo(x1, y1, x2, y2, radius);
	}

	public function beginPath():Void
	{
		// __backend.beginPath();
	}

	public function bezierCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, x:Float, y:Float):Void
	{
		// __backend.bezierCurveTo(controlX1, controlY1, controlX2, controlY2, x, y);
	}

	public function clip(path:Path2D = null, winding:Context2DWindingRule = NONZERO):Void
	{
		// __backend.clip(path, winding);
	}

	public function closePath():Void
	{
		// __backend.closePath();
	}

	public function createImageData(width:Float = null, height:Float = null, imageData:ImageData2D = null):ImageData2D
	{
		// return __backend.createImageData(width, height, imageData);
		return null;
	}

	public function createLinearGradient(startX:Float, startY:Float, endX:Float, endY:Float):Gradient2D
	{
		// return __backend.createLinearGradient(startX, startY, endX, endY);
		return null;
	}

	public function createPattern(surface:Surface2D, repetition:String):Pattern2D
	{
		// return __backend.createPattern(surface, repetition);
		return null;
	}

	public function createRadialGradient(centerX1:Float, centerY1:Float, radius1:Float, centerX2:Float, centerY2:Float, radius2:Float):Gradient2D
	{
		// return __backend.createRadialGradient(centerX1, centerY1, radius1, centerX2, centerY2, radius2);
		return null;
	}

	public function clearRect(x:Float, y:Float, w:Float, h:Float):Void
	{
		// __backend.clearRect(x, y, w, h);
	}

	public function drawImage(surface:Surface2D, x1:Float, y1:Float, width1:Float, height1:Float, x2:Float = null, y2:Float = null, width2:Float = null,
			height2:Float = null):Void
	{
		// __backend.drawImage(surface, x1, y1, width1, height1, x2, y2, width2, height2);
	}

	public function fill(path:Path2D = null, winding:Context2DWindingRule = NONZERO):Void
	{
		// __backend.fill(path, winding);
	}

	public function fillRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		// __backend.fillRect(x, y, width, height);
	}

	public function fillText(text:String, x:Float, y:Float, maxWidth:Null<Float> = null):Void
	{
		// __backend.fillText(text, x, y, maxWidth);
	}

	public function getImageData(sourceX:Float, sourceY:Float, sourceWidth:Float, sourceHeight:Float):ImageData2D
	{
		// __backend.getImageData(sourceX, sourceY, sourceWidth, sourceHeight);
	}

	public function isPointInPath(path:Path2D = null, x:Float = null, y:Float = null, winding:Context2DWindingRule = NONZERO):Void
	{
		// __backend.isPointInPath(path, x, y, winding);
	}

	public function lineTo(x:Float, y:Float):Void
	{
		// __backend.lineTo(x, y);
	}

	public function measureText(text:String):TextMetrics2D
	{
		// return __backend.measureText(text);
		return null;
	}

	public function moveTo(x:Float, y:Float):Void
	{
		// __backend.moveTo(x, y);
	}

	public function putImageData(imageData:ImageData2D, dx:Float, dy:Float, dirtyX:Float = null, dirtyY:Float = null, dirtyWidth:Float = null,
			dirtyHeight:Float = null):Void
	{
		// __backend.putImageData(imageData, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
	}

	public function quadraticCurveTo(controlX:Float, controlY:Float, x:Float, y:Float):Void
	{
		// __backend.quadraticCurveTo(controlX, controlY, x, y);
	}

	public function rect(x:Float, y:Float, width:Float, height:Float):Void
	{
		// __backend.rect(x, y, width, height);
	}

	public function restore():Void
	{
		// __backend.restore();
	}

	public function rotate(angle:Float):Void
	{
		// __backend.rotate(angle);
	}

	public function save():Void
	{
		// __backend.save();
	}

	public function scale(x:Float, y:Float):Void
	{
		// __backend.scale(x, y);
	}

	public function setTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		// __backend.setTransform(a, b, c, d, tx, ty);
	}

	public function stroke(path:Path2D = null):Void
	{
		// __backend.stroke(path);
	}

	public function strokeRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		// __backend.strokeRect(x, y, width, height);
	}

	public function strokeText(text:String, x:Float, y:Float, maxWidth:Float = null):Void
	{
		// __backend.strokeText(text, x, y, maxWidth);
	}

	public function transform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		// __backend.transform(a, b, c, d, tx, ty);
	}

	public function translate(x:Float, y:Float):Void
	{
		// __backend.translate(x, y);
	}

	// Get & Set Methods
	public function getFillStyle():Context2DFillStyle
	{
		// return __backend.getFillStyle();
		return null;
	}

	public function setFillStyle(value:Context2DFillStyle):Void
	{
		// __backend.setFillStyle(value);
		// return value;
	}

	public function getFont():String
	{
		// return __backend.getFont();
		return null;
	}

	public function setFont(value:String):Void
	{
		// __backend.setFont(value);
		// return value;
	}

	public function getGlobalAlpha():Float
	{
		// return __backend.getGlobalAlpha();
		return 0;
	}

	public function setGlobalAlpha(value:Float):Void
	{
		// __backend.setGlobalAlpha(value);
		// return value;
	}

	public function getGlobalCompositeOperation():Context2DCompositeOperation
	{
		// return __backend.getGlobalCompositeOperation();
		return null;
	}

	public function setGlobalCompositeOperation(value:Context2DCompositeOperation):Void
	{
		// __backend.setGlobalCompositeOperation(value);
		// return value;
	}

	public function getHeight():Int
	{
		// return __backend.getHeight();
		return 0;
	}

	public function setHeight(value:Int):Void
	{
		// __backend.setHeight(value);
		// return value;
	}

	public function getLineCap():Context2DLineCap
	{
		// return __backend.getLineCap();
		return null;
	}

	public function setLineCap(value:Context2DLineCap):Void
	{
		// __backend.setLineCap(value);
		// return value;
	}

	public function getLineJoin():Context2DLineJoin
	{
		// return __backend.getLineJoin();
		return null;
	}

	public function setLineJoin(value:Context2DLineJoin):Void
	{
		// __backend.setLineJoin(value);
		// return value;
	}

	public function getLineWidth():Float
	{
		// return __backend.getLineWidth();
		return 0;
	}

	public function setLineWidth(value:Float):Void
	{
		// __backend.setLineWidth(value);
		// return value;
	}

	public function getMiterLimit():Float
	{
		// return __backend.getMiterLimit();
		return 0;
	}

	public function setMiterLimit(value:Float):Void
	{
		// __backend.setMiterLimit(value);
		// return value;
	}

	public function getStrokeStyle():Context2DStrokeStyle
	{
		// return __backend.getStrokeStyle();
		return null;
	}

	public function setStrokeStyle(value:Context2DStrokeStyle):Void
	{
		// __backend.setStrokeStyle(value);
		// return value;
	}

	public function getShadowColor():Int // String?
	{
		// return __backend.getShadowColor();
		return 0;
	}

	public function setShadowColor(value:Int):Void // String?
	{
		// __backend.setShadowColor(value);
		// return value;
	}

	public function getShadowBlur():Float
	{
		// return __backend.getShadowBlur();
		return 0;
	}

	public function setShadowBlur(value:Float):Void
	{
		// __backend.setShadowBlur(value);
		// return value;
	}

	public function getShadowOffsetX():Float
	{
		// return __backend.getShadowOffsetX();
		return 0;
	}

	public function setShadowOffsetX(value:Float):Void
	{
		// __backend.setShadowOffsetX(value);
		// return value;
	}

	public function getShadowOffsetY():Float
	{
		// return __backend.getShadowOffsetY();
		return 0;
	}

	public function setShadowOffsetY(value:Float):Void
	{
		// __backend.setShadowOffsetY(value);
		// return value;
	}

	// public function getSurface:Surface2D;
	// public function setSurface:Surface2D;
	public function getTextAlign():Context2DTextAlign
	{
		// return __backend.getTextAlign();
		return null;
	}

	public function setTextAlign(value:Context2DTextAlign):Void
	{
		// __backend.setTextAlign(value);
		// return value;
	}

	public function getTextBaseline():Context2DTextBaseline
	{
		// return __backend.getTextBaseline();
		return null;
	}

	public function setTextBaseline(value:Context3DTextBaseline):Void
	{
		// __backend.setTextBaseline(value);
		// return value;
	}

	public function getWidth():Int
	{
		// return __backend.getWidth();
		return 0;
	}

	public function setWidth(value:Int):Void
	{
		// __backend.setWidth(value);
	}
}
#end
