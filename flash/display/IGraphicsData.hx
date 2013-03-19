package flash.display;
#if (flash || display)


extern interface IGraphicsData {
}


#else
typedef IGraphicsData = nme.display.IGraphicsData;
#end
