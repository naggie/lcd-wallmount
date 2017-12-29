// https://github.com/OskarLinde/scad-utils/blob/master/morphology.scad
// empty in in /Users/<user>/Documents/OpenSCAD/libraries
// TODO inspect https://github.com/howtokap/kap-tx1/blob/master/bezel/bezel.scad for ideas

$fn = 120; 

module rounded_cube(x,y,z,r) {
    linear_extrude(height=z) translate([r,r,0]) offset(r=r) square([x-2*r,y-2*r]);
}

// basic portrait bezel
// set tolerance to leave an appropriate gap for your manufacturing method
// https://www.3dprint-uk.co.uk/machine-accuracy/
// Tolerance is only given for the critical part, the tablet inlay
module bezel(x,y,z,overhang=[3,3,3,3],front=2,top=10,bottom=10,sides=5) {
    // overhang: top, right, bottom, left (like CSS)

    difference() {
        // bounding box
        rounded_cube(x+2*sides, y+top+bottom, z+front, 6);
        // tablet cut out
        translate([sides,bottom,-1]) rounded_cube(x,y,z+1,2);

        // display cut out leaving a frame
        translate([sides+overhang[3],bottom+overhang[2],-1])
            rounded_cube(x-overhang[1]-overhang[3], y-overhang[0]-overhang[2],z+front+2,2);
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
module countersunk_screwhole(head=8,diameter=4) {
    // head
    translate([0,0,-head*0.762/2]) cylinder(h=head*0.762,r1=0,r2=head/2,center=true);
    // shank
    // expand 10% for some play
    translate([0,0,-250/2]) cylinder(h=250,r1=diameter*0.55,r2=diameter*0.55,center=true);
    // plug hole
    translate([0,0,9.99]) cylinder(h=20,r=head/2,center=true);
}

module mountable_bezel(x,y,z,overhang=[3,3,3,3],front=2,top=11,bottom=11,sides=5,margin=0.5,vents=true) {
    x = x+margin;
    y = y+margin;
    z = z+margin;

    height = y + top + bottom;
    width = x+2*sides;
    screw_z = z+front-1;

    difference() {
        bezel(x,y,z,overhang,front,top,bottom,sides);
        translate([6,6,screw_z]) countersunk_screwhole(); // BL
        translate([width-6,6,screw_z]) countersunk_screwhole(); // BR
        translate([6,height-6,screw_z]) countersunk_screwhole(); // TL
        translate([width-6,height-6,screw_z]) countersunk_screwhole(); // TR
        if (vents) {
            translate([-500,sides+overhang[3]+y*0.2,3]) rotate([0,90,0]) rounded_cube(12,y*0.6,1000,3);
        }
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
//translate([0,0,0]) {
//    fire5_bezel();
//    translate([20,35]) {
//        nexus4_bezel();
//        //translate([5,10,0.1]) color("red") import("NEXUS4.STL");
//        //translate([5,10]) import("NEXUS4.STL");
//    }
//}

//!nexus4_bezel();
//
//

// pi LCD
mountable_bezel(193,111,26,overhang=[6,6,6,6],front=1.6,top=11,bottom=11,sides=5);
