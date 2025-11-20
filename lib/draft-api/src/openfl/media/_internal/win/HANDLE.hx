package openfl.media._internal.win;

import openfl.media._internal.VoidPointer;

/**
 * ...
 * @author Christopher Speciale
 */
abstract HANDLE(VoidPointer) to VoidPointer
{
	@:from
	static inline function fromPointer(ptr:VoidPointer):HANDLE
	{
		return cast ptr;
	}
}
