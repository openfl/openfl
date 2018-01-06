package openfl.display;


import openfl.display.IGraphicsData;


@:final class GraphicsStroke implements IGraphicsData implements IGraphicsStroke {
	
	
	public var caps:CapsStyle;
	public var fill:IGraphicsFill;
	public var joints:JointStyle;
	public var miterLimit:Float;
	public var pixelHinting:Bool;
	public var scaleMode:LineScaleMode;
	public var thickness:Float;
	
	public var __graphicsDataType (default, null):GraphicsDataType;
	
	
	public function new (thickness:Null<Float> = null, pixelHinting:Bool = false, scaleMode:LineScaleMode = LineScaleMode.NORMAL, caps:CapsStyle = CapsStyle.NONE, joints:JointStyle = JointStyle.ROUND, miterLimit:Float = 3, fill:IGraphicsFill = null) {
		
		if (thickness == null) thickness = Math.NaN;
		
		this.caps = caps;
		this.fill = fill;
		this.joints = joints;
		this.miterLimit = miterLimit;
		this.pixelHinting = pixelHinting;
		this.scaleMode = scaleMode;
		this.thickness = thickness;
		this.__graphicsDataType = STROKE;
		
	}
	
	
}