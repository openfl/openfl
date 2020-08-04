package openfl.fl.controls;

import openfl.fl.containers.BaseScrollPane;
import openfl.fl.controls.dataGridClasses.HeaderRenderer;
import openfl.fl.controls.dataGridClasses.DataGridColumn;
import openfl.fl.controls.listClasses.CellRenderer;
import openfl.fl.controls.listClasses.ICellRenderer;
import openfl.fl.controls.listClasses.ListData;
import openfl.fl.core.UIComponent;
import openfl.fl.data.DataProvider;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.events.MouseEvent;
import openfl.fl.events.ListEvent;
import openfl.text.TextFormat;
import openfl._internal.formats.xfl.XFLSymbolArguments;
import openfl._internal.formats.xfl.XFLAssets;

/**
 * Data grid
 */
class DataGrid extends BaseScrollPane
{
	public var columns:Array<DataGridColumn>;
	public var sortableColumns:Bool;
	public var resizableColumns:Bool;
	public var dataProvider(get, set):DataProvider;
	public var rowHeight(default, set):Float;

	private var _dataProvider:DataProvider;
	private var headerDisplayObjects:Array<DisplayObjectContainer>;
	private var dataDisplayObjects:Array<DisplayObjectContainer>;
	private var mouseOverDisplayObjects:DisplayObjectContainer;
	private var scrollPaneSource:Sprite;

	/**
	 * Public constructor
	**/
	public function new(name:String = null, xflSymbolArguments:XFLSymbolArguments = null)
	{
		super(name, xflSymbolArguments /* != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.controls.DataGrid")*/);
		headerDisplayObjects = new Array<DisplayObjectContainer>();
		dataDisplayObjects = new Array<DisplayObjectContainer>();
		mouseOverDisplayObjects = null;
		columns = new Array<DataGridColumn>();
		_width = 0;
		_height = 0;
		x = 0;
		y = 0;
		width = 0;
		height = 0;
		rowHeight = 0.0;
		mouseChildren = true;
		scrollPaneSource = new Sprite();
		source = scrollPaneSource;
		draw();
		update();
	}

	/**
	 * Add column
	 * @param arg0 - name
	 */
	public function addColumn(dataField:String):Void
	{
		var column:DataGridColumn = new DataGridColumn();
		column.dataField = dataField;
		column.headerText = dataField;
		columns.push(column);
		draw();
		update();
	}

	public function getCellRendererAt(row:Int, column:Int):ICellRenderer
	{
		return cast(dataDisplayObjects[row].getChildAt(column), ICellRenderer);
	}

	public function getItemAt(rowIdx:Int):Dynamic
	{
		return dataProvider.getItemAt(rowIdx);
	}

	private function get_dataProvider():DataProvider
	{
		return _dataProvider;
	}

	private function set_dataProvider(dataProvider:DataProvider):DataProvider
	{
		_dataProvider = dataProvider;
		setColumnWidth(_width);
		draw();
		update();
		return _dataProvider;
	}

