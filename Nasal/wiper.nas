var pause = 0.1;
var speed = 0;
var side = 0;
var action = 0;
var pausemapping = {1:6.0, 2:0.1, 3:0.1};
var speedmapping = {0:0.0, 1:1.0, 2:1.0, 3:0.5};

var mover = func{
  if( speed > 0){
    side = getprop( "controls/wiper/side" );
    if( getprop( "controls/wiper/posp" )==0 and action and side<=0){
      interpolate( "controls/wiper/posp", 90, speed, 0, speed );
    }
    if( getprop( "controls/wiper/poscp" )==0 and action and side>=0 ){
      interpolate( "controls/wiper/poscp", 90, speed, 0, speed );
    }
    if( action ){
      settimer( mover, pause );
    }else{
      action = 0;
    }
  }else if( speed == -1 ){
    interpolate( "controls/wiper/posp", 90, 1 );
    interpolate( "controls/wiper/poscp", 90, 1 );
  }else{  #speed==0
    interpolate( "controls/wiper/posp", 0, 1 );
    interpolate( "controls/wiper/poscp", 0, 1 );
  }
} #mover()

var wiperlistener = func{
  var a = getprop( "controls/wiper/speed" );
  if( a == -1 ){
   speed = -1;
  }else{
    action = !a ? 0 : 1;
    pause = pausemapping[a];
    speed = speedmapping[a];
  }
  mover();
} #wipermover()

setlistener( "controls/wiper/speed", func{bell205.wiperlistener() } );
