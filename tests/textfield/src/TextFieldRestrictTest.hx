package;

#if !flash
import openfl.text._internal.TextEngine;
#end
import utest.Assert;
import utest.Test;

class TextFieldRestrictTest extends Test
{
	#if !flash
	public function test_restrictCharacter()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "g";
		Assert.equals("", textEngine.restrictText("f"));
		Assert.equals("g", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("Y"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleCharacters()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "agx";
		Assert.equals("a", textEngine.restrictText("a"));
		Assert.equals("", textEngine.restrictText("b"));
		Assert.equals("", textEngine.restrictText("f"));
		Assert.equals("g", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("w"));
		Assert.equals("x", textEngine.restrictText("x"));
		Assert.equals("", textEngine.restrictText("y"));
		Assert.equals("", textEngine.restrictText("Y"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictRange()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "a-g";
		Assert.equals("g", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("Y"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleRanges()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "a-gi-z";
		Assert.equals("g", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("i", textEngine.restrictText("i"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictCharacterAndRange()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "ag-h";
		Assert.equals("a", textEngine.restrictText("a"));
		Assert.equals("", textEngine.restrictText("b"));
		Assert.equals("", textEngine.restrictText("f"));
		Assert.equals("g", textEngine.restrictText("g"));
		Assert.equals("h", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("i"));
		Assert.equals("", textEngine.restrictText("Y"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictCharacterExcludeOnly()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "^g";
		Assert.equals("f", textEngine.restrictText("f"));
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("h", textEngine.restrictText("h"));
		Assert.equals("Y", textEngine.restrictText("Y"));
		Assert.equals("3", textEngine.restrictText("3"));
		Assert.equals("@", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleCharactersExcludeOnly()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "^agx";
		Assert.equals("", textEngine.restrictText("a"));
		Assert.equals("b", textEngine.restrictText("b"));
		Assert.equals("f", textEngine.restrictText("f"));
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("h", textEngine.restrictText("h"));
		Assert.equals("w", textEngine.restrictText("w"));
		Assert.equals("", textEngine.restrictText("x"));
		Assert.equals("y", textEngine.restrictText("y"));
		Assert.equals("Y", textEngine.restrictText("Y"));
		Assert.equals("3", textEngine.restrictText("3"));
		Assert.equals("@", textEngine.restrictText("@"));
	}

	public function test_restrictRangeExcludeOnly()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "^a-g";
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("h", textEngine.restrictText("h"));
		Assert.equals("Y", textEngine.restrictText("Y"));
		Assert.equals("3", textEngine.restrictText("3"));
		Assert.equals("@", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleRangesExcludeOnly()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "^a-gi-z";
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("h", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("i"));
		Assert.equals("3", textEngine.restrictText("3"));
		Assert.equals("@", textEngine.restrictText("@"));
	}

	public function test_restrictCharacterAndRangeExcludeOnly()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "^ag-h";
		Assert.equals("", textEngine.restrictText("a"));
		Assert.equals("b", textEngine.restrictText("b"));
		Assert.equals("f", textEngine.restrictText("f"));
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("i", textEngine.restrictText("i"));
		Assert.equals("Y", textEngine.restrictText("Y"));
		Assert.equals("3", textEngine.restrictText("3"));
		Assert.equals("@", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleRangesIncludeAndExclude()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "a-z^g-i";
		Assert.equals("f", textEngine.restrictText("f"));
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("i"));
		Assert.equals("j", textEngine.restrictText("j"));
		Assert.equals("", textEngine.restrictText("Y"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}

	public function test_restrictMultipleRangesIncludeExcludeAndInclude()
	{
		var textEngine = new TextEngine(null);
		textEngine.restrict = "a-z^g-i^0-2";
		Assert.equals("f", textEngine.restrictText("f"));
		Assert.equals("", textEngine.restrictText("g"));
		Assert.equals("", textEngine.restrictText("h"));
		Assert.equals("", textEngine.restrictText("i"));
		Assert.equals("j", textEngine.restrictText("j"));
		Assert.equals("0", textEngine.restrictText("0"));
		Assert.equals("1", textEngine.restrictText("1"));
		Assert.equals("2", textEngine.restrictText("2"));
		Assert.equals("", textEngine.restrictText("3"));
		Assert.equals("", textEngine.restrictText("@"));
	}
	#end
}
