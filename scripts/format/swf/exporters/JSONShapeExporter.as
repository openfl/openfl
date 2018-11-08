package com.codeazur.hxswf.exporters
{
	import com.codeazur.hxswf.SWF;
	import com.codeazur.hxswf.data.SWFRectangle;
	import com.codeazur.hxswf.exporters.core.DefaultShapeExporter;
	import com.codeazur.hxswf.tags.TagDefineShape;
	import com.codeazur.hxswf.utils.ColorUtils;
	import com.codeazur.hxswf.utils.NumberUtils;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	//
	// Exports Shape data to a JSON format as follows (example):
	//
	// "shape": {
	//   "bounds": {
	//  	"origin": [ 0, 0],
	//		"size": [23.35, 31.5]
	//	 },
	//  "groups": [{
	// 		"fills": [{
	// 			"fill": {
	//				"path": [
	//					{
	//						"move_to": [10.95, 31]
	//					},
	//					{
	//						"quadratic_curve_to": [0.25, 22.6, 0, 13.8]
	//					},
	//					....
	//					....
	//					....
	//					{
	//						"line_to": [10.95, 31]
	//					}],
	//				"fill_rgba": [0.5098039215686274, 0.5098039215686274, 0.5098039215686274, 1]
	//			}
	//		}],
	//		"strokes": [{
	//			"stroke": {
	//				"path": [
	//					{
	//						"move_to": [11.45, 13.8]
	//					},
	//					{
	//						"quadratic_curve_to": [16, 15.7, 22.85, 20.15]
	//					},
	//					....
	//					....
	//					....
	//					{
	//						"line_to": [4.3, 10.8]
	//					}],
	//				"line_cap": "round",
	//				"line_join": "round",
	//				"line_width": 0.5,
	//				"stroke_rgba": [0, 0, 0, 0.4]
	//			}
	//		}]
	//	}]
	//	} // end shape 
	//
	//
	// Gradient fills are supported
	// Bitmap fills are not supported
	//
	
	class JSONShapeExporter extends DefaultShapeExporter
	{
		// state
		private static inline var NOT_ACTIVE:String = "notActive";
		private static inline var FILL_ACTIVE:String = "fillActive";
		private static inline var BITMAP_FILL_ACTIVE:String = "bitmapFillActive";
		private static inline var STROKE_ACTIVE:String = "strokeActive";
		
		private var active:String = NOT_ACTIVE;

		// back reference to TagDefineShape object
		private var _tag:TagDefineShape;
		
		private var fills:Array<String>;
		private var strokes:Array<String>;
		
		private var groups:Array;
		private var groupIndex:Int;
				
		private var geometry:Array;
		private var prefix:Array;
		private var suffix:Array;
		
		private var _js:String = "";
		private var lineSep:String = "\n";

		
		public function JSONShapeExporter(swf:SWF, tag:TagDefineShape)
		{
			_tag = tag;
			super(swf);
		}
		
		public function get js():String { return _js; }
		
		private function CGRectJSONFromSWFRect(r:SWFRectangle):String {
			// SWFRectangle coordinates are in TWIPS
			// 20 TWIPS in 1 pixel
			var w:Float = (Number(r.xmax) / 20 - Number(r.xmin) / 20);
			var h:Float = (Number(r.ymax) / 20 - Number(r.ymin) / 20);
			var x:Float = NumberUtils.roundPixels20(r.xmin / 20);
			var y:Float = NumberUtils.roundPixels20(r.ymin / 20);
			
			var output:Array;
			
			output = ["{"];
			output.push('"origin": [' + x + ", " + y + "],");
			output.push('"size": [' + w + ", " + h + "]");
			output.push("}");
			
			return output.join(lineSep);
		}
		
		override public function beginShape():Void {			
			var shapeInfo:Array;
			shapeInfo = ['"bounds": ' + CGRectJSONFromSWFRect(_tag.shapeBounds)];
			_js += '{ "shape": {' + shapeInfo.join("," + lineSep) + ",";
			
			groups = [];
			groupIndex = 0;
		}
		
		
		override public function beginFills():Void {
			fills = new Array<String>();
			groups[groupIndex] = [];
		}
		
		override public function endFills():Void {
			var i:Int;
			var fill_lines:Array = [];
			var stroke_lines:Array = [];
			
			if (fills != null) {
				for (i = 0; i < fills.length; i++) {
					if ( fills[i].length > 0 ) {
						fill_lines.push('{ "fill": {' +
							fills[i] +
							'} }');
					}
				}
				
				groups[groupIndex].push('"fills": [' + fill_lines.join(',' + lineSep) + ']');
			}
			
			fills = null;
		}
		
		
		override public function beginLines():Void {
			strokes = new Array<String>();
		}
		
		override public function endLines():Void {
			processPreviousStroke();
			
			var i:Int;
			var stroke_lines:Array = [];
			
			if (strokes != null) {
				for (i = 0; i < strokes.length; i++) {
					if ( strokes[i].length > 0 ) {
						stroke_lines.push('{ "stroke": {' +
							strokes[i] +
							'} }');
					}
				}
				
				if ( !groups[groupIndex] )
					groups[groupIndex] = [];
				
				groups[groupIndex].push('"strokes": [' + stroke_lines.join(',' + lineSep) + ']');
			}
			
			strokes = null;
			
			// increment group index
			groupIndex++;
		}
		
		
		override public function endShape():Void {
			if ( groups.length == 0 )
			{
				// empty shape info => bail
				_js = "";
				fills = null;
				strokes = null;
				return;
			}
			
			// print groups
			_js += '"groups": [';
			
			var i:Int;
			for ( i = 0; i < groups.length; i++ )
			{
				var recordSep:String = (i < (groups.length - 1)) ? "," : "";
				var group:Array = groups[i];
				_js += '{' + group.join(',' + lineSep) + '}' + recordSep;
			}
			
			_js += ']';
			
			// close shape record
			_js += "}" + lineSep + "}";

			fills = null;
			strokes = null;
		}
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = [];
			geometry = []; // start path
			suffix = ['"fill_rgba": [' +
				ColorUtils.r(color) + ", " +
				ColorUtils.g(color) + ", " +
				ColorUtils.b(color) + ", " +
				alpha +
				"]"];
		}
		
		// process gradients...		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			processPreviousFill();
			active = FILL_ACTIVE;
			prefix = [];
			if (type == GradientType.LINEAR) {
				beginLinearGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			} else if (type == GradientType.RADIAL) {
				beginRadialGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			}
		}
		
		private function beginLinearGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			geometry = []; //start path
			var i:Int;
			var len:Int = uint(Math.min(Math.min(colors.length, alphas.length), ratios.length));
			
			var gradient:Array = new Array();
			
			var color_list:Array = new Array();			
			for (i = 0; i < len; i++) {
				var color:Int = colors[i];
				var rgba:Array = [ColorUtils.r(color), ColorUtils.g(color), ColorUtils.b(color), alphas[i]];
				color_list.push("[" + rgba.join(", ") + "]");
			}
			gradient.push('"colors": [' + color_list.join("," + lineSep) + "]"); 
			
			var ratio_list:Array = new Array();
			for (i = 0; i < len; i++) {
				ratio_list.push(Number(ratios[i]) / 255);
			}
			gradient.push('"ratios": [' + ratio_list.join(", ") + "]");
			
			var from:Point = new Point(-819.2 * matrix.a + matrix.tx, -819.2 * matrix.b + matrix.ty);
			var to:Point = new Point(819.2 * matrix.a + matrix.tx, 819.2 * matrix.b + matrix.ty);
			gradient.push('"from": [' + from.x + ", " + from.y + "]");
			gradient.push('"to": [' + to.x + ", " + to.y + "]");
			
			// define gradient
			suffix = ['"linear_gradient": {' + gradient.join("," + lineSep) + '}'];
		}		
		
		private function beginRadialGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			var i:Int;
			var len:Int = uint(Math.min(Math.min(colors.length, alphas.length), ratios.length));
			
			geometry = new Array(); // start path
						
			var gradient:Array = new Array();
			
			var color_list:Array = new Array();			
			for (i = 0; i < len; i++) {
				var color:Int = colors[i];
				var rgba:Array = [ColorUtils.r(color), ColorUtils.g(color), ColorUtils.b(color), alphas[i]];
				color_list.push("[" + rgba.join(", ") + "]");
			}
			gradient.push('"colors": [' + color_list.join("," + lineSep) + "]"); 
			
			var ratio_list:Array = new Array();
			for (i = 0; i < len; i++) {
				ratio_list.push(Number(ratios[i]) / 255);
			}
			gradient.push('"ratios": [' + ratio_list.join(", ") + "]");
			
			// NOTE: start position can be inferred from tag.shapeBounds
			// end position can be inferred from start & focalPointRatio
			
			// focal point
			gradient.push('"focal_point_ratio": ' + focalPointRatio);
			
			// normalize matrix to remove flash space dependency
			var flashMat:Matrix = matrix.clone();
			matrix = new Matrix(819.2*2, 0, 0, 819.2*2, 0, 0);
			matrix.concat(flashMat);
			
			gradient.push('"gradient_transform": [' +
				matrix.a + ", " + matrix.b + ", " + matrix.c + ", " +
				matrix.d + ", " + matrix.tx + ", " + matrix.ty +
				"]");
			
			// define gradient
			suffix = ['"radial_gradient": {' + gradient.join("," + lineSep) + '}'];
		}
		
		// bitmap fills => currently NOT Supported
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
			prefix = new Array();
			var styleLines:Array = new Array();
			if (startCaps == null || startCaps == CapsStyle.ROUND) {
				styleLines.push('"line_cap": "round"');
			} else if (startCaps == CapsStyle.SQUARE) {
				styleLines.push('"line_cap": "square"');
			}
			if (joints == null || joints == JointStyle.ROUND) {
				styleLines.push('"line_join": "round"');
			} else if (joints == JointStyle.BEVEL) {
				styleLines.push('"line_join": "miter"');
				styleLines.push('"miter_limit": ' + miterLimit);
			} else {
				styleLines.push('"miter_limit": ' + miterLimit);
			}
			
			geometry = new Array(); // start path
			suffix = styleLines;
			suffix.push('"line_width": ' + thickness);
			suffix.push('"stroke_rgba": [' +
				ColorUtils.r(color) + ", " +
				ColorUtils.g(color) + ", " +
				ColorUtils.b(color) + ", " +
				alpha +
				"]");
		}
		
		override public function moveTo(x:Float, y:Float):Void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push('{ "move_to": [' + 
					NumberUtils.roundPixels20(x) + ", " + 
					NumberUtils.roundPixels20(y) + "] }");
			}
		}
		
		override public function lineTo(x:Float, y:Float):Void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push('{ "line_to": [' + 
					NumberUtils.roundPixels20(x) + ", " + 
					NumberUtils.roundPixels20(y) + "] }");
			}
		}
		
		override public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
			if (active != NOT_ACTIVE && active != BITMAP_FILL_ACTIVE) {
				geometry.push('{ "quadratic_curve_to": [' + 
					NumberUtils.roundPixels20(controlX) + ", " + 
					NumberUtils.roundPixels20(controlY) + ", " + 
					NumberUtils.roundPixels20(anchorX) + ", " + 
					NumberUtils.roundPixels20(anchorY) + "] }");
			}
		}
		
		private function processPreviousFill():Void {
			var path:String;			
			
			if (active == FILL_ACTIVE) {
				active = NOT_ACTIVE;
				
				// define path from geometry	
				path = '"path": [' + lineSep + geometry.join("," + lineSep) + ']';
				suffix.unshift(path);
				
				fills.push(
					prefix.join("," + lineSep),
					suffix.join("," + lineSep)
				);
			} else if(active == BITMAP_FILL_ACTIVE) {
				active = NOT_ACTIVE;
				
				// define path from geometry	
				path = '"path": [' + lineSep + geometry.join("," + lineSep) + ']';
				suffix.unshift(path);
				
				fills.push(
					prefix.join("," + lineSep),
					suffix.join("," + lineSep)
				);
			}
		}
		
		private function processPreviousStroke():Void {
			if (active == STROKE_ACTIVE) {
				active = NOT_ACTIVE;
				
				// define path from geometry
				var path:String = '"path": [' + lineSep + geometry.join("," + lineSep) + ']';
				suffix.unshift(path);

				strokes.push(
					prefix.join("," + lineSep),
					suffix.join("," + lineSep)
				);
			}
		}
	}
}