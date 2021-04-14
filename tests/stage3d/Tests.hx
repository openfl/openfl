import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new Context3DBlendFactorTest());
		runner.addCase(new Context3DBufferUsageTest());
		runner.addCase(new Context3DClearMaskTest());
		runner.addCase(new Context3DCompareModeTest());
		runner.addCase(new Context3DMipFilterTest());
		runner.addCase(new Context3DProfileTest());
		runner.addCase(new Context3DProgramTypeTest());
		runner.addCase(new Context3DRenderModeTest());
		runner.addCase(new Context3DStencilActionTest());
		runner.addCase(new Context3DTest());
		runner.addCase(new Context3DTextureFilterTest());
		runner.addCase(new Context3DTextureFormatTest());
		runner.addCase(new Context3DTriangleFaceTest());
		runner.addCase(new Context3DVertexBufferFormatTest());
		runner.addCase(new Context3DWrapModeTest());
		runner.addCase(new CubeTextureTest());
		runner.addCase(new IndexBuffer3DTest());
		runner.addCase(new Program3DTest());
		runner.addCase(new RectangleTextureTest());
		runner.addCase(new Stage3DTest());
		runner.addCase(new TextureBaseTest());
		runner.addCase(new TextureTest());
		runner.addCase(new VertexBuffer3DTest());
		Report.create(runner);
		runner.run();
	}
}
