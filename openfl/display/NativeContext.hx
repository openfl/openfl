package openfl.display;


enum NativeContext {
	
	OPENGL (gl:#if (!flash || display) NativeGLContext #else Dynamic #end);
	CANVAS (context:NativeCanvasContext);
	DOM (div:#if ((!js && !html5 && !dom) || display) NativeDOMContext #else Dynamic #end);
	FLASH (sprite:#if ((!js && !html5) || display) NativeFlashContext #else Dynamic #end);
	CAIRO (cairo:#if ((!js && !html5) || display) NativeCairoContext #else Dynamic #end);
	
}