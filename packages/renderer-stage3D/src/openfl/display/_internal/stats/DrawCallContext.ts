namespace openfl._internal.renderer.context3D.stats;

@: enum abstract DrawCallContext(Int) to Int
{
	public STAGE = 0;
	public STAGE3D = 1;
	public BATCHER = 2;
}
