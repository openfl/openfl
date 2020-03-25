namespace openfl._internal.backend.html5;

#if openfl_html5
class HTML5SystemBackend
{
	public static exit(code: number): void { }

	public static gc(): void { }

	public static getTotalMemory(): number
	{
		return untyped __js__("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
	}
}
#end
