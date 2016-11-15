package com.codeazur.hxswf.exporters
{
	import com.codeazur.hxswf.SWF;
	import com.codeazur.hxswf.exporters.core.DefaultSVGShapeExporter;
	import com.codeazur.hxswf.utils.ColorUtils;
	import com.codeazur.utils.StringUtils;
	
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	class SVGShapeExporter extends DefaultSVGShapeExporter
	{
		private static inline var s:Namespace = new Namespace("s", "http://www.w3.org/2000/svg");
		private static inline var xlink:Namespace = new Namespace("xlink", "http://www.w3.org/1999/xlink");
				
		private var _svg:XML;
		private var path:XML;
		private var gradients:Array<String>;
		
		public function SVGShapeExporter(swf:SWF) {
			super(swf);
		}
		
		public function get svg():XML { return _svg; }
		
		override public function beginShape():Void {
			_svg = <svg xmlns={s.uri} xmlns:xlink={xlink.uri}><defs /><g /></svg>;
			gradients = new Array<String>();
		}
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			finalizePath();
			path.@stroke = "none";
			path.@fill = ColorUtils.rgbToString(color);
			if(alpha != 1) { path.@["fill-opacity"] = alpha; }
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			finalizePath();
			var gradient:XML = (type == GradientType.LINEAR) ? <linearGradient /> : <radialGradient />;
			populateGradientElement(gradient, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			var id:Int = gradients.indexOf(gradient.toXMLString());
			if(id < 0) {
				id = gradients.length;
				gradients.push(gradient.toXMLString());
			}
			gradient.@id = "gradient" + id;
			path.@stroke = "none";
			path.@fill = "url(#gradient" + id + ")";
			svg.s::defs.appendChild(gradient);
		}

		override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
			throw(new Error("Bitmap fills are not yet supported for shape export."));
		}
		
		override public function lineStyle(thickness:Float = NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Float = 3):Void {
			finalizePath();
			path.@fill = "none";
			path.@stroke = ColorUtils.rgbToString(color);
			path.@["stroke-width"] = isNaN(thickness) ? 1 : thickness;
			if(alpha != 1) { path.@["stroke-opacity"] = alpha; }
			switch(startCaps) {
				case CapsStyle.NONE: path.@["stroke-linecap"] = "butt"; break;
				case CapsStyle.SQUARE: path.@["stroke-linecap"] = "square"; break;
				default: path.@["stroke-linecap"] = "round"; break;
			}
			switch(joints) {
				case JointStyle.BEVEL: path.@["stroke-linejoin"] = "bevel"; break;
				case JointStyle.ROUND: path.@["stroke-linejoin"] = "round"; break;
				default:
					path.@["stroke-linejoin"] = "miter";
					if(miterLimit >= 1 && miterLimit != 4) {
						path.@["stroke-miterlimit"] = miterLimit;
					}
					break;
			}
		}

		override public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			delete path.@["stroke-opacity"]
			var gradient:XML = (type == GradientType.LINEAR) ? <linearGradient /> : <radialGradient />;
			populateGradientElement(gradient, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			var id:Int = gradients.indexOf(gradient.toXMLString());
			if(id < 0) {
				id = gradients.length;
				gradients.push(gradient.toXMLString());
			}
			gradient.@id = "gradient" + id;
			path.@stroke = "url(#gradient" + id + ")";
			path.@fill = "none";
			svg.s::defs.appendChild(gradient);
		}

		
		override private function finalizePath():Void {
			if(path && pathData != "") {
				path.@d = StringUtils.trim(pathData);
				svg.s::g.appendChild(path);
			}
			path = <path />;
			super.finalizePath();
		}
		
		
		private function populateGradientElement(gradient:XML, type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Float):Void {
			gradient.@gradientUnits = "userSpaceOnUse";
			if(type == GradientType.LINEAR) {
				gradient.@x1 = -819.2;
				gradient.@x2 = 819.2;
			} else {
				gradient.@r = 819.2;
				gradient.@cx = 0;
				gradient.@cy = 0;
				if(focalPointRatio != 0) {
					gradient.@fx = 819.2 * focalPointRatio;
					gradient.@fy = 0;
				}
			}
			if(spreadMethod != SpreadMethod.PAD) { gradient.@spreadMethod = spreadMethod; }
			switch(spreadMethod) {
				case SpreadMethod.PAD: gradient.@spreadMethod = "pad"; break;
				case SpreadMethod.REFLECT: gradient.@spreadMethod = "reflect"; break;
				case SpreadMethod.REPEAT: gradient.@spreadMethod = "repeat"; break;
			}
			if(interpolationMethod == InterpolationMethod.LINEAR_RGB) { gradient.@["color-interpolation"] = "linearRGB"; }
			if(matrix) {
				var gradientValues:Array = [matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty];
				gradient.@gradientTransform = "matrix(" + gradientValues.join(" ") + ")";
			}
			for(var i:Int = 0; i < colors.length; i++) {
				var gradientEntry:XML = <stop offset={ratios[i] / 255} />
				if(colors[i] != 0) { gradientEntry.@["stop-color"] = ColorUtils.rgbToString(colors[i]); }
				if(alphas[i] != 1) { gradientEntry.@["stop-opacity"] = alphas[i]; }
				gradient.appendChild(gradientEntry);
			}
		}
	}
}
