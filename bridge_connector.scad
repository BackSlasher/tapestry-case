// Bridge Connector - spans between two complete cases bottom arms
// Provides pin-holders on top for mounting additional cases above
// Creates stackable/modular grid system

// Import parameters for consistency
include <parameters.scad>

// Bridge dimensions - spans between two cases
case_to_case_spacing = 240;  // 6 × 4cm spacing between case centers
bridge_length = 220;  // Long enough for 200mm pin spacing + clearance
bridge_width = 40;   // Reduced width to save material
bridge_thickness = 8; // Thickness for structural strength

// Bottom arm connection parameters (arms extend horizontally)
bottom_arm_slot_length = 62;   // Length to accommodate horizontal bottom arm
bottom_arm_slot_width = 6;     // Width of horizontal arm + clearance
bottom_arm_slot_depth = 4.5;   // Depth of groove to sit on horizontal arm (4mm + 0.5mm clearance)

// Pin-holder parameters (to match IKEA pin dimensions)
pin_head_diameter = 19;
pin_shaft_diameter = 8;
pin_total_height = 12;   // Total height of pin-holder
pin_shaft_height = 8;    // Height of shaft portion
pin_head_height = 4;     // Height of head portion

// Pin-holder positioning (must match complete case keyhole spacing)
pin_spacing = 200;  // 5 × 4cm spacing to match complete case keyholes
pin_1_x = bridge_length/2 - pin_spacing/2;
pin_2_x = bridge_length/2 + pin_spacing/2;
pin_y = bridge_width/2;

module bridge_connector() {
    difference() {
        union() {
            // Main bridge body
            cube([bridge_length, bridge_width, bridge_thickness]);

            // Pin-holders on top (IKEA pin compatible)
            for (pin_x = [pin_1_x, pin_2_x]) {
                translate([pin_x, pin_y, bridge_thickness]) {
                    // Pin shaft (narrow part)
                    cylinder(h = pin_shaft_height, d = pin_shaft_diameter, $fn = 30);

                    // Pin head (wide part)
                    translate([0, 0, pin_shaft_height])
                    cylinder(h = pin_head_height, d = pin_head_diameter, $fn = 30);
                }
            }

            // Reinforcement ribs for strength
            rib_thickness = 3;
            rib_height = 6;

            // Longitudinal ribs
            translate([0, (bridge_width - rib_thickness)/2, 0])
            cube([bridge_length, rib_thickness, rib_height]);

            // Cross ribs at pin positions
            for (pin_x = [pin_1_x, pin_2_x]) {
                translate([pin_x - rib_thickness/2, 0, 0])
                cube([rib_thickness, bridge_width, rib_height]);
            }
        }

        // Single long bottom groove for sliding onto horizontal arms
        translate([0, (bridge_width - bottom_arm_slot_width)/2, -1])
        cube([bridge_length, bottom_arm_slot_width, bottom_arm_slot_depth + 1]);
    }
}

// Render the bridge connector
bridge_connector();

// Optional: Show positioning guide
show_guide = false;
if (show_guide) {
    // Guide boxes showing where complete cases would be
    color("red", 0.3) {
        // Left case position
        translate([-60, -50, -case_thickness])
        cube([case_width, case_height, case_thickness]);

        // Right case position
        translate([bridge_length + 60 - case_width, -50, -case_thickness])
        cube([case_width, case_height, case_thickness]);
    }
}