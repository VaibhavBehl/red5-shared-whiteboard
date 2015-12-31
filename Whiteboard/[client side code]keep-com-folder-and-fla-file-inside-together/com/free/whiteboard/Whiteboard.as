/******************************************Whiteboard.as
* This is the main class which gets loaded 
* flash client will start
********************************************************/





import com.free.whiteboard.DepthUtils;
import com.free.whiteboard.WhiteboardEvents;

class com.free.whiteboard.Whiteboard
{
	
	public static var ref;       //For self reference

	public var connect_BTN:Button;
	public var disconnect_BTN:Button;
	public var whiteboard_MC:MovieClip;
	public var controlbox_MC:MovieClip;
	
	private var globalColor:String = "none";
	private var globalFontSize:Number = 10;
	private var globalThickness:Number = -1;
	private var globalBorderColor:String = "none";
	
	public var evtHandler:WhiteboardEvents;
	
	public function Whiteboard()
	{
		ref = this;
		evtHandler = new WhiteboardEvents();
		
		initilaizeGUI();
		attachEventHandler();
	}
	
	/**This function is responsible for
	*  craeting the interface of whiteboard
	*/
	public function initilaizeGUI()
	{
		connect_BTN = Button(_root.attachMovie("connect_BTN","connect_BTN",DepthUtils.getNextDepth(),{_x:278,_y:20}));
		connect_BTN._x = 278;
		connect_BTN._y = 20;
		connect_BTN._alpha = 50;
		disconnect_BTN = Button(_root.attachMovie("disconnect_BTN","disconnect_BTN",DepthUtils.getNextDepth(),{_x:429,_y:20}));
		disconnect_BTN._x = 429;
		disconnect_BTN._y = 20;
		disconnect_BTN._alpha = 50;
		whiteboard_MC = _root.attachMovie("whiteboard_MC","whiteboard_MC",DepthUtils.getNextDepth(),{_x:10,_y:54});
		controlbox_MC = _root.attachMovie("controlbox_MC","controlbox_MC",DepthUtils.getNextDepth(),{_x:226,_y:535});
		
		controlbox_MC._visible = false;	

		//whiteboard_MC.createTextField("serverip", DepthUtils.getNextDepth(), 200, 20, 200, 20);
		//serverip.text = "localhost";	
	}
	
	public function enableThickness()
	{
		controlbox_MC.thick1_BTN.enabled = true;
		controlbox_MC.thick2_BTN.enabled = true;
		controlbox_MC.thick3_BTN.enabled = true;
		controlbox_MC.thick4_BTN.enabled = true;
		controlbox_MC.thick5_BTN.enabled = true;
		controlbox_MC.thick6_BTN.enabled = true;
		controlbox_MC.thick7_BTN.enabled = true;
		
		controlbox_MC.thick1_BTN._alpha = 100;
		controlbox_MC.thick2_BTN._alpha = 100;
		controlbox_MC.thick3_BTN._alpha = 100;
		controlbox_MC.thick4_BTN._alpha = 100;
		controlbox_MC.thick5_BTN._alpha = 100;
		controlbox_MC.thick6_BTN._alpha = 100;
		controlbox_MC.thick7_BTN._alpha = 100;
	}
	
	public function disableThickness()
	{
		controlbox_MC.thick1_BTN.enabled = false;
		controlbox_MC.thick2_BTN.enabled = false;
		controlbox_MC.thick3_BTN.enabled = false;
		controlbox_MC.thick4_BTN.enabled = false;
		controlbox_MC.thick5_BTN.enabled = false;
		controlbox_MC.thick6_BTN.enabled = false;
		controlbox_MC.thick7_BTN.enabled = false;
		
		controlbox_MC.thick1_BTN._alpha = 20;
		controlbox_MC.thick2_BTN._alpha = 20;
		controlbox_MC.thick3_BTN._alpha = 20;
		controlbox_MC.thick4_BTN._alpha = 20;
		controlbox_MC.thick5_BTN._alpha = 20;
		controlbox_MC.thick6_BTN._alpha = 20;
		controlbox_MC.thick7_BTN._alpha = 20;
	}
	
