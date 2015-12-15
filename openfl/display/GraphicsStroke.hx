package openfl.display; #if !openfl_legacy


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
	
	
	public function new (thickness:Float = 0.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3, fill:IGraphicsFill = null) {
		
		this.caps = caps != null ? caps : CapsStyle.NONE;
		this.fill = fill;
		this.joints = joints != null ? joints : JointStyle.ROUND;
		this.miterLimit = miterLimit;
		this.pixelHinting = pixelHinting;
		this.scaleMode = scaleMode != null ? scaleMode : LineScaleMode.NORMAL;
		this.thickness = thickness;
		this.__graphicsDataType = STROKE;
		
	}
	
	
}


#else
typedef GraphicsStroke = openfl._legacy.display.GraphicsStroke;
#end