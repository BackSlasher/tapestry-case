// Parameters for ED060XC3 E-ink screen case design
// ED060XC3 specifications: 10cm × 14cm screen with top ribbon

// E-ink screen dimensions (ED060XC3)
eink_width = 135;     // 13.5cm width (reduced by 5mm)
eink_height = 100;    // 10cm height  
eink_thickness = 2;   // Assumed thickness

// Active part dimensions (estimated based on typical margins)
active_offset_x = 8;  // Estimated margin
active_offset_y = 8;  // Estimated margin
active_width = 124;   // Screen width - margins
active_height = 84;   // Screen height - margins

// Ribbon connection (located on top facet, 0.5cm from top-right corner)
ribbon_offset_from_right = 5;  // 0.5cm from right edge
ribbon_offset_from_top = 0;    // On the top edge
ribbon_width = 17;             // Estimated ribbon width
ribbon_height = 20;            // Estimated ribbon height

// PCB dimensions (reuse existing PCB from original design)
pcb_width = 97;
pcb_height = 55;
pcb_thickness = 1.6; // Standard PCB thickness

// Mounting hole positions (relative to PCB origin - reuse from original)
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
groove_width = eink_thickness + 1.0; // Screen thickness + clearance
wall_height = 1.5;
bottom_arm_thickness = 4;

// Calculate case dimensions to accommodate new screen size
case_width = eink_width + 2 * arm_thickness;   // 135 + 12 = 147mm
case_height = eink_height + bottom_arm_thickness; // 100 + 4 = 104mm

// Back structure parameters for e-ink holder
back_thickness = 2;
center_size = 60;
tendril_width = 10;

// PCB holder parameters
screw_hole_diameter = 2.4; // M2 screws (2mm + clearance)
screw_head_diameter = 4;   // M2 round head diameter  
screw_head_height = 1.4;   // M2 round head height (above surface)
standoff_height = 5;

// M2 nut parameters  
nut_diameter = 4.4;  // M2 hex nut width across flats (4mm + tolerance)
nut_thickness = 1.6; // M2 nut thickness

// Temporary assembly option (while waiting for screws)
use_temporary_pins = false;  // Set to false for screw holes, true for temporary pins
pin_diameter = 2.0;         // Pin diameter (fits through 2.2mm PCB holes)  
pin_height = 3;             // Pin height above standoff

// Calculate PCB holder dimensions to encompass all mounting holes
min_hole_x = min([for (hole = mounting_holes) hole[0]]) - 10;
max_hole_x = max([for (hole = mounting_holes) hole[0]]) + 10;
min_hole_y = min([for (hole = mounting_holes) hole[1]]) - 10;
max_hole_y = max([for (hole = mounting_holes) hole[1]]) + 10;

pcb_holder_width = max_hole_x - min_hole_x;
pcb_holder_height = max_hole_y - min_hole_y;

// Complete case parameters
case_thickness = 4; // Total thickness for back-to-back mounting (reduced by half)