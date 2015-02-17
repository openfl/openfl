package openfl._v2.display; #if lime_legacy


import openfl.Lib;


class GraphicsStroke extends IGraphicsData {
	
	
	public var caps:CapsStyle;
	public var fill:IGraphicsData;
	public var joints:JointStyle;
	public var miterLimit:Float;
	public var pixelHinting:Bool;
	public var scaleMode:LineScaleMode;
	public var thickness:Float;
	
	
	public function new (thickness:Null<Float> = null, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3, fill:IGraphicsData = null) {
		
		this.caps = caps != null ? caps : CapsStyle.NONE;
		this.fill = fill;
		this.joints = joints != null ? joints : JointStyle.ROUND;
		this.miterLimit = miterLimit;
		this.pixelHinting = pixelHinting;
		this.scaleMode = scaleMode != null ? scaleMode : LineScaleMode.NORMAL;
		this.thickness = thickness;
		
		super (lime_graphics_stroke_create (thickness, pixelHinting, scaleMode == null ? 0 : Type.enumIndex (scaleMode), caps == null ? 0 : Type.enumIndex (caps), joints == null ? 0 : Type.enumIndex (joints), miterLimit, fill == null ? null : fill.__handle));
		
	}
	
	
	private static var lime_graphics_stroke_create = Lib.load ("lime", "lime_graphics_stroke_create", -1);
	
	
}


#end