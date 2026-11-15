# fuel
# JP-4  (densitiy = 0.775 KG/dm^3)

#var FUEL_DENSITY = getprop("/consumables/fuel/tank/density-ppg"); # pound per gallon
#var GAL2LB = FUEL_DENSITY;
#var LB2GAL = 1 / GAL2LB;
#var KG2GAL = KG2LB * LB2GAL;
#var GAL2KG = 1 / KG2GAL;

var torque_pct = props.globals.getNode("sim/model/bell205/torque-pct", 1);
var fuel_lbs = props.globals.getNode("consumables/fuel/tank/level-lbs", 1 );
var fuel_consumption = props.globals.initNode( "consumables/fuel/tank/consumption", 0.0 );
var LBS_H = 17.5/366000;      # normal cruise power fuel consumption
var serviceable = "false";
var min_fuel = 150;
var act_fuel = getprop( "/consumables/fuel/tank/level-lbs" );
var old_fuel = act_fuel;
var fuel_boost = 0.0;
var listener_id = 0;

var update_fuel = func{
  var tq = torque_pct.getValue();
  if( tq==nil )
    tq=0.0;
  else if( tq<0 )
    tq=0.0;
  if( getprop( "/systems/electrical/outputs/start_fuel_pump" ) ){
    fuel_boost = 2.0;
  }else{
    fuel_boost = 1.0;
  }
  tq /= 3.16;
  var csp = LBS_H*tq*fuel_boost;
  fuel_consumption.setValue( csp );
  fuel_lbs.setValue( fuel_lbs.getValue()-csp );

  old_fuel = act_fuel;
  act_fuel = getprop( "/consumables/fuel/tank/level-lbs" );
  if( (act_fuel<min_fuel) and (old_fuel>=min_fuel) ){
    bell205.set_alarm( 1 );
    setprop( "/controls/switches/warn/fuel_low_level", "true" );
  }else{
    if( act_fuel>=min_fuel and old_fuel<min_fuel ){
      bell205.set_alarm( 0 );
      setprop( "/controls/switches/warn/fuel_low_level", "false" );
    }
  }

  if( serviceable=="true" and getprop( "/systems/electrical/outputs/fuel_indicator" ) ){
    interpolate( "/consumables/fuel/tank/ind_fuel_qty", act_fuel, 0.1 );
  }
  settimer( update_fuel, 0.25 );
} #update_fuel()



var start_fuel_ind = func{
  interpolate( "/consumables/fuel/tank/ind_fuel_qty", getprop( "consumables/fuel/tank/level-lbs" ), 1.5 );
  old_fuel = getprop( "/consumables/fuel/tank/level-lbs" );
  act_fuel = old_fuel;
  settimer( func{ serviceable = "true" }, 1.6 );
  settimer( func{ update_fuel() }, 1.6 );
} #start_fuel_ind()
bell205.start_fuel_ind();


var stop_fuel_ind = func{
  serviceable = "false";
  interpolate( "/consumables/fuel/tank/ind_fuel_qty", 0.0, 1.5 );
} #stop_fuel_ind()

setlistener( "/systems/electrical/outputs/fuel_indicator", func{
  if( getprop( "/systems/electrical/outputs/fuel_indicator" ) ){
    start_fuel_ind();
  }else{
    stop_fuel_ind();
  }
}, 1, 0 );


var fuel_indicator_test = func( b ){
  if( !getprop( "/systems/electrical/outputs/fuel_indicator" ) ){
    return;
  }
  if( b ){
    serviceable = "false";
    interpolate( "/consumables/fuel/tank/ind_fuel_qty", 0.0, 1.5 );
  }else{
    interpolate( "/consumables/fuel/tank/ind_fuel_qty", getprop( "/consumables/fuel/tank/level-lbs" ), 1.5 );
    settimer( func{ serviceable = "true" }, 1.6 );
  }
} #fuel_indicator_test()



var engine_listener_id = 0;

var start_engine = func(){
  if( engine_listener_id == 0 and
      getprop( "/systems/electrical/outputs/starter" ) and
      getprop( "/systems/electrical/outputs/fuel_pump" ) and
      getprop( "/systems/electrical/outputs/start_fuel_pump" ) ){
    engine_listener_id = setlistener( "/systems/electrical/outputs/fuel_pump", func{ stop_engine() }, 1, 0 );
    engines( 1 );
  }
} # start_engine


var stop_engine = func(){
  if( !getprop( "/systems/electrical/outputs/fuel_pump" ) ){
    removelistener( engine_listener_id );
    engine_listener_id = 0;
    engines( 0 );
  }
} # stop_engine


starter_listener_id = setlistener( "/systems/electrical/outputs/starter", func{ start_engine() }, 0, 0 );

####################################
###### new engine/fuel system ######
####################################


##### fuel pumps ###################
#var fuel_press = 0;
#setlistener( "systems/electrical/outputs/fuel_pump", func{
#  if( getprop( "systems/electrical/outputs/fuel_pump" ) ){
#    interpolate( fuel_press, 1.0, 1.5 );
#  }else{
#    interpolate( fuel_press, 0.0, 1.5 );
#  }
#}, 0, 0 );
#
#var start_fuel_press = 0;
#setlistener( "systems/electrical/outputs/start_fuel_pump", func{
#  if( getprop( "systems/electrical/outputs/start_fuel_pump" ) ){
#    interpolate( start_fuel_press, 1.0, 1.0 );
#  }else{
#    interpolate( start_fuel_press, 0.0, 1.0 );
#  }
#}, 0, 0 );


##### engine starter ###############
#var starter_running = 0;
#setlistener( "controls/switches/starter", func{
#  if( getprop( "systems/electrical/outputs/starter" ) ){
#    starter_running = 1;    
#  }else{
#    starter_running = 0;
#  }
#}, 0, 0 );

