/**************************************FreeHandDrawing.java
This class will handle all events generated for free hand drawing from client
**********************************************************/

package com.free.whiteboard;



import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.red5.server.api.Red5;
import org.red5.server.api.so.ISharedObject;

public class FreeHandDrawing
{
	
    /**Variable used for generating logs*/
    private static final Log log = LogFactory.getLog(FreeHandDrawing.class);
   
    /**Variable to hold application adapter reference*/
    private Whiteboard whiteboard;
    
    /**Variable to hold freehand drawing shared object's key index*/
    private int keyIndex = 0;
    
    public FreeHandDrawing()
    {
    }
    
    public FreeHandDrawing(Whiteboard whiteboard)
    {
    	this.whiteboard = whiteboard;
    }
    

/////////////////////This function will upadte the freehand drawing shared object to update all other clients
    public void doDraw(Object[] params)
    {
    	log.info((new StringBuilder()).append("Received ").append(params.length).
    			append("parameters for free hand drawing").toString());
    
    	/* param[0] = mode( drawing or moving ),
    	 * param[1] = mouse event mode( 0, 1 , 2..) 
    	 * param[2] = color, 
    	 * param[3] = thickness, 
    	 * param[4] = xmouse, 
    	 * param[5] = ymouse
    	 */
        String clientId = Red5.getConnectionLocal().getClient().getAttribute("userid").toString();
    	 
        log.info((new StringBuilder()).append("The client id for the client is : ").append(clientId).toString());
    		
    	ISharedObject freehandSO = whiteboard.getSharedObject(Red5.getConnectionLocal().getScope(), "freehandSO");
	freehandSO.setAttribute(Integer.toString(keyIndex++), (new StringBuilder()).
	    		append(params[0].toString()).append(":").append(params[1].toString()).
	    		append(":").append(params[2].toString()).append(":").
	    		append(params[3].toString()).append(":").append(params[4].toString()).
	    		append(":").append(params[5].toString()).append(":").append(clientId).toString());
    }
}
