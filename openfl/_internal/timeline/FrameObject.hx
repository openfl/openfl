package openfl._internal.timeline;


import openfl._internal.swf.FilterType;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class FrameObject {
	
	public var isKeyFrame:Bool;
	public var blendMode:BlendMode;
	public var cacheAsBitmap:Null<Bool>;
	public var clipDepth:Int;
	public var colorTransform:ColorTransform;
	public var depth:Int;
	public var filters:Array<FilterType>;
	public var id:Int;	//Also matches the tag index of the PlaceObject tag that placed this object on the display list
	public var matrix:Matrix;
	public var name:String;
	public var hasCharacter:Bool;
	public var hasMove:Bool;
	public var symbol:Int;
	public var type:FrameObjectType;
	public var visible:Null<Bool>;
    public var lastFrameObjectWithPlacementData:FrameObject;

	public function clone() : FrameObject {
		var frameObject = new FrameObject();
		frameObject.isKeyFrame = this.isKeyFrame;
		frameObject.blendMode = this.blendMode;
		frameObject.cacheAsBitmap = this.cacheAsBitmap;
		frameObject.clipDepth = this.clipDepth;
		var ct : ColorTransform = this.colorTransform;
		if(ct != null) {
			frameObject.colorTransform = new ColorTransform(ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, ct.alphaMultiplier, ct.redOffset, ct.greenOffset, ct.blueOffset, ct.alphaOffset);
		}
		frameObject.colorTransform = this.colorTransform;
		frameObject.depth = this.depth;
		if( this.filters != null) {
			frameObject.filters = this.filters.copy();
		}
		frameObject.id = this.id;
		if(this.matrix != null) {
			frameObject.matrix = this.matrix.clone();
		}
		frameObject.name = this.name;
		frameObject.hasCharacter = this.hasCharacter;
		frameObject.hasMove = this.hasMove;
		frameObject.symbol = this.symbol;
		frameObject.type = this.type;
		frameObject.visible = this.visible;
		//frameObject.lastFrameObjectWithPlacementData = this.lastFrameObjectWithPlacementData;
		return frameObject;
	}
	
	
	public function new () {
		
		
		
	}
	
	
}