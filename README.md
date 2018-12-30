Unibezel is a tough, parametric bezel suitable for mounting a touchscreen on to
any wall. It has vents for passive cooling, holes for screws and cut-outs for
cabling. It is an evolution of my last [Amazon fire tablet mounting
system.][1]. It is built using [OpenSCAD][4].

The OpenSCAD file (bezel.scad) is set up to fit the [official Pi LCD
display][2] with a reversed [Raspberry Pi 3][2] behind, with space for a generic 5v
802.11af PoE adaptor. There are also configurations for the Amazon Fire 5
tablet -- though, beware -- do not leave the battery in the tablet when wall
mounted as it is a fire hazard. It is possible to power the tablet without the
battery providing the battery interface board is left connected.

The design has optional cut-outs for a 20mm conduit entry point, as well as
slopes on the top and bottom to increase toughness. Edges are mostly rounded
and chamfered to reduce stress concentration.

# Finishing process

I've printed this design with PLA on my 3d printer. It seems to work well -- no
supports are required when it is printed front-down.

Stop at step 5 if you're happy with a mediocre finish.

1. Coat generously with flexible car body filler (2 part, toxic!)
1. Sand flat with 80 or 120, round off sharp edges a small amount. Beware of dust.
1. Continue with P240, P400, P600 etc
1. Plastic Primer (2 or 3)
1. Gloss black (2 or 3)
1. Lacquer 3 or 4 coats
1. Sand P2000, P4000, P5000
1. Polish (car polish is good)
1. Wax
1. Detailer


# Images (Raspberry Pi display)

<p align="center">
  <img src="https://github.com/naggie/unibezel/raw/master/etc/3d-model.png">
</p>

<p align="center">
  <img src="https://github.com/naggie/unibezel/raw/master/etc/pi-mounted.jpg">
</p>

<p align="center">
  <img src="https://github.com/naggie/unibezel/raw/master/etc/pi-behind.jpg">
</p>


[1]: https://callanbryant.co.uk/post/dshome-2-control-panels/
[2]: https://www.raspberrypi.org/products/raspberry-pi-touch-display/
[3]: https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/
[4]: https://www.openscad.org/
