namespace openfl._internal.formats.atf;

@: enum abstract ATFGPUFormat(Int) from Int to Int
{
	public DXT = 0; // DXT1/DXT5 depending on alpha
	public PVRTC = 1;
	public ETC1 = 2;
	public ETC2 = 3;
}
