import openfl.utils.CompressionAlgorithm;

class CompressionAlgorithmTest
{
	public static function __init__()
	{
		Mocha.describe("CompressionAlgorithm", function()
		{
			Mocha.it("test", function()
			{
				switch (CompressionAlgorithm.DEFLATE)
				{
					case CompressionAlgorithm.DEFLATE, CompressionAlgorithm.ZLIB, CompressionAlgorithm.LZMA:
					default: // CompressionAlgorithm.GZIP:
				}
			});
		});
	}
}
