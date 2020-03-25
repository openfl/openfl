namespace openfl._internal.backend.lime;

#if lime
import lime.system.System;
#if neko
import neko.vm.Gc;
#elseif cpp
import cpp.vm.Gc;
#end

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class LimeSystemBackend
{
	public static exit(code: number): void
	{
		System.exit(code);
	}

	public static gc(): void
	{
		#if(cpp || neko)
		return Gc.run(true);
		#end
	}

	public static getTotalMemory(): number
	{
		#if neko
		return Gc.stats().heap;
		#elseif cpp
		return untyped __global__.__hxcpp_gc_used_bytes();
		#elseif openfl_html5
		return untyped __js__("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
		#else
		return 0;
		#end
	}
}
#end
