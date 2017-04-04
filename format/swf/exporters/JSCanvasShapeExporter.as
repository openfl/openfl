package com.codeazur.as3swf.exporters
{
	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.utils.ColorUtils;
	import com.codeazur.as3swf.utils.NumberUtils;
	
	import flash.display.CapsStyle;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.codeazur.as3swf.exporters.core.DefaultShapeExporter;

	public class JSCanvasShapeExporter extends DefaultShapeExporter
	{
		protected static const NOT_ACTIVE:String = "notActive";
		protected static const FILL_ACTIVE:String = "fillActive";
		protected static const BITMAP_FILL_ACTIVE:String = "bitmapFillActive";
		protected static const STROKE_ACTIVE:String = "strokeActive";
		
		protected var _js:String = "";
		
		protected var fills:Vector.<String>;
		protected var strokes:Vector.<String>;
		
		protected var geometry:Array;
		protected var prefix:Array;
		protected var suffix:Array;
		
		protected var active:String = NOT_ACTIVE;
		
		protected var condensed:Boolean;
		protected var lineSep:String = "";
		
		public function JSCanvasShapeExporter(swf:SWF, condensed:Boolean = true)
		{
			super(swf);
			this.condensed = condensed;
			if(!condensed) {
				lineSep = "\r";
			}
		}
		
		public function get js():String { return _js; }
		

		override public function beginShape():void {
			_js = "";
		}
		
		
		override public function beginFills():void {
			fills = new Vector.<String>();
		}

		override public function endFills():void {
		}

		
		override public function beginLines():void {
			strokes = new Vector.<String>();
		}
		
		override public function endLines():void {
			processPreviousStroke();
		}
		
		
		override public function endShape():void {
			var i:uint;
			if (fills != null) {
				_js += fills.join(lineSep);
			}
			if (strokes != null) {
				_js += strokes.join(lineSep);
			}
			fills = null;
			strokes = null;
		}
		
		
		override public function beginFill(color:uint, alpha:Number = 1.0):void {
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = ["c.save();"];
			geometry = ["c.beginPath();"];
			suffix = ["c.fillStyle=\"rgba(" + 
				ColorUtils.r(color) * 255 + ", " +
				ColorUtils.g(color) * 255 + ", " +
				ColorUtils.b(color) * 255 + ", " +
				alpha +
				")\";",
				"c.fill();", 
				"c.restore();"];
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0):void {
			processPreviousFill();
			active = NOT_ACTIVE;
			// TODO
			/*
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = "\tCGContextSaveGState(ctx);\r\r";
			geometry = "\tCGContextBeginPath(ctx);\r";
			var i:uint;
			var len:uint = uint(Math.min(Math.min(colors.length, alphas.length), ratios.length));
			if (type == GradientType.LINEAR) {
				suffix = "\tCGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();\r"
				suffix += "\tCGFloat colors[" + (len * 4) + "] = {\r";
				for (i = 0; i < len; i++) {
					var color:uint = colors[i];
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
			*/
		}

		override public function beginBitmapFill(bitmapId:uint, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void {
			processPreviousFill();
			active = BITMAP_FILL_ACTIVE;
			prefix = ["c.save();"];
			geometry = [];
			suffix = ["var i=swf.ia[swf.ca[" + bitmapId + "].i].i;",
				"c.drawImage(i," + 
				"0," +
				"0," +
				"i.width," +
				"i.height," +
				matrix.tx + "," +
				matrix.ty + "," +
				(matrix.a/20) + "*i.width," +
				(matrix.d/20) + "*i.height" +
				");",
				"c.restore();"]
		}
		
		override public function endFill():void {
			processPreviousFill();
			active = NOT_ACTIVE;
		}
		
		override public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Number = 3):void {
			processPreviousStroke();
			active = STROKE_ACTIVE;
			prefix = ["c.save();"];
			if (startCaps == null || startCaps == CapsStyle.ROUND) {
				prefix.push("c.lineCap = \"round\";");
			} else if (startCaps == CapsStyle.SQUARE) {
				prefix.push("c.lineCap = \"square\";");
			}
			if (joints == null || joints == JointStyle.ROUND) {
				prefix.push("c.lineJoin = \"round\";");
			} else if (joints == JointStyle.BEVEL) {
				prefix.push("c.lineJoin = \"miter\";");
				prefix.push("c.miterLimit = " + miterLimit + ";");
			} else {
				prefix.push("c.miterLimit = " + miterLimit + ";");
			}
			geometry = ["c.beginPath();"];
			suffix = ["c.strokeStyle=\"rgba(" + 
				ColorUtils.r(color) * 255 + ", " +
				ColorUtils.g(color) * 255 + ", " +
				ColorUtils.b(color) * 255 + ", " +
				alpha +
				")\";",
				"c.lineWidth = " + thickness + ";",
				"c.stroke();",
				"c.restore();"];
		}
		
		override public function moveTo(x:Number, y:Number):void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push("c.moveTo(" + 
					NumberUtils.roundPixels20(x) + ", " + 
					NumberUtils.roundPixels20(y) + ");");
			}
		}
		
		override public function lineTo(x:Number, y:Number):void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push("c.lineTo(" + 
					NumberUtils.roundPixels20(x) + ", " + 
					NumberUtils.roundPixels20(y) + ");");
			}
		}
		
		override public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push("c.quadraticCurveTo(" + 
					NumberUtils.roundPixels20(controlX) + ", " + 
					NumberUtils.roundPixels20(controlY) + ", " + 
					NumberUtils.roundPixels20(anchorX) + ", " + 
					NumberUtils.roundPixels20(anchorY) + ");");
			}
		}

		
		protected function processPreviousFill():void {
			if (active == FILL_ACTIVE) {
				active = NOT_ACTIVE;
				geometry.push("c.closePath();");
				fills.push(
					prefix.join(lineSep),
					geometry.join(lineSep),
					suffix.join(lineSep)
				);
			} else if(active == BITMAP_FILL_ACTIVE) {
				active = NOT_ACTIVE;
				fills.push(
					prefix.join(lineSep), 
					suffix.join(lineSep)
				);
			}
		}
		
		protected function processPreviousStroke():void {
			if (active == STROKE_ACTIVE) {
				active = NOT_ACTIVE;
				strokes.push(
					prefix.join(lineSep),
					geometry.join(lineSep),
					suffix.join(lineSep)
				);
			}
		}
	}
}