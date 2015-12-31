red5-shared-whiteboard
======================

Interactive multi-user Whiteboard application using Flash (client end) and Red5 Media Server (server end), 
with support for basic drwaing tools for interation.

I picked up this code from google code projects-
red5-shared-whiteboard (http://code.google.com/p/red5-shared-whiteboard/) and 
new-red5-shared-whiteboard (http://code.google.com/p/red5-shared-whiteboard/),

did some Modifications: support for shape+text+object added on drawing board, and

Corrections: server ip was 192.x.x.x, should be localhost for test environment,
some param[] didn't match and so o/p kept coming wrong/none.


Running Application
-------------------

1) Stop any existing instances of red5 server and Download red 5-0.7., 
DONT modify any files or change any conf. using ant/eclipse !!

2)copy folder 'copy-inside-webapps/Whiteboard' inside 'red5-0.7.0/webapps' directory.
You may start the red5 server now and check the page http://localhost:5080/Whiteboard/Whiteboard.html
NOTE- to compile .java u need libraries in your
classpath:
-commons-logging-1.1.1.jar,
-red5_0.6.3_java6.jar,
-spring-core-2.5.6.jar

3) CLIENT SIDE- in ActionScript 2.0,
here i am using flash 8(very old version) to compile .fla->.swf 
and 'WhiteboardEvent.as' contains the remote connection ip, which is by default 'localhost'.

NOTE: as usual i worked on this project wayyy back (as you can see it uses AS 2.0/Flash 8.. DUHH),
so i won't be of much help if anything breaks, last time i ran this it worked like a charm,
i was using Ubuntu 10.04 for my server environment, and Red5 server version 5.0.7 (other version weren't working for me),


Code license
------------
This code was originally hosted under - GNU GPL v2, and so any derivatices including this fall under this license.