	override private function draw()
	{
		for (displayObject in headerDisplayObjects)
		{
			removeChild(displayObject);
		}
		headerDisplayObjects.splice(0, headerDisplayObjects.length);
		for (displayObject in dataDisplayObjects)
		{
			scrollPaneSource.removeChild(displayObject);
		}
		dataDisplayObjects.splice(0, dataDisplayObjects.length);
		var headerRenderer:Class<Dynamic> = styles.get("headerRenderer") != null ? cast(styles.get("headerRenderer"), Class<Dynamic>) : null;
		var cellRenderer:Class<Dynamic> = styles.get("cellRenderer") != null ? cast(styles.get("cellRenderer"), Class<Dynamic>) : null;
		for (column in columns)
		{
			column.headerRenderer = headerRenderer;
			column.cellRenderer = cellRenderer;
		}
		if (headerRenderer == null || cellRenderer == null) return;
		var _x:Float = 0.0;
		var columnIdx:Int = 0;
		var headerTextFormat:TextFormat = styles.get("headerTextFormat") != null ? cast(styles.get("headerTextFormat"), TextFormat) : null;
		var headerRow:DisplayObjectContainer = new DisplayObjectContainer();
		headerRow.x = 0.0;
		headerRow.y = 0.0;
		for (column in columns)
		{
			var headerRenderer:HeaderRenderer = Type.createInstance(column.headerRenderer, []);
			headerRenderer.name = "datagrid.header." + columnIdx;
			headerRenderer.column = columnIdx++;
			if (headerTextFormat != null) headerRenderer.setStyle("textFormat", headerTextFormat);
			headerRenderer.label = StringTools.ltrim(StringTools.rtrim(column.headerText));
			headerRenderer.x = _x;
			headerRenderer.y = 0.0;
			headerRenderer.setSize(column.width, headerRenderer.textField.height);
			headerRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			headerRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			headerRow.addChild(headerRenderer);
			_x += column.width;
		}
		headerDisplayObjects.push(headerRow);
		addChild(headerRow);
		if (_dataProvider != null)
		{
			var textFormat:TextFormat = styles.get("textFormat") != null ? cast(styles.get("textFormat"), TextFormat) : null;
			for (i in 0..._dataProvider.length)
			{
				_x = 0;
				var rowData:Dynamic = _dataProvider.getItemAt(i);
				var columnIdx = 0;
				var dataRow:DisplayObjectContainer = new DisplayObjectContainer();
				for (column in columns)
				{
					var cellRenderer:CellRenderer = Type.createInstance(column.cellRenderer, []);
					var listData:ListData = new ListData();
					listData.column = columnIdx;
					listData.index = i + 1;
					listData.icon = null;
					listData.label = null;
					listData.owner = cellRenderer;
					listData.row = i;
					cellRenderer.name = "datagrid.cell." + columnIdx + "," + i;
					if (textFormat != null) cellRenderer.setStyle("textFormat", textFormat);
					cellRenderer.label = StringTools.ltrim(StringTools.rtrim(column.itemToLabel(rowData)));
					cellRenderer.x = _x;
					cellRenderer.y = 0.0;
					var cellHeight:Float = cellRenderer.textField.height;
					if (cellHeight > rowHeight) rowHeight = cellHeight;
					if (cellHeight < rowHeight) cellHeight = rowHeight;
					cellRenderer.setSize(column.width, cellHeight);
					cellRenderer.data = rowData;
					cellRenderer.listData = listData;
					cellRenderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
					cellRenderer.addEventListener(MouseEvent.CLICK, onMouseEventClick);
					_x += column.width;
					columnIdx++;
					dataRow.addChild(cellRenderer);
				}
				scrollPaneSource.addChild(dataRow);
				dataDisplayObjects.push(dataRow);
			}
		}
		scrollPaneSource.y = alignDisplayObjects(headerDisplayObjects);
		alignDisplayObjects(dataDisplayObjects);
		update();
		if (verticalScrollBar.visible == true)
		{
			realignDisplayObjectsWidth(headerDisplayObjects, verticalScrollBar.width);
			realignDisplayObjectsWidth(dataDisplayObjects, verticalScrollBar.width);
		}
	}

