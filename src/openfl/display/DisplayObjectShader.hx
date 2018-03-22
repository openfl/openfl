package openfl.display;


import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class DisplayObjectShader extends Shader {
	
	
	@:glVertexHeader(
		
		"attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TexCoord;
		
		varying float openfl_vAlpha;
		varying vec4 openfl_vColorMultiplier;
		varying vec4 openfl_vColorOffset;
		varying vec2 openfl_vTexCoord;
		
		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;"
		
	)
	
	
	@:glVertexBody(
		
		"openfl_vAlpha = openfl_Alpha;
		openfl_vTexCoord = openfl_TexCoord;
		
		if (openfl_HasColorTransform) {
			
			openfl_vColorMultiplier = openfl_ColorMultiplier;
			openfl_vColorOffset = openfl_ColorOffset / 255.0;
			
		}
		
		gl_Position = openfl_Matrix * openfl_Position;"
		
	)
	
	
	@:glVertexSource(
		
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
		}"
		
	)
	
	
	@:glFragmentHeader(
		
		"varying float openfl_vAlpha;
		varying vec4 openfl_vColorMultiplier;
		varying vec4 openfl_vColorOffset;
		varying vec2 openfl_vTexCoord;
		
		uniform bool openfl_HasColorTransform;
		uniform sampler2D openfl_Texture;"
		
	)
	
	
	@:glFragmentBody(
		
		"vec4 color = texture2D (openfl_Texture, openfl_vTexCoord);
		
		if (color.a == 0.0) {
			
			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			
		} else if (openfl_HasColorTransform) {
			
			color = vec4 (color.rgb / color.a, color.a);
			
			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_vColorMultiplier.x;
			colorMultiplier[1][1] = openfl_vColorMultiplier.y;
			colorMultiplier[2][2] = openfl_vColorMultiplier.z;
			colorMultiplier[3][3] = openfl_vColorMultiplier.w;
			
			color = clamp (openfl_vColorOffset + (color * colorMultiplier), 0.0, 1.0);
			
			if (color.a > 0.0) {
				
				gl_FragColor = vec4 (color.rgb * color.a * openfl_vAlpha, color.a * openfl_vAlpha);
				
			} else {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			}
			
		} else {
			
			gl_FragColor = color * openfl_vAlpha;
			
		}"
		
	)
	
	
	@:glFragmentSource(
		
		#if emscripten
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
			gl_FragColor = gl_FragColor.bgra;
			
		}"
		#else
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
		}"
		#end
		
	)
	
	
	public function new (code:ByteArray = null) {
		
		#if !flash
		__isDisplayShader = true;
		#end
		
		super (code);
		
	}
	
	
}