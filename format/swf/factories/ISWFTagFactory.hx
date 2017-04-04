package format.swf.factories;

import format.swf.tags.ITag;

interface ISWFTagFactory
{
	function create(type:Int):ITag;
}