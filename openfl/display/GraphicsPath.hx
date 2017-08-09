package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsPath implements IGraphicsData implements IGraphicsPath {
	
	
	private static var SIN45 = 0.70710678118654752440084436210485;
	private static var TAN22 = 0.4142135623730950488016887242097;
	
	public var commands:Vector<Int>;
	public var data:Vector<Float>;
	public var winding:GraphicsPathWinding;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (commands:Vector<Int> = null, data:Vector<Float> = null, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD) {
		
		this.commands = commands;
		this.data = data;
		this.winding = winding;
		this.__graphicsDataType = PATH;
		
	}
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.CUBIC_CURVE_TO);
		data.push (controlX1);
		data.push (controlY1);
		data.push (controlX2);
		data.push (controlY2);
		data.push (anchorX);
		data.push (anchorY);
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.CURVE_TO);
		data.push (controlX);
		data.push (controlY);
		data.push (anchorX);
		data.push (anchorY);
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.LINE_TO);
		data.push (x);
		data.push (y);
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.MOVE_TO);
		data.push (x);
		data.push (y);
		
	}
	
	
	public function wideLineTo (x:Float, y:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.LINE_TO);
		data.push (x);
		data.push (y);
		
	}
	
	
	public function wideMoveTo (x:Float, y:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.MOVE_TO);
		data.push (x);
		data.push (y);
		
	}
	
	
	private function __drawCircle (x:Float, y:Float, radius:Float):Void {
		
		__drawRoundRect (x - radius, y - radius, radius * 2, radius * 2, radius * 2, radius * 2);
		
	}
	
	
	private function __drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		__drawRoundRect (x, y, width, height, width, height);
		
	}
	
	
	private function __drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		moveTo (x, y);
		lineTo (x + width, y);
		lineTo (x + width, y + height);
		lineTo (x, y + height);
		lineTo (x, y);
		
	}
	
	
	private function __drawRoundRect (x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ellipseHeight:Float):Void {
		
		ellipseWidth *= 0.5;
		ellipseHeight *= 0.5;
		
		if (ellipseWidth > width / 2) ellipseWidth = width / 2;
		if (ellipseHeight > height / 2) ellipseHeight = height / 2;
		
		var xe = x + width,
		ye = y + height,
		cx1 = -ellipseWidth + (ellipseWidth * SIN45),
		cx2 = -ellipseWidth + (ellipseWidth * TAN22),
		cy1 = -ellipseHeight + (ellipseHeight * SIN45),
		cy2 = -ellipseHeight + (ellipseHeight * TAN22);
		
		moveTo (xe, ye - ellipseHeight);
		curveTo (xe, ye + cy2, xe + cx1, ye + cy1);
		curveTo (xe + cx2, ye, xe - ellipseWidth, ye);
		lineTo (x + ellipseWidth, ye);
		curveTo (x - cx2, ye, x - cx1, ye + cy1);
		curveTo (x, ye + cy2, x, ye - ellipseHeight);
		lineTo (x, y + ellipseHeight);
		curveTo (x, y - cy2, x - cx1, y - cy1);
		curveTo (x - cx2, y, x + ellipseWidth, y);
		lineTo (xe - ellipseWidth, y);
		curveTo (xe + cx2, y, xe + cx1, y - cy1);
		curveTo (xe, y - cy2, xe, y + ellipseHeight);
		lineTo (xe, ye - ellipseHeight);
		
	}
	
	
}