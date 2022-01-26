package;

import openfl.utils.QName;
import openfl.utils.Namespace;
import utest.Assert;
import utest.Test;

class NamespaceTest extends Test
{
	public function test_constructorDefaults()
	{
		var ns = new Namespace();
		Assert.equals("", ns.prefix);
		Assert.equals("", ns.uri);
	}

	public function test_constructorEmptyStrings()
	{
		var ns = new Namespace("", "");
		Assert.equals("", ns.prefix);
		Assert.equals("", ns.uri);
	}

	public function test_constructorPrefixAndUri()
	{
		var ns = new Namespace("example", "http://example.com/");
		Assert.equals("example", ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorNullAndUri()
	{
		var ns = new Namespace(null, "http://example.com/");
		Assert.isNull(ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorUriOnly()
	{
		var ns = new Namespace("http://example.com/");
		Assert.isNull(ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorNamespace()
	{
		var nsToCopy = new Namespace("example", "http://example.com/");
		var ns = new Namespace(nsToCopy);
		Assert.equals("example", ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorQName()
	{
		var qname = new QName("http://example.com/", "property");
		var ns = new Namespace(qname);
		Assert.isNull(ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorPrefixAndQName()
	{
		var qname = new QName("http://example.com/", "property");
		var ns = new Namespace("abc", qname);
		Assert.equals("abc", ns.prefix);
		Assert.equals("http://example.com/", ns.uri);
	}

	public function test_constructorOneArgToString()
	{
		var ns = new Namespace("abc");
		Assert.isNull(ns.prefix);
		Assert.equals("abc", ns.uri);
	}

	public function test_constructorTwoArgsToString()
	{
		var obj = {
			toString: function():String
			{
				return "abc";
			}
		};
		var ns = new Namespace(obj, "def");
		Assert.equals("abc", ns.prefix);
		Assert.equals("def", ns.uri);
	}

	public function test_constructorTwoArgsToStringInvalidPrefix()
	{
		var ns = new Namespace(123.4, 567.8);
		Assert.isNull(ns.prefix);
		Assert.equals("567.8", ns.uri);
	}
}
