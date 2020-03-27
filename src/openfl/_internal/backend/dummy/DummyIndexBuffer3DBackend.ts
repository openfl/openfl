namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.IndexBuffer3D;
import ByteArray from "../utils/ByteArray";
import Vector from "../Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyIndexBuffer3DBackend
{
	public constructor(parent: IndexBuffer3D) { }

	public dispose(): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, startOffset: number, count: number): void { }

	public uploadFromTypedArray(data: ArrayBufferView, byteLength: number = -1): void { }

	public uploadFromVector(data: Vector<UInt>, startOffset: number, count: number): void { }
}
