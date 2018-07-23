package format.swf.data.actions;

import format.swf.SWFData;

interface IActionBranch extends IAction
{
	var branchOffset:Int;
	var branchIndex:Int;
}