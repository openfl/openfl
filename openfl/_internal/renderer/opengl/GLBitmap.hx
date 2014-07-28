package openfl._internal.renderer.opengl;


import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;

@:access(openfl.display.Bitmap)


class GLBitmap {
	
	
	public static inline function render (bitmap:Bitmap, renderSession:RenderSession):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		/*if (!__renderable || __worldAlpha <= 0) return;
		
		var gl = renderSession.gl;
		
		var texture = bitmapData.getTexture (gl);
		var buffer = bitmapData.getBuffer (gl);
		
		//__glMatrix = new lime.geom.Matrix4 ();
		__glMatrix.identity ();
		__glMatrix[0] = __worldTransform.a;
		__glMatrix[1] = __worldTransform.b;
		__glMatrix[4] = __worldTransform.c;
		__glMatrix[5] = __worldTransform.d;
		__glMatrix[12] = __worldTransform.tx;
		__glMatrix[13] = __worldTransform.ty;
		__glMatrix.append (renderSession.projectionMatrix);
		
		gl.activeTexture (gl.TEXTURE0);
		gl.bindTexture (gl.TEXTURE_2D, texture);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
		gl.uniform1f (renderSession.glProgram.alphaUniform, __worldAlpha);
		gl.uniformMatrix4fv (renderSession.glProgram.matrixUniform, false, __glMatrix);
		gl.uniform1i (renderSession.glProgram.imageUniform, 0);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, buffer);
		gl.vertexAttribPointer (renderSession.glProgram.vertexAttribute, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (renderSession.glProgram.textureAttribute, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end*/
		
		// if the sprite is not visible or the alpha is 0 then no need to render this element
    //if(!bitmap.visible || bitmap.alpha <= 0)return;
    
    var i,j;

    // do a quick check to see if this element has a mask or a filter.
    /*if(this._mask || this._filters)
    {
        var spriteBatch =  renderSession.spriteBatch;

        // push filter first as we need to ensure the stencil buffer is correct for any masking
        if(this._filters)
        {
            spriteBatch.flush();
            renderSession.filterManager.pushFilter(this._filterBlock);
        }

        if(this._mask)
        {
            spriteBatch.stop();
            renderSession.maskManager.pushMask(this.mask, renderSession);
            spriteBatch.start();
        }

        // add this sprite to the batch
        spriteBatch.render(this);

        // now loop through the children and make sure they get rendered
        for(i=0,j=this.children.length; i<j; i++)
        {
            this.children[i]._renderWebGL(renderSession);
        }

        // time to stop the sprite batch as either a mask element or a filter draw will happen next
        spriteBatch.stop();

        if(this._mask)renderSession.maskManager.popMask(this._mask, renderSession);
        if(this._filters)renderSession.filterManager.popFilter();
        
        spriteBatch.start();
    }
    else
    {*/
        renderSession.spriteBatch.render (bitmap);

        // simple render children!
        //for(i=0,j=this.children.length; i<j; i++)
        //{
            //this.children[i]._renderWebGL(renderSession);
        //}
    //}

   
		
		
	}
	
	
}