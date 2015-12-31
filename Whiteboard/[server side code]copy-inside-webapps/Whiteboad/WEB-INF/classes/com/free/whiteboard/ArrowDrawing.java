/****************************************ArrowDrawing.java
*This class will handle all events generated for arrow
* line drawing from client
***********************************************************/

package com.free.whiteboard;



import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.red5.server.api.Red5;
import org.red5.server.api.so.ISharedObject;



public class ArrowDrawing
{
	
    /**Variable used for generating logs*/
    private static final Log log = LogFactory.getLog(ArrowDrawing.class);
   
    /**Variable to hold application adapter reference*/
    private Whiteboard whiteboard;
    
    /**Variable to hold arrow line drawing shared object's key index*/
    private int keyIndex = 0;
    
    public ArrowDrawing()
    {
    }
    
    public ArrowDrawing(Whiteboard whiteboard)
    {
    	this.whiteboard = whiteboard;
    }

    
/////////////////////////This function will upadte the line drawing shared object to update all other clients
    public void doDraw(Object[] params)
    {
    	log.info((new StringBuilder()).append("Received ").append(params.length).append("parameters for arrow Line drawing").toString());
    
    	/* param[0] = mode( drawing or moving ),
    	 * param[1] = arrow type
    	 * param[2] = mouse event mode( 0, 1 , 2..) 
    	 * param[3] = color, 
    	 * param[4] = thickness, 
    	 * param[5] = xmouse, 
    	 * param[6] = ymouse
    	 */
 
    	String clientId = Red5.getConnectionLocal().getClient().getAttribute("userid").toString();
    		
    	log.info((new StringBuilder()).append("The client id for the client is : ").
    				append(clientId).toString());
    		
    	ISharedObject freehandSO = whiteboard.getSharedObject(Red5.getConnectionLocal().getScope(),"arrowdrawingSO");
	
        freehandSO.setAttribute(Integer.toString(keyIndex++), (new StringBuilder()).
	    		append(params[0].toString()).append(":").append(params[1].toString()).
	    		append(":").append(params[2].toString()).append(":").
	    		append(params[3].toString()).append(":").append(params[4].toString()).
	    		append(":").append(params[5].toString()).append(":").append(clientId).toString());
    }
}
