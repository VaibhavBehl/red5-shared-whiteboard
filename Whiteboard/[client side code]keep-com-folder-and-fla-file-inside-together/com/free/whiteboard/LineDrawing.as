/*************************************LineDrawing.as 
* This class which handles 
* Line drawing on whiteboard
* 
* 
****************************************************/






//import com.free.whiteboard.Whiteboard;
import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents

class com.free.whiteboard.LineDrawing
{
	
	//Default Line settings
	private var color:String = "#000000";
	private var thickness:Number = 3;
	private var linetype:String = "noarrow";
	private static var ref;
	private var pressX;
	private var pressY;
	private var wevent:WhiteboardEvents;
	private var cnt:Number =1;
		
	public function LineDrawing(wevent:WhiteboardEvents)
	{
		ref = this;
		this.wevent = wevent;
	}
	
	public function setThickness(thickness:Number)
	{
		this.thickness = thickness;
	}
	
	public function setColor(color:String)
	{
		this.color = color;
	}
	
	public function setLineType(linetype:String)
	{
		this.linetype = linetype;
	}
	
	public function applyDrawingOnWhiteboard(drawingarea:MovieClip)
	{
		
		var temp_MC:MovieClip=drawingarea.createEmptyMovieClip("temp_MC", DepthUtils.getNextDepth());
		
		drawingarea.val = this;
		drawingarea.onRelease = function()
		{
				
			temp_MC.clear();
			delete this.onMouseMove;
			this.val.wevent.movie_COUNT++;
			ref.cnt = 1;
			
			WhiteboardEvents.connect_NC.call("updateLineDrawing",null,0,2,this.val.color,this.val.thickness, this._xmouse,this._ymouse);
		};
		drawingarea.onReleaseOutside = drawingarea.onRelease;
		
		drawingarea.val = this;
		drawingarea.onPress = function()
		{
			var dw_MC:MovieClip = this.createEmptyMovieClip("dw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
			var draw_MC:MovieClip = dw_MC.createEmptyMovieClip("draw_MC"+ref.cnt,DepthUtils.getNextDepth());
			
			temp_MC.swapDepths(draw_MC);
			draw_MC.lineStyle(this.val.thickness, this.val.color);
			this.val.wevent.movie_ARR.push(dw_MC);

			draw_MC.moveTo(this._xmouse, this._ymouse);
			
			this.val.pressX = this._xmouse;
			this.val.pressY = this._ymouse;
			
			WhiteboardEvents.connect_NC.call("updateLineDrawing",null,0,0,this.val.color,this.val.thickness,this._xmouse,this._ymouse);
			this.onMouseMove = function()
			{
				this.val.mouseMoveEvent(draw_MC,temp_MC,this);
			};
			
		};
	}
	
	public function mouseMoveEvent(draw_MC, temp_MC,drawingarea)
	{

		if(drawingarea._xmouse<=1 || drawingarea._xmouse>=drawingarea._width)
		{
			return;	
		}
		else if(drawingarea._ymouse<=1 || drawingarea._ymouse>=drawingarea._height)
		{
			return;
		}
		
		// Remove any previous drawing
		temp_MC.clear();
		// Draw dot at End Point
		temp_MC.lineStyle(10, 0x00ff00);
		temp_MC.moveTo(drawingarea._xmouse, drawingarea._ymouse);
		temp_MC.lineTo(drawingarea._xmouse + 0.5, drawingarea._ymouse);
		// Draw line segment
		
		(drawingarea["dw_MC"+drawingarea.val.wevent.movie_COUNT])["draw_MC"+ref.cnt].removeMovieClip();
		delete (drawingarea["dw_MC"+drawingarea.val.wevent.movie_COUNT])["draw_MC"+ref.cnt];
		ref.cnt++;
		
		var draw_MC:MovieClip = drawingarea["dw_MC"+drawingarea.val.wevent.movie_COUNT].createEmptyMovieClip("draw_MC"+ref.cnt,DepthUtils.getNextDepth());
		
		temp_MC.swapDepths(draw_MC);
			
		draw_MC.lineStyle(thickness, color);
	
		draw_MC.moveTo(pressX, pressY);
		draw_MC.lineTo(drawingarea._xmouse,drawingarea. _ymouse);
		
		WhiteboardEvents.connect_NC.call("updateLineDrawing",null,0,1,color,thickness,drawingarea._xmouse,drawingarea._ymouse);
	}
	
	public function applyDrawingForArrowLine(drawingarea:MovieClip, linetype:String)
	{
		
		drawingarea.val = this;
		
		drawingarea.onRollOver = function()
		{
			
			var draw_MC:MovieClip = drawingarea.createEmptyMovieClip("draw_MC"+wevent.movie_COUNT++,DepthUtils.getNextDepth());
			var temp_MC:MovieClip = drawingarea.createEmptyMovieClip("temp_MC", DepthUtils.getNextDepth());
			draw_MC.lineStyle(this.val.thickness, this.val.color);
		
			this.startX = this._xmouse;
			this.startY = this._ymouse;
			
			MovieClip.prototype.arrowTo = function(init,w,h,rgb,alpha)
			{
				if(w==undefined) w = 10;
				if(h==undefined) h = 20;
				if(rgb==undefined) rgb = 0x000000;
				if(alpha==undefined) alpha = 100;
				if(this.arrowDepth==undefined) this.arrowDepth = this.getDepth();
				this.arrowDepth++;
				
				this.lineTo(init.x2,init.y2);
				//create clip to contain arrowhead
				var t = this.createEmptyMovieClip("arrowHead"+this.arrowDepth+"_mc",this.arrowDepth);
				t._x = init.x2;
				t._y = init.y2;
				//draw arrowhead
				
				if(linetype == "both")
				{
					t.beginFill(rgb,alpha);
				}
				
				if(drawingarea.val.thickness > 10)
					t.lineStyle(8,rgb,alpha);
				else if(drawingarea.val.thickness > 8)
					t.lineStyle(5,rgb,alpha);
				else	
					t.lineStyle(3,rgb,alpha);
					
				if(linetype == "both")
				{
					t.lineTo(-w,h);
					t.lineTo(w,h);
					t.lineTo(0,0);
					t.endFill();
				}
				else if(linetype == "right")
				{
					t.lineTo(w,h);
					t.lineTo(0,0);
					
				}
				else if(linetype == "left")
				{
					t.lineTo(-w,h);
					t.lineTo(0,0);
				}
				else if(linetype == "no")
				{
					
				}
				
				//calculate and apply rotation
				var theta = Math.atan2(init.y2-init.y1,init.x2-init.x1); 
				var thetaDegrees = theta*180/Math.PI;
				t._rotation += 90+thetaDegrees; 
			}

			var mouseMoveListener = new Object();
			mouseMoveListener.onMouseMove = function()
			{
				ref.mouseMoveEventForArrow(draw_MC, temp_MC, drawingarea);
			};
			//
			var mouseClickListener = new Object();
			mouseClickListener.onMouseDown = function()
			{
				ref.mouseDownEvent(draw_MC, temp_MC, drawingarea, mouseMoveListener);
			};
			mouseClickListener.onMouseUp = function()
			{
				ref.mouseUpEvent(draw_MC, temp_MC, drawingarea,mouseMoveListener);
			};
			
			Mouse.addListener(mouseClickListener);
			
			this.onRollOut = function()
			{
				MovieClip.prototype.arrowTo = undefined;
				
				delete mouseClickListener.onMouseDown;
				delete mouseClickListener.onMouseUp;
				delete mouseMoveListener.onMouseMove;
				
				Mouse.addListener(null);
			}
			this.onReleaseOutside = function()
			{
				MovieClip.prototype.arrowTo = undefined;
				Mouse.addListener(null);
				delete mouseClickListener.onMouseDown;
				delete mouseClickListener.onMouseUp;
				delete mouseMoveListener.onMouseMove;
			}
		}
	}
	
	public function mouseDownEvent(draw_MC, temp_MC, drawingarea,mouseMoveListener)
	{
		if(_ymouse > drawingarea._y + drawingarea._height+50)
			return;
		
		if(_ymouse < drawingarea._y+50)
			return;
		
		if(_xmouse > drawingarea._x + drawingarea._width)
			return;
		
		if(_xmouse < drawingarea._x)
			return;
			
		draw_MC.lineStyle(drawingarea.val.thickness, drawingarea.val.color);
	        drawingarea.startX = drawingarea._xmouse;
	        drawingarea.startY = drawingarea._ymouse;
	        Mouse.addListener(mouseMoveListener);
	}

	public function mouseUpEvent(draw_MC, temp_MC, drawingarea, mouseMoveListener)
	{
		
		if(_ymouse > drawingarea._y + drawingarea._height+50)
			return;
		
		if(_ymouse < drawingarea._y+50)
			return;
		
		if(_xmouse > drawingarea._x + drawingarea._width)
			return;
		
		if(_xmouse < drawingarea._x)
			return;
		
	        draw_MC.moveTo(drawingarea.startX, drawingarea.startY);
	        //draw_mc.lineTo(_xmouse, _ymouse);
	        var myInit = {x1:drawingarea.startX,x2:drawingarea._xmouse,y1:drawingarea.startY,y2:drawingarea._ymouse};
		
		if(drawingarea.val.thickness > 8)
			draw_MC.arrowTo(myInit,20,30, drawingarea.val.color, 100);
		else	
			draw_MC.arrowTo(myInit,10,20, drawingarea.val.color, 100);
        	temp_MC.clear();
	        Mouse.removeListener(mouseMoveListener);
	}

	public function mouseMoveEventForArrow(draw_MC, temp_MC, drawingarea)
	{
		
		if(_ymouse > drawingarea._y + drawingarea._height+50)
			return;
		
		if(_ymouse < drawingarea._y+50)
			return;
		
		if(_xmouse > drawingarea._x + drawingarea._width)
			return;
		
		if(_xmouse < drawingarea._x)
			return;
		
        	// Remove any previous drawing
	        temp_MC.clear();
	        // Draw line
	        temp_MC.lineStyle(drawingarea.val.thickness,drawingarea.val.color);
	        temp_MC.moveTo(drawingarea.startX, drawingarea.startY);
	        temp_MC.lineTo(drawingarea._xmouse, drawingarea._ymouse);
	        // Draw dot at End Point
	        temp_MC.lineStyle(6, 0x00ff00);
        	temp_MC.lineTo(drawingarea._xmouse+0.5, drawingarea._ymouse);
	        // Draw dot at Start Point
	        temp_MC.moveTo(drawingarea.startX, drawingarea.startY);
	        temp_MC.lineTo(drawingarea.startX+0.5, drawingarea.startY);
	}	
}
