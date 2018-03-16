package openfl._internal.renderer.opengl;


import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;


class GLMaskShader extends DisplayObjectShader {
	
	
	public static var opaqueBitmapData = new BitmapData (1, 1, false, 0);
	
	
	@:glFragmentSource(
		
		"varying vec2 openfl_vTexCoord;
		
		uniform sampler2D texture0;
		
		void main(void) {
			
			vec4 color = texture2D (texture0, openfl_vTexCoord);
			
			if (color.a == 0.0) {
				
				discard;
				
			} else {
				
				gl_FragColor = color;
				
			}
			
		}"
		
	)
	
	
	@:glVertexSource(
		
		"attribute vec4 openfl_Position;
		attribute vec2 openfl_TexCoord;
		varying vec2 openfl_vTexCoord;
		
		uniform mat4 openfl_Matrix;
		
		// unused
		attribute float alpha;
		attribute vec4 colorMultipliers;
		attribute vec4 colorOffsets;
		uniform bool openfl_HasColorTransform;
		
		void main(void) {
			
			openfl_vTexCoord = openfl_TexCoord;
			
			gl_Position = openfl_Matrix * openfl_Position;
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
	}
	
	
}