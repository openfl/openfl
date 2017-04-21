package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsPath implements IGraphicsData implements IGraphicsPath {
	
	
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
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		if (commands == null) commands = new Vector ();
		if (data == null) data = new Vector ();
		
		commands.push (GraphicsPathCommand.CURVE_TO);
		data.push (anchorX);
		data.push (anchorY);
		data.push (controlX);
		data.push (controlY);
		
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
	
	
}