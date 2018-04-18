all: bezel.stl bezel.gcode

bezel.gcode:
	# WIP
	"/Applications/Ultimaker Cura.app/Contents/MacOS/CuraEngine" slice -v -j ../Cura/resources/definitions/dual_extrusion_printer.def.json -o "output/test.gcode" -e1 -s infill_line_distance=0 -e0 -l "/model_1.stl" -e1 -l "fully_filled_model.stl"

bezel.stl:
	/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -D $fn=200 -o bezel.stl bezel.scad
