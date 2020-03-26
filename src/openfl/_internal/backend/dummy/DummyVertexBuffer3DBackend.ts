namespace openfl._internal.backend.dummy;

import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl.display3D.Context3DBufferUsage;
import openfl.display3D.VertexBuffer3D;
import ByteArray from "openfl/utils/ByteArray";
import Vector from "openfl/Vector";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyVertexBuffer3DBackend
{
	public new(parent: VertexBuffer3D) { }

	public dispose(): void { }

	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, startVertex: number, numVertices: number): void { }

	public uploadFromTypedArray(data: ArrayBufferView, byteLength: number = -1): void { }

	public uploadFromVector(data: Vector<number>, startVertex: number, numVertices: number): void { }
}
