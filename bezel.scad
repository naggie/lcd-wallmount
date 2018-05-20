// https://github.com/OskarLinde/scad-utils/blob/master/morphology.scad
// empty in in /Users/<user>/Documents/OpenSCAD/libraries
// NOTE: Something I realised is symmetry is more important than spatial
// efficacy.
$fn = 200;

module rounded_cube(x,y,z,r) {
    linear_extrude(height=z) translate([r,r,0]) offset(r=r) square([x-2*r,y-2*r]);
}

// basic portrait bezel
// set tolerance to leave an appropriate gap for your manufacturing method
// https://www.3dprint-uk.co.uk/machine-accuracy/
// Tolerance is only given for the critical part, the tablet inlay
module bezel(
    // size of tablet/display (bounding box)
    x,y,z,
    // plastic covering screen: top, right, yframe, left (like CSS)
    // use to cover corner radius of tablet/display
    // use to cover non-display areas of tablet/display
    overhang=[3,3,3,3],
    // thickness of plastic covering screen
    rim_depth=2,
    // how far to move the rim down, use only to mount a flush screen from the front
    rim_inset=0,
    // frame intersecting y-axis
    yframe=10,
    // frame intersecting x-axis
    xframe=5,
    // move position of tablet/display along x-axis/y-axis to center a display with non-symmetric edges
    xshift=0,
    yshift=0,
    // internal cut out radius -- could match tablet/display corners. Important for flush displays
    internal_radius=2,
    // radius of rim, or support for flush screen
    rim_radius=2
) {


    difference() {
        // bounding box
        rounded_cube(x+xframe*2, y+yframe*2, z + rim_depth + rim_inset, 3);

        // cut tablet, leaving a thin wall at front
        translate([xframe+xshift,yframe+yshift,-1]) rounded_cube(x,y,z+1.001,internal_radius);

        // cut front inset, eating into rim to make inset
        translate([xframe+xshift,yframe+yshift, z + rim_depth + 0.001]) rounded_cube(x, y, 500, internal_radius);

        // cut out window leaving a rim
        translate([xframe + overhang[3], yframe + overhang[2], -500])
            rounded_cube(x - overhang[1] - overhang[3], y-overhang[0] - overhang[2], 1000, rim_radius);
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
module countersunk_screwhole(head=8.5,diameter=4.5) {
    // head
    translate([0,0,-head*0.762/2]) cylinder(h=head*0.762,r1=0,r2=head/2,center=true);
    // shank
    // expand 10% for some play
    translate([0,0,-250/2]) cylinder(h=250,r1=diameter*0.55,r2=diameter*0.55,center=true);
    // plug hole
    translate([0,0,9.99]) cylinder(h=20,r=head/2,center=true);
}

module mountable_bezel(
    x,
    y,
    z,
    overhang=[3, 3, 3, 3],
    rim_depth=2,
    rim_inset=0,
    yframe=11,
    xframe=5,
    margin=1,
    xshift=0,
    yshift=0,
    internal_radius=2,
    rim_radius=2
) {
    x = x+margin;
    y = y+margin;
    z = z+margin;

    height = y + yframe*2;
    width = x+2*xframe;
    screw_z = z+rim_depth-1.5;

    difference() {
        bezel(
            x=x, y=y, z=z,
            overhang=overhang,
            rim_depth=rim_depth,
            rim_inset=rim_inset,
            yframe=yframe,
            xframe=xframe,
            xshift=xshift,
            yshift=yshift,
            internal_radius=internal_radius,
            rim_radius=rim_radius
        );
        translate([6,6,screw_z]) countersunk_screwhole(); // BL
        translate([width-6,6,screw_z]) countersunk_screwhole(); // BR
        translate([6,height-6,screw_z]) countersunk_screwhole(); // TL
        translate([width-6,height-6,screw_z]) countersunk_screwhole(); // TR


        // vents provide passive cooling (remove the back cover of tablet if
        // tablet is used) and also make the product look slimmer
        vent_margin = max(xframe + 5, yframe + 5);
        // x vents
        translate([-500,vent_margin,4]) rotate([0,90,0]) rounded_cube(12,y+yframe*2-2*vent_margin,1000,4);
        // y vents
        translate([vent_margin, 500, 4]) rotate([0,90,270]) rounded_cube(12,x+xframe*2-2*vent_margin,1000,4);

        // cable recesses, will only appear if frames are wide enough
        translate([3, yframe+y*0.2, z]) mirror([0,0,1]) rounded_cube(xframe*2 + x -6, y*0.6, 500, 3);
        translate([xframe+x*0.2, 3, z]) mirror([0, 0, 1]) rounded_cube(x*0.6, yframe*2 + y -6, 500, 3);

        // WIP -- conduit. TODO: thin wall to accept coupling, possibly also hex. Shorten vent conduit side.
        //translate([25, -1, 17]) rotate([270, 0, 0]) cylinder(yframe+2, d=20);
        //// spanner, recess
        //translate([14.5, 3, -0.001]) cube([21, yframe, 30]);
    }

}

module fire5_bezel() {
    difference() {
        mountable_bezel(115,191,10.6,rim_depth=1.5,yframe=12);

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

module nexus4_bezel() {
    difference() {
        mountable_bezel(68.7,133.9,9.1,[12,3,12,3],rim_depth=1.5,yframe=13);

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

//fire5_bezel();
//nexus4_bezel();

// pi LCD
mountable_bezel(
    193,
    111,
    29,
    overhang=[6, 6, 6, 6],
    rim_depth=1.6,
    rim_inset=0,
    yframe=12,
    xframe=3,
    yshift=1,
    internal_radius=6.5
);

// pi LCD with inset bezel
//difference() {
//mountable_bezel(
//    193.5,
//    111.5,
//    26,
//    overhang=[7, 11, 3, 4],
//    rim_depth=2,
//    rim_inset=1.50,
//    yframe=12,
//    xframe=3,
//    yshift=1,
//    internal_radius=6.5,
//    rim_radius=1
//);
//
//translate([-1,-1,-1]) cube([300,300,25]);
//}
