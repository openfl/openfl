package openfl.fl.controls.dataGridClasses;

class DataGridColumn
{
	public var cellRenderer:Class<Dynamic> = null;
	public var dataField:String = null;
	public var editable:Bool = true;
	public var editorDataField:String = "text";
	public var headerRenderer:Class<Dynamic> = null;
	public var headerText:String = "header text";
	public var imeMode:String = null;
	public var itemEditor:Dynamic = null;
	public var labelFunction:Dynamic->String = null;
	public var minWidth:Float = -1;
	public var resizable:Bool = true;
	public var sortable:Bool = true;
	public var sortCompareFunction:Void->Void = null;
	public var sortDescending:Bool = false;
	public var sortOptions:Float = 0;
	public var visible:Bool = true;
	public var width:Float = -1;

	public function new() {}

	public function itemToLabel(data:Dynamic):String
	{
		if (labelFunction != null)
		{
			return labelFunction(data);
		}
		if (dataField != null)
		{
			return Reflect.field(data, dataField) != null ? Std.string(Reflect.field(data, dataField)) : "";
		}
		return "No label";
	}
}
