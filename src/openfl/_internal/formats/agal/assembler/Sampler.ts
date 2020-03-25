namespace openfl._internal.formats.agal.assembler;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class Sampler
{
	public mask: number;
	public shift: number;
	public value: number;

	public new(shift: number, mask: number, value: number)
	{
		this.shift = shift;
		this.mask = mask;
		this.value = value;
	}
}
