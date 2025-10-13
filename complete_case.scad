// Complete case for epdiy - back-to-back design
// E-ink screen on front, PCB mounted on back, minimal ribbon travel

include <parameters.scad>

// Keyhole parameters (from keyhole_test.scad with updated thicknesses)
pin_head_diameter = 19;
pin_shaft_diameter = 8;
clearance = 1;
wide_opening = pin_head_diameter + clearance;   // 20mm
narrow_slot = pin_shaft_diameter + clearance;   // 9mm
slot_length = 15;

// Updated layer thicknesses for better tolerance
layer1_thickness = 3.5;  // Top layer with narrow slot + wide opening
layer2_thickness = 3.5;  // Middle layer with full pin head width
layer3_thickness = 2;    // Bottom solid layer (pin stop)
keyhole_total_thickness = layer1_thickness + layer2_thickness + layer3_thickness; // 9mm

module keyhole_mount() {
    // Keyhole opening from the back side (bottom) of the case
    // Note: we cut from the BOTTOM (negative Z), working upward through layers
    
    // Layer 1: Keyhole shape cuts through both Layer 1 and Layer 2 (no ceiling)
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
    
    // Layer 2: Full pin head width opening throughout entire keyhole area - MIDDLE layer
    translate([0, 0, layer1_thickness - 0.1]) {
        hull() {
            // Bottom wide opening (matches Layer 1 position)
            translate([0, -wide_opening/2 + 5, 0])
                cylinder(h = layer2_thickness + 0.2, d = wide_opening, $fn = 40);
            // Top of slot area (matches Layer 1 extent)  
            translate([0, slot_length/2 + 5, 0])
                cylinder(h = layer2_thickness + 0.2, d = wide_opening, $fn = 40);
        }
    }
    
    // Layer 3: NO CUTS - solid material remains (pin stop surface) - TOP layer
    // This layer intentionally has no cuts to provide the pin stop surface
}

module complete_case() {
    // E-ink screen positioning (centered in case)
    screen_offset_x = (case_width - eink_width) / 2;
    screen_offset_y = (case_height - eink_height) / 2;
    
    // PCB positioned back-to-back with screen (positioned on left side, adjusted)
    pcb_offset_x = screen_offset_x + 5;  // Move 5mm toward center (right)
    pcb_offset_y = screen_offset_y + (eink_height - pcb_height) / 2 + 15 - 5 + 2;  // Move 5mm toward bottom + 2mm up
    
    // PCB mounting area bounds (defined once for use throughout)
    pcb_left = pcb_offset_x + min([for (hole = mounting_holes) hole[0]]) - 8;
    pcb_right = pcb_offset_x + max([for (hole = mounting_holes) hole[0]]) + 8;
    pcb_bottom = pcb_offset_y + min([for (hole = mounting_holes) hole[1]]) - 8;
    pcb_top = pcb_offset_y + max([for (hole = mounting_holes) hole[1]]) + 8;
    
