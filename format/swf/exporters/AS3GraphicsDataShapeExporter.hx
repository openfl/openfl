package format.swf.exporters;

import format.swf.instance.Bitmap;
import format.swf.SWFRoot;
import format.swf.exporters.core.DefaultShapeExporter;
import flash.display.GradientType;
import format.swf.SWFTimelineContainer;
import format.swf.tags.TagDefineBitsLossless;

import flash.display.CapsStyle;
import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.InterpolationMethod;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import flash.Vector;

class AS3GraphicsDataShapeExporter extends DefaultShapeExporter
{
	public var graphicsData (default, null):Vector<IGraphicsData>;
	
	private var tmpGraphicsPath:GraphicsPath;
	private var tmpStroke:GraphicsStroke;
	
	public function new(swf:SWFTimelineContainer) {
		super(swf);
	}
	
	override public function beginShape():Void {
		graphicsData = new Vector<IGraphicsData>();
	}
	
	override public function beginFills():Void {
		graphicsData.push(new GraphicsStroke());
	}

	override public function beginFill(color:Int, alpha:Float = 1.0):Void {
		cleanUpGraphicsPath();
		graphicsData.push(new GraphicsSolidFill(color, alpha));
	}
	
	override public function beginGradientFill(type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Float>, matrix:Matrix = null, spreadMethod:SpreadMethod = null/*SpreadMethod.PAD*/, interpolationMethod:InterpolationMethod = null/*InterpolationMethod.RGB*/, focalPointRatio:Float = 0):Void {
		cleanUpGraphicsPath();
		
		#if flash
		var newColors:Array<UInt> = [];
		for (color in colors) {
			newColors.push (color);
		}
		#else
		var newColors = colors;
		#end
		
		graphicsData.push(new GraphicsGradientFill(
			type,
			newColors,
			alphas,
			ratios,
			matrix,
			spreadMethod,
			interpolationMethod,
			focalPointRatio
		));
	}

	override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		cleanUpGraphicsPath();
		var symbol = swf.getCharacter (bitmapId);
		var bitmap = new Bitmap (symbol);
		if (bitmap.bitmapData != null) {
			graphicsData.push (new GraphicsBitmapFill (bitmap.bitmapData, matrix, repeat, smooth));
		}
		// TODO
	}
	
	override public function endFill():Void {
		cleanUpGraphicsPath();
		graphicsData.push(new GraphicsEndFill());
	}

	override public function lineStyle(thickness:Float = 0/*NaN*/, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:LineScaleMode = null/*LineScaleMode.NORMAL*/, startCaps:CapsStyle = null/*CapsStyle.ROUND*/, endCaps:CapsStyle = null/*CapsStyle.ROUND*/, joints:JointStyle = null/*JointStyle.ROUND*/, miterLimit:Float = 3):Void {
		cleanUpGraphicsPath();
		tmpStroke = new GraphicsStroke(
			thickness,
			pixelHinting,
			scaleMode,
			startCaps,
			joints,
			miterLimit,
			new GraphicsSolidFill(color, alpha)
		);
		graphicsData.push(tmpStroke);
	}
	
	override public function lineGradientStyle(type:GradientType, colors:Array<Int>, alphas:Array<Float>, ratios:Array<Float>, matrix:Matrix=null, spreadMethod:SpreadMethod=null/*SpreadMethod.PAD*/, interpolationMethod:InterpolationMethod=null/*InterpolationMethod.RGB*/, focalPointRatio:Float=0):Void {
		
		#if flash
		var newColors:Array<UInt> = [];
		for (color in colors) {
			newColors.push (color);
		}
		#else
		var newColors = colors;
		#end
		
		#if flash
		if(tmpStroke != null) {
			tmpStroke.fill = new GraphicsGradientFill(
				type,
				newColors,
				alphas,
				ratios,
				matrix,
				spreadMethod,
				interpolationMethod,
				focalPointRatio
			);
		}
		#end
	}
	
	override public function moveTo(x:Float, y:Float):Void {
		tmpGraphicsPath.moveTo(x, y);
	}
	
	override public function lineTo(x:Float, y:Float):Void {
		tmpGraphicsPath.lineTo(x, y);
	}
	
	override public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		tmpGraphicsPath.curveTo(controlX, controlY, anchorX, anchorY);
	}
	
	override public function endLines():Void {
		cleanUpGraphicsPath();
	}
	
	private function cleanUpGraphicsPath():Void {
		if(tmpGraphicsPath != null && tmpGraphicsPath.commands != null && tmpGraphicsPath.commands.length > 0) {
			graphicsData.push(tmpGraphicsPath);
		}
		tmpGraphicsPath = new GraphicsPath();
		tmpStroke = null;
	}
}