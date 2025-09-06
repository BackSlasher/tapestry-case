// E-ink screen holder for epdiy case
// Based on specifications from instructions.md

// E-ink screen dimensions (non-active part)
eink_width = 220;
eink_height = 196;
eink_thickness = 2; // Assumed thickness

// Active part dimensions
active_offset_x = 12;
active_offset_y = 12;
active_width = 202.8;
active_height = 139.4;

// Thicker ribbon dimensions
thick_ribbon_width = 182;
thick_ribbon_height = 20;
thick_ribbon_offset_x = 20; // from left of non-active part

// PCB connection ribbon dimensions  
pcb_ribbon_width = 17;
pcb_ribbon_height = 20;
pcb_ribbon_offset_x = 20; // from left of thicker ribbon

// Holder parameters
arm_thickness = 6; // Reduced from 10
arm_length = 10; // Reduced from 15
groove_depth = 2; // Reduced from 3
groove_width = eink_thickness + 0.5; // Screen thickness + clearance
wall_height = 1.5; // Reduced from 2

module eink_holder() {
    // Parameters for minimized back structure
    back_thickness = 2; // Reduced from 3
    center_size = 60; // Reduced from 80
    tendril_width = 10; // Reduced from 15
    
    // Central back plate (for PCB mounting)
    translate([(eink_width - center_size) / 2, (eink_height - center_size) / 2, 0])
        cube([center_size, center_size, back_thickness]);
    
    // Tendril to left arm (extends from center to left arm)
    translate([0, (eink_height - tendril_width) / 2, 0])
        cube([(eink_width - center_size) / 2 + center_size / 2, tendril_width, back_thickness]);
    
    // Tendril to right arm (extends from center to right arm)
    translate([(eink_width - center_size) / 2 + center_size, (eink_height - tendril_width) / 2, 0])
        cube([(eink_width - center_size) / 2, tendril_width, back_thickness]);
    
    // Tendril to bottom arm (extends from center to bottom arm)
    translate([(eink_width - tendril_width) / 2, 0, 0])
        cube([tendril_width, (eink_height - center_size) / 2 + center_size / 2, back_thickness]);
    
    // Left arm with groove
    difference() {
        cube([arm_thickness, eink_height, arm_length]);
        translate([arm_thickness - groove_depth, 0, (arm_length - groove_width) / 2])
            cube([groove_depth, eink_height, groove_width]);
    }
    
    // Right arm with groove  
    translate([eink_width - arm_thickness, 0, 0])
    difference() {
        cube([arm_thickness, eink_height, arm_length]);
        translate([0, 0, (arm_length - groove_width) / 2])
            cube([groove_depth, eink_height, groove_width]);
    }
    
    // Bottom arm with groove (thinner than sides)
    bottom_arm_thickness = 4; // Reduced from 5
    difference() {
        cube([eink_width, bottom_arm_thickness, arm_length]);
        translate([0, bottom_arm_thickness - groove_depth, (arm_length - groove_width) / 2])
            cube([eink_width, groove_depth, groove_width]);
    }
}

eink_holder();