    difference() {
        union() {
            // PCB mounting area (unified base structure)
            
            translate([pcb_left, pcb_bottom, 0])
            cube([pcb_right - pcb_left, pcb_top - pcb_bottom, case_thickness]);
            
            // PCB standoffs integrated into base
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], 0])
                    cylinder(h = case_thickness, d = screw_head_diameter + 2);
            }
            
            // Temporary pins (when enabled) extending below standoffs for bottom PCB attachment
            if (use_temporary_pins) {
                for (hole = mounting_holes) {
                    translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -pin_height])
                        cylinder(h = pin_height, d = pin_diameter);
                }
            }
            
            // E-ink discrete mount points (60mm each)
            mount_point_length = 60;
            
            // Left mount point - at full case edge, centered on left tendril
            translate([0, (pcb_top + pcb_bottom - mount_point_length) / 2, 0])
            cube([arm_thickness, mount_point_length, case_thickness + arm_length]);
            
            // Right mount point - at full case edge, centered on right tendril  
            translate([case_width - arm_thickness, (pcb_top + pcb_bottom - mount_point_length) / 2, 0])
            cube([arm_thickness, mount_point_length, case_thickness + arm_length]);
            
            // Bottom mount point - at bottom edge of case, full height from ground
            translate([(pcb_left + pcb_right - mount_point_length) / 2, 0, 0])
            cube([mount_point_length, bottom_arm_thickness, case_thickness + arm_length]);
            
            // Connecting tendrils from PCB area to e-ink arms
            // Left tendril - from center of PCB to left arm
            translate([screen_offset_x, (pcb_top + pcb_bottom - tendril_width) / 2, 0])
            cube([pcb_left - screen_offset_x, tendril_width, case_thickness]);
            
            // Right tendril - from center of PCB to right arm  
            translate([pcb_right, (pcb_top + pcb_bottom - tendril_width) / 2, 0])
            cube([screen_offset_x + eink_width - pcb_right, tendril_width, case_thickness]);
            
            // Bottom tendril - from PCB area down to bottom mount point
            translate([(pcb_left + pcb_right - tendril_width) / 2, bottom_arm_thickness, 0])
            cube([tendril_width, pcb_bottom - bottom_arm_thickness, case_thickness]);
            
            // Ribbon fold guide - extends 2.5cm from top of PCB, from middle-2cm to right edge, half thickness
            ribbon_guide_start_x = (pcb_left + pcb_right) / 2 - 20;  // PCB middle - 2cm (40mm/2)
            ribbon_guide_width = pcb_right - ribbon_guide_start_x;  // From start position to right edge
            ribbon_guide_length = 25; // 2.5cm
            ribbon_guide_thickness = case_thickness / 2; // Half the case thickness
            
            translate([ribbon_guide_start_x, pcb_top, 0])
            cube([ribbon_guide_width, ribbon_guide_length, ribbon_guide_thickness]);
            
            // Keyhole material extensions (add material around keyhole areas)
            // Position keyholes exactly 200mm apart (5 × 4cm grid spacing)
            keyhole_spacing = 200;  // Exact 4cm multiple
            case_center_x = case_width / 2;  // Center of case
            keyhole_1_x = case_center_x - keyhole_spacing / 2;  // 100mm left of center
            keyhole_2_x = case_center_x + keyhole_spacing / 2;  // 100mm right of center
            keyhole_y = (pcb_top + pcb_bottom) / 2; // Centered on PCB height
            keyhole_material_width = 25;  // Width of keyhole support material
            keyhole_material_height = 40; // Height of keyhole support material (doubled)
            
            for (keyhole_x = [keyhole_1_x, keyhole_2_x]) {
                translate([keyhole_x - keyhole_material_width/2, keyhole_y - keyhole_material_height/2, 0])
                cube([keyhole_material_width, keyhole_material_height, case_thickness]);
            }
            
        }
        
        // E-ink screen grooves at the proper height
        screen_offset_x = (case_width - eink_width) / 2;
        screen_offset_y = (case_height - eink_height) / 2;
        
        // Grooves for discrete mount points
        mount_point_length = 60;
        
        // Left groove - in left mount point (positioned to match eink_holder screen depth)
        translate([arm_thickness - groove_depth, (pcb_top + pcb_bottom - mount_point_length) / 2, 
                  case_thickness])
            cube([groove_depth, mount_point_length, groove_width]);
        
        // Right groove - in right mount point (positioned to match eink_holder screen depth)
        translate([case_width - arm_thickness, (pcb_top + pcb_bottom - mount_point_length) / 2,
                  case_thickness])
            cube([groove_depth, mount_point_length, groove_width]);

        // Left outer groove - for horizontal case connections
        translate([0, (pcb_top + pcb_bottom - mount_point_length) / 2,
                  case_thickness])
            cube([groove_depth, mount_point_length, groove_width]);

        // Right outer groove - for horizontal case connections
        translate([case_width - groove_depth, (pcb_top + pcb_bottom - mount_point_length) / 2,
                  case_thickness])
            cube([groove_depth, mount_point_length, groove_width]);
        
        // Bottom groove - in bottom mount point (positioned to match eink_holder screen depth)
        translate([(pcb_left + pcb_right - mount_point_length) / 2, bottom_arm_thickness - groove_depth,
                  case_thickness])
            cube([mount_point_length, groove_depth, groove_width]);
        
        // PCB mounting: pins or holes based on parameter
        if (use_temporary_pins) {
            // No holes needed - just pins extending upward from standoffs
        } else {
            // PCB mounting holes (screw clearance)
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -1])
                    cylinder(h = case_thickness + arm_length + 2, d = screw_hole_diameter);
            }
            
            // Round screw head clearance (from bottom)  
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -screw_head_height])
                    cylinder(h = screw_head_height + 1, d = screw_head_diameter);
            }
            
            // Nut traps (from top of standoffs)
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], case_thickness - nut_thickness])
                    cylinder(h = nut_thickness + 1, d = nut_diameter, $fn=6); // Hexagonal nut trap
            }
        }
        
        // Text removed
        
        // Keyhole mounting holes exactly 200mm apart (5 × 4cm grid spacing)
        keyhole_spacing = 200;  // Exact 4cm multiple
        case_center_x = case_width / 2;  // Center of case
        keyhole_1_x = case_center_x - keyhole_spacing / 2;  // 100mm left of center
        keyhole_2_x = case_center_x + keyhole_spacing / 2;  // 100mm right of center
        keyhole_y = (pcb_top + pcb_bottom) / 2; // Centered on PCB height
        
        for (keyhole_x = [keyhole_1_x, keyhole_2_x]) {
            translate([keyhole_x, keyhole_y, 0]) {
                keyhole_mount();
            }
        }
    }
}

complete_case();