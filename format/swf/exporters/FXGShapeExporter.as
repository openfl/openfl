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
	
	class FXGShapeExporter extends DefaultSVGShapeExporter
	{
		private static inline var s:Namespace = new Namespace("s", "library://ns.adobe.com/flex/spark");
		
		private var _fxg:XML;
		private var path:XML;
		
		public function FXGShapeExporter(swf:SWF) {
			super(swf);
		}
		
		public function get fxg():XML { return _fxg; }
		
		override public function beginShape():Void {
			_fxg = <s:Graphic xmlns:s={s.uri}><s:Group /></s:Graphic>;
		}
		
		override public function beginFill(color:Int, alpha:Float = 1.0):Void {
			finalizePath();
			var fill:XML = <s:fill xmlns:s={s.uri} />;
			var solidColor:XML = <s:SolidColor xmlns:s={s.uri} />;
			if(color != 0) { solidColor.@color = ColorUtils.rgbToString(color); }
			if(alpha != 1) { solidColor.@alpha = alpha; }
			fill.appendChild(solidColor);
			path.appendChild(fill);
		}
		
		override public function beginGradientFill(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			finalizePath();
			var fill:XML = <s:fill xmlns:s={s.uri} />;
			var gradient:XML;
			if(type == GradientType.LINEAR) {
				gradient = <s:LinearGradient xmlns:s={s.uri} />;
			} else {
				gradient = <s:RadialGradient xmlns:s={s.uri} />;
			}
			populateGradientElement(gradient, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			fill.appendChild(gradient);
			path.appendChild(fill);
		}

		override public function beginBitmapFill(bitmapId:Int, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
			throw(new Error("Bitmap fills are not yet supported for shape export."));
		}
		
		override public function lineStyle(thickness:Float = NaN, color:Int = 0, alpha:Float = 1.0, pixelHinting:Bool = false, scaleMode:String = LineScaleMode.NORMAL, startCaps:String = null, endCaps:String = null, joints:String = null, miterLimit:Float = 3):Void {
			finalizePath();
			var stroke:XML = <s:stroke xmlns:s={s.uri} />;
			var solidColorStroke:XML = <s:SolidColorStroke xmlns:s={s.uri} />;
			if(!isNaN(thickness) && thickness != 1) { solidColorStroke.@weight = thickness; }
			if(color != 0) { solidColorStroke.@color = ColorUtils.rgbToString(color); }
			if(alpha != 1) { solidColorStroke.@alpha = alpha; }
			if(pixelHinting) { solidColorStroke.@pixelHinting = "true"; }
			if(scaleMode != LineScaleMode.NORMAL) { solidColorStroke.@scaleMode = scaleMode; }
			if(startCaps && startCaps != CapsStyle.ROUND) { solidColorStroke.@caps = startCaps; }
			if(joints && joints != JointStyle.ROUND) { solidColorStroke.@joints = joints; }
			if(miterLimit != 3) { solidColorStroke.@miterLimit = miterLimit; }
			stroke.appendChild(solidColorStroke);
			path.appendChild(stroke);
		}

		override public function lineGradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Float = 0):Void {
			var strokeElement:XML = path..s::SolidColorStroke[0];
			if(strokeElement) {
				if(type == GradientType.LINEAR) {
					strokeElement.setLocalName("LinearGradientStroke");
				} else {
					strokeElement.setLocalName("RadialGradientStroke");
				}
				delete strokeElement.@color;
				delete strokeElement.@alpha;
				populateGradientElement(strokeElement, type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
			}
		}

		
		override private function finalizePath():Void {
			if(path && pathData != "") {
				path.@data = StringUtils.trim(pathData);
				fxg.s::Group.appendChild(path);
			}
			path = <s:Path xmlns:s={s.uri} />;
			super.finalizePath();
		}
		
		
		private function populateGradientElement(gradient:XML, type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix, spreadMethod:String, interpolationMethod:String, focalPointRatio:Float):Void {
			var isLinear:Bool = (type == GradientType.LINEAR);
			if(!isLinear && focalPointRatio != 0) {
				gradient.@focalPointRatio = focalPointRatio;
			}
			if(spreadMethod != SpreadMethod.PAD) { gradient.@spreadMethod = spreadMethod; }
			if(interpolationMethod != InterpolationMethod.RGB) { gradient.@interpolationMethod = interpolationMethod; }
			if(matrix) {
				// The original matrix transforms the SWF gradient rect:
				// (-16384, -16384), (16384, 16384)
				// into the target gradient rect.
				// We need to transform the FXG gradient rect:
				// (0, 0), (1, 1) for linear gradients
				// (-0.5, -0.5), (0.5, 0.5) for radial gradients
				// Scale and rotation of the original matrix is based on twips,
				// so additionaly we have to divide by 20.
				var m:Matrix = matrix.clone();
				// Normalize the original scale and rotation
				m.scale(32768 / 20, 32768 / 20);
				// Adjust the translation
				// For linear gradients, we take the point (-16384, 0)
				// and scale and rotate it using the original matrix.
				// What we get is the start point of the gradient,
				// so we add tx/ty to get the real translation for the new rect.
				// For radial gradients we just stick with the original tx/ty.
				m.tx = isLinear ? -16384 * matrix.a / 20 + matrix.tx : matrix.tx;
				m.ty = isLinear ? -16384 * matrix.b / 20 + matrix.ty : matrix.ty;
				var matrixContainer:XML = <s:matrix xmlns:s={s.uri} /> 
				var matrixChild:XML = <s:Matrix xmlns:s={s.uri} />
				if(m.tx != 0) { matrixChild.@tx = m.tx; }
				if(m.ty != 0) { matrixChild.@ty = m.ty; }
				if(m.a != 1) { matrixChild.@a = m.a; }
				if(m.b != 0) { matrixChild.@b = m.b; }
				if(m.c != 0) { matrixChild.@c = m.c; }
				if(m.d != 1) { matrixChild.@d = m.d; }
				matrixContainer.appendChild(matrixChild);
				gradient.appendChild(matrixContainer);
			}
			for(var i:Int = 0; i < colors.length; i++) {
				var gradientEntry:XML = <s:GradientEntry xmlns:s={s.uri} ratio={ratios[i] / 255} />
				if(colors[i] != 0) { gradientEntry.@color = ColorUtils.rgbToString(colors[i]); }
				if(alphas[i] != 1) { gradientEntry.@alpha = alphas[i]; }
				gradient.appendChild(gradientEntry);
			}
		}
	}
}
