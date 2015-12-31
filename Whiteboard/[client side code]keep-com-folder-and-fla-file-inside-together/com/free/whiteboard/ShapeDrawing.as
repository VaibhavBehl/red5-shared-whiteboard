/*******************************************ShapeDrawing.as
* This is the class which handles 
* shape(Oval, Triangle, Rectangle) 
* drawing on whiteboard 
**********************************************************/







//import com.free.whiteboard.Whiteboard;
import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents;
import flash.filters.GlowFilter;
//!!


class com.free.whiteboard.ShapeDrawing
{
	private var wevent:WhiteboardEvents;
	//Default shape settings
	private var borderColor:String = "0x000000";
	private var fillColor:String = "0x00FF00";
	private var borderThick:Number = 3;
	
	private static var ref;
	private var selectedShape:String;
//	private var localCounter:Number = 0;
	
	public function ShapeDrawing(wevent:WhiteboardEvents,selectedShape)
	{
		ref = this;
		this.selectedShape = selectedShape;
		this.wevent = wevent;
	}
	
	public function setBorderColor(color:String)
	{
		this.borderColor = color;
	}
	
	public function setFillColor(color:String)
	{
		this.fillColor = color;
	}
	
	public function setThickness(thick:Number)
	{
		this.borderThick = thick;
	}
	
