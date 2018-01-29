import GraphicsPathWinding from "./GraphicsPathWinding";
import IGraphicsData from "./IGraphicsData";
import IGraphicsPath from "./IGraphicsPath";

type Vector<T> = any;


declare namespace openfl.display {
	
	
	/**
	 * A collection of drawing commands and the coordinate parameters for those
	 * commands.
	 *
	 *  Use a GraphicsPath object with the
	 * `Graphics.drawGraphicsData()` method. Drawing a GraphicsPath
	 * object is the equivalent of calling the `Graphics.drawPath()`
	 * method. 
	 *
	 * The GraphicsPath class also has its own set of methods
	 * (`curveTo()`, `lineTo()`, `moveTo()`
	 * `wideLineTo()` and `wideMoveTo()`) similar to those
	 * in the Graphics class for making adjustments to the
	 * `GraphicsPath.commands` and `GraphicsPath.data`
	 * vector arrays.
	 */
	/*@:final*/ export class GraphicsPath implements IGraphicsData, IGraphicsPath {
		
		
		/**
		 * The Vector of drawing commands as integers representing the path. Each
		 * command can be one of the values defined by the GraphicsPathCommand class.
		 */
		public commands:Vector<number>;
		
		/**
		 * The Vector of Numbers containing the parameters used with the drawing
		 * commands.
		 */
		public data:Vector<number>;
		
		/**
		 * Specifies the winding rule using a value defined in the
		 * GraphicsPathWinding class.
		 */
		public winding:GraphicsPathWinding; /* note: currently ignored */
		
		
		/**
		 * Creates a new GraphicsPath object.
		 * 
		 * @param winding Specifies the winding rule using a value defined in the
		 *                GraphicsPathWinding class.
		 */
		public constructor (commands?:Vector<number>, data?:Vector<number>, winding?:GraphicsPathWinding);
		
		
		public cubicCurveTo (controlX1:number, controlY1:number, controlX2:number, controlY2:number, anchorX:number, anchorY:number):void;
		
		/**
		 * Adds a new "curveTo" command to the `commands` vector and new
		 * coordinates to the `data` vector.
		 * 
		 * @param controlX A number that specifies the horizontal position of the
		 *                 control point relative to the registration point of the
		 *                 parent display object.
		 * @param controlY A number that specifies the vertical position of the
		 *                 control point relative to the registration point of the
		 *                 parent display object.
		 * @param anchorX  A number that specifies the horizontal position of the
		 *                 next anchor point relative to the registration point of
		 *                 the parent display object.
		 * @param anchorY  A number that specifies the vertical position of the next
		 *                 anchor point relative to the registration point of the
		 *                 parent display object.
		 */
		public curveTo (controlX:number, controlY:number, anchorX:number, anchorY:number):void;
		
		
		/**
		 * Adds a new "lineTo" command to the `commands` vector and new
		 * coordinates to the `data` vector.
		 * 
		 * @param x The x coordinate of the destination point for the line.
		 * @param y The y coordinate of the destination point for the line.
		 */
		public lineTo (x:number, y:number):void;
		
		
		/**
		 * Adds a new "moveTo" command to the `commands` vector and new
		 * coordinates to the `data` vector.
		 * 
		 * @param x The x coordinate of the destination point.
		 * @param y The y coordinate of the destination point.
		 */
		public moveTo (x:number, y:number):void;
		
		
		/**
		 * Adds a new "wideLineTo" command to the `commands` vector and
		 * new coordinates to the `data` vector.
		 * 
		 * @param x The x-coordinate of the destination point for the line.
		 * @param y The y-coordinate of the destination point for the line.
		 */
		public wideLineTo (x:number, y:number):void;
		
		
		/**
		 * Adds a new "wideMoveTo" command to the `commands` vector and
		 * new coordinates to the `data` vector.
		 * 
		 * @param x The x-coordinate of the destination point.
		 * @param y The y-coordinate of the destination point.
		 */
		public wideMoveTo (x:number, y:number):void;
		
		
	}
	
	
}


export default openfl.display.GraphicsPath;