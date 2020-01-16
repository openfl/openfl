package openfl.fl.controls.listClasses;

/**
 *  ICellRenderer
 */
interface ICellRenderer
{
	public var data(get, set):Dynamic;
	public var listData(get, set):ListData;
	public var selected(get, set):Bool;
	public function setMouseState(state:String):Void;
}
