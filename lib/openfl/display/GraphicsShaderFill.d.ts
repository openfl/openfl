import Matrix from "./../geom/Matrix";
import IGraphicsData from "./IGraphicsData";
import IGraphicsFill from "./IGraphicsFill";
import Shader from "./Shader";


declare namespace openfl.display {
	
	
	export class GraphicsShaderFill implements IGraphicsData, IGraphicsFill {
		
		
		public matrix:Matrix;
		public shader:Shader;
		
		public constructor (shader?:Shader, matrix?:Matrix);
		
		
	}
	
	
}


export default openfl.display.GraphicsShaderFill;