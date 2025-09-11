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

// Keyhole parameters
pin_head_diameter = 19;
pin_shaft_diameter = 8;
clearance_keyhole = 1;
wide_opening = pin_head_diameter + clearance_keyhole;   // 20mm
narrow_slot = pin_shaft_diameter + clearance_keyhole;   // 9mm
slot_length = 15;

// Layer thicknesses for keyhole
layer1_thickness = 3.5;  // Top layer
layer2_thickness = 3.5;  // Middle layer  
layer3_thickness = 2;    // Bottom solid layer (pin stop)

// Keyhole spacing (multiple of 4cm)
keyhole_spacing = 80;  // 2 × 4cm = 80mm
keyhole_material_width = 25;
keyhole_material_height = 45;  // Increased height to close top of keyhole

module keyhole_mount() {
    // Keyhole shape cuts through both Layer 1 and Layer 2 (no ceiling)
    translate([0, 0, -0.1]) {
        // Wide circular opening at bottom
        translate([0, -wide_opening/2 + 5, 0])
            cylinder(h = layer1_thickness + layer2_thickness + 0.2, d = wide_opening, $fn = 40);
        
        // Narrow slot extending upward
        translate([0, slot_length/2 + 5, 0])
            cube([narrow_slot, slot_length, layer1_thickness + layer2_thickness + 0.2], center = true);
        
        // Smooth transition between wide and narrow
        hull() {
            translate([0, -wide_opening/2 + 5, 0])
                cylinder(h = layer1_thickness + layer2_thickness + 0.2, d = wide_opening, $fn = 40);
            translate([0, 5, 0])
                cube([narrow_slot, 1, layer1_thickness + layer2_thickness + 0.2], center = true);
        }
    }
    
    // Layer 3: NO CUTS - solid material remains (pin stop surface)
}

module psu_holder() {
    difference() {
        union() {
            // Base plate
            translate([0, 0, 0])
            cube([holder_length, holder_width, base_thickness]);
            
            // Left arm - holds the thick part (high for 3.5cm section) 
            translate([0, 0, base_thickness])
            cube([arm_thickness, holder_width, side_arm_height]);
            
            // Left arm ledge - extends inward to grab thick part
            translate([arm_thickness, clearance, base_thickness + side_arm_height - ledge_thickness])
            cube([ledge_depth, holder_width - 2 * clearance, ledge_thickness]);
            
            // Right arm - holds the thin part (short for 2.5cm section)
            translate([holder_length - arm_thickness, 0, base_thickness])
            cube([arm_thickness, holder_width, bottom_arm_height]);
            
            // Right arm ledge - extends inward to grab thin part  
            translate([holder_length - arm_thickness - ledge_depth, clearance, base_thickness + bottom_arm_height - ledge_thickness])
            cube([ledge_depth, holder_width - 2 * clearance, ledge_thickness]);
            
            // Bottom left arm (left-leaning, high for thick section)
            bottom_left_width = holder_length * 0.6; // 60% of length for thick section
            translate([0, 0, base_thickness])
            cube([bottom_left_width, arm_thickness, side_arm_height]);
            
            // Bottom left arm ledge
            translate([clearance, arm_thickness, base_thickness + side_arm_height - ledge_thickness])
            cube([bottom_left_width - 2 * clearance, ledge_depth, ledge_thickness]);
            
            // Bottom right arm (right-leaning, short for thin section)  
            bottom_right_start = holder_length * 0.4; // Start at 40% for thin section
            bottom_right_width = holder_length - bottom_right_start;
            translate([bottom_right_start, 0, base_thickness])
            cube([bottom_right_width, arm_thickness, bottom_arm_height]);
            
            // Bottom right arm ledge
            translate([bottom_right_start + clearance, arm_thickness, base_thickness + bottom_arm_height - ledge_thickness])
            cube([bottom_right_width - 2 * clearance, ledge_depth, ledge_thickness]);
            
            // Keyhole mounting material (positioned in top area where there are no arms)
            case_center_x = holder_length / 2;
            keyhole_y_pos = holder_width; // At the top end (opposite from bottom arms)
            keyhole_1_x = case_center_x - keyhole_spacing / 2;  // 40mm left of center
            keyhole_2_x = case_center_x + keyhole_spacing / 2;  // 40mm right of center
            
            // First keyhole tab
            translate([keyhole_1_x - keyhole_material_width/2, keyhole_y_pos, 0])
            cube([keyhole_material_width, keyhole_material_height, base_thickness]);
            
            // Second keyhole tab  
            translate([keyhole_2_x - keyhole_material_width/2, keyhole_y_pos, 0])
            cube([keyhole_material_width, keyhole_material_height, base_thickness]);
        }
        
        // PSU cavity (sunken area for PSU to sit in)
        translate([clearance, clearance, base_thickness - 1])
        cube([psu_length, psu_width, 2]); // 1mm sunken depth
        
        // Keyhole mounting holes (in top area)
        case_center_x = holder_length / 2;
        keyhole_y_center = holder_width + keyhole_material_height / 2; // Center of keyhole tabs
        keyhole_1_x = case_center_x - keyhole_spacing / 2;
        keyhole_2_x = case_center_x + keyhole_spacing / 2;
        
        for (keyhole_x = [keyhole_1_x, keyhole_2_x]) {
            translate([keyhole_x, keyhole_y_center, 0]) {
                keyhole_mount();
            }
        }
    }
}

// Show PSU holder
psu_holder();