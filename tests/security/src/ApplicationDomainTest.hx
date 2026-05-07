package;

import openfl.system.ApplicationDomain;
import utest.Assert;
import utest.Test;

class ApplicationDomainTest extends Test
{
	private static inline var QNAME_INVALID = "this can't possibly exist!";
	private static inline var QNAME_SPRITE_NS = #if flash "flash.display::Sprite" #else "openfl.display::Sprite" #end;
	private static inline var QNAME_SPRITE_DOT = #if flash "flash.display.Sprite" #else "openfl.display.Sprite" #end;

	public function test_new_()
	{
		var applicationDomain = new ApplicationDomain();
		Assert.notNull(applicationDomain);
	}

	public function test_currentDomain()
	{
		Assert.notNull(ApplicationDomain.currentDomain);
	}

	public function test_parentDomain()
	{
		var currentDomain = ApplicationDomain.currentDomain;
		Assert.isNull(currentDomain.parentDomain);

		var childDomainWithoutParent = new ApplicationDomain();
		// parentDomain defaults to ApplicationDomain.currentDomain
		Assert.notNull(childDomainWithoutParent.parentDomain);
		#if flash
		Assert.notEquals(currentDomain, childDomainWithoutParent.parentDomain);
		#end

		var childDomain = new ApplicationDomain(currentDomain);
		Assert.notNull(childDomain.parentDomain);
		#if flash
		Assert.notEquals(currentDomain, childDomain.parentDomain);
		#end

		var grandChildDomain = new ApplicationDomain(childDomain);
		Assert.notNull(grandChildDomain.parentDomain);
		#if flash
		Assert.notEquals(childDomain, grandChildDomain.parentDomain);
		#end
	}

	public function test_hasDefinition()
	{
		var currentDomain = ApplicationDomain.currentDomain;
		Assert.isTrue(currentDomain.hasDefinition(QNAME_SPRITE_NS));
		Assert.isTrue(currentDomain.hasDefinition(QNAME_SPRITE_DOT));
		Assert.isFalse(currentDomain.hasDefinition(QNAME_INVALID));

		var childDomain = new ApplicationDomain(currentDomain);
		// hasDefinition does not automatically delegate to the parent domain
		Assert.isFalse(childDomain.hasDefinition(QNAME_SPRITE_NS));
		Assert.isFalse(childDomain.hasDefinition(QNAME_SPRITE_DOT));
		Assert.isFalse(childDomain.hasDefinition(QNAME_INVALID));
	}

	public function test_getDefinition()
	{
		var currentDomain = ApplicationDomain.currentDomain;
		Assert.equals(openfl.display.Sprite, currentDomain.getDefinition(QNAME_SPRITE_NS));
		Assert.equals(openfl.display.Sprite, currentDomain.getDefinition(QNAME_SPRITE_DOT));
		#if flash
		Assert.raises(function():Void
		{
			currentDomain.getDefinition(QNAME_INVALID);
		}, flash.errors.ReferenceError);
		#else
		Assert.isNull(currentDomain.getDefinition(QNAME_INVALID));
		#end

		var childDomain = new ApplicationDomain(currentDomain);
		// why doesn't flash throw a reference error here?
		Assert.isNull(childDomain.getDefinition(QNAME_SPRITE_NS));
		Assert.isNull(childDomain.getDefinition(QNAME_SPRITE_DOT));
		Assert.isNull(childDomain.getDefinition(QNAME_INVALID));
	}
}
