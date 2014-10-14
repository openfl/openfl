package events;

import openfl.events.ContextMenuEvent;

/**
 * The interface for Context Menu events.
 */
interface IContextMenu 
{
	/**
	 * The function called when an item in the given context menu is selected.
	 */
	public var menuItemSelected:ContextMenuEvent -> Void;
	
	/**
	 * The function called when the given context menu is selected.
	 */
	public var menuSelected:ContextMenuEvent -> Void;
}