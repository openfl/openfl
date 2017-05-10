package openfl.display;


enum NativeRenderContext {
	
	OPENGL (gl:#if (!flash || display) NativeGLContext #else Dynamic #end);
	CANVAS (context:NativeCanvasContext);
	DOM (div:#if ((!js && !html5 && !dom) || display) NativeDOMContext #else Dynamic #end);
	FLASH (sprite:Sprite);
	CAIRO (cairo:#if ((!js && !html5) || display) NativeCairoContext #else Dynamic #end);
	
}