	public function enableLineControls()
	{
		controlbox_MC.leftarrow_BTN.enabled = true;
		controlbox_MC.leftarrow_BTN._alpha = 100;
		
		controlbox_MC.rightarrow_BTN.enabled = true;
		controlbox_MC.rightarrow_BTN._alpha = 100;
		
		controlbox_MC.botharrow_BTN.enabled = true;
		controlbox_MC.botharrow_BTN._alpha = 100;
		
		controlbox_MC.noarrow_BTN.enabled = true;
		controlbox_MC.noarrow_BTN._alpha = 100;
		
		controlbox_MC.thick_BTN.enabled = true;
		controlbox_MC.thick_BTN._alpha = 100;
		
		controlbox_MC.color1_BTN.enabled = true;
		controlbox_MC.color1_BTN._alpha = 100;
	}
	
	public function disableLineControls()
	{
		controlbox_MC.leftarrow_BTN.enabled = false;
		controlbox_MC.leftarrow_BTN._alpha = 20;
		
		controlbox_MC.rightarrow_BTN.enabled = false;
		controlbox_MC.rightarrow_BTN._alpha = 20;
		
		controlbox_MC.botharrow_BTN.enabled = false;
		controlbox_MC.botharrow_BTN._alpha = 20;
		
		controlbox_MC.noarrow_BTN.enabled = false;
		controlbox_MC.noarrow_BTN._alpha = 20;
		
		controlbox_MC.thick_BTN.enabled = false;
		controlbox_MC.thick_BTN._alpha = 20;
		
		controlbox_MC.color1_BTN.enabled = false;
		controlbox_MC.color1_BTN._alpha = 20;
		
		disableThickness();
	}
	
	public function enableShapeControls()
	{
		
		controlbox_MC.thick_BTN.enabled = true;
		controlbox_MC.thick_BTN._alpha = 100;
		
		controlbox_MC.color1_BTN.enabled = true;
		controlbox_MC.color1_BTN._alpha = 100;
		
		controlbox_MC.color2_BTN.enabled = true;
		controlbox_MC.color2_BTN._alpha = 100;
	}
	
	public function disableShapeControls()
	{
		
		controlbox_MC.thick_BTN.enabled = false;
		controlbox_MC.thick_BTN._alpha = 20;
		
		controlbox_MC.color1_BTN.enabled = false;
		controlbox_MC.color1_BTN._alpha = 20;
		
		controlbox_MC.color2_BTN.enabled = false;
		controlbox_MC.color2_BTN._alpha = 20;
		
		disableThickness();
	}
	
