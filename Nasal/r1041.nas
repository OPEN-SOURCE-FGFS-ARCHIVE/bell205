var switch_pwr_btn = func(){
  setprop( "instrumentation/marker-beacon/power-btn",
           getprop( "systems/electrical/outputs/marker_beacon" )==0 ? "false" : "true" );
} #switch_pwr_btn()


var adjust_volume = func(){
  setprop( "instrumentation/marker-beacon/volume", ( getprop( "controls/switches/r1041/func" )/100 ) );
} #adjust_volume()


if( getprop( "sim/aircraft" )=="uh1" ){
  adjust_volume();
  setlistener( "systems/electrical/outputs/marker_beacon", func{ switch_pwr_btn() } );
  setlistener( "controls/switches/r1041/func", func{ adjust_volume() } );
}