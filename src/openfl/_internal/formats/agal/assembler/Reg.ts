namespace openfl._internal.formats.agal.assembler;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class Reg
{
	public code: number;
	public desc: string;

	public constructor(code: number, desc: string)
	{
		this.code = code;
		this.desc = desc;
	}
}
