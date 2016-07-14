// https://github.com/OskarLinde/scad-utils/blob/master/morphology.scad
// empty in in /Users/<user>/Documents/OpenSCAD/libraries
// TODO inspect https://github.com/howtokap/kap-tx1/blob/master/bezel/bezel.scad for ideas
use <morphology.scad>

$fn = 80;

// basic portrait bezel
// set tolerance to leave an appropriate gap for your manufacturing method
// https://www.3dprint-uk.co.uk/machine-accuracy/
// Tolerance is only given for the critical part, the tablet inlay
module bezel(x,y,z,overhang=[3,3,3,3],front=2,top=10,bottom=10,sides=5) {
    // overhang: top, right, bottom, left (like CSS)

    difference() {
        // 2D shape is extruded (instead of 3d to begin with) such that morphology library can be used

        // bounding box
        linear_extrude(height=z+front) rounding(r=4) square([x+2*sides,y+top+bottom]);
        // tablet cut out
        linear_extrude(height=z) rounding(r=2)  translate ([sides,bottom,0]) square([x,y]);
        ///translate ([sides,bottom,0]) cube([x,y,z]);
        // display cut out leaving a frame
        linear_extrude(height=z+front) rounding(r=4)  translate ([sides+overhang[3],bottom+overhang[2],0]) square([x-overhang[1]-overhang[3],y-overhang[0]-overhang[2]]) ;
    }


}

// http://www.screwfix.com/p/fischer-plasterboard-plug-ldf-4-x-mm-pk100/81956
// http://www.screwfix.com/p/goldscrew-woodscrews-double-self-countersunk-4-x-25mm-pk200/17430
//
// Possibly use
// http://www.screwfix.com/p/dewalt-plasterboard-fixings-metal-25mm-pack-of-100/69132
// Which is not countersunk and therefore not self centering. Can tolerate alignment with bigger hole.
//
// It turns out the screws/plugs work great if you mount them right:
// 1. Attach bezel to wall with masking tape (level with spirit level)
// 2. Drill 4mm pilot holes
// 3. Remove bezel
// 4. Ream out holes with 6mm bit
// 5. Tap in plugs with hammer
// 6. Apply black nail polish to screw heads
//
// (6) was discovered to be better than using printed plastic screw head covers.
module countersunk_screwhole(head=8,diameter=4,height=25) {
    // expand 10% for some play
    scale([1.1,1.1,1.1]) {
        // head
        translate([0,0,-diameter/2]) cylinder(h=4,r1=diameter/2,r2=head/2,center=true);
        // shank
        translate([0,0,-height/2]) cylinder(h=height,r1=diameter/2,r2=diameter/2,center=true);
        // plug hole
        translate([0,0,10]) cylinder(h=20,r=head/2,center=true);
    }
}

module mountable_bezel(x,y,z,overhang=[3,3,3,3],front=2,top=11,bottom=11,sides=5) {
    height = y + top + bottom;
    width = x+2*sides;
    screw_z = z+front-1;

    difference() {
        bezel(x,y,z,overhang,front,top,bottom,sides);
        translate([5.5,5.5,screw_z]) countersunk_screwhole(); // BL
        translate([width-5.5,5.5,screw_z]) countersunk_screwhole(); // BR
        translate([5.5,height-5.5,screw_z]) countersunk_screwhole(); // TL
        translate([width-5.5,height-5.5,screw_z]) countersunk_screwhole(); // TR
    }
}

module fire5_bezel() {
    difference() {
        mountable_bezel(115,191,10.6,front=1.5,top=12,bottom=11);

        // volume rocker (30-54)
        translate([30+5,10+192,0]) cube([24,1.8,10.8]);

        // microUSB solder connector + wire routing (25 45)
        translate([2*5+115-45,10+191,0]) cube([20,11,10.8]);

        // power button cutout
        translate([2*5+115-27,10+192,0]) cube([14,2,10.8]);

        // power button hole
        translate([2*5+115-20,10+191,10.6/2]) rotate([270,0,0]) cylinder(h=20,r=1.5);
    }
}

// TODO hide corners with large radius
// TODO check proximity sensor does not affect correct operation of phone
module nexus4_bezel() {
    difference() {
        mountable_bezel(68.7,133.9,9.1,[12,3,12,3],front=1.5,top=11,bottom=13);

        // volume rocker
        translate([5-1.8,12+79,0]) cube([1.8,23,0]);

        // microUSB solder connector + wire routing (25 45)
        translate([5+68.7/2-10,2,0]) cube([20,13,9]);

        // power button cutout
        translate([5+68.7,12+101,0]) cube([1.8,12,9]);

        // power button hole
        translate([5+68.7,12+101+6,9.1/2]) rotate([270,0,270]) cylinder(h=20,r=1.5);
    }
}
// LG Nexus 4
//translate([-65,-106,0]) {
translate([0,0,0]) {
    fire5_bezel();
    translate([20,35]) {
        nexus4_bezel();
        //translate([5,10,0.1]) color("red") import("NEXUS4.STL");
        //translate([5,10]) import("NEXUS4.STL");
    }
}

//!nexus4_bezel();
//
