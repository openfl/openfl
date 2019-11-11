package openfl._internal.backend.lime;

#if lime
typedef ImageCanvasUtil = lime._internal.graphics.ImageCanvasUtil;
#else
typedef ImageCanvasUtil = Dynamic;
#end
