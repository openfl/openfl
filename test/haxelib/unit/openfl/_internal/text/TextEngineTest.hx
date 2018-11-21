package openfl._internal.text;

import openfl.text.TextField;
import massive.munit.Assert;

@:access(openfl.text.TextField)

class TextEngineTest {
	#if (flash && !air) @Ignore #end @Test public function getLine() {
		#if !flash
		var field = new TextField();
		field.text = 'Sample Text';

		var engine = field.__textEngine;

		Assert.isNull(engine.getLine(-5));
		Assert.isNull(engine.getLine(100));

		Assert.areEqual('Sample Text', engine.getLine(0));
		#end
	}

	#if (flash && !air) @Ignore #end @Test public function getLineBreakIndex() {
		#if !flash
		var field = new TextField();
		field.text = 'Sample Text Without Break Index';

		var engine = field.__textEngine;

		Assert.areEqual(-1, engine.getLineBreakIndex());
		Assert.areEqual(-1, engine.getLineBreakIndex(10));

		field.text = 'Sample Text With <br> Break Index';

		Assert.areEqual(17, engine.getLineBreakIndex());
		Assert.areEqual(17, engine.getLineBreakIndex(10));
		Assert.areEqual(-1, engine.getLineBreakIndex(20));

		field.text = 'Another Sample Text With \n Break Index';

		Assert.areEqual(25, engine.getLineBreakIndex());
		Assert.areEqual(25, engine.getLineBreakIndex(15));
		Assert.areEqual(-1, engine.getLineBreakIndex(30));

		field.text = 'Yet Another Sample Text With \r Break Index';

		Assert.areEqual(29, engine.getLineBreakIndex());
		Assert.areEqual(29, engine.getLineBreakIndex(15));
		Assert.areEqual(-1, engine.getLineBreakIndex(30));

		field.text = 'Multiple Indexes \r within \n single <br> text';

		Assert.areEqual(17, engine.getLineBreakIndex());
		Assert.areEqual(17, engine.getLineBreakIndex(15));
		Assert.areEqual(26, engine.getLineBreakIndex(20));
		Assert.areEqual(35, engine.getLineBreakIndex(30));
		#end
	}
}