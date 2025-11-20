package openfl.net._internal.win;

import openfl.net._internal.VoidPointer;

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
