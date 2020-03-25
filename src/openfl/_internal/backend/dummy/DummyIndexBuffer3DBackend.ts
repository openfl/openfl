namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl.display3D.IndexBuffer3D;
import ByteArray from "openfl/utils/ByteArray";
import Vector from "openfl/Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyIndexBuffer3DBackend
{
	public new(parent: IndexBuffer3D) { }

	public dispose(): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, startOffset: number, count: number): void { }

	public uploadFromTypedArray(data: ArrayBufferView, byteLength: number = -1): void { }

	public uploadFromVector(data: Vector<UInt>, startOffset: number, count: number): void { }
}
