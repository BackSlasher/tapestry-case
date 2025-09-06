// PCB holder for epdiy case
// Based on specifications from instructions.md

// PCB dimensions
pcb_width = 97;
pcb_height = 55;
pcb_thickness = 1.6; // Standard PCB thickness

// Mounting hole positions (relative to PCB origin)
mounting_holes = [
    [27.5, 12],
    [122.5, 12], 
    [27.5, 62],
    [122.5, 62]
];

// Calculate holder dimensions to encompass all mounting holes
max_hole_x = 122.5;
max_hole_y = 62;
holder_width = max_hole_x + 10; // Add margin beyond furthest hole
holder_height = max_hole_y + 10; // Add margin beyond furthest hole

// Holder parameters
wall_thickness = 3;
screw_hole_diameter = 3.2; // M3 screws
screw_head_diameter = 6;
screw_head_depth = 2;
standoff_height = 5;

module pcb_holder() {
    difference() {
        union() {
            // Base plate sized to encompass all mounting holes
            cube([holder_width + 2*wall_thickness, holder_height + 2*wall_thickness, wall_thickness]);
            
            // Standoffs for mounting screws
            for (hole = mounting_holes) {
                translate([wall_thickness + hole[0], wall_thickness + hole[1], wall_thickness])
                    cylinder(h = standoff_height, d = screw_head_diameter + 2);
            }
        }
        
        // Screw holes through standoffs
        for (hole = mounting_holes) {
            translate([wall_thickness + hole[0], wall_thickness + hole[1], -1])
                cylinder(h = wall_thickness + standoff_height + 2, d = screw_hole_diameter);
            
            // Countersink for screw heads (from bottom)
            translate([wall_thickness + hole[0], wall_thickness + hole[1], -1])
                cylinder(h = screw_head_depth + 1, d = screw_head_diameter);
        }
    }
}

pcb_holder();