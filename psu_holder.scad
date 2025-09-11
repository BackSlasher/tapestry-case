// Simple PSU Holder
// Bottom arm holds short part (2.5cm high, 4cm long)
// Left-right arms hold thick part (3.5cm high, 3cm long + ramp)

// PSU dimensions
psu_length = 90;        // 9cm side length
psu_width = 140;        // 14cm width  
psu_short_height = 25;  // 2.5cm high (short part)
psu_tall_height = 35;   // 3.5cm high (tall part)
psu_short_length = 40;  // 4cm long (short part)
psu_ramp_length = 10;   // 1cm long (ramp)
psu_tall_length = 30;   // 3cm long (tall part)

// Holder parameters
base_thickness = 3;
arm_thickness = 6;
bottom_arm_height = psu_short_height + 5;  // Height to grab short part (2.5cm + 0.5cm)
side_arm_height = psu_tall_height + 5;     // Height to grab tall part (3.5cm + 0.5cm) 
ledge_depth = 4;   // How far the ledges extend inward to grab PSU
ledge_thickness = 3;  // Thickness of the grabbing ledges
clearance = 2;   // Extra space around PSU

holder_length = psu_length + 2 * clearance;  // 94mm
holder_width = psu_width + 2 * clearance;    // 144mm

module psu_holder() {
    difference() {
        union() {
            // Base plate
            translate([0, 0, 0])
            cube([holder_length, holder_width, base_thickness]);
            
            // Bottom arm - holds the short part of PSU (2.5cm high section)
            // Position at the short end, tall enough to grab the short part
            translate([0, 0, base_thickness])
            cube([arm_thickness, holder_width, bottom_arm_height]);
            
            // Bottom arm ledges - extend inward to grab the short part of PSU
            translate([arm_thickness, clearance, base_thickness + bottom_arm_height - ledge_thickness])
            cube([ledge_depth, holder_width - 2 * clearance, ledge_thickness]);
            
            // Left arm - holds the thick part (3.5cm high section) 
            // Position where the thick part would be (right side), tall enough to grab thick part
            thick_part_start = clearance + psu_short_length + psu_ramp_length - arm_thickness;
            translate([thick_part_start, 0, base_thickness])
            cube([arm_thickness + psu_tall_length, arm_thickness, side_arm_height]);
            
            // Left arm ledge - extends inward to grab thick part
            translate([thick_part_start, arm_thickness, base_thickness + side_arm_height - ledge_thickness])
            cube([arm_thickness + psu_tall_length, ledge_depth, ledge_thickness]);
            
            // Right arm - holds the thick part (3.5cm high section)
            // Tall enough to grab the thick part
            translate([thick_part_start, holder_width - arm_thickness, base_thickness])
            cube([arm_thickness + psu_tall_length, arm_thickness, side_arm_height]);
            
            // Right arm ledge - extends inward to grab thick part  
            translate([thick_part_start, holder_width - arm_thickness - ledge_depth, base_thickness + side_arm_height - ledge_thickness])
            cube([arm_thickness + psu_tall_length, ledge_depth, ledge_thickness]);
        }
        
        // PSU cavity (sunken area for PSU to sit in)
        translate([clearance, clearance, base_thickness - 1])
        cube([psu_length, psu_width, 2]); // 1mm sunken depth
        
        // Access slots for cables
        // Power cable access (from power socket side)
        translate([holder_length - 20, holder_width/2 - 10, -1])
        cube([25, 20, base_thickness + 2]);
        
        // USB cable access (from USB port side - short part)
        translate([-1, holder_width/2 - 15, base_thickness + 2])
        cube([arm_thickness + 2, 30, 6]);
    }
}

// Show PSU holder
psu_holder();