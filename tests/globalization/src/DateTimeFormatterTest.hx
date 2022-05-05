package;

import openfl.globalization.DateTimeFormatter;
import utest.Assert;
import utest.Test;

class DateTimeFormatterTest extends Test
{
	public function test_actualLocaleIDName()
	{
		// TODO: Confirm functionality

		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.actualLocaleIDName;

		Assert.notEquals(exists, null);
	}

	public function test_requestedLocaleIDName()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.requestedLocaleIDName;
		Assert.notEquals(exists, null);
	}

	public function test_lastOperationStatus()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.lastOperationStatus;
		Assert.notEquals(exists, null);
	}

	public function test_new()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		Assert.notEquals(dateTimeFormatter, null);
	}

	public function test_format()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.format;
		Assert.notEquals(exists, null);
	}

	public function test_formatUTC()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.formatUTC;
		Assert.notEquals(exists, null);
	}

	public function test_getDateStyle()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.getDateStyle;
		Assert.notEquals(exists, null);
	}

	public function test_getDateTimePattern()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.getDateTimePattern;
		Assert.notEquals(exists, null);
	}

	public function test_getFirstWeekday()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.getFirstWeekday;
		Assert.notEquals(exists, null);
	}

	public function test_getMonthNames()
	{
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var monthNames = dateTimeFormatter.getMonthNames();
		Assert.notNull(monthNames);
		Assert.equals(12, monthNames.length);
	}

	public function test_getTimeStyle()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.getTimeStyle;
		Assert.notEquals(exists, null);
	}

	public function test_getWeekdayNames()
	{
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var weekdayNames = dateTimeFormatter.getWeekdayNames();
		Assert.notNull(weekdayNames);
		Assert.equals(7, weekdayNames.length);
	}

	public function test_setDateTimePattern()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.setDateTimePattern;
		Assert.notEquals(exists, null);
	}

	public function test_setDateTimeStyles()
	{
		// TODO: Confirm functionality
		var dateTimeFormatter = new DateTimeFormatter("en-US");
		var exists = dateTimeFormatter.setDateTimeStyles;
		Assert.notEquals(exists, null);
	}

	public function test_getAvailableLocaleIDNames()
	{
		// TODO: Confirm functionality
		var exists = DateTimeFormatter.getAvailableLocaleIDNames;
		Assert.notEquals(exists, null);
	}
}
