package openfl.fl.events;

import openfl.events.Event;

/**
 * List event
 */
class ListEvent extends Event
{
	public inline static var ITEM_CLICK:String = "listevent_item_click";

	public var columnIndex:Int;
	public var rowIndex:Int;
	public var index:Int;
	public var item:Dynamic;

	/**
	 * Public constructor
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, columnIndex:Int, rowIndex:Int, index:Int, item:Dynamic)
	{
		super(type, bubbles, cancelable);
		this.columnIndex = columnIndex;
		this.rowIndex = rowIndex;
		this.index = index;
		this.item = item;
	}
}
