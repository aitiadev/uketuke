


// version - 02

// import librarys
import processing.serial.*;

import ddf.minim.*;


import com.skype.*;
import com.skype.Profile.Status;
import java.text.SimpleDateFormat;


// vars for serial com
final static boolean arduinoInUse = true; 
Serial port;
//String portname = "COM4";  // windows
int baudrate = 9600;  

AudioPlayer player;
Minim minim;


void setup() {

  size(640, 480);
  background(255);

  minim = new Minim(this);
  player = minim.loadFile("sound.wav", 2048);


  if (arduinoInUse) {
    println(Serial.list());
    //port = new Serial(this, portname, baudrate); 	// windows
    port = new Serial(this, Serial.list()[0], baudrate);  
    println(port);
  }
  // set up skype
  Skype.setDeamon(false); // to prevent exiting from this program
  try {
    Skype.setDebug(false);
  } 
  catch (SkypeException e) {
    e.printStackTrace();
  }

  testCallUser("aitia.macpro");
}	



public void draw()
{

  textSize(64);

  if (mousePressed == true) { 
    background(0);
    fill(255);
    text("calling", 100, 200);
    CallUser("aitia.macpro", port);
  } else { 
    background(255);
    fill(0);
    text("click here", 100, 200);
  } 


  while (port.available ()>0) {

    if (port.read()=='H') {
      CallUser("aitia.macpro", port);
      //   stalkAFriend("live:madly_cappin");
    }
  }

  // sleep for a while, because there is nothing to do
  try {
    Thread.sleep(1);
  } 
  catch (InterruptedException e) {
    e.printStackTrace();
  }
}


public void CallUser(String _friend, Serial comm) {
  // like allways some try and catch   
  try {
    // check if the friend is in your contact list
    ContactList	c = Skype.getContactList();
    Friend f = c.getFriend(_friend);

    if (f!=null) {
      player.rewind();
      player.play();
      Call call = Skype.call(_friend);
      
      if (call==null) {
        while (call==null) {
          call=Skype.call(_friend);
          Thread.sleep(2000);
        }
      }
      
      boolean closeflag=false;
      int elapsedtime=0;
      int routingtime=0;
      // whait 2 secs
      // enum currentStatus = call.getStatus();
      comm.write("S");
      while (true) {
        Thread.sleep(1000);
        //  currentStatus = call.getStatus();

        println(call.getStatus());
        switch(call.getStatus()) {

          case ROUTING:
          routingtime++;
          break;
          
        case RINGING:
          elapsedtime++;
          comm.write("R");
          break;   

        case INPROGRESS:
          comm.write("P");
          break;

        case FINISHED:
        case REFUSED:
        case FAILED:
        case MISSED:
          comm.write("F");
          closeflag=true;
          break;
        }

        if (port.read()=='H') {
          call.finish();
          comm.write("F");
          break;
          //   stalkAFriend("live:madly_cappin");
        }
        if (closeflag==true) {
          break;
        }
        if (elapsedtime>30) {
          comm.write("F");
          call.finish();
          break;
        }
      }

      // end call
      //call.finish();
    } else {
      System.out.println("/p error -> no friend to call named: " + _friend);
    }
  } 
  catch (SkypeException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } 
  catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}

public void testCallUser(String _friend) {
  // like allways some try and catch   
  try {
    // check if the friend is in your contact list
    ContactList	c = Skype.getContactList();
    Friend f = c.getFriend(_friend);

    if (f!=null) {
      Call call = Skype.call(_friend);
      // whait 2 secs

      Thread.sleep(2000);
      // end call
      call.finish();
    } else {
      System.out.println("/p error -> no friend to call named: " + _friend);
    }
  } 
  catch (SkypeException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  } 
  catch (InterruptedException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
  }
}







