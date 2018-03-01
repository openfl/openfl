package openfl.display;


class DisplayObjectShader extends Shader {
	
	
	@:glFragmentSource(
		
		#if emscripten
		"varying float vAlpha;
		varying vec4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 openfl_vTexCoord;
		
		uniform bool openfl_HasColorTransform;
		uniform sampler2D texture0;
		
		void main(void) {
			
			vec4 color = texture2D (texture0, openfl_vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (openfl_HasColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier = mat4 (0);
				colorMultiplier[0][0] = vColorMultipliers.x;
				colorMultiplier[1][1] = vColorMultipliers.y;
				colorMultiplier[2][2] = vColorMultipliers.z;
				colorMultiplier[3][3] = vColorMultipliers.w;
				
				color = clamp (vColorOffsets + (color * colorMultiplier), 0.0, 1.0);
				
				if (color.a > 0.0) {
					
					gl_FragColor = vec4 (color.bgr * color.a * vAlpha, color.a * vAlpha);
					
				} else {
					
					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
					
				}
				
			} else {
				
				gl_FragColor = color.bgra * vAlpha;
				
			}
			
		}"
		#else
		"varying float vAlpha;
		varying vec4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 openfl_vTexCoord;
		
		uniform bool openfl_HasColorTransform;
		uniform sampler2D texture0;
		
		void main(void) {
			
			vec4 color = texture2D (texture0, openfl_vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (openfl_HasColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier = mat4 (0);
				colorMultiplier[0][0] = vColorMultipliers.x;
				colorMultiplier[1][1] = vColorMultipliers.y;
				colorMultiplier[2][2] = vColorMultipliers.z;
				colorMultiplier[3][3] = vColorMultipliers.w;
				
				color = clamp (vColorOffsets + (color * colorMultiplier), 0.0, 1.0);
				
				if (color.a > 0.0) {
					
					gl_FragColor = vec4 (color.rgb * color.a * vAlpha, color.a * vAlpha);
					
				} else {
					
					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
					
				}
				
			} else {
				
				gl_FragColor = color * vAlpha;
				
			}
			
		}"
		#end
		
	)
	
	
	@:glVertexSource(
		
		"attribute float alpha;
		attribute vec4 colorMultipliers;
		attribute vec4 colorOffsets;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TexCoord;
		varying float vAlpha;
		varying vec4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 openfl_vTexCoord;
		
		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		
		void main(void) {
			
			vAlpha = alpha;
			openfl_vTexCoord = openfl_TexCoord;
			
			if (openfl_HasColorTransform) {
				
				vColorMultipliers = colorMultipliers;
				vColorOffsets = colorOffsets / 255.0;
				
			}
			
			gl_Position = openfl_Matrix * openfl_Position;
			
		}"
		
	)
	
	
	public function new () {
		
		#if !flash
		__isDisplayShader = true;
		#end
		
		super ();
		
	}
	
	
}