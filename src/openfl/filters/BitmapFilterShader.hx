package openfl.filters;


import openfl.display.Shader;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class BitmapFilterShader extends Shader {
	
	
	@:glVertexHeader(
		
		"attribute vec4 openfl_Position;
		attribute vec2 openfl_TexCoord;
		
		varying vec2 openfl_TexCoordv;
		
		uniform mat4 openfl_Matrix;"
		
	)
	
	
	@:glVertexBody(
		
		"openfl_TexCoordv = openfl_TexCoord;
		
		gl_Position = openfl_Matrix * openfl_Position;"
		
	)
	
	
	@:glVertexSource(
		
		"#pragma header
		
		void main(void) {
			
			#pragma body
			
		}"
		
	)
	
	
	@:glFragmentHeader(
		
		"varying vec2 openfl_TexCoordv;
		
		uniform sampler2D openfl_Texture;"
		
	)
	
	
	@:glFragmentBody(
		
		"vec4 color = texture2D (openfl_Texture, openfl_TexCoordv);
		
		gl_FragColor = color;"
		
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
		
		super (code);
		
	}
	
	
}