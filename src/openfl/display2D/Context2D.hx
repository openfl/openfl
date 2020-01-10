package openfl.display2D;

class Context2D
{
	public var fillStyle(get, set):Context2DFillStyle;
	public var font(get, set):String;
	public var globalAlpha(get, set):Float;
	public var globalCompositeOperation(get, set):Context2DCompositeOperation;
	public var height(get, set):Int;
	public var lineCap(get, set):Context2DLineCap;
	public var lineJoin(get, set):Context2DLineJoin;
	public var lineWidth(get, set):Float;
	public var miterLimit(get, set):Float;
	public var strokeStyle(get, set):Context2DStrokeStyle;
	public var shadowColor(get, set):Int; // String?
	public var shadowBlur(get, set):Float;
	public var shadowOffsetX(get, set):Float;
	public var shadowOffsetY(get, set):Float;
	// public var surface:Surface2D;
	public var textAlign(get, set):Context2DTextAlign;
	public var textBaseline(get, set):Context2DTextBaseline;
	public var width(get, set):Int;

	@:noCompletion private var __backend:Context2DBackend;

	@:noCompletion private function new()
	{
		__backend = new Context2DBackend(this);
	}

	public function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, counterClockwise:Bool = false):Void
	{
		__backend.arc(x, y, radius, startAngle, endAngle, counterClockwise);
	}

	public function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void
	{
		__backend.arcTo(x1, y1, x2, y2, radius);
	}

	public function beginPath():Void
	{
		__backend.beginPath();
	}

	public function bezierCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, x:Float, y:Float):Void
	{
		__backend.bezierCurveTo(controlX1, controlY1, controlX2, controlY2, x, y);
	}

	public function clip(path:Path2D = null, winding:Context2DWindingRule = NONZERO):Void
	{
		__backend.clip(path, winding);
	}

	public function closePath():Void
	{
		__backend.closePath();
	}

	public function createImageData(width:Float = null, height:Float = null, imageData:ImageData2D = null):ImageData2D
	{
		return __backend.createImageData(width, height, imageData);
	}

	public function createLinearGradient(startX:Float, startY:Float, endX:Float, endY:Float):Gradient2D
	{
		return __backend.createLinearGradient(startX, startY, endX, endY);
	}

	public function createPattern(surface:Surface2D, repetition:String):Pattern2D
	{
		return __backend.createPattern(surface, repetition);
	}

	public function createRadialGradient(centerX1:Float, centerY1:Float, radius1:Float, centerX2:Float, centerY2:Float, radius2:Float):Gradient2D
	{
		return __backend.createRadialGradient(centerX1, centerY1, radius1, centerX2, centerY2, radius2);
	}

	public function clearRect(x:Float, y:Float, w:Float, h:Float):Void
	{
		__backend.clearRect(x, y, w, h);
	}

	public function drawImage(surface:Surface2D, x1:Float, y1:Float, width1:Float, height1:Float, x2:Float = null, y2:Float = null, width2:Float = null,
			height2:Float = null):Void
	{
		__backend.drawImage(surface, x1, y1, width1, height1, x2, y2, width2, height2);
	}

	public function fill(path:Path2D = null, winding:Context2DWindingRule = NONZERO):Void
	{
		__backend.fill(path, winding);
	}

	public function fillRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		__backend.fillRect(x, y, width, height);
	}

	public function fillText(text:String, x:Float, y:Float, maxWidth:Null<Float> = null):Void
	{
		__backend.fillText(text, x, y, maxWidth);
	}

	public function getImageData(sourceX:Float, sourceY:Float, sourceWidth:Float, sourceHeight:Float):ImageData2D
	{
		__backend.getImageData(sourceX, sourceY, sourceWidth, sourceHeight);
	}

	public function isPointInPath(path:Path2D = null, x:Float = null, y:Float = null, winding:Context2DWindingRule = NONZERO):Void
	{
		__backend.isPointInPath(path, x, y, winding);
	}

	public function lineTo(x:Float, y:Float):Void
	{
		__backend.lineTo(x, y);
	}

	public function measureText(text:String):TextMetrics2D
	{
		return __backend.measureText(text);
	}

	public function moveTo(x:Float, y:Float):Void
	{
		__backend.moveTo(x, y);
	}

	public function putImageData(imageData:ImageData2D, dx:Float, dy:Float, dirtyX:Float = null, dirtyY:Float = null, dirtyWidth:Float = null,
			dirtyHeight:Float = null):Void
	{
		__backend.putImageData(imageData, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
	}

	public function quadraticCurveTo(controlX:Float, controlY:Float, x:Float, y:Float):Void
	{
		__backend.quadraticCurveTo(controlX, controlY, x, y);
	}

	public function rect(x:Float, y:Float, width:Float, height:Float):Void
	{
		__backend.rect(x, y, width, height);
	}

	public function restore():Void
	{
		__backend.restore();
	}

	public function rotate(angle:Float):Void
	{
		__backend.rotate(angle);
	}

	public function save():Void
	{
		__backend.save();
	}

	public function scale(x:Float, y:Float):Void
	{
		__backend.scale(x, y);
	}

	public function setTransform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		__backend.setTransform(a, b, c, d, tx, ty);
	}

	public function stroke(path:Path2D = null):Void
	{
		__backend.stroke(path);
	}

	public function strokeRect(x:Float, y:Float, width:Float, height:Float):Void
	{
		__backend.strokeRect(x, y, width, height);
	}

	public function strokeText(text:String, x:Float, y:Float, maxWidth:Float = null):Void
	{
		__backend.strokeText(text, x, y, maxWidth);
	}

	public function transform(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		__backend.transform(a, b, c, d, tx, ty);
	}

	public function translate(x:Float, y:Float):Void
	{
		__backend.translate(x, y);
	}

	// Get & Set Methods
	@:noCompletion private function get_fillStyle():Context2DFillStyle
	{
		return __backend.getFillStyle();
	}

	@:noCompletion private function set_fillStyle(value:Context2DFillStyle):Context2DFillStyle
	{
		__backend.setFillStyle(value);
		return value;
	}

	@:noCompletion private function get_font():String
	{
		return __backend.getFont();
	}

	@:noCompletion private function set_font(value:String):String
	{
		__backend.setFont(value);
		return value;
	}

	@:noCompletion private function get_globalAlpha():Float
	{
		return __backend.getGlobalAlpha();
	}

	@:noCompletion private function set_globalAlpha(value:Float):Float
	{
		__backend.setGlobalAlpha(value);
		return value;
	}

	@:noCompletion private function get_globalCompositeOperation():Context2DCompositeOperation
	{
		return __backend.getGlobalCompositeOperation();
	}

	@:noCompletion private function set_globalCompositeOperation(value:Context2DCompositeOperation):Context2DCompositeOperation
	{
		__backend.setGlobalCompositeOperation(value);
		return value;
	}

	@:noCompletion private function get_height():Int
	{
		return __backend.getHeight();
	}

	@:noCompletion private function set_height(value:Int):Int
	{
		__backend.setHeight(value);
		return value;
	}

	@:noCompletion private function get_lineCap():Context2DLineCap
	{
		return __backend.getLineCap();
	}

	@:noCompletion private function set_lineCap(value:Context2DLineCap):Context2DLineCap
	{
		__backend.setLineCap(value);
		return value;
	}

	@:noCompletion private function get_lineJoin():Context2DLineJoin
	{
		return __backend.getLineJoin();
	}

	@:noCompletion private function set_lineJoin(value:Context2DLineJoin):Context2DLineJoin
	{
		__backend.setLineJoin(value);
		return value;
	}

	@:noCompletion private function get_lineWidth():Float
	{
		return __backend.getLineWidth();
	}

	@:noCompletion private function set_lineWidth(value:Float):Float
	{
		__backend.setLineWidth(value);
		return value;
	}

	@:noCompletion private function get_miterLimit():Float
	{
		return __backend.getMiterLimit();
	}

	@:noCompletion private function set_miterLimit(value:Float):Float
	{
		__backend.setMiterLimit(value);
		return value;
	}

	@:noCompletion private function get_strokeStyle():Context2DStrokeStyle
	{
		return __backend.getStrokeStyle();
	}

	@:noCompletion private function set_strokeStyle(value:Context2DStrokeStyle):Context2DStrokeStyle
	{
		__backend.setStrokeStyle(value);
		return value;
	}

	@:noCompletion private function get_shadowColor():Int // String?
	{
		return __backend.getShadowColor();
	}

	@:noCompletion private function set_shadowColor(value:Int):Int // String?
	{
		__backend.setShadowColor(value);
		return value;
	}

	@:noCompletion private function get_shadowBlur():Float
	{
		return __backend.getShadowBlur();
	}

	@:noCompletion private function set_shadowBlur(value:Float):Float
	{
		__backend.setShadowBlur(value);
		return value;
	}

	@:noCompletion private function get_shadowOffsetX():Float
	{
		return __backend.getShadowOffsetX();
	}

	@:noCompletion private function set_shadowOffsetX(value:Float):Float
	{
		__backend.setShadowOffsetX(value);
		return value;
	}

	@:noCompletion private function get_shadowOffsetY():Float
	{
		return __backend.getShadowOffsetY();
	}

	@:noCompletion private function set_shadowOffsetY(value:Float):Float
	{
		__backend.setShadowOffsetY(value);
		return value;
	}

	// @:noCompletion private function get_surface:Surface2D;
	// @:noCompletion private function set_surface:Surface2D;
	@:noCompletion private function get_textAlign():Context2DTextAlign
	{
		return __backend.getTextAlign();
	}

	@:noCompletion private function set_textAlign(value:Context2DTextAlign):Context2DTextAlign
	{
		__backend.setTextAlign(value);
		return value;
	}

	@:noCompletion private function get_textBaseline():Context2DTextBaseline
	{
		return __backend.getTextBaseline();
	}

	@:noCompletion private function set_textBaseline(value:Context3DTextBaseline):Context2DTextBaseline
	{
		__backend.setTextBaseline(value);
		return value;
	}

	@:noCompletion private function get_width():Int
	{
		return __backend.getWidth();
	}

	@:noCompletion private function set_width(value:Int):Int
	{
		__backend.setWidth(value);
		return value;
	}
}

#if openfl_html5
private typedef Context2DBackend = openfl._internal.backend.html5.HTML5Context2DBackend;
#end
