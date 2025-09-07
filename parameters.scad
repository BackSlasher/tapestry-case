// Shared parameters for epdiy case design
// Single source of truth for all dimensions and design parameters

// E-ink screen dimensions (non-active part)
eink_width = 217;
eink_height = 156;
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

// PCB dimensions
pcb_width = 97;
pcb_height = 55;
pcb_thickness = 1.6; // Standard PCB thickness

// Mounting hole positions (relative to PCB origin)
mounting_holes = [
    [27.5, 12],
    [122.5, 12], 
    [27.5, 62],
    [122.5, 62]
];

// Design parameters for e-ink holder
arm_thickness = 6;
arm_length = 10;
groove_depth = 2;
groove_width = eink_thickness + 0.5; // Screen thickness + clearance
wall_height = 1.5;
bottom_arm_thickness = 4;

// Calculate case dimensions to accommodate screen size
case_width = eink_width + 2 * arm_thickness;  // 217 + 12 = 229mm
case_height = eink_height + bottom_arm_thickness; // 156 + 4 = 160mm

// Back structure parameters for e-ink holder
back_thickness = 2;
center_size = 60;
tendril_width = 10;

// PCB holder parameters
screw_hole_diameter = 3.2; // M3 screws
screw_head_diameter = 6;
screw_head_depth = 2;
standoff_height = 5;

// M3 nut parameters  
nut_diameter = 6.4;  // M3 hex nut width across flats (6mm + tolerance)
nut_thickness = 2.5; // M3 nut thickness

// Calculate PCB holder dimensions to encompass all mounting holes
min_hole_x = min([for (hole = mounting_holes) hole[0]]) - 10;
max_hole_x = max([for (hole = mounting_holes) hole[0]]) + 10;
min_hole_y = min([for (hole = mounting_holes) hole[1]]) - 10;
max_hole_y = max([for (hole = mounting_holes) hole[1]]) + 10;

pcb_holder_width = max_hole_x - min_hole_x;
pcb_holder_height = max_hole_y - min_hole_y;

// Complete case parameters
case_thickness = 8; // Total thickness for back-to-back mounting