	public function applyDrawingForCircle(drawingarea:MovieClip)
	{
		
		MovieClip.prototype.drawCircle = function(x, y, radius, yRadius)
		{
				// x, y = center of circle
			// radius = radius of circle. If [optional] yRadius is defined, r is the x radius.
			// yRadius = [optional] y radius of oval.
			// ==============
			if (arguments.length<3) {
				return;
			}
			// init variables
			var theta, xrCtrl, yrCtrl, angle, angleMid, px, py, cx, cy;
			// if only yRadius is undefined, yRadius = radius
			if (yRadius == undefined) {
				yRadius = radius;
			}
			// covert 45 degrees to radians for our calculations
			theta = Math.PI/4;
			// calculate the distance for the control point
			xrCtrl = radius/Math.cos(theta/2);
			yrCtrl = yRadius/Math.cos(theta/2);
			// start on the right side of the circle
			angle = 0;
			this.moveTo(x+radius, y);
			// this loop draws the circle in 8 segments
			for (var i = 0; i<8; i++)
			{
				// increment our angles
				angle += theta;
				angleMid = angle-(theta/2);
				// calculate our control point
				cx = x+Math.cos(angleMid)*xrCtrl;
				cy = y+Math.sin(angleMid)*yrCtrl;
				// calculate our end point
				px = x+Math.cos(angle)*radius;
				py = y+Math.sin(angle)*yRadius;
				// draw the circle segment
				this.curveTo(cx, cy, px, py);
			}
		};
			
		drawingarea.val = this;
		drawingarea.onPress = function()
		{
			
			var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());				
			var handle:MovieClip = draw_MC.attachMovie("handle", "handle", DepthUtils.getNextDepth(),{_x:this._xmouse, _y:this._ymouse});
				
			draw_MC.pressX = this._xmouse;
			draw_MC.pressY = this._ymouse;
					
			this.val.circle(draw_MC);
			this.val.drag(draw_MC, handle);

			handle.clr = new Color(handle);
			//handle._alpha =20;
//!!
		var dx = draw_MC._xmouse - draw_MC.pressX;
		var dy = draw_MC._ymouse - draw_MC.pressY;
		var radius = Math.sqrt((dx*dx)+(dy*dy));
			
		WhiteboardEvents.connect_NC.call("updateShapeDrawing",null,0,0,this.val.fillColor, this.val.borderThick,this.val.borderColor, draw_MC._xmouse,draw_MC._ymouse,draw_MC.pressX,draw_MC.pressY,radius,radius,2);
//!!
					
		}
		drawingarea.onRelease = function()
		{
			this.val.noDrag(this["draw_MC"+this.val.wevent.movie_COUNT], this["draw_MC"+this.val.wevent.movie_COUNT].handle);
			this.val.wevent.movie_ARR.push(this["draw_MC"+this.val.wevent.movie_COUNT]);
			this.val.wevent.movie_COUNT++;
//!!
			WhiteboardEvents.connect_NC.call("updateShapeDrawing",null,0,2,this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse,this._ymouse,0,0,0,0,2);
//!!
		}
		//!!<commented it>drawingarea.onReleaseOutside = drawingarea.onRelease;
	}
	
	public function applyDrawingOnWhiteboard(drawingarea:MovieClip)
	{
		
		drawingarea.val = this;
		
		if(selectedShape == "triangle")
		{
			//Handling mouse events differently
			drawingarea.val = this;
			drawingarea.onPress = function()
			{
				var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
				this.movie = draw_MC;
				this.pressX = this._xmouse;
				this.pressY = this._ymouse;
				this.press = true;
				this.once = 1;
//!!
				WhiteboardEvents.connect_NC.call("updateShapeDrawing",null,0,0,this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse,this._ymouse,this.pressX,this.pressY,0,0,0);
//!!
			};
			
			drawingarea.onMouseMove = function()
			{
				if(this.press == true)
				{ 
					if((this._xmouse>= this._x && this._xmouse<=this._x + this._width) && (this._ymouse >= this._y && this._ymouse<=this._y + this._height))
					{
						//removeMovieClip(this.movie.temp1);
						//delete this.movie.temp1;
						var temp = this.movie.createEmptyMovieClip("temp1", 2);
						this.movie.temp1.beginFill(this.val.fillColor);
						this.movie.temp1.lineStyle(this.val.borderThick,this.val.borderColor, 100);
						this.movie.temp1.moveTo(this.pressX, this.pressY);
						this.movie.temp1.lineTo(this._xmouse, this._ymouse);
						this.movie.temp1.lineTo(this._xmouse, this.pressY);
						this.movie.temp1.lineTo(this.pressX, this.pressY);
						this.movie.temp1.endFill();
//!!
					WhiteboardEvents.connect_NC.call("updateShapeDrawing",null,0,1,this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse,this._ymouse,this.pressX,this.pressY,0,0,0);
//!!
					}	
				}
			};
			
			drawingarea.onRelease = function()
			{
				if(this.press == true)
				{
					this.press = false;
				}	
				this.val.wevent.movie_ARR.push(this.movie);
				this.val.wevent.movie_COUNT++;
//!!
			WhiteboardEvents.connect_NC.call("updateShapeDrawing",null, 
					0 , 2 , this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse, 
					this._ymouse,this.pressX,this.pressY,0,0,0);
//!!
			};
			//!!drawingarea.onReleaseOutside = drawingarea.onRelease;
		}
		else if(selectedShape == "rect")
		{
			//Handling mouse events differently
			
			drawingarea.val = this;
			drawingarea.onPress = function()
			{
				var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
				this.movie = draw_MC;
				this.pressX = this._xmouse;
				this.pressY = this._ymouse;
				this.press = true;
				this.once = 1;
//!!
			WhiteboardEvents.connect_NC.call("updateShapeDrawing",null, 
					0 , 0 ,this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse, 
					this._ymouse,this.pressX,this.pressY,0,0,1);
//!!
			};
			drawingarea.onMouseMove = function()
			{
				if(this.press == true)
				{ 
					if((this._xmouse> this._x+10 && this._xmouse<this._x + this._width-10) && (this._ymouse > this._y+10 && this._ymouse<this._y + this._height-10))
					{
					//	removeMovieClip(this.movie.temp);
					//	delete this.movie.temp;
						var temp = this.movie.createEmptyMovieClip("temp", 1);
					//	trace(this.val.fillColor);
						this.movie.temp.beginFill(this.val.fillColor);
						this.movie.temp.lineStyle(this.val.borderThick,this.val.borderColor, 100);
						this.movie.temp.moveTo(this.pressX, this.pressY);
						this.movie.temp.lineTo(this._xmouse+(this._xmouse-this.pressX)/150,this.pressY);
						this.movie.temp.lineTo(this._xmouse+(this._xmouse-this.pressX)/150,this._ymouse+(this._ymouse-this.pressY)/150);
						this.movie.temp.lineTo(this.pressX, this._ymouse+(this._ymouse-this.pressY)/150);
						this.movie.temp.lineTo(this.pressX,this.pressY);
						
						this.movie.temp.endFill();
//!!
						WhiteboardEvents.connect_NC.call("updateShapeDrawing",null, 
					0 , 1 , this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse, 
					this._ymouse,this.pressX,this.pressY,0,0,1);
//!!
					}
				}
			};
			drawingarea.onRelease = function()
			{
				if(this.press == true)
				{					
					this.press = false;
				}	
				this.val.wevent.movie_ARR.push(this.movie);
				this.val.wevent.movie_COUNT++;
//!!
				WhiteboardEvents.connect_NC.call("updateShapeDrawing",null, 
					0 , 2 , this.val.fillColor, this.val.borderThick,this.val.borderColor, this._xmouse, 
					this._ymouse,this.pressX,this.pressY,0,0,1);
//!!
			};
			//drawingarea.onReleaseOutside = drawingarea.onRelease;
		}	
	}	
		
	public function setPenEdge(temp_mc, pencolor)
	{
		
			//var color				= "0xFFFFFF;	
			var color               = pencolor;
			var alpha				=	1																												;	
			var blurX				=	2																												;	
			var blurY				=	2																												;
			var strength			=	borderThick;//1000																											;	
			var quality				=	3																												;	
			var inner				=	false																											;	
			var knockout			=	false																											;
			var filter:GlowFilter =	new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			
			var filterArray = new Array();
			filterArray.push(filter)																													;
			temp_mc.filters = filterArray;
	}
		
	public function circle(draw_MC)
	{
		draw_MC.clear();
		draw_MC.lineStyle(borderThick,borderColor);
		draw_MC.beginFill(fillColor,50);
		var dx = draw_MC._xmouse - draw_MC.pressX;
		var dy = draw_MC._ymouse - draw_MC.pressY;
		var radius = Math.sqrt((dx*dx)+(dy*dy));
	//	trace("radius is "+ radius+":"+dx+":"+dy);
		draw_MC.drawCircle(draw_MC.pressX, draw_MC.pressY, radius, radius);
		draw_MC.endFill();
		updateAfterEvent();
	}
			
//
	public function drag(draw_MC, handle)
	{
		//draw_MC.startDrag(false,10,75,190,75);
		handle.startDrag();
		var val = this;
		handle.onMouseMove = function()
		{
			val.circle(draw_MC);
//!!
			WhiteboardEvents.connect_NC.call("updateShapeDrawing",null, 
					0 , 1 , val.fillColor, val.borderThick,val.borderColor, draw_MC._xmouse, 
					draw_MC._ymouse,draw_MC.pressX,draw_MC.pressY,0,0,2);
//!!
		}
		handle.clr.setTransform({rb:255});
	}
//
	public function noDrag(draw_MC, handle)
	{
		var val = this;
		handle.stopDrag();
		handle.onMouseMove = null;
		handle.clr.setTransform({rb:0});
		val.circle(draw_MC);
	}
		
}
