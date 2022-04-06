//Display Verbose Output?
VERBOSE=1; // [1:Yes,0:No]
//Units
UNITS=1; // [0:in,1:mm]

/* [Tray Dimensions] */
//Tray Diameter (X)
CUSTOM_TRAY_DIAMETER=0; // [1:.1:250]
//Tray Height (Z)
CUSTOM_TRAY_HEIGHT=0; // [1:.1:210]
//Center Diameter (X)
CUSTOM_CENTER_DIAMETER=0; // [1:.1:210]
//Wall Width (X)
CUSTOM_WALL_WIDTH=0; // [.1:.1:250]
//Floor Depth (Z)
CUSTOM_FLOOR_DEPTH=0; // [.1:.1:210]
/* [Misc] */

/* [Hidden] */
$fa = 0.3;
$fs = 0.3;

/*
If the corresponding input variable is set to zero (0), define the working values relative to the PIPE_ID
*/
CONVERSION=(UNITS==0) ? 25.4 : 1;
DIAMETER=(CUSTOM_TRAY_DIAMETER==0) ? 308 : CUSTOM_TRAY_DIAMETER;
HEIGHT=(CUSTOM_TRAY_HEIGHT==0) ? 23 : CUSTOM_TRAY_HEIGHT;
HOLE=(CUSTOM_CENTER_DIAMETER==0) ? 68 : CUSTOM_TRAY_DIAMETER;
WALL=(CUSTOM_WALL_WIDTH==0) ? 2.5 : CUSTOM_WALL_WIDTH;
FLOOR=(CUSTOM_FLOOR_DEPTH==0) ? 3 : CUSTOM_FLOOR_DEPTH;

//Metric to Imperial Conversion
scale([CONVERSION,CONVERSION,CONVERSION])
{
    //Create Tray Model
    if(VERBOSE) echo("--> Begin Tray Modeling");
    union(){
        difference()
        {
            difference()
            {
                if(VERBOSE) echo("--> Create Base Model");
                if(VERBOSE) echo(str("**======> Tray Diameter: ",DIAMETER,"**"));
                if(VERBOSE) echo(str("**======> Tray Wall Height: ",HEIGHT,"**"));
                if(VERBOSE) echo(str("**======> Hole Diameter: ",HOLE,"**"));
                cylinder_tube(HEIGHT,DIAMETER/2,DIAMETER/2-HOLE/2);
                if(VERBOSE) echo("--> Complete Base Model");
                
                if(VERBOSE) echo("--> Hollow Base Model");
                if(VERBOSE) echo(str("**======> Wall Width: ",WALL,"**"));
                if(VERBOSE) echo(str("**======> Floor Depth: ",FLOOR,"**"));
                translate([0,0,FLOOR]) cylinder_tube(HEIGHT-FLOOR,DIAMETER/2-WALL,DIAMETER/2-HOLE/2-WALL*2);
                if(VERBOSE) echo("--> Complete \"Hole\" Removal");
            }
            if(VERBOSE) echo("--> Divide Model (X/Y)");
            translate([0,DIAMETER/2,HEIGHT/2]) cube([DIAMETER,DIAMETER,HEIGHT],center=true);
            translate([DIAMETER/2,0,HEIGHT/2]) cube([DIAMETER,DIAMETER,HEIGHT],center=true);
            if(VERBOSE) echo("--> Complete Divide Model (X/Y)");
        }
        if(VERBOSE) echo("--> Recreate Wall(s) (X/Y)");
        translate([-(DIAMETER/4+HOLE/4),-WALL/2,HEIGHT/2]) cube([DIAMETER/2-HOLE/2,WALL,HEIGHT],center=true);
        translate([-WALL/2,-(DIAMETER/4+HOLE/4),HEIGHT/2]) cube([WALL,DIAMETER/2-HOLE/2,HEIGHT],center=true);
        if(VERBOSE) echo("--> Complete Wall(s) Recreation (X/Y)");
    } 
}

//Modules
module cylinder_tube(height, radius, wall, center = false){
    tubify(radius,wall)
    cylinder(h=height, r=radius, center=center);
}
module tubify(radius,wall){
  difference()
  {
    children(0);
    translate([0, 0, -0.1]) scale([(radius-wall)/radius, (radius-wall)/radius, 2]) children(0);
  }
}