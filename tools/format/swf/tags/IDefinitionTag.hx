package format.swf.tags;

interface IDefinitionTag extends ITag
{
	var characterId:Int;
	
	function clone():IDefinitionTag;
}