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
            
            // Keyhole mounting material (positioned on the side opposite from bottom arm)
            case_center_y = holder_width / 2;
            keyhole_x_pos = holder_length; // At the far end from bottom arm (length direction)
            keyhole_1_y = case_center_y - keyhole_spacing / 2;  // 40mm left of center
            keyhole_2_y = case_center_y + keyhole_spacing / 2;  // 40mm right of center
            
            // First keyhole tab
            translate([keyhole_x_pos, keyhole_1_y - keyhole_material_width/2, 0])
            cube([keyhole_material_height, keyhole_material_width, base_thickness]);
            
            // Second keyhole tab  
            translate([keyhole_x_pos, keyhole_2_y - keyhole_material_width/2, 0])
            cube([keyhole_material_height, keyhole_material_width, base_thickness]);
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
        
        // Keyhole mounting holes  
        case_center_y = holder_width / 2;
        keyhole_x_center = holder_length + keyhole_material_height / 2; // Center of keyhole tabs
        keyhole_1_y = case_center_y - keyhole_spacing / 2;
        keyhole_2_y = case_center_y + keyhole_spacing / 2;
        
        for (keyhole_y = [keyhole_1_y, keyhole_2_y]) {
            translate([keyhole_x_center, keyhole_y, 0]) {
                rotate([0, 0, 270])  // Rotate 270 degrees (90 + 180) so wide end faces away from bottom arm
                keyhole_mount();
            }
        }
    }
}

// Show PSU holder
psu_holder();