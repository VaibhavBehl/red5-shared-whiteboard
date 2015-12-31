/*********************************LineDrawingSO.as 
* This class handles 
* line drawing on whiteboard
* from shared object
*************************************************/






import com.free.whiteboard.DepthUtils;
//import com.free.whiteboard.WhiteboardEvents;

class com.free.whiteboard.LineDrawingSO
{	
	private var linedrawingSO:SharedObject;
	private var linedrawingIndex:Number =0;
	public static var ref;
	private var cnt:Number =1;
	private var pressX;
	private var pressY;
	
	private var drawingarea;
	
	public function LineDrawingSO()
	{
		ref = this;
	}
	
////////////////////////////////////////////////This function will add a line drawing shared object with this 
////////////////////////////////////////////////////////client to get line drawing events from other clients.
	public function addLineDrawingSO(connect_NC, clientId)
	{
		//Get remote shared object reference
		linedrawingSO = SharedObject.getRemote("linedrawingSO", connect_NC.uri, false);
		linedrawingSO.onSync = function(infoList)
		{			
			var sortedlist:Array = new Array();
			
			for(var t=0;t<infoList.length;t++)
			{
				var sname = Number(infoList[t].name);
				var scode = infoList[t].code;
				sortedlist.push({name:sname, code:scode});
			}	
			
			sortedlist.sortOn("name",Array.NUMERIC);

			for(var i = 0; i<sortedlist.length;i++)
			{				
				var info = sortedlist[i];
				switch(info.code)
				{
					case "change":						
						var id = info.name;
						var drawing = this.data[id];
						var drawingData:Array = drawing.split(":");

						if(drawingData[6] == clientId)        //self id
							return;

						if(drawingData[0] == "0")//Means drawing a free hand object
						{     
							
							if(drawingData[1] == "0")//Means mouse press
							{     
								ref.startNewDrawing(drawingData[2], drawingData[3],drawingData[4], drawingData[5]);
								
							}
							else if(drawingData[1] == "1")//Means mouse move
							{ 
								ref.continueDrawing(drawingData[2], drawingData[3],drawingData[4], drawingData[5]);
							}
							else if(drawingData[1] == "2")//Means mouse release
							{ 
								ref.stopNewDrawing(drawingData[4], drawingData[5]);
							}
						}
						else if(drawingData[0] == "1")//Means moving a freehand object
						{  
						
						}	
						break;
					case "delete":
						break;
				}
			}
			
		};
		linedrawingSO.connect(connect_NC);
	}
	
///////////////////////////////////////////////This function will create a new freehand drawing on whiteboard
	public function startNewDrawing(color, thickness, xmouse, ymouse)
	{	
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remoteL_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteL_MC"+linedrawingIndex,DepthUtils.getNextDepth());
		var remmoteLine_MC:MovieClip = remoteL_MC.createEmptyMovieClip("remoteLine_MC"+cnt , DepthUtils.getNextDepth());
		var remoteTemp_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTemp_MC", DepthUtils.getNextDepth());
		
		remmoteLine_MC.lineStyle(thickness, color);
		_global.whiteboard.evtHandler.movie_ARR.push(remmoteLine_MC);
			
		remmoteLine_MC.moveTo(xmouse, ymouse);
		pressX = xmouse;
		pressY = ymouse;
	}
	
	public function continueDrawing(color, thickness, xmouse, ymouse)
	{
		// Remove any previous drawing
		drawingarea.remoteTemp_MC.clear();
		// Draw dot at End Point
		drawingarea.remoteTemp_MC.lineStyle(10, 0x00ff00);
		drawingarea.remoteTemp_MC.moveTo(xmouse, ymouse);
		drawingarea.remoteTemp_MC.lineTo(xmouse, ymouse);
		// Draw line segment
		
		(drawingarea["remoteL_MC"+linedrawingIndex])["remmoteLine_MC"+cnt].removeMovieClip();
		delete (drawingarea["remoteL_MC"+linedrawingIndex])["remmoteLine_MC"+cnt];
		cnt++;
		
		var remmoteLine_MC:MovieClip = drawingarea["remoteL_MC"+linedrawingIndex].createEmptyMovieClip("remmoteLine_MC"+cnt,DepthUtils.getNextDepth());
		
		remmoteLine_MC.lineStyle(thickness, color);
	
		remmoteLine_MC.moveTo(pressX, pressY);
		remmoteLine_MC.lineTo(xmouse,ymouse);
	}
	
	public function stopNewDrawing(xmouse, ymouse)
	{
		drawingarea.remoteTemp_MC.clear();
		linedrawingIndex++;
		cnt = 1;
	}
}
