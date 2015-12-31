//!!


package com.free.whiteboard;

import java.util.Iterator;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.red5.server.api.Red5;
import org.red5.server.api.so.ISharedObject;

public class ShapeDrawing {
	/**Variable used for generating logs*/
    private static final Log log = LogFactory.getLog(ShapeDrawing.class);
   
    /**Variable to hold application adapter reference*/
    private Whiteboard whiteboard;
    
    /**Variable to hold line drawing shared object's key index*/
    private int keyIndex = 0;
    
    public ShapeDrawing(){
    	
    }
    
    public ShapeDrawing(Whiteboard whiteboard){
    	this.whiteboard = whiteboard;
    }
    
    /**This function will upadte the freehand drawing
     * shared object to update all other clients
     */
    public void doDraw(Object[] params){
    	log.info((new StringBuilder()).append("Received ").append(params.length).
    			append("parameters for Shape drawing").toString());
    
    	/* param[0] = mode( drawing or moving ),
    	 * param[1] = mouse event mode( 0, 1 , 2..) 
    	 * param[2] = color, 
    	 * param[3] = thickness, 
    	 * param[4] = xmouse, 
    	 * param[5] = ymouse
    	 */
 
    		String clientId = Red5.getConnectionLocal().getClient().getAttribute("userid").toString();
    		
    		log.info((new StringBuilder()).append("The client id for the client is : ").append(clientId).toString());
    		
    		ISharedObject shapedrawingSO = whiteboard.getSharedObject(Red5.getConnectionLocal().getScope(),
    				"shapedrawingSO");
    		Iterator<String> it =  shapedrawingSO.getAttributeNames().iterator();
    		log.info((new StringBuilder()).append("So parame : ").append(shapedrawingSO.getAttributes().size()).toString());
    		while(it.hasNext())
    			log.info((new StringBuilder()).append("co Para : ").append(it.next()));
     		shapedrawingSO.setAttribute(Integer.toString(keyIndex++), (new StringBuilder()).
	    			append(params[0].toString()).append(":").append(params[1].toString()).
	    			append(":").append(params[2].toString()).append(":").
	    			append(params[3].toString()).append(":").append(params[4].toString()).
	    			append(":").append(params[5].toString()).append(":").append(params[6].toString()).append(":")
				.append(params[7].toString()).append(":").append(params[8].toString()).append(":")
				.append(params[9].toString()).append(":").append(params[10].toString()).append(":").append(params[11].toString()).append(":")
				.append(clientId).toString());
    }
}
