namespace openfl._internal.formats.agal.assembler;

import ByteArray from "../utils/ByteArray";
import openfl.utils.Endian;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class Part
{
	public data: ByteArray;
	public name: string;
	public version: number;

	public constructor(name: string = "", version: number = 0)
	{
		this.name = name;
		this.version = version;

		this.data = new ByteArray();
		data.endian = Endian.LITTLE_ENDIAN;
	}
}
