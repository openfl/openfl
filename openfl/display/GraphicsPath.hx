package openfl.display;


import openfl.display.IGraphicsData;
import openfl.Vector;


@:final class GraphicsPath implements IGraphicsData implements IGraphicsPath {
	
	
	public var commands:Vector<Int>;
	public var data:Vector<Float>;
	public var winding:GraphicsPathWinding;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (commands:Vector<Int> = null, data:Vector<Float> = null, winding:GraphicsPathWinding = null) {
		
		if (winding == null) {
			
			winding = GraphicsPathWinding.EVEN_ODD;
			
		}
		
		this.commands = commands;
		this.data = data;
		this.winding = winding;
		this.__graphicsDataType = PATH;
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		if (this.commands != null && this.data != null) {
			
			this.commands.push (GraphicsPathCommand.CURVE_TO);
			this.data.push (anchorX);
			this.data.push (anchorY);
			this.data.push (controlX);
			this.data.push (controlY);
			
		}
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		if (this.commands != null && this.data != null) {
			
			this.commands.push (GraphicsPathCommand.LINE_TO);
			this.data.push (x);
			this.data.push (y);
			
		}
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		if (this.commands != null && this.data != null) {
			
			this.commands.push (GraphicsPathCommand.MOVE_TO);
			this.data.push (x);
			this.data.push (y);
			
		}
		
	}
	
	
	public function wideLineTo (x:Float, y:Float):Void {
		
		if (this.commands != null && this.data != null) {
			
			this.commands.push (GraphicsPathCommand.LINE_TO);
			this.data.push (x);
			this.data.push (y);
			
		}
		
	}
	
	
	public function wideMoveTo (x:Float, y:Float):Void {
		
		if (this.commands != null && this.data != null) {
			
			this.commands.push (GraphicsPathCommand.MOVE_TO);
			this.data.push (x);
			this.data.push (y);
			
		}
		
	}
	
	
}