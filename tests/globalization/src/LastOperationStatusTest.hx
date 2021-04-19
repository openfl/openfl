package;

import openfl.globalization.LastOperationStatus;
import utest.Assert;
import utest.Test;

class LastOperationStatusTest extends Test
{
	public function test_test()
	{
		switch (LastOperationStatus.BUFFER_OVERFLOW_ERROR)
		{
			case LastOperationStatus.BUFFER_OVERFLOW_ERROR, LastOperationStatus.ERROR_CODE_UNKNOWN, LastOperationStatus.ILLEGAL_ARGUMENT_ERROR,
				LastOperationStatus.INDEX_OUT_OF_BOUNDS_ERROR, LastOperationStatus.INVALID_ATTR_VALUE, LastOperationStatus.INVALID_CHAR_FOUND,
				LastOperationStatus.MEMORY_ALLOCATION_ERROR, LastOperationStatus.NO_ERROR, LastOperationStatus.NUMBER_OVERFLOW_ERROR,
				LastOperationStatus.PARSE_ERROR, LastOperationStatus.PATTERN_SYNTAX_ERROR, LastOperationStatus.PLATFORM_API_FAILED,
				LastOperationStatus.TRUNCATED_CHAR_FOUND, LastOperationStatus.UNEXPECTED_TOKEN, LastOperationStatus.UNSUPPORTED_ERROR,
				LastOperationStatus.USING_DEFAULT_WARNING, LastOperationStatus.USING_FALLBACK_WARNING:
				Assert.isTrue(true);
		}
	}
}
