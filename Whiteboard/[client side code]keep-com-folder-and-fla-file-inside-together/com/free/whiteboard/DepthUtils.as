/**********************************DepthUtils.as 
* This is the class which handles the
* depth of different components in flash
* client
************************************************/




class com.free.whiteboard.DepthUtils{

	private static var depth = 0;
	
	public function DepthUtils(){
		
	}
	
	public static function getNextDepth():Number{
		depth = depth + 1;
		return depth; 	
	}
	
	public function setMaxDepth():Number{
		return 999999;
	}
}
