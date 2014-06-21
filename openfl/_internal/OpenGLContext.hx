package openfl._internal;


import lime.graphics.GLProgram;
import lime.graphics.GLUniformLocation;
import lime.graphics.GLRenderContext;
import lime.graphics.GLTexture;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;


class OpenGLContext extends HardwareRenderer {
	
	
	private var contextID:Int;
	private var gl:GLRenderContext;
	private var height:Int;
	private var modelView:Matrix;
	private var offsetX:Float;
	private var offsetY:Float;
	private var scaleX:Float;
	private var scaleY:Float;
	private var viewport:Rectangle;
	private var width:Int;
	
	//
	
	public var currentProgram:OpenGLProgram;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		HardwareRenderer.current = this;
		contextID = HardwareRenderer.textureContextVersion;
		
		width = 0;
		height = 0;
		
		//
		
		currentProgram = OpenGLProgram.create (gl, 0);
		
	}
	
	
	public function beginRender (rect:Rectangle, forHitTest:Bool):Void {
		
		if (!forHitTest) {
			
			if (contextID != HardwareRenderer.textureContextVersion) {
				
				updateContext ();
				
			}
			
			// Force dirty
			//viewport.width = -1;
			setViewport (rect);
			
			gl.enable (gl.BLEND);
			
			#if webos
			gl.colorMask (gl.TRUE, gl.TRUE, gl.TRUE, gl.FALSE);
			#end
			
			//mLineWidth = 99999;
			
			//sgDrawCount = 0;
			//sgDrawBitmap = 0;
			
			//
			
			currentProgram.bind ();
			gl.enableVertexAttribArray (currentProgram.vertexAttribute);
			gl.enableVertexAttribArray (currentProgram.textureAttribute);
			
		}
		
	}
	
	
	public function clear (color:Int, rect:Rectangle = null):Void {
		
		var r = ((color >> 16) & 0xFF) / 0xFF;
		var g = ((color >> 8) & 0xFF) / 0xFF;
		var b = (color & 0xFF) / 0xFF;
		var a = ((color >> 24) & 0xFF) / 0xFF;
		
		if (rect == null) {
			
			gl.clearColor (r, g, b, a);
			gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
			
		} else {
			
			gl.viewport (Std.int (rect.x), Std.int (height - rect.y - rect.height), Std.int (rect.width), Std.int (rect.height));
			
			// do partial clear
			
			gl.viewport (0, 0, width, height);
			
		}
		
	}
	
	
	public function combineModelView (modelView:Matrix):Void {
		
		/*mTrans[0][0] = inModelView.m00 * mScaleX;
		mTrans[0][1] = inModelView.m01 * mScaleX;
		mTrans[0][2] = 0;
		mTrans[0][3] = inModelView.mtx * mScaleX + mOffsetX;
		
		mTrans[1][0] = inModelView.m10 * mScaleY;
		mTrans[1][1] = inModelView.m11 * mScaleY;
		mTrans[1][2] = 0;
		mTrans[1][3] = inModelView.mty * mScaleY + mOffsetY;*/
		
	}
	
	
	public function endRender ():Void {
		
		
		
	}
	
	
	public function render ():Void {
		
		//const RenderState &inState, const HardwareData &inData
		/*      if (!inData.mArray.size())
         return;

      SetViewport(inState.mClipRect);

      if (mModelView!=*inState.mTransform.mMatrix)
      {
         mModelView=*inState.mTransform.mMatrix;
         CombineModelView(mModelView);
         mLineScaleV = -1;
         mLineScaleH = -1;
         mLineScaleNormal = -1;
      }
      const ColorTransform *ctrans = inState.mColourTransform;
      if (ctrans && ctrans->IsIdentity())
         ctrans = 0;

      RenderData(inData,ctrans,mTrans);*/
		
		
	}
	
	
	public function renderData ():Void {
		
		//const HardwareData &inData, const ColorTransform *ctrans,const Trans4x4 &inTrans
		
		/*const uint8 *data = 0;
      if (inData.mVertexBo)
      {
         if (inData.mContextId!=gTextureContextVersion)
         {
            if (inData.mVboOwner)
               inData.mVboOwner->DecRef();
            inData.mVboOwner = 0;
            // Create one right away...
            inData.mRendersWithoutVbo = 5;
            inData.mVertexBo = 0;
            inData.mContextId = 0;
         }
         else
            glBindBuffer(GL_ARRAY_BUFFER, inData.mVertexBo);
      }

      if (!inData.mVertexBo)
      {
         data = &inData.mArray[0];
         inData.mRendersWithoutVbo++;
         if ( inData.mRendersWithoutVbo>4)
         {
            glGenBuffers(1,&inData.mVertexBo);
            inData.mVboOwner = this;
            IncRef();
            inData.mContextId = gTextureContextVersion;
            glBindBuffer(GL_ARRAY_BUFFER, inData.mVertexBo);
            // printf("VBO DATA %d\n", inData.mArray.size());
            glBufferData(GL_ARRAY_BUFFER, inData.mArray.size(), data, GL_STATIC_DRAW);
            data = 0;
         }
      }

      GPUProg *lastProg = 0;
 
      for(int e=0;e<inData.mElements.size();e++)
      {
         const DrawElement &element = inData.mElements[e];
         int n = element.mCount;
         if (!n)
            continue;

 

         int progId = 0;
         bool premAlpha = false;
         if ((element.mFlags & DRAW_HAS_TEX) && element.mSurface)
         {
            if (element.mSurface->GetFlags() & surfUsePremultipliedAlpha)
               premAlpha = true;
            progId |= PROG_TEXTURE;
            if (element.mSurface->BytesPP()==1)
               progId |= PROG_ALPHA_TEXTURE;
         }

         if (element.mFlags & DRAW_HAS_COLOUR)
            progId |= PROG_COLOUR_PER_VERTEX;

         if (element.mFlags & DRAW_HAS_NORMAL)
            progId |= PROG_NORMAL_DATA;

         if (element.mFlags & DRAW_RADIAL)
         {
            progId |= PROG_RADIAL;
            if (element.mRadialPos!=0)
               progId |= PROG_RADIAL_FOCUS;
         }

         if (ctrans || element.mColour != 0xffffffff)
         {
            progId |= PROG_TINT;
            if (ctrans && ctrans->HasOffset())
               progId |= PROG_COLOUR_OFFSET;
         }

         bool persp = element.mFlags & DRAW_HAS_PERSPECTIVE;

         GPUProg *prog = mProg[progId];
         if (!prog)
             mProg[progId] = prog = GPUProg::create(progId);
         if (!prog)
            continue;

         switch(element.mBlendMode)
         {
            case bmAdd:
               glBlendFunc( GL_SRC_ALPHA, GL_ONE );
               break;
            case bmMultiply:
               glBlendFunc( GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA);
               break;
            case bmScreen:
               glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_COLOR);
               break;
            default:
               glBlendFunc(premAlpha ? GL_ONE : GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
         }


         if (prog!=lastProg)
         {
            if (lastProg)
               lastProg->disableSlots();

            prog->bind();
            prog->setTransform(inTrans);
            lastProg = prog;
         }

         int stride = element.mStride;
         if (prog->vertexSlot >= 0)
         {
            glVertexAttribPointer(prog->vertexSlot, persp ? 4 : 2 , GL_FLOAT, GL_FALSE, stride,
                data + element.mVertexOffset);
            glEnableVertexAttribArray(prog->vertexSlot);
         }

         if (prog->textureSlot >= 0)
         {
            glVertexAttribPointer(prog->textureSlot,  2 , GL_FLOAT, GL_FALSE, stride,
                data + element.mTexOffset);
            glEnableVertexAttribArray(prog->textureSlot);

            if (element.mSurface)
            {
               Texture *boundTexture = element.mSurface->GetTexture(this);
               element.mSurface->Bind(*this,0);
               boundTexture->BindFlags(element.mFlags & DRAW_BMP_REPEAT,element.mFlags & DRAW_BMP_SMOOTH);
            }
         }

         if (prog->colourSlot >= 0)
         {
            glVertexAttribPointer(prog->colourSlot, 4, GL_UNSIGNED_BYTE, GL_TRUE, stride,
                data + element.mColourOffset);
            glEnableVertexAttribArray(prog->colourSlot);
         }

         if (prog->normalSlot >= 0)
         {
            glVertexAttribPointer(prog->normalSlot, 2, GL_FLOAT, GL_FALSE, stride,
                data + element.mNormalOffset);
            glEnableVertexAttribArray(prog->normalSlot);
         }

         if (element.mFlags & DRAW_RADIAL)
         {
            prog->setGradientFocus(element.mRadialPos * one_on_256);
         }

         if (progId & (PROG_TINT | PROG_COLOUR_OFFSET) )
         {
            prog->setColourTransform(ctrans, element.mColour );
         }

         if ( (element.mPrimType == ptLineStrip || element.mPrimType==ptPoints || element.mPrimType==ptLines)
                 && element.mCount>1)
         {
            if (element.mWidth<0)
               SetLineWidth(1.0);
            else if (element.mWidth==0)
               SetLineWidth(0.0);
            else
               switch(element.mScaleMode)
               {
                  case ssmNone: SetLineWidth(element.mWidth); break;
                  case ssmNormal:
                  case ssmOpenGL:
                     if (mLineScaleNormal<0)
                        mLineScaleNormal =
                           sqrt( 0.5*( mModelView.m00*mModelView.m00 + mModelView.m01*mModelView.m01 +
                                          mModelView.m10*mModelView.m10 + mModelView.m11*mModelView.m11 ) );
                     SetLineWidth(element.mWidth*mLineScaleNormal);
                     break;
                  case ssmVertical:
                     if (mLineScaleV<0)
                        mLineScaleV =
                           sqrt( mModelView.m00*mModelView.m00 + mModelView.m01*mModelView.m01 );
                     SetLineWidth(element.mWidth*mLineScaleV);
                     break;

                  case ssmHorizontal:
                     if (mLineScaleH<0)
                        mLineScaleH =
                           sqrt( mModelView.m10*mModelView.m10 + mModelView.m11*mModelView.m11 );
                     SetLineWidth(element.mWidth*mLineScaleH);
                     break;
               }
         }
   
            //printf("glDrawArrays %d : %d x %d\n", element.mPrimType, element.mFirst, element.mCount );

         sgDrawCount++;
         glDrawArrays(sgOpenglType[element.mPrimType], 0, element.mCount );
      }

      if (lastProg)
        lastProg->disableSlots();

      if (inData.mVertexBo)
         glBindBuffer(GL_ARRAY_BUFFER,0);*/
		
		
	}
	
	
	public function setOrtho (x0:Float, x1:Float, y0:Float, y1:Float):Void {
		
		scaleX = 2.0 / (x1 - x0);
		scaleY = 2.0 / (y1 - y0);
		
		offsetX = (x0 + x1) / (x0 - x1);
		offsetY = (y0 + y1) / (y0 - y1);
		
		modelView = new Matrix ();
		
		/*mBitmapTrans[0][0] = mScaleX;
		mBitmapTrans[0][3] = mOffsetX;
		mBitmapTrans[1][1] = mScaleY;
		mBitmapTrans[1][3] = mOffsetY;*/
		
		combineModelView (modelView);
		
	}
	
	
	public function setViewport (rect:Rectangle):Void {
		
		if (rect == null) rect = new Rectangle (0, 0, width, height);
		
		setOrtho (rect.x, rect.x + rect.width, rect.y + rect.height, rect.y);
		viewport = rect;
		gl.viewport (Std.int (rect.x), Std.int (height - rect.y - rect.height), Std.int (rect.width), Std.int (rect.height));
		
	}
	
	
	public function setWindowSize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
	}
	
	
	public function updateContext ():Void {
		
		contextID = HardwareRenderer.textureContextVersion;
		
	}
	
	
}