/******************************FreeHandDrawing.as
* This is the class which handles 
* free hand drawing on whiteboard
* 
* 
*
************************************************/






import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents

class com.free.whiteboard.FreeHandDrawing
{
	private var wevent:WhiteboardEvents;
	
	//Default free hand settings
	private var color:String = "#000000";
	private var thickness:Number = 3;
	private static var ref;
	
	public function FreeHandDrawing(wevent:WhiteboardEvents)
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
	
	public function applyDrawingOnWhiteboard(drawingarea:MovieClip)
	{	
		var temp_MC:MovieClip=drawingarea.createEmptyMovieClip("temp_MC", DepthUtils.getNextDepth());
		
		drawingarea.val = this;
		drawingarea.onRelease = function()
		{
			temp_MC.clear();
			delete this.onMouseMove;
			this.val.wevent.movie_COUNT++;
			WhiteboardEvents.connect_NC.call("updateFreeHandDrawing",null,0,2,this.val.color,this.val.thickness,this._xmouse,this._ymouse);

		};
		drawingarea.onReleaseOutside = drawingarea.onRelease;
		
		drawingarea.val = this;
		drawingarea.onPress = function()
		{
			var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
			
			temp_MC.swapDepths(draw_MC);
			
			draw_MC.lineStyle(this.val.thickness, this.val.color);
			wevent.movie_ARR.push(draw_MC);
			
			draw_MC.moveTo(this._xmouse, this._ymouse);
			
			WhiteboardEvents.connect_NC.call("updateFreeHandDrawing",null,0,0,this.val.color,this.val.thickness, this._xmouse,this._ymouse);
			
			this.onMouseMove = function()
			{
				this.val.mouseMoveEvent(draw_MC,temp_MC,this);
			};
		};
	}
	
	public function mouseMoveEvent(draw_MC, temp_MC,drawingarea)
	{
		
		if(drawingarea._xmouse<=5 || drawingarea._xmouse>=770)
		{
			return;	
		}
		else if(drawingarea._ymouse<=5 || drawingarea._ymouse>=465)
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
		
		drawingarea["draw_MC"+wevent.movie_COUNT].lineTo(drawingarea._xmouse,drawingarea. _ymouse);
		
		WhiteboardEvents.connect_NC.call("updateFreeHandDrawing",null,0,1,color,thickness,drawingarea._xmouse,drawingarea._ymouse);
	}
	
}
