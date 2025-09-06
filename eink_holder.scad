// E-ink screen holder for epdiy case
// Based on specifications from instructions.md

// E-ink screen dimensions (non-active part)
eink_width = 220;
eink_height = 158;
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
arm_thickness = 6;
arm_length = 10;
groove_depth = 2;
groove_width = eink_thickness + 0.5; // Screen thickness + clearance
wall_height = 1.5;

// Calculate case dimensions to accommodate screen size
case_width = eink_width + 2 * arm_thickness;  // 220 + 12 = 232mm
case_height = eink_height + 4; // 158 + 4 = 162mm (4mm for bottom arm)

module eink_holder() {
    // Parameters for minimized back structure
    back_thickness = 2;
    center_size = 60;
    tendril_width = 10;
    
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
    
    // Left arm with groove
    difference() {
        cube([arm_thickness, case_height, arm_length]);
        translate([arm_thickness - groove_depth, 4, (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - 4, groove_width]);
    }
    
    // Right arm with groove  
    translate([case_width - arm_thickness, 0, 0])
    difference() {
        cube([arm_thickness, case_height, arm_length]);
        translate([0, 4, (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - 4, groove_width]);
    }
    
    // Bottom arm with groove (thinner than sides)
    bottom_arm_thickness = 4;
    difference() {
        cube([case_width, bottom_arm_thickness, arm_length]);
        translate([arm_thickness, bottom_arm_thickness - groove_depth, (arm_length - groove_width) / 2])
            cube([case_width - 2*arm_thickness, groove_depth, groove_width]);
    }
}

eink_holder();