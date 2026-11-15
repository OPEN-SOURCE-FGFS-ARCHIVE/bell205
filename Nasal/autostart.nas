var apply_rotorbrake = func(){
  if( getprop( "rotors/main/rpm" ) < 130 ){
    interpolate( "controls/rotor/brake", 1.0, 3.0 );
  }else{
    settimer( apply_rotorbrake, 1.0 );
  }
}#rotorbrake()


var release_starter = func(){
  if( getprop( "rotors/main/rpm" ) > 225 ){
    setprop( "controls/switches/startergen", "false" );
    setprop( "controls/switches/engine/start", "false" );
    settimer( func{ setprop( "controls/switches/battery", "false" ) }, 750 );
    settimer( func{ setprop( "controls/switches/vm", 1 )}, 2.5 );
  }else{
    settimer( release_starter, 1.0 );
  }
}#release_starter()


var autostart = func(){
  if( arg[0] == 1 ){  # startup
#starting engine
    interpolate( "controls/rotor/brake", 0.0, 3.0 );
    setprop( "controls/switches/main_key", "true" );
    setprop( "controls/switches/maingenclutchguard", "true" );
    setprop( "controls/switches/main_gen", "1" );
    setprop( "controls/switches/maingenclutchguard", "false" );
    setprop( "controls/switches/battery", "true" );
    setprop( "controls/switches/invtr", "1" );
    setprop( "controls/switches/engine/clutchguard", "true" );
    setprop( "controls/switches/engine/mainfuel", "true" );
    setprop( "controls/switches/engine/clutchguard", "false" );
    setprop( "controls/switches/engine/start", "true" );
    bell205.start_fuel_ind();
    bell205.engines(1);
    settimer( release_starter, 25.0 );
    #engine runup
    setprop( "controls/switches/hydcont", "true" );
    setprop( "controls/switches/forcetrim", "true" );
    setprop( "controls/switches/main_avionics", "true" );
    setprop( "controls/switches/apx72/master", "1" );              # Transponder
    setprop( "controls/switches/arc51bx/func", "1" );              # UHF comm
    setprop( "controls/switches/arn83/gainswitch", "1" );          # adf
    setprop( "controls/switches/c6533/transmitter", "3" );         # audio panel
    setprop( "controls/switches/r1041/func", 40 );                 # marker beacon
    setprop( "controls/switches/arn82/pwr", 1 );                   # nav comm
    setprop( "controls/switches/anticoll_lights", "true" );
    setprop( "controls/switches/extltsmode", 1 );
    setprop( "controls/switches/arc134/pwr", 1 );                  # VHF comm
    setprop( "controls/switches/arc134_2/pwr", 1 );
    setprop( "controls/switches/apx72/master", "2" );              # transponder
    chronograph.click();
    setprop( "controls/switches/startergen", "true" );
  }else{  # shutdown
    setprop( "controls/switches/startergen", "false" );
    setprop( "controls/avionics/fuel-pump", "false" );
    apply_rotorbrake();
    engines(0);
    setprop( "controls/switches/engine/mainfuel", "false" );
    setprop( "controls/switches/extltsmode", "0" );
    setprop( "controls/switches/main_avionics", "false" );
    setprop( "controls/switches/anticoll_lights", "false" );
    setprop( "controls/switches/main_gen", "0" );
    setprop( "controls/switches/invtr", "0" );
    setprop( "controls/switches/battery", "false" );
    bell205.stop_fuel_ind();
    setprop( "controls/switches/main_key", "false" );
    bell205.serviceable = "false";
    engines(0);
  }
} #autostart()

#
# end of autostart.nas
#
