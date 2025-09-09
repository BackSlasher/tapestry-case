// Keyhole hanging test piece for IKEA pins
// Pin head diameter: 19mm
// This is a test piece to verify the keyhole mechanism works

// Parameters for IKEA pin
pin_head_diameter = 19;      // Wide part of pin
pin_shaft_diameter = 8;      // Estimated shaft diameter (narrower part)
clearance = 1;               // Extra clearance for easy insertion

// Keyhole dimensions
wide_opening = pin_head_diameter + clearance;   // 20mm - for pin head entry/exit
narrow_slot = pin_shaft_diameter + clearance;   // 9mm - for pin shaft to rest in
slot_length = 15;            // Length of narrow slot
material_thickness = 8;      // Total thickness of test piece (3+3+2=8mm for the three layers)

// Test piece dimensions  
test_width = 60;
test_height = 50;  // Increased height to provide more padding at top

module keyhole() {
    layer1_thickness = 3.5;  // Layer 1: Original keyhole (narrow slot + wide opening) - extra clearance
    layer2_thickness = 3.5;  // Layer 2: Full pin head width opening - extra clearance
    layer3_thickness = 2;    // Layer 3: Solid material (pin stop)
    
    // Layer 1: Original keyhole design (top layer) - opening faces positive Z
    translate([0, 0, material_thickness/2]) {
        // Wide circular opening at bottom
        translate([0, -wide_opening/2 + 5, -layer1_thickness/2])
            cylinder(h = layer1_thickness + 0.1, d = wide_opening, center = true);
        
        // Narrow slot extending upward
        translate([0, slot_length/2 + 5, -layer1_thickness/2])
            cube([narrow_slot, slot_length, layer1_thickness + 0.1], center = true);
        
        // Smooth transition between wide and narrow
        hull() {
            translate([0, -wide_opening/2 + 5, -layer1_thickness/2])
                cylinder(h = layer1_thickness + 0.1, d = wide_opening, center = true);
            translate([0, 5, -layer1_thickness/2])
                cube([narrow_slot, 1, layer1_thickness + 0.1], center = true);
        }
    }
    
    // Layer 2: Full pin head width opening (middle layer) - opening faces positive Z
    translate([0, 0, material_thickness/2 - layer1_thickness]) {
        hull() {
            translate([0, -wide_opening/2 + 5, -layer2_thickness/2])
                cylinder(h = layer2_thickness + 0.1, d = wide_opening, center = true);
            translate([0, slot_length/2 + 5, -layer2_thickness/2])
                cylinder(h = layer2_thickness + 0.1, d = wide_opening, center = true);
        }
    }
    
    // Layer 3: No opening - solid material (pin stop) - no cuts for this layer
}

module keyhole_test_piece() {
    difference() {
        // Base test piece
        cube([test_width, test_height, material_thickness], center = true);
        
        // Single keyhole in center for testing
        translate([0, 0, 0])
            keyhole();
        
        // Optional: second keyhole offset for comparison testing
        // translate([25, 0, 0])
        //     keyhole();
    }
}

// Main test piece
keyhole_test_piece();

// Optional: Show pin outline for reference (comment out for printing)
// %translate([0, -5, material_thickness/2 + 2]) {
//     color("red") cylinder(h = 2, d = pin_head_diameter);
//     color("blue") cylinder(h = 8, d = pin_shaft_diameter);
// }