namespace openfl._internal.backend.dummy;

import openfl.display3D.Program3D;
import ByteArray from "../utils/ByteArray";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyProgram3DBackend
{
	public constructor(parent: Program3D) { }

	public dispose(): void { }

	public markDirty(isVertex: boolean, index: number, count: number): void { }

	public upload(vertexProgram: ByteArray, fragmentProgram: ByteArray): void { }

	public uploadSources(vertexSource: string, fragmentSource: string): void { }
}
