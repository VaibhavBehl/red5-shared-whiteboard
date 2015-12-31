//!!

/**ShapeDrawingSO
* This is the class which handles 
* ShapeDrawingSO on whiteboard
* from shared object
*/


import com.free.whiteboard.DepthUtils;
//import com.free.whiteboard.WhiteboardEvents;
import flash.filters.GlowFilter;

class com.free.whiteboard.ShapeDrawingSO{
	
	private var shapeDrawingSO:SharedObject;
	private var shapeDrawingSOIndex:Number =0;

	public static var ref;
	private var cnt:Number =1;
	private var pressX;
	private var pressY;
	
	private var drawingarea;
	
	public function ShapeDrawingSO(){
		ref = this;
	}

	public function addShapeDrawingSO(connect_NC, clientId)
	{
		trace("client id 1== "+ clientId)
		//Get remote shared object reference
		
		shapeDrawingSO = SharedObject.getRemote("shapedrawingSO", connect_NC.uri, false);
		
		trace("I am called");
		shapeDrawingSO.onSync = function(infoList){
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
						trace(drawingData[11] +"=="+ clientId+"\n"+ drawingData[0]+"\n"+
							 drawingData[1]+"\n"+drawingData[2]);
						//_global.whiteboard.participantLists.changeColor(drawingData[12]);	
						if(drawingData[12] == clientId)        //self id
							return;
						
						//triangle
						if(drawingData[11]==0)
						{
							//mx.controls.Alert.show("drawingData[0] " +drawingData[0]);
							if(drawingData[0] == "0"){     //Means drawing a free hand object							
								//mx.controls.Alert.show("drawingData[1] " +drawingData[1]);
								
								if(drawingData[1] == "0"){     //Means mouse press

								//			mx.controls.Alert.show("callingfdsfsd");
									ref.startNewDrawingTriangle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
								else if(drawingData[1] == "1"){ //Means mouse move
									ref.continueDrawingTriangle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
								else if(drawingData[1] == "2"){ //Means mouse release

									ref.stopNewDrawingTriangle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
							}
							else if(drawingData[0] == "1"){  //Means moving a freehand object
							}	
						}//end triangle
						//rect
						else if(drawingData[11]==1)
						{
							//mx.controls.Alert.show("rect");
							if(drawingData[1] == "0"){     //Means mouse press
								ref.startNewDrawingRect(drawingData[2], drawingData[3], 
								drawingData[4], drawingData[5],drawingData[6],
								drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
							}
							else if(drawingData[1] == "1"){ //Means mouse move
								ref.continueDrawingRect(drawingData[2], drawingData[3], 
								drawingData[4], drawingData[5],drawingData[6],
								drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
							}
							else if(drawingData[1] == "2"){ //Means mouse release
								ref.stopNewDrawingRect(drawingData[2], drawingData[3], 
								drawingData[4], drawingData[5],drawingData[6],
								drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
							}
						}
						//circle
						else if(drawingData[11]==2){
							//mx.controls.Alert.show("circle");
							if(drawingData[1] == "0"){     //Means mouse press

									ref.startNewDrawingCircle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
								else if(drawingData[1] == "1"){ //Means mouse move
									ref.continueDrawingCircle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
								else if(drawingData[1] == "2"){ //Means mouse release
									ref.stopNewDrawingCircle(drawingData[2], drawingData[3], 
									drawingData[4], drawingData[5],drawingData[6],
									drawingData[7],drawingData[8],drawingData[9],drawingData[10],drawingData[11]);
								}
						}
						
						trace("calling"+drawingData.length+"  "+id);
						break;
					case "delete":
					break;
				}
			}
			
		};
		shapeDrawingSO.connect(connect_NC);
	}
	
	/**This function will create a new triangle drawing
	* on whiteboard
	*/	
	/*******************************triangle***********************************************/
	public function startNewDrawingTriangle(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		//mx.controls.Alert.show("drawing started");
	
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remoteT_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteT_MC"+shapeDrawingSOIndex,DepthUtils.getNextDepth());
		var remmoteTriangle_MC:MovieClip = remoteT_MC.createEmptyMovieClip("remoteTriangle_MC"+cnt , DepthUtils.getNextDepth());
		var remoteTempTriangle_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTempTriangle_MC", DepthUtils.getNextDepth());
		
		remmoteTriangle_MC.lineStyle(thickness, borderColor);
		_global.whiteboard.evtHandler.movie_ARR.push(remmoteTriangle_MC);
			
		remmoteTriangle_MC.moveTo(xmouse, ymouse);
		pressX = xmouse;
		pressY = ymouse;
		
	}
	
	public function continueDrawingTriangle(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		// Remove any previous drawing
		drawingarea.remoteTempTrianlge_MC.clear();
		(drawingarea["remoteT_MC"+shapeDrawingSOIndex])["remmoteTriangle_MC"+cnt].removeMovieClip();
		delete (drawingarea["remoteT_MC"+shapeDrawingSOIndex])["remmoteTriangle_MC"+cnt];
		cnt++;
		
		var remmoteTriangle_MC:MovieClip = drawingarea["remoteT_MC"+shapeDrawingSOIndex].createEmptyMovieClip("remmoteTriangle_MC"+cnt,DepthUtils.getNextDepth());
		remmoteTriangle_MC.beginFill(color);
		remmoteTriangle_MC.lineStyle(thickness,borderColor, 100);
		remmoteTriangle_MC.moveTo(pressX, pressY);
		remmoteTriangle_MC.lineTo(xmouse, ymouse);
		remmoteTriangle_MC.lineTo(xmouse, pressY);
		remmoteTriangle_MC.lineTo(xmouse, pressY);
		remmoteTriangle_MC.lineTo(pressX, pressY);
		remmoteTriangle_MC.endFill();		
	}
	
	public function stopNewDrawingTriangle(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		drawingarea.remoteTempTriangle_MC.clear();
		shapeDrawingSOIndex++;
		cnt = 1;
	}
	//triangle
	//*****************************end triangle********************************************/	
	/**************************************************************************************/
	/********************************rect**************************************************/	
	//rect
		public function startNewDrawingRect(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		//mx.controls.Alert.show("drawing started");
	
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remoteR_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteR_MC"+shapeDrawingSOIndex,DepthUtils.getNextDepth());
		var remmoteRect_MC:MovieClip = remoteR_MC.createEmptyMovieClip("remoteRect_MC"+cnt , DepthUtils.getNextDepth());
		var remoteTempRect_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTempRect_MC", DepthUtils.getNextDepth());
		
		remmoteRect_MC.lineStyle(thickness, borderColor);
		_global.whiteboard.evtHandler.movie_ARR.push(remmoteRect_MC);
			
		remmoteRect_MC.moveTo(xmouse, ymouse);
		pressX = xmouse;
		pressY = ymouse;
		
	}
	
	public function continueDrawingRect(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		// Remove any previous drawing
		drawingarea.remoteTempRect_MC.clear();
		(drawingarea["remoteR_MC"+shapeDrawingSOIndex])["remmoteRect_MC"+cnt].removeMovieClip();
		delete (drawingarea["remoteR_MC"+shapeDrawingSOIndex])["remmoteRect_MC"+cnt];
		cnt++;
		
		var remmoteRect_MC:MovieClip = drawingarea["remoteR_MC"+shapeDrawingSOIndex].createEmptyMovieClip("remmoteRect_MC"+cnt,DepthUtils.getNextDepth());
		remmoteRect_MC.beginFill(color);
		remmoteRect_MC.lineStyle(thickness,borderColor, 100);
		remmoteRect_MC.moveTo(pressX, pressY);
		remmoteRect_MC.lineTo(xmouse,pressY);
		remmoteRect_MC.lineTo(xmouse, ymouse);
		remmoteRect_MC.lineTo(pressX,ymouse);
		//remmoteLine_MC.moveTo(xmouse, ymouse);
		//remmoteLine_MC.lineTo(xmouse,pressY);
		//remmoteLine_MC.lineTo(pressX,ymouse);
		/*remmoteLine_MC.lineTo(xmouse+(xmouse-pressX)/150,pressY);
		remmoteLine_MC.lineTo(xmouse+(xmouse-pressX)/150,ymouse+(ymouse-pressY)/150);
		remmoteLine_MC.lineTo(pressX, ymouse+(ymouse-pressY)/150);
		remmoteLine_MC.lineTo(pressX,pressY);*/
		remmoteRect_MC.endFill();
	}
	
	public function stopNewDrawingRect(color, thickness,borderColor, xmouse, ymouse,pressX,pressY,radius,YRadius,type){
		drawingarea.remoteTempRect_MC.clear();
		shapeDrawingSOIndex++;
		cnt = 1;
	}
	//end rect
	/*******************************end rect*******************************************/	
	/**********************************************************************************/
	/******************************circle**********************************************/	
	//circle
	public function startNewDrawingCircle(color, thickness,borderColor, xmouse, 
										  ymouse,pressX,pressY,radius,YRadius,type){
		//mx.controls.Alert.show("drawing started");		
//		mx.controls.Alert.show("thicksness : " + thickness + " color : " + color );
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remoteC_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteC_MC"+shapeDrawingSOIndex,DepthUtils.getNextDepth());
		var remmoteCircle_MC:MovieClip = remoteC_MC.createEmptyMovieClip("remoteCircle_MC"+cnt , DepthUtils.getNextDepth());
		var remoteTempCircle_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTempCircle_MC", DepthUtils.getNextDepth());
		
		//remmoteLine_MC.lineStyle(thickness, borderColor);
		_global.whiteboard.evtHandler.movie_ARR.push(remmoteCircle_MC);
			
		//remmoteLine_MC.moveTo(xmouse, ymouse);
		//pressX = xmouse;
		//pressY = ymouse;

		this.circle(remmoteCircle_MC,xmouse,ymouse,pressX,pressY,thickness,borderColor,color);
	
	}
	
	public function continueDrawingCircle(color, thickness,borderColor, xmouse, 
										  ymouse,pressX,pressY,radius,YRadius,type){
		//mx.controls.Alert.show("xmouse " +xmouse+"ymouse " +ymouse+"pressX " +pressX+"pressY "+ pressY);		
		// Remove any previous drawing
		drawingarea.remoteTempCircle_MC.clear();
		(drawingarea["remoteC_MC"+shapeDrawingSOIndex])["remmoteCircle_MC"+cnt].removeMovieClip();
		delete (drawingarea["remoteC_MC"+shapeDrawingSOIndex])["remmoteCircle_MC"+cnt];
		cnt++;					
		var remmoteCircle_MC:MovieClip = drawingarea["remoteC_MC"+shapeDrawingSOIndex].createEmptyMovieClip("remmoteCircle_MC"+cnt,DepthUtils.getNextDepth());
		this.circle(remmoteCircle_MC,xmouse,ymouse,pressX,pressY,thickness,borderColor,color)		

	}
	
	public function stopNewDrawingCircle(color, thickness,borderColor, xmouse, 
										  ymouse,pressX,pressY,radius,YRadius,type){
				
		drawingarea.remoteTempCircle_MC.clear();
		shapeDrawingSOIndex++;		
		var remmoteCircle_MC:MovieClip = drawingarea["remoteC_MC"+shapeDrawingSOIndex].createEmptyMovieClip("remmoteCircle_MC"+cnt,DepthUtils.getNextDepth());
		
		this.circle(remmoteCircle_MC,xmouse,ymouse,pressX,pressY,thickness,borderColor,color)				
		
		cnt = 1;
	}
	
	public function circle(draw_MC:MovieClip,xmouse,ymouse,pressX,pressY
						   ,borderThick,borderColor,fillColor) {
		MovieClip.prototype.drawCircle = function(xTemp, yTemp, radius, yRadius) {
			var TO_RADIANS:Number = Math.PI/180;
   			// begin circle at 0, 0 (its registration point) -- move it when done
			this.moveTo(radius, 0);
		   // draw 12 30-degree segments 
		   // (could do more efficiently with 8 45-degree segments)
			 var a:Number = 0.268;  // tan(15)
			for (var i=0; i < 12; i++) {
			  var endx = radius*Math.cos((i+1)*30*TO_RADIANS);
			  var endy = radius*Math.sin((i+1)*30*TO_RADIANS);
			  var ax = endx+radius*a*Math.cos(((i+1)*30-90)*TO_RADIANS);
			  var ay = endy+radius*a*Math.sin(((i+1)*30-90)*TO_RADIANS);
			  this.curveTo(ax, ay, endx, endy);	
			}
			this._x = xTemp;
	        this._y = yTemp;   				
		};
		
		draw_MC.clear();
		draw_MC.lineStyle(borderThick,borderColor);
		draw_MC.beginFill(fillColor,50);
		var dx = xmouse - pressX;
		var dy = ymouse - pressY;
		var radius = Math.sqrt((dx*dx)+(dy*dy));
	//	trace("radius is "+ radius+":"+dx+":"+dy);
		draw_MC.drawCircle(pressX, pressY, radius, radius);
		draw_MC.endFill();
		updateAfterEvent();
	}
	
	//end circle
	/*******************************end circle******************************************/	
}
