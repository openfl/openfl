package openfl.display;


class DisplayObjectShader extends Shader {
	
	
	@:glFragmentSource(
		
		#if emscripten
		"varying float vAlpha;
		varying mat4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 vTexCoord;
		
		uniform bool uUseColorTransform;
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (uUseColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier;
				colorMultiplier[0].x = vColorMultipliers.x;
				colorMultiplier[1].y = vColorMultipliers.y;
				colorMultiplier[2].z = vColorMultipliers.z;
				colorMultiplier[3].w = vColorMultipliers.w;
				
				color = vColorOffsets + (color * vColorMultipliers);
				
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
		varying vec2 vTexCoord;
		
		uniform bool uUseColorTransform;
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
				
			} else if (uUseColorTransform) {
				
				color = vec4 (color.rgb / color.a, color.a);
				
				mat4 colorMultiplier;
				colorMultiplier[0][0] = vColorMultipliers.x;
				colorMultiplier[1][1] = vColorMultipliers.y;
				colorMultiplier[2][2] = vColorMultipliers.z;
				colorMultiplier[3][3] = vColorMultipliers.w;
				
				color = vColorOffsets + (color * colorMultiplier);
				
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
		
		"attribute float aAlpha;
		attribute vec4 aColorMultipliers;
		attribute vec4 aColorOffsets;
		attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying float vAlpha;
		varying vec4 vColorMultipliers;
		varying vec4 vColorOffsets;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		uniform bool uUseColorTransform;
		
		void main(void) {
			
			vAlpha = aAlpha;
			vTexCoord = aTexCoord;
			
			if (uUseColorTransform) {
				
				vColorMultipliers = aColorMultipliers;
				vColorOffsets = aColorOffsets;
				
			}
			
			gl_Position = uMatrix * aPosition;
			
		}"
		
	)
	
	
	public function new () {
		
		super ();
		
	}
	
	
}