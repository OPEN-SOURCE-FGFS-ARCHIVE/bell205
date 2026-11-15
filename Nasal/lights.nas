var lightpath    = "lighting/";
var strobeswitch = "systems/electrical/outputs/anticoll_lights"; #/sim/multiplay/generic/int[4]
var modeswitch   = "controls/switches/extltsmode";            #/sim/multiplay/generic/float[17]
var beaconswitch = "systems/electrical/outputs/nav_lights";      #/sim/multiplay/generic/int[6]


### BEACON ###
var beacon = nil;
if( beaconswitch!=nil ){
#  props.globals.initNode( beaconswitch, 1, "BOOL" );
  beacon = aircraft.light.new( lightpath~"beacon", [0.85, 0.85], beaconswitch );

  setlistener( modeswitch, func(){
    var bmode = props.globals.getNode( modeswitch ).getValue();
    if( bmode == -1.0 ){
      beacon.blink();
    }else if( bmode == 1.0 ){
      beacon.cont();
    }else{  # bmode == 0.0
      beacon.switch( 0 );
    }
  }, 1, 0 );
}


### STROBE ###
var strobe = nil;
var strobe2 = nil;
if( strobeswitch!=nil ){
  strobe =  aircraft.light.new( lightpath~"strobe-state",  [0.05, 1.00], strobeswitch );
  strobe2 = aircraft.light.new( lightpath~"strobe-state2", [0.05, 1.05], strobeswitch );
}


### center searchlight ###
var center_searchlight = func{
  interpolate( "instrumentation/searchlight/elevation-deg", 0, 2.0 );
  interpolate( "instrumentation/searchlight/heading-deg", 0, 2.0 );
};

print( "Bell205 lights initialized" );
