// Complete case for epdiy - back-to-back design
// E-ink screen on front, PCB mounted on back, minimal ribbon travel

// E-ink screen dimensions
eink_width = 220;
eink_height = 158;

// Calculate case dimensions to accommodate screen size
case_width = eink_width + 2 * 6;  // 220 + 12 = 232mm  
case_height = eink_height + 4;    // 158 + 4 = 162mm
eink_thickness = 2;

// PCB dimensions
pcb_width = 97;
pcb_height = 55;

// Mounting hole positions
mounting_holes = [
    [27.5, 12],
    [122.5, 12], 
    [27.5, 62],
    [122.5, 62]
];

// Design parameters
arm_thickness = 6;
arm_length = 10;
groove_depth = 2;
groove_width = eink_thickness + 0.5;
case_thickness = 8; // Total thickness for back-to-back mounting

module complete_case() {
    pcb_offset_x = (case_width - pcb_width) / 2;
    pcb_offset_y = (case_height - pcb_height) / 2;
    tendril_width = 10;
    
    difference() {
        union() {
            // Solid PCB mounting area - sized to encompass all standoffs
            // Calculate bounds from mounting holes
            min_x = min([for (hole = mounting_holes) hole[0]]) - 10;
            max_x = max([for (hole = mounting_holes) hole[0]]) + 10;
            min_y = min([for (hole = mounting_holes) hole[1]]) - 10;
            max_y = max([for (hole = mounting_holes) hole[1]]) + 10;
            
            translate([pcb_offset_x + min_x, pcb_offset_y + min_y, 0])
            cube([max_x - min_x, max_y - min_y, case_thickness]);
            
            // PCB mounting standoffs (integrated into base)
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], 0])
                    cylinder(h = case_thickness, d = 8);
            }
            
            // E-ink arms extending from front face
            // Left arm
            cube([arm_thickness, case_height, case_thickness + arm_length]);
            
            // Right arm
            translate([case_width - arm_thickness, 0, 0])
            cube([arm_thickness, case_height, case_thickness + arm_length]);
            
            // Bottom arm
            cube([case_width, 4, case_thickness + arm_length]);
            
            // Tendrils connecting PCB area to e-ink arms
            pcb_left = pcb_offset_x + min_x;
            pcb_right = pcb_offset_x + max_x;
            pcb_bottom = pcb_offset_y + min_y;
            
            // Tendril to left arm
            translate([0, (case_height - tendril_width) / 2, 0])
            cube([pcb_left, tendril_width, case_thickness]);
            
            // Tendril to right arm  
            translate([pcb_right, (case_height - tendril_width) / 2, 0])
            cube([case_width - arm_thickness - pcb_right, tendril_width, case_thickness]);
            
            // Tendril to bottom arm
            translate([(case_width - tendril_width) / 2, 0, 0])
            cube([tendril_width, pcb_bottom, case_thickness]);
        }
        
        // E-ink arm grooves (full height for screen insertion)
        // Left groove (inside face of left arm)
        translate([arm_thickness - groove_depth, 4, case_thickness + (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - 4, groove_width]);
        
        // Right groove (inside face of right arm) 
        translate([case_width - arm_thickness, 4, case_thickness + (arm_length - groove_width) / 2])
            cube([groove_depth, case_height - 4, groove_width]);
        
        // Bottom groove (inside face of bottom arm)
        translate([arm_thickness, 4 - groove_depth, case_thickness + (arm_length - groove_width) / 2])
            cube([case_width - 2*arm_thickness, groove_depth, groove_width]);
        
        // PCB mounting holes through standoffs
        for (hole = mounting_holes) {
            translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -1])
                cylinder(h = case_thickness + 2, d = 3.2);
        }
    }
}

complete_case();