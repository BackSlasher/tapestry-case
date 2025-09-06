// PCB holder for epdiy case
// Based on specifications from instructions.md

include <parameters.scad>

// Just PCB mounting standoffs (no base plate)
module pcb_standoffs() {
    for (hole = mounting_holes) {
        difference() {
            cylinder(h = standoff_height, d = screw_head_diameter + 2);
            translate([0, 0, -1])
                cylinder(h = standoff_height + 2, d = screw_hole_diameter);
        }
    }
}

// Full PCB holder with base plate (for standalone printing)  
module pcb_holder() {
    difference() {
        union() {
            // Base plate sized to encompass all mounting holes
            cube([pcb_holder_width + 6, pcb_holder_height + 6, 3]);
            
            // Standoffs for mounting screws
            for (hole = mounting_holes) {
                translate([3 + hole[0] - min_hole_x, 3 + hole[1] - min_hole_y, 3])
                    cylinder(h = standoff_height, d = screw_head_diameter + 2);
            }
        }
        
        // Screw holes through standoffs
        for (hole = mounting_holes) {
            translate([3 + hole[0] - min_hole_x, 3 + hole[1] - min_hole_y, -1])
                cylinder(h = 3 + standoff_height + 2, d = screw_hole_diameter);
            
            // Countersink for screw heads (from bottom)
            translate([3 + hole[0] - min_hole_x, 3 + hole[1] - min_hole_y, -1])
                cylinder(h = screw_head_depth + 1, d = screw_head_diameter);
        }
    }
}

pcb_holder();