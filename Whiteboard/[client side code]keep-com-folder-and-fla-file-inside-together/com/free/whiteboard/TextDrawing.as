/*************************************TextDrawing.as
* This is the class which handles 
* text drawing on whiteboard
* 
*
***************************************************/






//import com.free.whiteboard.Whiteboard;
import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents
//import mx.controls.TextField;

class com.free.whiteboard.TextDrawing
{
	private var wevent:WhiteboardEvents;
	//Default text settings
	private var tcolor:String = "#0B333C ";
	private var fontsize:Number;
	private static var ref;
	
	public function TextDrawing(wevent:WhiteboardEvents)
	{
		ref = this;
		this.wevent = wevent;
	}
	
	public function setColor(tcolor:String)
	{
		this.tcolor = tcolor;
	}
	
	public function setTextFont(fontsize:Number)
	{
		this.fontsize = fontsize;
	}
	
	public function applyDrawingOnWhiteboard(drawingarea:MovieClip)
	{
		
		_global.styles.TextInput.setStyle("backgroundColor", "transparent");
		_global.styles.TextInput.setStyle("borderStyle", "none");
		
		drawingarea.val = this;
		
		drawingarea.onRelease = function()
		{
			var draw_MC:MovieClip = this.createEmptyMovieClip("draw_MC"+this.val.wevent.movie_COUNT,DepthUtils.getNextDepth());
			this.val.movieRefer = draw_MC;
			//var textArea:TextField = TextField(draw_MC.attachMovie("TextInput","textarea", DepthUtils.getNextDepth(),{_x:this._xmouse-15,_y:this._ymouse-20}));
			
			var textArea:TextField = draw_MC.createTextField("textarea", DepthUtils.getNextDepth(),this._xmouse-15,this._ymouse-20, 150, 100 );
			
			textArea.embedFonts = true;
			textArea.type = "input";
			textArea.autoSize = true;
			textArea.maxChars = 50;
			textArea.textColor = this.val.tcolor;
			//textArea.multiline = false;
			//textArea.setStyle("color", this.val.color);
			//textArea.setStyle("fontSize", this.val.fontSize);
			
			var my_fmt:TextFormat = new TextFormat(); 
		//	trace(ref.fontsize);
			my_fmt.font = "myfont";
			my_fmt.size = this.val.fontsize;
			textArea.setNewTextFormat(my_fmt); 

			//textArea.hScrollPolicy = "off";
			//textArea.vScrollPolicy = "off";

			Selection.setFocus(textArea);
			
			textArea.onChanged = function(txtfield)
			{
							
				if(txtfield._x + txtfield._width+10 >= drawingarea._x+drawingarea._width || txtfield.length >= 50)
				{
					
					Selection.setFocus(_root.createTextField("dummy"));
					removeMovieClip(_root.dummy);
					delete _root.dummy;
					txtfield.type = "dynamic";
					//trace("oops crossed the border");
				}
					
			}
			
			var keyListener = new Object();       // establish listener (generic) object

			keyListener.val = textArea;
			keyListener.onKeyUp = function ()// when keyboard key released take action
			{        
				if (Key.getCode() == Key.ENTER)  // if Enter/Return key was pressed
				{trace("*****inside enter if--before******");
					
					Selection.setFocus(_root.createTextField("dummy"));
					removeMovieClip(_root.dummy);
					delete _root.dummy;
					this.val.type = "dynamic";
					//send message to red5 server that this object is 
					//now ready to be moved
					WhiteboardEvents.connect_NC.call("updateTextDrawing",null,0,0,textArea.textColor, textArea.textHeight, textArea._x,textArea._y,textArea.text);
					trace("*****inside enter if--after******");
				}
			}
			Key.addListener(keyListener);      // register object to receive onKeyUp
			
			wevent.movie_ARR.push(draw_MC);
					
			this.val.wevent.movie_COUNT++;
		};
		drawingarea.onReleaseOutside = drawingarea.onRelease;
	}
}
