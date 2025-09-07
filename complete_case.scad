// Complete case for epdiy - back-to-back design
// E-ink screen on front, PCB mounted on back, minimal ribbon travel

include <parameters.scad>

module complete_case() {
    // E-ink screen positioning (centered in case)
    screen_offset_x = (case_width - eink_width) / 2;
    screen_offset_y = (case_height - eink_height) / 2;
    
    // PCB positioned back-to-back with screen (positioned on left side)
    pcb_offset_x = screen_offset_x;
    pcb_offset_y = screen_offset_y + (eink_height - pcb_height) / 2 + 15;
    
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
    }
}

complete_case();