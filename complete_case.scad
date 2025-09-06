// Complete case for epdiy - back-to-back design
// E-ink screen on front, PCB mounted on back, minimal ribbon travel

include <parameters.scad>

module complete_case() {
    // E-ink screen positioning (centered in case)
    screen_offset_x = (case_width - eink_width) / 2;
    screen_offset_y = (case_height - eink_height) / 2;
    
    // PCB positioned back-to-back with screen (directly behind it)
    // Center PCB within the screen area for back-to-back mounting
    pcb_offset_x = screen_offset_x + (eink_width - pcb_width) / 2;
    pcb_offset_y = screen_offset_y + (eink_height - pcb_height) / 2;
    
    difference() {
        union() {
            // PCB mounting area (unified base structure) 
            pcb_left = pcb_offset_x + min([for (hole = mounting_holes) hole[0]]) - 8;
            pcb_right = pcb_offset_x + max([for (hole = mounting_holes) hole[0]]) + 8;
            pcb_bottom = pcb_offset_y + min([for (hole = mounting_holes) hole[1]]) - 8;
            pcb_top = pcb_offset_y + max([for (hole = mounting_holes) hole[1]]) + 8;
            
            translate([pcb_left, pcb_bottom, 0])
            cube([pcb_right - pcb_left, pcb_top - pcb_bottom, case_thickness]);
            
            // PCB standoffs integrated into base
            for (hole = mounting_holes) {
                translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], 0])
                    cylinder(h = case_thickness, d = screw_head_diameter + 2);
            }
            
            // E-ink arms extending from base to full height (connected structure)
            // Open edge away from 0 axis - so arms are on left, right, and top (not bottom)
            
            // Left arm - full height from base to screen level
            translate([screen_offset_x, screen_offset_y, 0])
            cube([arm_thickness, eink_height, case_thickness + arm_length]);
            
            // Right arm - full height from base to screen level  
            translate([screen_offset_x + eink_width - arm_thickness, screen_offset_y, 0])
            cube([arm_thickness, eink_height, case_thickness + arm_length]);
            
            // Top arm - full height from base to screen level (was bottom arm)
            translate([screen_offset_x, screen_offset_y, 0])
            cube([eink_width, bottom_arm_thickness, case_thickness + arm_length]);
            
            // Connecting tendrils from PCB area to e-ink arms
            // Left tendril - from PCB to left arm
            translate([screen_offset_x, (screen_offset_y + screen_offset_y + eink_height - tendril_width) / 2, 0])
            cube([pcb_left - screen_offset_x, tendril_width, case_thickness]);
            
            // Right tendril - from PCB to right arm  
            translate([pcb_right, (screen_offset_y + screen_offset_y + eink_height - tendril_width) / 2, 0])
            cube([screen_offset_x + eink_width - pcb_right, tendril_width, case_thickness]);
            
            // Top tendril - from PCB to top arm
            translate([(pcb_left + pcb_right - tendril_width) / 2, screen_offset_y, 0])
            cube([tendril_width, pcb_bottom - screen_offset_y, case_thickness]);
        }
        
        // E-ink screen grooves at the proper height
        screen_offset_x = (case_width - eink_width) / 2;
        screen_offset_y = (case_height - eink_height) / 2;
        
        // Left groove
        translate([screen_offset_x + arm_thickness - groove_depth, screen_offset_y, 
                  case_thickness + (arm_length - groove_width) / 2])
            cube([groove_depth, eink_height, groove_width]);
        
        // Right groove
        translate([screen_offset_x + eink_width - arm_thickness, screen_offset_y,
                  case_thickness + (arm_length - groove_width) / 2])
            cube([groove_depth, eink_height, groove_width]);
        
        // Top groove
        translate([screen_offset_x + arm_thickness, screen_offset_y + bottom_arm_thickness - groove_depth,
                  case_thickness + (arm_length - groove_width) / 2])
            cube([eink_width - 2*arm_thickness, groove_depth, groove_width]);
        
        // PCB mounting holes
        for (hole = mounting_holes) {
            translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -1])
                cylinder(h = case_thickness + 2, d = screw_hole_diameter);
                
            translate([pcb_offset_x + hole[0], pcb_offset_y + hole[1], -1])
                cylinder(h = screw_head_depth + 1, d = screw_head_diameter);
        }
    }
}

complete_case();