package;

import openfl.utils.QName;
import openfl.utils.Namespace;
import utest.Assert;
import utest.Test;

class QNameTest extends Test
{
	public function test_constructorDefaults()
	{
		var qname = new QName();
		Assert.equals("", qname.uri);
		Assert.equals("", qname.localName);
	}

	public function test_constructorEmptyStrings()
	{
		var qname = new QName("", "");
		Assert.equals("", qname.uri);
		Assert.equals("", qname.localName);
	}

	public function test_constructorUriAndLocalName()
	{
		var qname = new QName("http://example.com/", "example");
		Assert.equals("http://example.com/", qname.uri);
		Assert.equals("example", qname.localName);
	}

	public function test_constructorNamespaceAndLocalName()
	{
		var ns = new Namespace("example", "http://example.com/");
		var qname = new QName(ns, "property");
		Assert.equals("http://example.com/", qname.uri);
		Assert.equals("property", qname.localName);
	}

	public function test_constructorNullAndLocalName()
	{
		var qname = new QName(null, "example");
		Assert.isNull(qname.uri);
		Assert.equals("example", qname.localName);
	}

	public function test_constructorLocalNameOnly()
	{
		var qname = new QName("example");
		Assert.equals("", qname.uri);
		Assert.equals("example", qname.localName);
	}

	public function test_constructorQName()
	{
		var qnameToCopy = new QName("http://example.com/", "example");
		var qname = new QName(qnameToCopy);
		Assert.equals("http://example.com/", qname.uri);
		Assert.equals("example", qname.localName);
	}

	public function test_constructorOneArgToString()
	{
		var qname = new QName(123.4);
		Assert.equals("", qname.uri);
		Assert.equals("123.4", qname.localName);
	}

	public function test_constructorTwoArgsToString()
	{
		var qname = new QName(123.4, 567.8);
		Assert.equals("123.4", qname.uri);
		Assert.equals("567.8", qname.localName);
	}
}
