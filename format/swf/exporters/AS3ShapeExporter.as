package com.codeazur.hxswf.exporters
{
	import com.codeazur.hxswf.SWF;
	import com.codeazur.hxswf.exporters.core.DefaultShapeExporter;
	import com.codeazur.hxswf.utils.NumberUtils;
	import com.codeazur.utils.StringUtils;
	
	import flash.display.CapsStyle;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	class AS3ShapeExporter extends DefaultShapeExporter
	{
		private var _actionScript:String;
		
		public function AS3ShapeExporter(swf:SWF) {
			super(swf);
		}
		
		public function get actionScript():String { return _actionScript; }
		
		override public function beginShape():Void {
			_actionScript = "";
		}
		
		override public function beginFills():Void {
			_actionScript += "// Fills:\rgraphics.lineStyle();\r";
		}

		override public function beginLines():Void {
			_actionScript += "// Lines:\r";
		}
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			if (alpha != 1.0) {
				_actionScript += StringUtils.printf("graphics.beginFill(0x%06x, %f);\r", color, alpha);
			} else {
				_actionScript += StringUtils.printf("graphics.beginFill(0x%06x);\r", color);
			}
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			var asMatrix:String = "null";
			if (matrix != null) {
				asMatrix = "new Matrix(" + 
					matrix.a + "," + 
					matrix.b + "," + 
					matrix.c + "," + 
					matrix.d + "," + 
					matrix.tx + "," + 
					matrix.ty + ")";
			}
			var asColors:String = "";
			for (var i:Int = 0; i < colors.length; i++) {
				asColors += StringUtils.printf("0x%06x", colors[i]);
				if (i < colors.length - 1) { asColors += ","; }
			}
			if (focalPointRatio != 0.0) {
				_actionScript += StringUtils.printf("graphics.beginGradientFill('%s', [%s], [%s], [%s], %s, '%s', '%s', %s);\r", 
					type,
					asColors,
					alphas.join(","),
					ratios.join(","),
					asMatrix,
					spreadMethod,
					interpolationMethod,
					focalPointRatio.toString());
			} else if (interpolationMethod != InterpolationMethod.RGB) {
				_actionScript += StringUtils.printf("graphics.beginGradientFill('%s', [%s], [%s], [%s], %s, '%s', '%s'\r);", 
					type,
					asColors,
					alphas.join(","),
					ratios.join(","),
					asMatrix,
					spreadMethod,
					interpolationMethod);
			} else if (spreadMethod != SpreadMethod.PAD) {
				_actionScript += StringUtils.printf("graphics.beginGradientFill('%s', [%s], [%s], [%s], %s, '%s');\r", 
					type,
					asColors,
					alphas.join(","),
					ratios.join(","),
					asMatrix,
					spreadMethod);
			} else if (matrix != null) {
				_actionScript += StringUtils.printf("graphics.beginGradientFill('%s', [%s], [%s], [%s], %s);\r", 
					type,
					asColors,
					alphas.join(","),
					ratios.join(","),
					asMatrix);
			} else {
				_actionScript += StringUtils.printf("graphics.beginGradientFill('%s', [%s], [%s], [%s]);\r", 
					type,
					asColors,
					alphas.join(","),
					ratios.join(","));
			}
		}

		override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
			var asMatrix:String = "null";
			if (matrix != null) {
				asMatrix = "new Matrix(" + 
					matrix.a + "," + 
					matrix.b + "," + 
					matrix.c + "," + 
					matrix.d + "," + 
					matrix.tx + "," + 
					matrix.ty + ")";
			}
			if (smooth) {
				_actionScript += StringUtils.printf("// graphics.beginBitmapFill(%d, %s, %s, %s);\r", bitmapId, asMatrix, repeat, smooth);
			} else if (!repeat) {
				_actionScript += StringUtils.printf("// graphics.beginBitmapFill(%d, %s, %s, %s);\r", bitmapId, asMatrix, repeat);
			} else {
				_actionScript += StringUtils.printf("// graphics.beginBitmapFill(%d, %s, %s, %s);\r", bitmapId, asMatrix);
			}
		}
		
		override public function endFill():Void {
			_actionScript += "graphics.endFill();\r";
		}
		
		override public function lineStyle(thickness:Float = NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Float = 3):Void {
			if (miterLimit != 3) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f, %s, %s, %s, %s, %f);\r", 
					thickness, color, alpha, pixelHinting.toString(),
					(scaleMode == null ? "null" : "'" + scaleMode + "'"),
					(startCaps == null ? "null" : "'" + startCaps + "'"),
					(joints == null ? "null" : "'" + joints + "'"),
					miterLimit);
			} else if (joints != null && joints != JointStyle.ROUND) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f, %s, %s, %s, %s);\r", 
					thickness, color, alpha, pixelHinting.toString(),
					(scaleMode == null ? "null" : "'" + scaleMode + "'"),
					(startCaps == null ? "null" : "'" + startCaps + "'"),
					"'" + joints + "'");
			} else if(startCaps != null && startCaps != CapsStyle.ROUND) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f, %s, %s, %s);\r", 
					thickness, color, alpha, pixelHinting.toString(),
					(scaleMode == null ? "null" : "'" + scaleMode + "'"),
					"'" + startCaps + "'");
			} else if(scaleMode != LineScaleMode.NORMAL) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f, %s, %s);\r", 
					thickness, color, alpha, pixelHinting.toString(),
					(scaleMode == null ? "null" : "'" + scaleMode + "'"));
			} else if(pixelHinting) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f, %s);\r", 
					thickness, color, alpha, pixelHinting.toString());
			} else if(alpha != 1.0) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x, %f);\r", thickness, color, alpha);
			} else if(color != 0) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f, 0x%06x);\r", thickness, color);
			} else if(!isNaN(thickness)) {
				_actionScript += StringUtils.printf("graphics.lineStyle(%f);\r", thickness);
			} else {
				_actionScript += "graphics.lineStyle();\r";
			}
		}
		
		override public function moveTo(x:Float, y:Float):Void {
			_actionScript += StringUtils.printf("graphics.moveTo(%s, %s);\r",
				NumberUtils.roundPixels400(x),
				NumberUtils.roundPixels400(y)
			);
		}
		
		override public function lineTo(x:Float, y:Float):Void {
			_actionScript += StringUtils.printf("graphics.lineTo(%s, %s);\r",
				NumberUtils.roundPixels400(x),
				NumberUtils.roundPixels400(y)
			);
		}
		
		override public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
			_actionScript += StringUtils.printf("graphics.curveTo(%s, %s, %s, %s);\r",
				NumberUtils.roundPixels400(controlX),
				NumberUtils.roundPixels400(controlY),
				NumberUtils.roundPixels400(anchorX),
				NumberUtils.roundPixels400(anchorY)
			);
		}
	}
}
