package openfl.display._internal;

#if !flash
import openfl.display.BitmapData;
import openfl.filters.BitmapFilterShader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class BlendModeShader extends BitmapFilterShader
{
	@:glFragmentSource("varying vec2 openfl_TextureCoordv;
		uniform sampler2D openfl_Texture;
		uniform sampler2D uBackdrop;
		uniform vec4 uBackdropFrame;
		uniform float uAlpha;
		uniform int uMode;
		uniform bool uDiscardTransparent;
		uniform sampler2D uCoverage;
		uniform bool uHasCoverage;
		uniform sampler2D uTouched;
		uniform vec2 uTouchedFrame;
		uniform bool uHasTouched;

		vec3 hardLight(vec3 base, vec3 control) {
			return mix(2.0 * base * control, 1.0 - 2.0 * (1.0 - base) * (1.0 - control), step(0.5, control));
		}

		void main(void) {
			// the source is the object's own texture, at its alpha; the backdrop copy is read at
			// this fragment's position in the framebuffer (see setBackdrop), so the source quad
			// can be a group at the backdrop's rectangle or the object drawn with its own matrix
			vec4 src = texture2D(openfl_Texture, openfl_TextureCoordv) * uAlpha;
			vec2 backdropCoord = (gl_FragCoord.xy - uBackdropFrame.xy) * uBackdropFrame.zw;
			vec4 dst = texture2D(uBackdrop, backdropCoord);

			float srcAlpha = src.a;
			float dstAlpha = dst.a;

			// a texel the shape did not draw: leave the backdrop alone (see applyDiscardTransparent)
			if (uDiscardTransparent && srcAlpha == 0.0) discard;

			// every mode is the source on its own where the backdrop is transparent, plus the
			// backdrop's share from the mode's formula, with the part of the backdrop alpha that
			// stays (PDF compositing on premultiplied colour)
			vec3 sourceOnly = src.rgb * (1.0 - dstAlpha);
			float sourceAlpha = srcAlpha * (1.0 - dstAlpha);
			float kept = 1.0;

			vec3 backdrop;

			if (uMode < 6) {
				// a separable blend of the straight colours, weighted by both alphas
				vec3 s = srcAlpha > 0.0 ? src.rgb / srcAlpha : vec3(0.0);
				vec3 d = dstAlpha > 0.0 ? dst.rgb / dstAlpha : vec3(0.0);

				vec3 blend;

				if (uMode == 0) blend = abs(d - s); 			// DIFFERENCE
				else if (uMode == 1) blend = d * s; 			// MULTIPLY
				else if (uMode == 2) blend = min(d, s); 		// DARKEN
				else if (uMode == 3) blend = max(d, s); 		// LIGHTEN
				else if (uMode == 4) blend = hardLight(d, s); 	// HARDLIGHT
				else blend = hardLight(s, d); 					// OVERLAY

				backdrop = dst.rgb * (1.0 - srcAlpha) + srcAlpha * dstAlpha * blend;

			} else {
				// Flash's formulas, applied to the covered part c of the pixel (from the touched
				// buffer, or 1) on that part's color; over the rest the object shows as it is
				float c = uHasTouched ? texture2D(uTouched, gl_FragCoord.xy * uTouchedFrame).a : 1.0;
				vec4 d = c > 0.0 ? dst / c : vec4(0.0);
				vec3 f;
				float fa;

				if (uMode == 6) { f = max(vec3(0.0), d.rgb - src.rgb); fa = min(1.0, srcAlpha + d.a); }						// SUBTRACT: the alpha adds up
				else if (uMode == 7) { f = d.rgb + srcAlpha * (1.0 - 2.0 * d.rgb); fa = srcAlpha + d.a * (1.0 - srcAlpha); }	// INVERT
				else if (uMode == 8) { f = d.rgb * (1.0 - srcAlpha); fa = d.a * (1.0 - srcAlpha); }							// ERASE
				else {																										// ALPHA
					// with a coverage of the object, the backdrop is kept by 1 - coverage + alpha: what
					// the object did not cover stays, what it covered stays by its alpha
					float keep = uHasCoverage ? min(1.0, 1.0 - texture2D(uCoverage, openfl_TextureCoordv).a + srcAlpha) : srcAlpha;
					f = d.rgb * keep;
					fa = d.a * keep;
				}

				gl_FragColor = vec4((1.0 - c) * src.rgb + c * f, (1.0 - c) * srcAlpha + c * fa);
				return;
			}

			gl_FragColor = vec4(sourceOnly + backdrop, sourceAlpha + dstAlpha * kept);
		}")
	public function new()
	{
		super();

		#if !macro
		uBackdropFrame.value = [0, 0, 1, 1];
		uAlpha.value = [1];
		uMode.value = [0];
		uDiscardTransparent.value = [false];
		uHasCoverage.value = [false];
		uTouchedFrame.value = [1, 1];
		uHasTouched.value = [false];
		#end
	}

	/**
		Sets the copy of the backdrop the shader blends against. (x, y) is the framebuffer position the
		copy was taken from, so that the fragment position maps straight onto it.
	**/
	public function setBackdrop(backdrop:BitmapData, x:Float, y:Float):Void
	{
		#if !macro
		uBackdrop.input = backdrop;
		uBackdrop.filter = NEAREST;
		uBackdrop.mipFilter = MIPNONE;
		uBackdrop.wrap = CLAMP;
		uBackdropFrame.value[0] = x;
		uBackdropFrame.value[1] = y;
		uBackdropFrame.value[2] = 1 / backdrop.__textureWidth;
		uBackdropFrame.value[3] = 1 / backdrop.__textureHeight;
		#end
	}

	/**
		Sets the touched buffer (see `DisplayObjectRenderer.__touch`), read at the fragment position.
		With null, every pixel counts as covered.
	**/
	public function setTouched(touched:BitmapData):Void
	{
		#if !macro
		uHasTouched.value[0] = touched != null;
		uTouched.input = touched;
		uTouched.filter = NEAREST;
		uTouched.mipFilter = MIPNONE;
		uTouched.wrap = CLAMP;
		if (touched != null)
		{
			uTouchedFrame.value[0] = 1 / touched.__textureWidth;
			uTouchedFrame.value[1] = 1 / touched.__textureHeight;
		}
		#end
	}

	/**
		Prepares the shader for one draw: the blend mode, the alpha of the source, whether to skip fully
		transparent source texels, and for ALPHA the source's coverage, which is sampled with the same
		texture coordinates as the source. `mode` is one of the ids from
		`OpenGLRenderer.__shaderModeId`.
	**/
	public function prepare(mode:Int, alpha:Float, discardTransparent:Bool, coverage:BitmapData):Void
	{
		#if !macro
		uMode.value[0] = mode;
		uAlpha.value[0] = alpha;
		uDiscardTransparent.value[0] = discardTransparent;
		uHasCoverage.value[0] = coverage != null;
		uCoverage.input = coverage;
		uCoverage.filter = NEAREST;
		uCoverage.mipFilter = MIPNONE;
		uCoverage.wrap = CLAMP;
		#end
	}
}
#end
