import BlendMode from "./../display/BlendMode";
import Shader from "./../display/Shader";
import BitmapFilter from "./BitmapFilter";


declare namespace openfl.filters {
	
	
	export class ShaderFilter extends BitmapFilter {
		
		
		public blendMode:BlendMode;
		public bottomExtension:number;
		public leftExtension:number;
		public rightExtension:number;
		public shader:Shader;
		public topExtension:number;
		
		public constructor (shader:Shader);
		
		
	}
	
	
}


export default openfl.filters.ShaderFilter;