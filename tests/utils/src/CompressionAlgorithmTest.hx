package;

import openfl.utils.CompressionAlgorithm;
import utest.Assert;
import utest.Test;

class CompressionAlgorithmTest extends Test
{
	public function test_test()
	{
		switch (CompressionAlgorithm.DEFLATE)
		{
			case CompressionAlgorithm.DEFLATE, CompressionAlgorithm.ZLIB, CompressionAlgorithm.LZMA:
				Assert.isTrue(true);
			default: // CompressionAlgorithm.GZIP:
		}
	}
}
