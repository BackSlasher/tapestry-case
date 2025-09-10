// Raspberry Pi 4 Model B Wall Holder - Clean Design
// RPi support floor + keyhole mounting on sides

// RPi4 dimensions (rotated 90 degrees for better keyhole clearance)
rpi_length = 56;      // 56mm length (parallel to keyholes)
rpi_width = 85;       // 85mm width (perpendicular to keyholes)  
rpi_thickness = 1.5;  // PCB thickness

// RPi mounting hole positions (rotated 90 degrees)
mounting_holes = [
    [3.5, 3.5],    // Bottom-left
    [3.5, 61.5],   // Bottom-right  
    [52.5, 3.5],   // Top-left
    [52.5, 61.5]   // Top-right
];

// Basic case parameters
case_base_thickness = 3;
standoff_height = 5;
rpi_margin = 5;  // Small margin around RPi

// RPi support floor dimensions (just RPi + small margin)
rpi_floor_length = rpi_length + 2 * rpi_margin;  // ~66mm
rpi_floor_width = rpi_width + 2 * rpi_margin;    // ~95mm

// Keyhole parameters (matching complete_case.scad)
pin_head_diameter = 19;
pin_shaft_diameter = 8;
clearance = 1;
wide_opening = pin_head_diameter + clearance;   // 20mm
narrow_slot = pin_shaft_diameter + clearance;   // 9mm
slot_length = 15;

// Keyhole layer thicknesses (matching complete_case.scad)
layer1_thickness = 3.5;  // Wide opening layer
layer2_thickness = 3.5;  // Keyhole shape layer
layer3_thickness = 2;    // Solid stop layer

module keyhole_mount() {
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

module rpi4_holder() {
    // Calculate keyhole spacing to be multiple of 4cm
    keyhole_spacing = 80; // 2 × 4cm = 80mm  
    keyhole_tab_width = 25;
    keyhole_tab_height = 30;
    
    // Total case length = RPi floor + keyhole tabs on sides
    total_case_length = rpi_floor_length + 2 * keyhole_tab_width;
    
    // Define shared variables once at module level
    rpi_floor_offset_x = (total_case_length - rpi_floor_length) / 2;
    keyhole_1_x = keyhole_tab_width / 2;
    keyhole_2_x = total_case_length - keyhole_tab_width / 2;
    keyhole_y = rpi_floor_width / 2;
    keyhole_tab_actual_height = keyhole_tab_height + 2 * 20; // keyhole height + 2cm above + 2cm below
    
    difference() {
        union() {
            // 1. RPi support area (centered in total case length)
            translate([rpi_floor_offset_x, 0, 0])
            cube([rpi_floor_length, rpi_floor_width, case_base_thickness]);
            
            // 2. RPi mounting standoffs
            for (hole = mounting_holes) {
                translate([rpi_floor_offset_x + rpi_margin + hole[0], rpi_margin + hole[1], case_base_thickness])
                cylinder(h = standoff_height, d = 6, $fn = 30);
            }
            
            // 3. Left keyhole tab (just keyhole + 2cm margins above/below)
            translate([keyhole_1_x - keyhole_tab_width/2, keyhole_y - keyhole_tab_actual_height/2, 0])
            cube([keyhole_tab_width, keyhole_tab_actual_height, case_base_thickness]);
            
            // 4. Right keyhole tab (just keyhole + 2cm margins above/below)
            translate([keyhole_2_x - keyhole_tab_width/2, keyhole_y - keyhole_tab_actual_height/2, 0])
            cube([keyhole_tab_width, keyhole_tab_actual_height, case_base_thickness]);
        }
        
        // RPi mounting holes (M2.5 screws)
        for (hole = mounting_holes) {
            translate([rpi_floor_offset_x + rpi_margin + hole[0], rpi_margin + hole[1], -1])
            cylinder(h = case_base_thickness + standoff_height + 2, d = 2.7, $fn = 20);
            
            // Countersink for screw heads
            translate([rpi_floor_offset_x + rpi_margin + hole[0], rpi_margin + hole[1], case_base_thickness + standoff_height - 1])
            cylinder(h = 2, d1 = 2.7, d2 = 5, $fn = 20);
        }
        
        // Keyhole mounting holes
        for (keyhole_x = [keyhole_1_x, keyhole_2_x]) {
            translate([keyhole_x, keyhole_y, 0]) {
                keyhole_mount();
            }
        }
        
        // Ventilation holes (only within RPi floor area)
        vent_spacing = 8;
        for (x = [rpi_floor_offset_x + rpi_margin + 8 : vent_spacing : rpi_floor_offset_x + rpi_floor_length - rpi_margin - 8]) {
            for (y = [rpi_margin + 8 : vent_spacing : rpi_floor_width - rpi_margin - 8]) {
                translate([x, y, -1])
                cylinder(h = case_base_thickness + 2, d = 3, $fn = 20);
            }
        }
        
        // No material reduction cutouts - keep solid keyhole tabs
    }
}

rpi4_holder();