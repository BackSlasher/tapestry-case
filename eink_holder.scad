// E-ink screen holder for epdiy case
// Based on specifications from instructions.md

include <parameters.scad>

// Just the e-ink arms with grooves (no back structure)
module eink_arms() {
    // Left arm with groove
    difference() {
        cube([arm_thickness, case_height, arm_length]);
        translate([arm_thickness - groove_depth, bottom_arm_thickness, (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - bottom_arm_thickness, groove_width]);
    }
    
    // Right arm with groove  
    translate([case_width - arm_thickness, 0, 0])
    difference() {
        cube([arm_thickness, case_height, arm_length]);
        translate([0, bottom_arm_thickness, (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - bottom_arm_thickness, groove_width]);
    }
    
    // Bottom arm with groove (thinner than sides)
    difference() {
        cube([case_width, bottom_arm_thickness, arm_length]);
        translate([arm_thickness, bottom_arm_thickness - groove_depth, (arm_length - groove_width) / 2])
            cube([case_width - 2*arm_thickness, groove_depth, groove_width]);
    }
}

// Full e-ink holder with back structure (for standalone printing)
module eink_holder() {
    // Central back plate (for PCB mounting)
    translate([(case_width - center_size) / 2, (case_height - center_size) / 2, 0])
        cube([center_size, center_size, back_thickness]);
    
    // Tendril to left arm (extends from center to left arm)
    translate([0, (case_height - tendril_width) / 2, 0])
        cube([(case_width - center_size) / 2 + center_size / 2, tendril_width, back_thickness]);
    
    // Tendril to right arm (extends from center to right arm)
    translate([(case_width - center_size) / 2 + center_size, (case_height - tendril_width) / 2, 0])
        cube([(case_width - center_size) / 2, tendril_width, back_thickness]);
    
    // Tendril to bottom arm (extends from center to bottom arm)
    translate([(case_width - tendril_width) / 2, 0, 0])
        cube([tendril_width, (case_height - center_size) / 2 + center_size / 2, back_thickness]);
    
    // Add the arms
    translate([0, 0, back_thickness])
    eink_arms();
}

eink_holder();