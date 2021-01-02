import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ShaderDataTest());
		runner.addCase(new ShaderInputTest());
		runner.addCase(new ShaderJobTest());
		runner.addCase(new ShaderParameterTest());
		runner.addCase(new ShaderParameterTypeTest());
		runner.addCase(new ShaderPrecisionTest());
		runner.addCase(new ShaderTest());
		Report.create(runner);
		runner.run();
	}
}
