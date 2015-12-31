/*****************************************FreeHandSO.as
* This is the class which handles 
* free hand drawing on whiteboard
* from shared object
* 
* 
******************************************************/







import com.free.whiteboard.DepthUtils;
//import com.free.whiteboard.WhiteboardEvents;

class com.free.whiteboard.FreeHandSO
{	
	private var freehandSO:SharedObject;
	private var freehandIndex:Number =0;
	public static var ref;
	
	private var drawingarea;
	
	public function FreeHandSO()
	{
		ref = this;
	}
	
////////This function will add a freehand drawing shared object with this client to get freehand drawing events from other clients
	public function addFreeHandSO(connect_NC, clientId)
	{
		trace("client id 1== "+ clientId)
		//Get remote shared object reference
		freehandSO = SharedObject.getRemote("freehandSO", connect_NC.uri, false);
		
		trace("I am called");
		freehandSO.onSync = function(infoList)
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
								ref.continueDrawing(drawingData[4], drawingData[5]);
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
		freehandSO.connect(connect_NC);
	}
	
///////////////////////////////////////////////This function will create a new freehand drawing on whiteboard
	public function startNewDrawing(color, thickness, xmouse, ymouse)
	{	
		drawingarea = _global.whiteboard.whiteboard_MC.drawingarea_MC; //main drawboard
		
		var remmoteDraw_MC:MovieClip = drawingarea.createEmptyMovieClip("remoteDraw_MC"+freehandIndex , DepthUtils.getNextDepth());
		var remoteTemp_MC:MovieClip=drawingarea.createEmptyMovieClip("remoteTemp_MC", DepthUtils.getNextDepth());
		
		remmoteDraw_MC.lineStyle(thickness, color);
		_global.whiteboard.evtHandler.movie_ARR.push(remmoteDraw_MC);
			
		remmoteDraw_MC.moveTo(xmouse, ymouse);
	}
	
	public function continueDrawing(xmouse, ymouse)
	{
		// Remove any previous drawing
		drawingarea.remoteTemp_MC.clear();
		// Draw dot at End Point
		drawingarea.remoteTemp_MC.lineStyle(10, 0x00ff00);
		drawingarea.remoteTemp_MC.moveTo(xmouse, ymouse);
		drawingarea.remoteTemp_MC.lineTo(xmouse, ymouse);
		// Draw line segment
		drawingarea["remoteDraw_MC"+freehandIndex].lineTo(xmouse , ymouse);
	}
	
	public function stopNewDrawing(xmouse, ymouse)
	{
		drawingarea.remoteTemp_MC.clear();
		freehandIndex++;
	}
}
