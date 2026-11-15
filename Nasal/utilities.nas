#var switch_avionics = func(){
#  var x=getprop( "controls/switches/main_avionics" );
##  setprop( "instrumentation/heading-indicator/serviceable", x );
#} #switch_avionics()
#setlistener( "systems/electrical/outputs/bus_avionics", func{ switch_avionics() } );
#setlistener( "controls/switches/master_avionics", func{ switch_avionics() } );


var switch_attd_pilot = func(){
  setprop( "instrumentation/attitude-indicator/serviceable",
           getprop( "controls/switches/main_avionics" ) and
           getprop( "controls/circuit_breaker/attd_pilot_1" ) and
           getprop( "controls/circuit_breaker/attd_pilot_2" ) );
} # switch_attd_pilot()
setlistener( "controls/switches/main_avionics", func{ switch_attd_pilot() } );
setlistener( "controls/circuit_breaker/attd_pilot_1", func{ switch_attd_pilot() } );
setlistener( "controls/circuit_breaker/attd_pilot_2", func{ switch_attd_pilot() } );



var switch_gyro_comp = func(){
  setprop( "instrumentation/magnetic-compass/serviceable", getprop( "systems/electrical/outputs/gyro_comp" ) );
} # switch_gyro_comp()
setlistener( "systems/electrical/outputs/gyro_comp", func{ switch_gyro_comp() } );



var switch_turn_ind = func{
  setprop( "instrumentation/turn-indicator/serviceable", getprop( "systems/electrical/outputs/turn_slip_ind" ) );
} # switch_turn_ind()
setlistener( "systems/electrical/outputs/turn_slip_ind", func{ switch_turn_ind() } );



var switch_vsi = func(){
  setprop( "instrumentation/vertical-speed-indicator/serviceable", getprop( "systems/electrical/outputs/vsi" ) );
} # switch_vsi()
setlistener( "systems/electrical/outputs/vsi", func{ switch_vsi() } );



var switch_invtr = func(){
  var x = getprop( "controls/switches/invtr" );
  setprop( "controls/switches/main_invtr", x>0 ? "true" : "false" );
  setprop( "controls/switches/spare_invtr", x<0 ? "true" : "false" );
} # switch_invtr()
setlistener( "controls/switches/invtr", func{ switch_invtr() } );
