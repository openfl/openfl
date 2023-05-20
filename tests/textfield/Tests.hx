import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new AntiAliasTypeTest());
		runner.addCase(new FontStyleTest());
		runner.addCase(new FontTest());
		runner.addCase(new FontTypeTest());
		runner.addCase(new GridFitTypeTest());
		runner.addCase(new TextFieldAutoSizeTest());
		#if !flash
		runner.addCase(new TextFieldRestrictTest());
		#end
		runner.addCase(new TextFieldTest());
		runner.addCase(new TextFieldTypeTest());
		runner.addCase(new TextFormatAlignTest());
		runner.addCase(new TextFormatTest());
		runner.addCase(new TextLineMetricsTest());
		// runner.addCase(new TextFieldRenderTest());
		Report.create(runner);
		runner.run();
	}
}
