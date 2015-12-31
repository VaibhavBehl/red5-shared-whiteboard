/*********************textdrawingSO.as 
* This is the class which handles 
* text drawing on whiteboard
* from shared object
* 
* 
**********************************/

import com.free.whiteboard.DepthUtils;
//import com.free.whiteboard.WhiteboardEvents;


class com.free.whiteboard.TextDrawingSO{
	
	private var textdrawingSO:SharedObject;
	private var textdrawingIndex:Number =0;
	public static var ref;
	private var cnt:Number =1;
	private var pressX;
	private var pressY;
	
	private var drawingarea;
	
	public function TextDrawingSO(){
		ref = this;
	}
	
	/**This function will add a text drawing shared object
	* with this client to get line drawing events from other
	* clients
	*/
	public function addTextDrawingSO(connect_NC, clientId){
		trace("client id 1== "+ clientId)
		//Get remote shared object reference
		textdrawingSO = SharedObject.getRemote("textdrawingSO", connect_NC.uri, false);
		
		trace("I am called");
		textdrawingSO.onSync = function(infoList){
			
			var sortedlist:Array = new Array();
			
			for(var t=0;t<infoList.length;t++){
				var sname = Number(infoList[t].name);
				var scode = infoList[t].code;
				sortedlist.push({name:sname, code:scode});
			}	
			
			sortedlist.sortOn("name",Array.NUMERIC);

			for(var i = 0; i<sortedlist.length;i++){
				
				var info = sortedlist[i];
		
				switch(info.code){
					case "change":
						
						var id = info.name;
						var drawing = this.data[id];
						var drawingData:Array = drawing.split(":");
						//for(var t in info)
							trace(drawingData[6] +"=="+ clientId+"\n"+ drawingData[0]+"\n"+
								drawingData[1]+"\n"+drawingData[2]);
						//_global.whiteboard.participantLists.changeColor(drawingData[7]);	
						if(drawingData[7] == clientId)        //self id
							return;
					
						trace("calling"+drawingData.length+"  "+id);
						if(drawingData[0] == "0"){     //Means drawing a free hand object
							
							
							if(drawingData[1] == "0"){     //Means mouse press
								//mx.controls.Alert.show("callingfdsfsd");
								ref.startNewDrawing(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6]);
								
							}
							else if(drawingData[1] == "1"){ //Means mouse move
								ref.continueDrawing(drawingData[2], drawingData[3],
									drawingData[4], drawingData[5]);
							}
							else if(drawingData[1] == "2"){ //Means mouse release
								ref.stopNewDrawing(drawingData[4], drawingData[5]);
							}
						}
						else if(drawingData[0] == "1"){  //Means moving a freehand object
						
						}	
					break;
					case "delete":
					break;
				}
			}
			
		};
		textdrawingSO.connect(connect_NC);
	}
	
	/**This function will create a new freehand drawing
	* on whiteboard
	*/
	public function startNewDrawing(color, fontsize, pressX, pressY,contenu){
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remoteTe_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteTe_MC"+textdrawingIndex,DepthUtils.getNextDepth());
		var remmoteText_MC:MovieClip = remoteTe_MC.createEmptyMovieClip("remoteText_MC"+cnt , DepthUtils.getNextDepth());
		var remoteTempText_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTempText_MC", DepthUtils.getNextDepth());

		//remmoteLine_MC["textarea"].clear();
		//(drawingarea["remoteTe_MC"+textdrawingIndex])["remmoteText_MC"+cnt].removeMovieClip();
		//delete (drawingarea["remoteTe_MC"+textdrawingIndex])["remmoteText_MC"+cnt];
		cnt++;

		var remmoteLine_MC:MovieClip = drawingarea["remoteTe_MC"+textdrawingIndex].createEmptyMovieClip("remmoteText_MC"+cnt,DepthUtils.getNextDepth());
		var textArea:TextField = remmoteLine_MC.createTextField("textarea", DepthUtils.getNextDepth(),pressX-15,pressY-20, 1500, 1000 );
		
		drawingarea["textarea"].embedFonts = true;
		//textArea.type = "output";
		drawingarea["textarea"].autoSize = true;
		//drawingarea["textarea"].maxChars = 50;
		//textArea.textColor = "#0B333C";
		//textArea.appendText(contenu);
		//textArea.text=contenu;
		//textArea._visible=true;
		
		var my_fmt:TextFormat = new TextFormat(); 
		//	trace(ref.fontsize);
		my_fmt.font = "myfont";
		my_fmt.size = fontsize;
		remmoteLine_MC["textarea"].setNewTextFormat(my_fmt); 
			
		remmoteLine_MC["textarea"].textColor=color;
		remmoteLine_MC["textarea"].text=contenu;		
	}
	
	public function continueDrawing(color, thickness, xmouse, ymouse){
		// Remove any previous drawing
		drawingarea.remoteTemp_MC.clear();
		// Draw dot at End Point
		drawingarea.remoteTemp_MC.lineStyle(10, 0x00ff00);
		drawingarea.remoteTemp_MC.moveTo(xmouse, ymouse);
		drawingarea.remoteTemp_MC.lineTo(xmouse, ymouse);
		// Draw line segment
		
		(drawingarea["remoteL_MC"+textdrawingIndex])["remmoteLine_MC"+cnt].removeMovieClip();
		delete (drawingarea["remoteL_MC"+textdrawingIndex])["remmoteLine_MC"+cnt];
		cnt++;
		
		var remmoteLine_MC:MovieClip = drawingarea["remoteL_MC"+textdrawingIndex].createEmptyMovieClip("remmoteLine_MC"+cnt,DepthUtils.getNextDepth());
		
		remmoteLine_MC.lineStyle(thickness, color);
	
		remmoteLine_MC.moveTo(pressX, pressY);
		remmoteLine_MC.lineTo(xmouse,ymouse);
	}
	
	public function stopNewDrawing(xmouse, ymouse){
	//	mx.controls.Alert.show(drawingarea.remoteTemp_MC);
		drawingarea.remoteTemp_MC.clear();
		textdrawingIndex++;
		cnt = 1;
	}
}
