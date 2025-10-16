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
clearance = 5;   // Extra space around PSU for easier insertion

holder_length = psu_length + 2 * clearance;  // 100mm
holder_width = psu_width + 2 * clearance;    // 150mm

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
    // Define arm parameters at module level
    left_arm_height = 60;
    left_arm_y = holder_width - left_arm_height;
    right_arm_height = 60;
    right_arm_y = holder_width - right_arm_height;
    bottom_arm_length = 60;
    
    hub_size = 40;
    case_center_x = holder_length / 2;
    case_center_y = left_arm_y + left_arm_height/2;  // Position at intersection of tendrils
    bottom_arm_x = case_center_x - bottom_arm_length/2;
    
    difference() {
        union() {
            // Expanded central hub - covers entire floor between and including arms
            expanded_hub_width = holder_length;  // Full width including arms
            expanded_hub_height = left_arm_height;  // Matches arm height
            translate([0, left_arm_y, 0])
            cube([expanded_hub_width, expanded_hub_height, base_thickness]);
            
            // Left arm (high for thick section) - positioned near top
            translate([0, left_arm_y, base_thickness])
            cube([arm_thickness, left_arm_height, side_arm_height]);
            
            // Left arm ledge
            translate([arm_thickness, left_arm_y, base_thickness + side_arm_height - ledge_thickness])
            cube([ledge_depth, left_arm_height, ledge_thickness]);
            
            // Right arm (short for thin section) - positioned near top
            translate([holder_length - arm_thickness, right_arm_y, base_thickness])
            cube([arm_thickness, right_arm_height, bottom_arm_height]);
            
            // Right arm ledge
            translate([holder_length - arm_thickness - ledge_depth, right_arm_y, base_thickness + bottom_arm_height - ledge_thickness])
            cube([ledge_depth, right_arm_height, ledge_thickness]);
            
            // Bottom arm (centered) - extends to floor
            translate([bottom_arm_x, 0, 0])
            cube([bottom_arm_length, arm_thickness, base_thickness + side_arm_height]);
            
            // Bottom arm ledge
            translate([bottom_arm_x, arm_thickness, base_thickness + side_arm_height - ledge_thickness])
            cube([bottom_arm_length, ledge_depth, ledge_thickness]);
            
            // Bottom tendril (from bottom arm to expanded hub)
            tendril_width = 8;
            translate([case_center_x - tendril_width/2, arm_thickness, 0])
            cube([tendril_width, left_arm_y - arm_thickness, base_thickness]);
            
            // Keyhole mounting material (on sides of left-right arms) - 120mm apart (3×4cm)
            keyhole_spacing_target = 120;  // Must be 4cm multiple
            case_center_x = holder_length / 2;
            keyhole_1_x = case_center_x - keyhole_spacing_target/2 - keyhole_material_width/2;  // Left side
            keyhole_2_x = case_center_x + keyhole_spacing_target/2 - keyhole_material_width/2;  // Right side
            keyhole_y_pos = left_arm_y + left_arm_height/2 - keyhole_material_height/2; // Centered on arms

            // Left keyhole tab (extending from left arm)
            translate([keyhole_1_x, keyhole_y_pos, 0])
            cube([keyhole_material_width, keyhole_material_height, base_thickness]);

            // Right keyhole tab (extending from right arm)
            translate([keyhole_2_x, keyhole_y_pos, 0])
            cube([keyhole_material_width, keyhole_material_height, base_thickness]);
        }
        
        // PSU cavity removed - not needed for this design
        
        // Keyhole mounting holes (on sides of left-right arms) - 120mm apart (3×4cm)
        keyhole_spacing_target = 120;  // Must be 4cm multiple
        case_center_x = holder_length / 2;
        keyhole_1_x = case_center_x - keyhole_spacing_target/2;  // Center of left keyhole
        keyhole_2_x = case_center_x + keyhole_spacing_target/2;  // Center of right keyhole
        keyhole_y_center = left_arm_y + left_arm_height/2; // Center of arms

        for (keyhole_x = [keyhole_1_x, keyhole_2_x]) {
            translate([keyhole_x, keyhole_y_center, 0]) {
                keyhole_mount();
            }
        }
    }
}

// Show PSU holder
psu_holder();