// E-ink screen holder for epdiy case
// Based on specifications from instructions.md

include <parameters.scad>

// Discrete mount points instead of continuous arms (material saving design)
module eink_arms() {
    mount_point_length = 60; // Length of each discrete mount point
    
    // Left mount point with groove (centered on left side)
    translate([0, (case_height - mount_point_length) / 2, 0])
    difference() {
        cube([arm_thickness, mount_point_length, arm_length]);
        translate([arm_thickness - groove_depth, 0, (arm_length - groove_width) / 2])
            cube([groove_depth, mount_point_length, groove_width]);
    }
    
    // Right mount point with groove (centered on right side)
    translate([case_width - arm_thickness, (case_height - mount_point_length) / 2, 0])
    difference() {
        cube([arm_thickness, mount_point_length, arm_length]);
        translate([0, 0, (arm_length - groove_width) / 2])
            cube([groove_depth, mount_point_length, groove_width]);
    }
    
    // Bottom mount point with groove (positioned at bottom edge where tendril connects)
    translate([(case_width - mount_point_length) / 2, 0, 0])
    difference() {
        cube([mount_point_length, bottom_arm_thickness, arm_length]);
        translate([0, bottom_arm_thickness - groove_depth, (arm_length - groove_width) / 2])
            cube([mount_point_length, groove_depth, groove_width]);
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