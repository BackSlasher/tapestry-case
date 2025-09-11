// PSU Model - to understand the exact shape
// Based on your description:
// Side is 9cm long with this profile:
//       /---|
//  ----/    |
// |         |
// ----------
// Short part: 4cm long, 2.5cm high
// Ramp: 1cm long  
// Tall part: 3cm long, 3.5cm high
// Width: 14cm
// Power socket on right side of tall part

// PSU dimensions
psu_length = 90;        // 9cm side length
psu_width = 140;        // 14cm width  
psu_short_height = 25;  // 2.5cm high (short part)
psu_tall_height = 35;   // 3.5cm high (tall part)
psu_short_length = 40;  // 4cm long (short part)
psu_ramp_length = 10;   // 1cm long (ramp)
psu_tall_length = 30;   // 3cm long (tall part) - calculated: 90-40-10=40, but you said 3cm, so using 30

module psu_model() {
    union() {
        // Short part (left side)
        translate([0, 0, 0])
        cube([psu_short_length, psu_width, psu_short_height]);
        
        // Ramp part (middle) - angled transition
        translate([psu_short_length, 0, 0])
        hull() {
            // Bottom of ramp (same height as short part)
            cube([0.1, psu_width, psu_short_height]);
            // Top of ramp (same height as tall part)  
            translate([psu_ramp_length, 0, 0])
            cube([0.1, psu_width, psu_tall_height]);
        }
        
        // Tall part (right side) - with socket cutout
        difference() {
            translate([psu_short_length + psu_ramp_length, 0, 0])
            cube([psu_tall_length, psu_width, psu_tall_height]);
            
            // Power socket cutout (on right side panel of tall part)
            socket_width = 25;
            socket_height = 15;
            socket_depth = 5;  // Depth of cutout
            
            // Position in center of tall section's left panel (opposite side)
            translate([psu_short_length + psu_ramp_length + (psu_tall_length - socket_width)/2, 
                      -1, 
                      psu_tall_height/2 - socket_height/2])
            cube([socket_width, socket_depth + 1, socket_height]);
        }
        
        // USB ports representation (on top of short part - low area)
        for (i = [0:7]) {
            translate([5 + i * 4.5, psu_width/2 - 5, psu_short_height])
            cube([4, 10, 3]);
        }
    }
}

// Show the PSU model
psu_model();