/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  SpringFactory: desiccant_tray.scad

        Copyright (c) 2022, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/desiccant_tray
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  GNU GPLv3
&&
This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/





use <MCAD/regular_shapes.scad>;





/*?????????????????????????????????????????????????????????????????
??
/*???????????????????????????????????????????????????????
?? Section: Customizer
??
    Description:
        The Customizer feature provides a graphic user interface for editing model parameters.
??
???????????????????????????????????????????????????????*/
/* [Global] */
//Display Verbose Output?
$VERBOSE=1; // [1:Yes,0:No]

/* [Tray Dimensions] */
//Tray Diameter (X)
CUSTOM_TRAY_DIAMETER=0;     // [1:.1:250]
//Tray Height (Z)
CUSTOM_TRAY_HEIGHT=0;       // [1:.1:210]
//Center Diameter (X)
CUSTOM_CENTER_DIAMETER=0;   // [1:.1:210]
//Wall Width (X)
CUSTOM_WALL_WIDTH=0;        // [.1:.1:250]
//Floor Depth (Z)
CUSTOM_FLOOR_DEPTH=0;       // [.1:.1:210]
//Number of Tray Sections
CUSTOM_TRAY_SECTIONS=0;     // [1:1:20]
/* [Misc] */
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Defined/Derived Variables
*/
/* [Hidden] */
$fa = 0.3;
$fs = 0.3;

/*
If the corresponding input variable is set to zero (0), define the working values relative to the PIPE_ID
*/
diameter=(CUSTOM_TRAY_DIAMETER==0) ? 308 : CUSTOM_TRAY_DIAMETER;
radius=diameter/2;
hole=(CUSTOM_CENTER_DIAMETER==0) ? 68 : CUSTOM_CENTER_DIAMETER;
hole_radius=hole/2;
height=(CUSTOM_TRAY_HEIGHT==0) ? 23 : CUSTOM_TRAY_HEIGHT;
wall=(CUSTOM_WALL_WIDTH==0) ? 2.5 : CUSTOM_WALL_WIDTH;
floor=(CUSTOM_FLOOR_DEPTH==0) ? 3 : CUSTOM_FLOOR_DEPTH;
angle=(CUSTOM_TRAY_SECTIONS==0) ? 90 : 360/CUSTOM_TRAY_SECTIONS;

if($VERBOSE) echo(str("**======> Tray Diameter: ",diameter,"**"));
if($VERBOSE) echo(str("**======> Hole Diameter: ",hole,"**"));
if($VERBOSE) echo(str("**======> Tray Wall Height: ",height,"**"));
if($VERBOSE) echo(str("**======> Wall Width: ",wall,"**"));
if($VERBOSE) echo(str("**======> Floor Depth: ",floor,"**"));
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
/*///////////////////////////////////////////////////////
// Module: make_dessicant_tray()
//
    Description:
        Wrapper module to create desiccant_tray object

    Arguments:
        N/A
*/
make_dessicant_tray();
///////////////////////////////////////////////////////*/
module make_dessicant_tray(){
    // Create Tray Shape
    union(){
        rotate([0,0,180]){
            hollow_shape(){
                make_shape(radius,hole_radius,height, angle=angle);
                translate([0,0,floor])
                    make_shape(radius-wall,hole_radius+wall,height, angle=angle);
            }
        }
        // Recreate Wall Segments (X/Y)
        translate([hole_radius,0,0])
            cube([radius-hole_radius,wall,height]);
        rotate([0,0,angle]) translate([hole_radius,0,0])
            cube([radius-hole_radius,wall,height]);
    }
}
///////////////////////////////////////////////////////*/

/////////////////////////////////////////////////////////
module make_shape(radius,hole_radius,height, angle=90) {
    r=radius-hole_radius;
    translate([0,0,height/2]) rotate_extrude(angle=angle, $fn=360)
        translate([-((r/2)+hole_radius),0,0]) square([r,height],center=true);
}
module hollow_shape(wall,floor) {
    difference(){
        children(0);
        children(1);
    }
}
module mirror_copy(vec=[0,1,0]) {
    children();
    mirror(vec) children();
}
///////////////////////////////////////////////////////*/
/*
/////////////////////////////////////////////////////////////////*/