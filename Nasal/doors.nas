# doors ============================================================
leftFrontDoor  = aircraft.door.new("/sim/model/bell205/door-positions/leftFrontDoor", 2, 0 );
rightFrontDoor = aircraft.door.new("/sim/model/bell205/door-positions/rightFrontDoor", 2, 0 );
leftSideDoor   = aircraft.door.new("/sim/model/bell205/door-positions/leftSideDoor", 2, 0 );
rightSideDoor  = aircraft.door.new("/sim/model/bell205/door-positions/rightSideDoor", 2, 0 );
leftSlideDoor  = aircraft.door.new("/sim/model/bell205/door-positions/leftSlideDoor", 4, 0 );
rightSlideDoor = aircraft.door.new("/sim/model/bell205/door-positions/rightSlideDoor", 4, 0 );


var door_status = "false";
var old_door_status = "false";

var check_doors = func(){
  door_status = getprop( "/sim/model/bell205/door-positions/leftFrontDoor/position-norm"  )>0.0 or
                getprop( "/sim/model/bell205/door-positions/rightFrontDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/leftSideDoor/position-norm"   )>0.0 or
                getprop( "/sim/model/bell205/door-positions/rightSideDoor/position-norm"  )>0.0 or
               (getprop( "/sim/model/bell205/door-positions/leftSlideDoor/position-norm"  )>0.0 and
                       getprop( "/sim/model/bell205/door-positions/leftSlideDoor/position-norm"  )<1.0 )or
               (getprop( "/sim/model/bell205/door-positions/rightSlideDoor/position-norm" )>0.0 and
                       getprop( "/sim/model/bell205/door-positions/rightSlideDoor/position-norm" )<1.0 );
#print( "door_status == ", door_status, "     old_door_status == ", old_door_status );

  if( getprop( "systems/electrical/outputs/door_egt_ind" ) ){
    if( door_status and !old_door_status ){
      bell205.set_alarm( 1 );
      setprop( "controls/switches/warn/door_lock", "true" );
    }else if( !door_status and old_door_status ){
      bell205.set_alarm( 0 );
      setprop( "controls/switches/warn/door_lock", "false" );
    }
  }

  old_door_status = door_status;
  door_status = getprop( "/sim/model/bell205/door-positions/leftFrontDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/rightFrontDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/leftSideDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/rightSideDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/leftSlideDoor/position-norm" )>0.0 or
                getprop( "/sim/model/bell205/door-positions/rightSlideDoor/position-norm" )>0.0;
  setprop( "sim/model/bell205/doors/door_status", door_status );

  settimer( check_doors, 0.75 );
} # check_doors()
check_doors();
