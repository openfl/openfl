import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ByteArrayTest());
		runner.addCase(new CompressionAlgorithmTest());
		runner.addCase(new DictionaryTest());
		runner.addCase(new EndianTest());
		runner.addCase(new MemoryTest());
		runner.addCase(new TimerEventTest());
		runner.addCase(new TimerTest());
		runner.addCase(new VectorTest());
		Report.create(runner);
		runner.run();
	}
}