	public function enableTextControls()
	{
		controlbox_MC.color1_BTN.enabled = true;
		controlbox_MC.color1_BTN._alpha = 100;
		var font1 = controlbox_MC.attachMovie("font1_BTN","font1",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font1._x = 58.8;
		controlbox_MC.font1._y = 94.3;
		
		var font2 = controlbox_MC.attachMovie("font2_BTN","font2",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font2._x = 105.8;
		controlbox_MC.font2._y = 94.3;
		
		var font3 = controlbox_MC.attachMovie("font3_BTN","font3",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font3._x = 155.2;
		controlbox_MC.font3._y = 94.3;
		
		var font4 = controlbox_MC.attachMovie("font4_BTN","font4",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font4._x = 202;
		controlbox_MC.font4._y = 94.3;
		
		var font5 = controlbox_MC.attachMovie("font5_BTN","font5",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font5._x = 251;
		controlbox_MC.font5._y = 94.3;
		
		var font6 = controlbox_MC.attachMovie("font6_BTN","font6",DepthUtils.getNextDepth(),{_x:0,_y:94.3});		
		
		controlbox_MC.font6._x = 305;
		controlbox_MC.font6._y = 94.3;
		
		
		controlbox_MC.font1._width = 39.6;
		controlbox_MC.font1._height = 17.5;
		controlbox_MC.font2._width = 39.6;
		controlbox_MC.font2._height = 17.5;
		controlbox_MC.font3._width = 39.6;
		controlbox_MC.font3._height = 17.5;
		controlbox_MC.font4._width = 39.6;
		controlbox_MC.font4._height = 17.5;
		controlbox_MC.font5._width = 39.6;
		controlbox_MC.font5._height = 17.5;
		controlbox_MC.font6._width = 39.6;
		controlbox_MC.font6._height = 17.5;
		
		for(var i = 1; i<= 6 ; i++)
		{
			controlbox_MC["font"+i].i = i;
			controlbox_MC["font"+i].onRelease = function()
			{
				_global.whiteboard.evtHandler.textdrawing.setTextFont(9+3+this.i+(this.i-1));
			}
		}
	}
	
	public function disableTextControls()
	{
		controlbox_MC.color1_BTN.enabled = false;
		controlbox_MC.color1_BTN._alpha = 20;
		
		for(var i = 1; i<= 6 ; i++){
			controlbox_MC["font"+i].unloadMovie();
			removeMovieClip(controlbox_MC["font"+i]);
			delete controlbox_MC["font"+i];
		}
		
	}

	public function enableObjectControls()
	{
		controlbox_MC.color1_BTN.enabled = true;
		controlbox_MC.color1_BTN._alpha = 100;
		
		
	}
	
	public function disableObjectControls()
	{
		controlbox_MC.color1_BTN.enabled = false;
		controlbox_MC.color1_BTN._alpha = 20;
		
	}


	public function enableFreeHandControls()
	{
		controlbox_MC.color1_BTN.enabled = true;
		controlbox_MC.color1_BTN._alpha = 100;
		
		controlbox_MC.thick_BTN.enabled = true;
		controlbox_MC.thick_BTN._alpha = 100;
		
	}
	
	public function disableFreeHandControls()
	{
		controlbox_MC.color1_BTN.enabled = false;
		controlbox_MC.color1_BTN._alpha = 20;
		
		controlbox_MC.thick_BTN.enabled = false;
		controlbox_MC.thick_BTN._alpha = 20;
		disableThickness();
	}
	
	
	
	/**This function is responsible for 
	* attaching events handler with every
	* event generating components
	*/
	public function attachEventHandler()
	{
		
		/**Red5 events*/
		connect_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.connectServer();
		}
		disconnect_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.disconnectServer();
		}
		
		/**Drawing events*/
		controlbox_MC.freehand_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.freeHandDraw();
		}
		controlbox_MC.circle_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.circleDraw();
		}
		controlbox_MC.rect_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.rectDraw();
		}
		controlbox_MC.triangle_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.triangleDraw();
		}
		controlbox_MC.line_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.lineDraw("no");
		}
		
		controlbox_MC.leftarrow_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.lineDraw("left");
		};
		
		controlbox_MC.rightarrow_BTN.onRelease = function(){
			_global.whiteboard.evtHandler.lineDraw("right");
		};
		
		controlbox_MC.botharrow_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.lineDraw("both");
		};
		
		controlbox_MC.noarrow_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.lineDraw("no");
		};
		
		controlbox_MC.text_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.textDraw();
		}
		controlbox_MC.clear_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.clearDrawing();
		}
		
		/**Undo/Redo events*/
		controlbox_MC.undo_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.undoDrawing();
		}
		controlbox_MC.redo_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.redoDrawing();
		}
		
		/**Interface events*/
		controlbox_MC.thick_BTN.onRelease = function()
		{
			_global.whiteboard.enableThickness();
		};
		
		/**Object events*/
		controlbox_MC.cupidarrowobject_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.insertObject("cupidarrowplay");
		}
		controlbox_MC.starobject_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.insertObject("starplay");
		}
		controlbox_MC.smileyobject_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.insertObject("smileyplay");
		}
		controlbox_MC.sadobject_BTN.onRelease = function()
		{
			_global.whiteboard.evtHandler.insertObject("sadplay");
		}
		
		for(var i =1 ; i <=7 ; i++ )
		{
			controlbox_MC["thick"+i+"_BTN"].i = i;
			controlbox_MC["thick"+i+"_BTN"].onRelease = function()
			{
				if(_global.whiteboard.evtHandler.selectedControl == "freehand")
				{
					_global.whiteboard.evtHandler.freehanddrawing.setThickness(15-this.i*2);
				}
				else if(_global.whiteboard.evtHandler.selectedControl == "line")
				{
					_global.whiteboard.evtHandler.linedrawing.setThickness(15-this.i*2);
				}
				else if(_global.whiteboard.evtHandler.selectedControl == "circle" || 
					_global.whiteboard.evtHandler.selectedControl == "triangle" ||
					_global.whiteboard.evtHandler.selectedControl == "rect")
				{
					_global.whiteboard.evtHandler.shapedrawing.setThickness(15-this.i*2);
				}
				
				_global.whiteboard.setGlobalThick(15-this.i*2); //Setting global for later use
			}
		}
		
		for(var i =1 ; i <=2 ; i++ )
		{
			controlbox_MC["color"+i+"_BTN"].i = i;
			controlbox_MC["color"+i+"_BTN"].onRelease = function()
			{
			
				var PenColor_MC	=_root.attachMovie("PenColor_MC","PenColor_MC",100,{_x:250,_y:200});
				
				PenColor_MC._lockroot = true;
				PenColor_MC.PenColor_BTN1.i = this.i;
				PenColor_MC.PenColor_BTN1.onPress =function()
				{
					
					var Pos = { x:PenColor_MC.Palette_OB._x	, y:PenColor_MC.Palette_OB._y };
						
					PenColor_MC.localToGlobal(Pos);
					var X = _xmouse - Pos.x
					var Y =	_ymouse - Pos.y
					var PenColor = PenColor_MC.Palette.getPixel(X,Y).toString(16);
		
					
					if(_global.whiteboard.evtHandler.selectedControl == "freehand")
					{
						_global.whiteboard.evtHandler.freehanddrawing.setColor("0x"+PenColor);
					}
					else if(_global.whiteboard.evtHandler.selectedControl == "line")
					{
						_global.whiteboard.evtHandler.linedrawing.setColor("0x"+PenColor);
					}
					else if(_global.whiteboard.evtHandler.selectedControl == "object")
					{
						//trace("fdfs");
						_global.whiteboard.evtHandler.objectdrawing.setColor("0x"+PenColor);
					}
					else if(_global.whiteboard.evtHandler.selectedControl == "text")
					{
						_global.whiteboard.evtHandler.textdrawing.setColor("0x"+PenColor);
					}
					else if(_global.whiteboard.evtHandler.selectedControl == "circle" || 
					_global.whiteboard.evtHandler.selectedControl == "triangle" ||
					_global.whiteboard.evtHandler.selectedControl == "rect")
					{
						if(this.i == 1)
							_global.whiteboard.evtHandler.shapedrawing.setFillColor("0x"+PenColor);
						else if(this.i == 2)	
							_global.whiteboard.evtHandler.shapedrawing.setBorderColor("0x"+PenColor);
					}
					 
					 //Setting global color/border color for later use of other controls
					if(this.i == 1)
					{
						_global.whiteboard.setGlobalColor("0x"+PenColor);
					}	
					else if(this.i == 2)
					{
						_global.whiteboard.setGlobalBorderColor("0x"+PenColor);
					}
					removeMovieClip(PenColor_MC); //removing color dialog
				}
				
			}
		}
		
	}
	
	public function setGlobalColor(newcol:String)
	{
		globalColor = newcol;
	}
	public function getGlobalColor():String
	{
		return globalColor;
	}
	public function setGlobalThick(newthick:Number)
	{
		globalThickness = newthick;
	}
	public function getGlobalThick():Number
	{
		return 	globalThickness;
	}
	public function setGlobalBorderColor(newcolor:String)
	{
		globalBorderColor = newcolor;
	}	
	public function getGlobalBorderColor():String
	{
		return globalBorderColor;
	}	
	public function getFontSize():Number
	{
		return globalFontSize;
	}	
	public function getGlobalFontSize():Number
	{
		return globalFontSize;
	}
}
