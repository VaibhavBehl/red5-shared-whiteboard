/*****************************ObjectDrawing.as
* This is the class which handles 
* object drawing on whiteboard
**********************************************/






//import com.free.whiteboard.Whiteboard;
import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents

class com.free.whiteboard.ObjectDrawing{
	
	private var wevent:WhiteboardEvents;
	//Default free hand settings
	private var color:String = "#000000";
	private static var ref;
	private var selectedMovieClip:String;
	private var press:Boolean = false;
	
	public function ObjectDrawing(wevent:WhiteboardEvents,selectedMovieClip){
		ref = this;
		this.selectedMovieClip = selectedMovieClip;
		this.wevent = wevent;
	}
	
	public function setColor(color:String){
	//	trace("color==>"+ color);
		this.color = color;
	}
	
	public function applyDrawingOnWhiteboard(drawingarea:MovieClip){
		
		drawingarea.val = this;
		
		drawingarea.onPress = function(){
			var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
			
			var mc =draw_MC.attachMovie(this.val.selectedMovieClip,"movie",DepthUtils.getNextDepth(),{_x:this._xmouse-15,_y:this._ymouse-20});
			var movieColor:Color = new Color(mc);
			//trace(this.val.color);
			movieColor.setRGB(this.val.color);
			
			this.val.press = true;
			this.pressX = this._xmouse;
			this.pressY = this._ymouse;
			this.mc = mc;
		}
		drawingarea.onMouseMove = function(){
			if(this.val.press == true){
				if(this.mc._width <= 25 || this.mc._height <=25){
					if(this._xmouse-this.pressX < 0 || this._ymouse-this.pressY < 0)
						return;
					this.mc._width = this.mc._height = 25;	
				}
				this.mc._width = this.mc._width+(this._xmouse-this.pressX);
				this.mc._height = this.mc._height+(this._ymouse-this.pressY);
				this.pressX = this._xmouse;
				this.pressY = this._ymouse;
			}
		}
		
		drawingarea.onRelease = function(){
			/*var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
			
			var mc =draw_MC.attachMovie(this.val.selectedMovieClip,"movie",DepthUtils.getNextDepth(),{_x:this._xmouse-15,_y:this._ymouse-20});
			var movieColor:Color = new Color(mc);
			//trace(this.val.color);
			movieColor.setRGB(this.val.color);
			
			this.val.wevent.movie_ARR.push(draw_MC);
			this.val.wevent.movie_COUNT++;*/
			
			this.val.wevent.movie_ARR.push(this["draw_MC"+this.val.wevent.movie_COUNT]);
			this.val.wevent.movie_COUNT++;
			this.val.press = false;
		};
		drawingarea.onReleaseOutside = drawingarea.onRelease;
	}
}
