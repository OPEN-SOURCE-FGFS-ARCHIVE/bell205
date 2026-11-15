var counter = 0;
var rpm_alarm = "false";


var update_sounder = func(){
  if( (rpm_alarm != "false"
                and getprop( "/controls/switches/lowrpmaudio" )>0
                and getprop( "/controls/switches/engine/mainfuel" )>0)
       or counter ){
    setprop( "/controls/switches/sounds/sounder", "true" );
  }else{
    setprop( "/controls/switches/sounds/sounder", "false" );
  }
} #update_sounder()

setlistener( "controls/switches/lowrpmaudio", func{ update_sounder(); } );


var set_alarm = func( i ){
  if( i ){
    counter+=1;
  }else{
    counter-=1;
    if( counter<0 ){
      counter=0;
    }
  }

  if( counter ){
    setprop( "/controls/switches/master_caution", "true" );
    update_sounder();
  }else{ #counter==0
    setprop( "/controls/switches/master_caution", "false" );
    update_sounder();
  }
} #set_alarm()


var set_rpm_alarm = func{
  var rpm = getprop( "rotors/main/rpm" );
  if( getprop( "/controls/switches/lowrpmaudio" ) ){
    if( rpm<=300 ){
      rpm_alarm = "true";
    }else{
      rpm_alarm = "false";
    }
    update_sounder();
  }
} #set_rpm_alarm()
setlistener( props.globals.getNode( "rotors/main/rpm" ), func{ set_rpm_alarm(); } );


var switch_warns = func( i ){
  setprop( "/controls/switches/warn/dc_generator", i );
  setprop( "/controls/switches/warn/door_lock", i );
  setprop( "/controls/switches/warn/eng_fuel_pump", i );
  setprop( "/controls/switches/warn/eng_oil_filter", i );
  setprop( "/controls/switches/warn/engine_ice_det", i );
  setprop( "/controls/switches/warn/engine_icing", i );
  setprop( "/controls/switches/warn/engine_deice_on", i );
  setprop( "/controls/switches/warn/engine_oil_press", i );
  setprop( "/controls/switches/warn/fuel_boost_left", i );
  setprop( "/controls/switches/warn/fuel_boost_right", i );
  setprop( "/controls/switches/warn/fuel_filter", i );
  setprop( "/controls/switches/warn/fuel_low_level", i );
  setprop( "/controls/switches/warn/gov_emer", i );
  setprop( "/controls/switches/warn/hyd1_pressure", i );
  setprop( "/controls/switches/warn/hyd2_pressure", i );
  setprop( "/controls/switches/warn/inst_inverter", i );
  setprop( "/controls/switches/warn/spare", i );
  setprop( "/controls/switches/warn/xmsn_oil_hot", i );
  setprop( "/controls/switches/warn/xmsn_oil_press", i );
  setprop( "/controls/switches/master_caution", i );
  setprop( "/controls/switches/sounds/sounder", i );
} # switch_warns()
