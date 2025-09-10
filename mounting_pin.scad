// Correct IKEA-style mounting pin based on actual design
// Symmetrical double-disc design with T-mechanism on one side

// Main pin parameters
head_disk_diameter = 18;        // Main head disks
head_disk_thickness = 2.5;      // Thickness of each disk (reduced by 0.5mm)
connecting_pipe_length = 15;    // 1.5cm pipe between disks
connecting_pipe_diameter = 8;   // 0.8cm pipe diameter

// T-mechanism parameters (on one disk)
t_pipe_diameter = 4;            // T stem diameter
t_pipe_height = 5;              // T stem height (without arms)
t_arms_total_length = 20;       // Total arm span (2cm)
t_arm_thickness = 2;            // Thickness of T arms

// Small nub parameters
nub_diameter = 4;               // 4mm nub
nub_height = 2;                 // 2mm high

module ikea_pin() {
    union() {
        // Bottom disk (plain)
        translate([0, 0, 0])
        cylinder(h = head_disk_thickness, d = head_disk_diameter, $fn = 50);
        
        // Connecting pipe
        translate([0, 0, head_disk_thickness])
        cylinder(h = connecting_pipe_length, d = connecting_pipe_diameter, $fn = 30);
        
        // Top disk (with mechanisms)
        translate([0, 0, head_disk_thickness + connecting_pipe_length])
        cylinder(h = head_disk_thickness, d = head_disk_diameter, $fn = 50);
        
        // Small nub (positioned at 12 o'clock)
        translate([0, head_disk_diameter/3, head_disk_thickness + connecting_pipe_length + head_disk_thickness]) {
            cylinder(h = nub_height, d = nub_diameter, $fn = 20);
        }
        
        // T-mechanism on top disk (positioned at 6 o'clock, opposite to nub)
        translate([0, -head_disk_diameter/4, head_disk_thickness + connecting_pipe_length + head_disk_thickness]) {
            // T stem (extended higher to blend with arms)
            cylinder(h = t_pipe_height + t_pipe_diameter/2, d = t_pipe_diameter, $fn = 30);
            
            // T arms (cylindrical, each 0.5cm long, positioned to blend with stem)
            translate([0, 0, t_pipe_height + t_pipe_diameter/2]) {
                // Left arm
                translate([-5, 0, 0])
                rotate([0, 90, 0])
                cylinder(h = 5, d = t_pipe_diameter, $fn = 20);
                
                // Right arm  
                translate([0, 0, 0])
                rotate([0, 90, 0])
                cylinder(h = 5, d = t_pipe_diameter, $fn = 20);
            }
        }
    }
}

ikea_pin();