	private function alignDisplayObjects(displayObjects:Array<DisplayObjectContainer>, verticalScrollBarSize:Float = 0.0):Float
	{
		var _y:Float = 0.0;
		if (displayObjects.length > 0)
		{
			for (i in 0...Std.int(displayObjects.length))
			{
				var cellHeight:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					if ((cell is HeaderRenderer))
					{
						cast(cell, HeaderRenderer).init();
						cast(cell, HeaderRenderer).validateNow();
					}
					else
					{
						cast(cell, CellRenderer).init();
						cast(cell, CellRenderer).validateNow();
					}
					if (cell.height > cellHeight) cellHeight = cell.height;
				}
				if (rowHeight > cellHeight) cellHeight = rowHeight;
				var _x:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					if ((cell is HeaderRenderer))
					{
						cast(cell, HeaderRenderer).setSize(columns[j].width, cellHeight);
					}
					else
					{
						cast(cell, CellRenderer).setSize(columns[j].width, cellHeight);
					}
					cell.x = _x;
					cell.height = cellHeight;
					cell.width -= verticalScrollBarSize / columns.length;
					_x += cell.width;
				}
				displayObjects[i].y = _y;
				_y += cellHeight;
			}
		}
		return _y;
	}

	private function realignDisplayObjectsWidth(displayObjects:Array<DisplayObjectContainer>, verticalScrollBarSize:Float = 0.0):Void
	{
		if (displayObjects.length > 0)
		{
			for (i in 0...displayObjects.length)
			{
				var _x:Float = 0.0;
				for (j in 0...columns.length)
				{
					var cell:DisplayObject = displayObjects[i].getChildAt(j);
					cell.x = _x;
					cell.width -= verticalScrollBarSize / columns.length;
					_x += cell.width;
				}
			}
		}
	}

	private function set_rowHeight(rowHeight:Float):Float
	{
		this.rowHeight = rowHeight;
		draw();
		update();
		return rowHeight;
	}

	private function setColumnWidth(_width:Float):Void
	{
		if (_width <= 0) return;
		var columnsWithoutWidth:Int = 0;
		var columnsWidth:Float = 0;
		for (column in columns)
		{
			if (column.width != -1)
			{
				columnsWidth += column.width;
			}
			else
			{
				columnsWithoutWidth++;
			}
		}
		var columnsWidthLeft:Float = _width - columnsWidth;
		for (column in columns)
		{
			if (column.width == -1)
			{
				column.width = columnsWidthLeft / columnsWithoutWidth;
			}
			else
			{
				column.width *= _width / columnsWidth;
			}
		}
		draw();
		update();
	}

	override public function setSize(_width:Float, _height:Float):Void
	{
		super.setSize(_width, _height);
		setColumnWidth(width);
		draw();
		update();
	}

	private function onMouseEvent(event:MouseEvent):Void
	{
		if ((event.target is HeaderRenderer) == true)
		{
			var mouseHeaderRenderer:HeaderRenderer = cast(event.target, HeaderRenderer);
			for (columnIdx in 0...columns.length)
			{
				var headerRenderer:DisplayObject = headerDisplayObjects[0].getChildAt(columnIdx);
				if (headerRenderer != null)
				{
					cast(headerRenderer, HeaderRenderer).setMouseState(event.type.charAt("mouse".length)
						.toLowerCase() + event.type.substr("mouse".length + 1));
				}
			}
		}

		// un mouse over last mouse over cells
		if (mouseOverDisplayObjects != null)
		{
			for (columnIdx in 0...columns.length)
			{
				var cellRenderer:DisplayObject = mouseOverDisplayObjects.getChildAt(columnIdx);
				if (cellRenderer != null)
				{
					cast(cellRenderer, CellRenderer).setMouseState("out");
				}
			}
			mouseOverDisplayObjects = null;
		}

		// find mouse cell renderer down up the hierarchy
		var mouseCellRendererCandidate:DisplayObject = event.target;
		while (mouseCellRendererCandidate != null && (mouseCellRendererCandidate is CellRenderer) == false)
			mouseCellRendererCandidate = mouseCellRendererCandidate.parent;
		var mouseCellRenderer:CellRenderer = mouseCellRendererCandidate != null ? cast(mouseCellRendererCandidate, CellRenderer) : null;
		if (mouseCellRenderer != null)
		{
			var displayObjectIndex:Int = mouseCellRenderer.listData.index - 1;
			for (columnIdx in 0...columns.length)
			{
				var cellRenderer:DisplayObject = displayObjectIndex < dataDisplayObjects.length ? dataDisplayObjects[displayObjectIndex].getChildAt(columnIdx) : null;
				if (cellRenderer != null)
				{
					cast(cellRenderer, CellRenderer).setMouseState(event.type.charAt("mouse".length).toLowerCase() + event.type.substr("mouse".length + 1));
				}
			}
			mouseOverDisplayObjects = dataDisplayObjects[displayObjectIndex];
		}
	}

	private function onMouseEventClick(event:MouseEvent):Void
	{
		if ((cast(event.target, DisplayObject) is CellRenderer) == true)
		{
			var cell:CellRenderer = cast(event.target, CellRenderer);
			var listData:ListData = cell.listData;
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, false, listData.column, listData.row, listData.index,
				cast(listData.owner, CellRenderer).data));
		}
	}
}
