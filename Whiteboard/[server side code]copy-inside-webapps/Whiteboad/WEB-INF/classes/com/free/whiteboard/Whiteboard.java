/*************************************************Whiteboard.java
*This is the main class which gets loaded when red5 server starts-up.
* Also is a entry point for client/server method calling. This class is 
* configured as a spring bean in red5.
*****************************************************************/
package com.free.whiteboard;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;

import com.free.whiteboard.LineDrawing;
import com.free.whiteboard.ArrowDrawing;
import com.free.whiteboard.FreeHandDrawing;
import com.free.whiteboard.ShapeDrawing;
import com.free.whiteboard.TextDrawing;

public class Whiteboard extends ApplicationAdapter
{
	
    /**Variable used for generating logs*/
    private static final Log log = LogFactory.getLog(Whiteboard.class);
        
    
    /*Invoked as soon as the red5 server get started
    @param app, the scope of the application, e.g. room in this case
    @return true/false if application successfully start/not-start*/
    public boolean appStart(IScope app)
    {
    	
    	log.info("AppStart called for : " + app.getName());
    	
    	if (!super.appStart(app))
        {
    	    log.error("Unable to start the application");
            return false;
    	}    
    	
    	/*Now we will create some shared object here
    	 * These shared object will keep all clients
    	 * in sync with each other 
    	 */
    	this.createSharedObject(app,"freehandSO",false);    //Shared object for freehand drawing
    	this.createSharedObject(app,"linedrawingSO",false); //Shared object for line drawing
    	this.createSharedObject(app,"arrowdrawingSO",false);//Shared object for arrow line drawing
	this.createSharedObject(app, "shapedrawingSO", false);//!!Shared object for shape line drawing
	this.createSharedObject(app, "textdrawingSO", false);//!!Shared object for shape line drawing
    	
    	//Object of free hand drawing
    	app.setAttribute("freehand",new FreeHandDrawing(this));
    	
    	//Object of Line Drawing
    	app.setAttribute("linedrawing",new LineDrawing(this));
    	
    	//Object of Arrow Drawing
    	app.setAttribute("arrowdrawing",new ArrowDrawing(this));

    	//!!Object of Shape Drawing
    	app.setAttribute("shapedrawing" , new ShapeDrawing(this));

    	//!!Object of Text Drawing
    	app.setAttribute("textdrawing" , new TextDrawing(this));
    	
    	return true;
    }
	
     /*Invoked as soon as any client connect to red5 server.
     * @param conn, the connection string of the client with red5
     * @param param, an Object array[] passed from client side
     * @return true/false if client successfully connect/not connect 
     */
     public boolean appConnect(IConnection conn, Object[] params)
     {
    	log.info("appConnect called for : " + conn.getScope().getName() );
    	
    	if (!super.appConnect(conn,params))
	{
    		log.error("Unable to connect from " + conn.getScope().getName() + " for the application");
    		return false;
    	}
    	conn.getClient().setAttribute("userid", params[0].toString());   //setting user id
     	return true;
    }
    
     /*Invoked after successfull app connect
     * @param scope, the scope of the room
     * @param client, the reference to hold the client information
     * @return true/false if room successfully join/not join 
     */
      public boolean appJoin(IClient client, IScope scope)
      {
     	 log.info("appJoined Called for client: " + client.getId() + "of scope " + scope.getName());
     	 return true;
      }
      
    /*Invoked as soon first user joins the room(for a particular IScope).
    * @param room, the scope of the room
    * @return true/false if room successfully start/not-started 
    */ 
    public boolean roomStart(IScope room)
    {
    	log.info("RoomStart called for : " + room.getName() );
    	
    	if (!super.roomStart(room))
        {
    		log.error("Unable to start " + room.getName() + " for the application");
    		return false;
    	}
    	return true;
    }
        
    /**@Invoked as soon as any client connect to red5 server.
    *@param conn, the connection string of the client with red5
    *@param param, an Object array[] passed from client side
    *@return true/false if client successfully connect/not connect 
    */
     public boolean roomConnect(IConnection conn, Object[] params)
     {
    	log.info("RoomConnect called for : " + conn.getScope().getName() );
    	
    	if (!super.roomConnect(conn,params))
        {
    		log.error("Unable to connect from " + conn.getScope().getName() + " for the application");
    		return false;
    	}    	
    	return true;
    }

    /**Invoked after successfull room connect.
    *@param scope, the scope of the room
    *@param client, the reference to hold the client information
    *@return true/false if room successfully join/not join 
    */
     public boolean roomJoin(IClient client, IScope scope)
     {
    	 log.info("RoomJoined Called for client: " + client.getId() + "of scope " + scope.getName());
    	 
         return true;
      }
    
    
     /**Called everytime client leave the application scope
     *@param scope, the scope of the application
     *@param client, the reference to hold the client information
     */
     public void appLeave(IClient client,IScope scope)
     {
    	 log.info("AppLeave called for client : " + client.getId() + " of scope " + scope.getName());
     }

     /**Called every time client leaves room scope
     *@param room, the scope of the room
     *@param client, the reference to hold the client information
     */
     public void roomLeave(IClient client,IScope room)
     {
     	log.info("Roomleave Called for : " + client.getId() + " , " + scope.getName());
     }
     
     /**Called when room scope is stopped
     *@param scope, the scope of the room
     */
     public void roomStop(IScope scope)
     {
     	log.info("RoomStop Called for : " + scope.getName());
     }

     /*Called when client disconnect from the application
     *@param conn, the connection of client from the server
     */
     public void roomDisconnect(IConnection conn)
     {
     	log.info("RoomDisconnect Called for : " + conn.getScope().getName());	
     } 
     
      /**Called everytime when client disconnect from the application
      *@param conn, the connection of client from the server
      */
      public void appDisconnect(IConnection conn)
      {
      	log.info("appDisconnect Called for : " + conn.getScope().getName());	
      } 
     
      /*Called when application is stopped
      *@param scope, the scope of the room
      */
     public void appStop(IScope app)
     {
     	log.info("AppStop Called for : " + app.getName());
     }
     
     /**Called when application reject a client due to reasons like duplicate client
     *@param msg, Message string to send to client
     */
     public void rejectClient(String msg)
     {
    	log.info("RejectClient Called for : " + msg);
    	super.rejectClient(msg);	//throws ClientRejectedException internally 	
     }



//////////////////////////////////////////////////////////////////////////////////
     /**Called when a client do the freehand drawing,client
      * sends data to server and server forward this data
      * to other clients connected
      * 
      * @param params, Data string from client
      */
     public void updateFreeHandDrawing(Object[] params)
     {
    	 ((FreeHandDrawing)this.getAttribute("freehand")).doDraw(params);        //calling method
     }
     
     /**Called when a client do the freehand drawing,client
      * sends data to server and server forward this data
      * to other clients connected
      * 
      * @param params, Data string from client
      */
     public void updateLineDrawing(Object[] params)
     {
    	 ((LineDrawing)this.getAttribute("linedrawing")).doDraw(params);        //calling method
     }
	

     //!!
     public void updateShapeDrawing(Object[] params){
    	 ((ShapeDrawing)this.getAttribute("shapedrawing")).doDraw(params);        //calling method
     }
    public void updateTextDrawing(Object[] params){
    	 ((TextDrawing)this.getAttribute("textdrawing")).doDraw(params);        //calling method
     }
     //!!
     public void updateArrowDrawing(Object[] params){
    	 ((ArrowDrawing)this.getAttribute("arrowdrawing")).doDraw(params);        //calling method
     }

}
