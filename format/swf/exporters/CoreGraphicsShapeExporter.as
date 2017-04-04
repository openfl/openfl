package com.codeazur.hxswf.exporters
{
	import com.codeazur.hxswf.SWF;
	import com.codeazur.hxswf.utils.ColorUtils;
	import com.codeazur.hxswf.utils.ObjCUtils;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.codeazur.hxswf.exporters.core.DefaultShapeExporter;

	class CoreGraphicsShapeExporter extends DefaultShapeExporter
	{
		private static inline var DEFAULT_CLASSNAME:String = "DefaultClassName";
		
		private static inline var NOT_ACTIVE:String = "notActive";
		private static inline var FILL_ACTIVE:String = "fillActive";
		private static inline var STROKE_ACTIVE:String = "strokeActive";
		
		private var _m:String = "";
		private var _h:String = "";
		
		private var _className:String;
		private var _projectName:String;
		private var _author:String;
		private var _copyright:String;

		private var fills:Array<String>;
		private var strokes:Array<String>;
		private var geometry:String = "";
		private var prefix:String = "";
		private var suffix:String = "";
		
		private var active:String = NOT_ACTIVE;
		
		public function CoreGraphicsShapeExporter(swf:SWF, aClassName:String, aProjectName:String = "###ProjectName###", aAuthor:String = "###AuthorName###", aCopyright:String = "###Copyright###")
		{
			_className = (aClassName != null && aClassName.length > 0) ? aClassName : DEFAULT_CLASSNAME;
			_projectName = aProjectName;
			_author = aAuthor;
			_copyright = aCopyright;
			super(swf);
		}
		
		public function get m():String { return _m; }
		
		public function get h():String { return _h; }
		
		public function get className():String { return _className; }
		public function set className(value:String):Void {
			_className = (value != null && value.length > 0) ? value : DEFAULT_CLASSNAME;
		}
		
		public function get projectName():String { return _projectName; }
		public function set projectName(value:String):Void { _projectName = value; }
		
		public function get author():String { return _author; }
		public function set author(value:String):Void { _author = value; }
		
		public function get copyright():String { return _copyright; }
		public function set copyright(value:String):Void { _copyright = value; }


		override public function beginShape():Void {
			_m = "//\r" +
				"//  " + className + ".m\r" +
				"//  " + projectName + "\r" +
				"//\r" +
				"//  Created by " + _author + " on " + new Date().toDateString() + ".\r" +
				"//  Copyright " + new Date().fullYear + " " + _copyright + ". All rights reserved.\r" +
				"//\r" +
				"\r" +
				"#import \"" + className + ".h\"\r" +
				"\r" +
				"@implementation " + className + "\r" +
				"\r" +
				"- (id)initWithFrame:(CGRect)frame {\r" + 
				"\tif (self = [super initWithFrame:frame]) {\r" + 
				"\t\t// Initialization code\r" + 
				"\t}\r" + 
				"\treturn self;\r" + 
				"}\r" + 
				"\r" +
				"- (void)drawRect:(CGRect)rect {\r" +
				"\tCGContextRef ctx = UIGraphicsGetCurrentContext();\r";
			_h = "//\r" +
				"//  " + className + ".h\r" +
				"//  " + projectName + "\r" +
				"//\r" +
				"//  Created by " + _author + " on " + new Date().toDateString() + ".\r" +
				"//  Copyright " + new Date().fullYear + " " + _copyright + ". All rights reserved.\r" +
				"//\r" +
				"\r" +
				"#import <UIKit/UIKit.h>\r" +
				"\r" +
				"@interface " + className + " : UIView {\r" +
				"}\r";
		}
		
		
		override public function beginFills():Void {
			fills = new Array<String>();
		}

		override public function endFills():Void {
			for (var i:Int = 0; i < fills.length; i++) {
				_m += "\t[self drawFill" + i + ":ctx];\r";
			}
		}

		
		override public function beginLines():Void {
			strokes = new Array<String>();
		}
		
		override public function endLines():Void {
			processPreviousStroke();
			for (var i:Int = 0; i < strokes.length; i++) {
				_m += "\t[self drawStroke" + i + ":ctx];\r";
			}
		}
		
		
		override public function endShape():Void {
			var i:Int;
			_m += "}\r";
			if (fills != null) {
				for (i = 0; i < fills.length; i++) {
					_m += "\r- (void)drawFill" + i + ":(CGContextRef)ctx {\r" + fills[i] + "}\r";
					_h += "\r- (void)drawFill" + i + ":(CGContextRef)ctx;";
				}
			}
			if (strokes != null) {
				for (i = 0; i < strokes.length; i++) {
					_m += "\r- (void)drawStroke" + i + ":(CGContextRef)ctx {\r" + strokes[i] + "}\r";
					_h += "\r- (void)drawStroke" + i + ":(CGContextRef)ctx;";
				}
			}
			_m += "\r- (void)dealloc {\r\t[super dealloc];\r}\r\r@end\r";
			_h += "\r\r@end\r";
			fills = null;
			strokes = null;
		}
		
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = "\tCGContextSaveGState(ctx);\r\r";
			geometry = "\tCGContextBeginPath(ctx);\r";
			suffix = "\tCGFloat c[4] = { " + 
				ObjCUtils.num2str(ColorUtils.r(color)) + ", " +
				ObjCUtils.num2str(ColorUtils.g(color)) + ", " +
				ObjCUtils.num2str(ColorUtils.b(color)) + ", " +
				ObjCUtils.num2str(alpha) +
				" };\r" +
				"\tCGContextSetFillColor(ctx, c);\r" +
				"\tCGContextFillPath(ctx);\r\r" + 
				"\tCGContextRestoreGState(ctx);\r";
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = "\tCGContextSaveGState(ctx);\r\r";
			geometry = "\tCGContextBeginPath(ctx);\r";
			var i:Int;
			var len:Int = uint(Math.min(Math.min(colors.length, alphas.length), ratios.length));
			if (type == GradientType.LINEAR) {
				suffix = "\tCGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();\r"
				suffix += "\tCGFloat colors[" + (len * 4) + "] = {\r";
				for (i = 0; i < len; i++) {
					var color:Int = colors[i];
					suffix += "\t\t" +
						ObjCUtils.num2str(ColorUtils.r(color)) + ", " +
						ObjCUtils.num2str(ColorUtils.g(color)) + ", " +
						ObjCUtils.num2str(ColorUtils.b(color)) + ", " +
						ObjCUtils.num2str(alphas[i]);
					if (i < colors.length - 1) {
						suffix += ",";
					}
					suffix += "\r";
				}
				suffix += "\t};\r";
				suffix += "\tCGFloat ratios[" + len + "] = { ";
				for (i = 0; i < len; i++) {
					suffix += ObjCUtils.num2str(Number(ratios[i]) / 255);
					if (i < ratios.length - 1) {
						suffix += ", ";
					}
				}
				suffix += " };\r";
				suffix += "\tCGGradientRef g = CGGradientCreateWithColorComponents(cs, colors, ratios, " + len + ");\r"
				suffix += "\tCGContextEOClip(ctx);\r"
				var from:Point = new Point(-819.2 * matrix.a + matrix.tx, -819.2 * matrix.b + matrix.ty);
				var to:Point = new Point(819.2 * matrix.a + matrix.tx, 819.2 * matrix.b + matrix.ty);
				suffix += "\tCGPoint from = CGPointMake(" + ObjCUtils.num2str(from.x) + ", " + ObjCUtils.num2str(from.y) + ");\r";
				suffix += "\tCGPoint to = CGPointMake(" + ObjCUtils.num2str(to.x) + ", " + ObjCUtils.num2str(to.y) + ");\r";
				suffix += "\tCGContextDrawLinearGradient(ctx, g, from, to, 0);\r";
				suffix += "\tCGGradientRelease(g);\r";
				suffix += "\tCGColorSpaceRelease(cs);\r\r"
			} else if (type == GradientType.RADIAL) {
				// TODO
				suffix = "";
			}
			suffix += "\tCGContextRestoreGState(ctx);\r"
		}

		override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
			processPreviousFill();
			active = NOT_ACTIVE;
			// TODO
		}
		
		override public function endFill():Void {
			processPreviousFill();
			active = NOT_ACTIVE;
		}
		
		override public function lineStyle(thickness:Float = NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Float = 3):Void {
			processPreviousStroke();
			active = STROKE_ACTIVE;
			prefix = "\tCGContextSaveGState(ctx);\r\r" +
				"\tCGFloat c[4] = { " +
				ObjCUtils.num2str(ColorUtils.r(color)) + ", " +
				ObjCUtils.num2str(ColorUtils.g(color)) + ", " +
				ObjCUtils.num2str(ColorUtils.b(color)) + ", " +
				ObjCUtils.num2str(alpha) +
				" };\r" +
				"\tCGContextSetStrokeColor(ctx, c);\r" +
				"\tCGContextSetLineWidth(ctx, " + ObjCUtils.num2str(thickness) + ");\r";
			if (startCaps == null || startCaps == CapsStyle.ROUND) {
				prefix += "\tCGContextSetLineCap(ctx, kCGLineCapRound);\r";
			} else if (startCaps == CapsStyle.SQUARE) {
				prefix += "\tCGContextSetLineCap(ctx, kCGLineCapSquare);\r";
			}
			if (joints == null || joints == JointStyle.ROUND) {
				prefix += "\tCGContextSetLineJoin(ctx, kCGLineJoinRound);\r";
			} else if (joints == JointStyle.BEVEL) {
				prefix += "\tCGContextSetLineJoin(ctx, kCGLineJoinMiter);\r";
				prefix += "\tCGContextSetMiterLimit(ctx, " + ObjCUtils.num2str(miterLimit) + ");\r";
			} else {
				prefix += "\tCGContextSetMiterLimit(ctx, " + ObjCUtils.num2str(miterLimit) + ");\r";
			}
			prefix += "\r";
			geometry = "\tCGContextBeginPath(ctx);\r";
			suffix = "\tCGContextStrokePath(ctx);\r\r\tCGContextRestoreGState(ctx);\r";
		}
		
		override public function moveTo(x:Float, y:Float):Void {
			if (active != NOT_ACTIVE) {
				geometry += "\tCGContextMoveToPoint(ctx, " + 
					ObjCUtils.num2str(x, true) + ", " + 
					ObjCUtils.num2str(y, true) + ");\r";
			}
		}
		
		override public function lineTo(x:Float, y:Float):Void {
			if (active != NOT_ACTIVE) {
				geometry += "\tCGContextAddLineToPoint(ctx, " + 
					ObjCUtils.num2str(x, true) + ", " + 
					ObjCUtils.num2str(y, true) + ");\r";
			}
		}
		
		override public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
			if (active != NOT_ACTIVE) {
				geometry += "\tCGContextAddQuadCurveToPoint(ctx, " + 
					ObjCUtils.num2str(controlX, true) + ", " + 
					ObjCUtils.num2str(controlY, true) + ", " +
					ObjCUtils.num2str(anchorX, true) + ", " + 
					ObjCUtils.num2str(anchorY, true) + ");\r";
			}
		}

		
		private function processPreviousFill():Void {
			if (active == FILL_ACTIVE) {
				active = NOT_ACTIVE;
				fills.push(prefix + geometry + "\tCGContextClosePath(ctx);\r\r" + suffix);
				geometry = "";
				prefix = "";
				suffix = "";
			}
		}
		
		private function processPreviousStroke():Void {
			if (active == STROKE_ACTIVE) {
				active = NOT_ACTIVE;
				strokes.push(prefix + geometry + "\tCGContextClosePath(ctx);\r\r" + suffix);
				geometry = "";
				prefix = "";
				suffix = "";
			}
		}
	}
}
