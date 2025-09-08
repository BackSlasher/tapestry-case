# EPDiy Case Design Project

## Overview
Created a 3D printed case system for EPDiy project that holds an e-ink screen and PCB connected by ribbon cable.

## Design Components

### E-ink Holder (`eink_holder.scad`)
- **Minimal arm design**: 3 discrete 60mm mount points (left: 6mm, right: 6mm, bottom: 4mm thick)
- **Groove system**: 2mm deep grooves positioned at top of arms for 2.5mm screen thickness + clearance
- **No window**: Active area fully exposed for visibility
- **Back structure**: 60×60mm central mounting area connected via 10mm wide tendrils
- **Dimensions**: 10mm arm length, 2mm back plate thickness
- **Screen specs**: 216×156mm (`eink_width` × `eink_height`), assumes 2mm thickness + 0.5mm clearance
- **Case dimensions**: 228×160mm (`case_width` × `case_height`) to accommodate screen + arms

### PCB Holder (`pcb_holder.scad`) 
- **Mounting**: 4 standoffs at positions (27.5,12), (122.5,12), (27.5,62), (122.5,62)
- **Configurable system**: Supports both M2 screws with nut traps OR temporary pins (`use_temporary_pins` parameter)
- **Dimensions**: 138.5×78mm base to encompass all mounting holes with 10mm margins
- **Hardware**: M2 screws (2.4mm clearance), 5mm standoffs, or 2mm diameter pins

### Complete Case (`complete_case.scad`)
- **Integrated design**: Single-piece case combining e-ink holder and PCB mounting
- **Back-to-back mounting**: E-ink screen on front, PCB mounted on back side
- **PCB positioning**: Left-aligned with screen area + 5mm right, offset +12mm higher for proper ribbon routing
- **Tendril system**: Connections originate from center of PCB area to arms
- **Arm positioning**: Left/right arms at case edges (x=0, x=228mm), bottom arm at case bottom (y=0)
- **Case thickness**: 8mm base provides structural integrity for integrated design
- **Groove positioning**: Located at `case_thickness` height for proper screen seating
- **Ribbon fold guide**: 2.5cm extension from PCB top, spans from PCB center-2cm to right edge
- **Text branding**: "digink" text sunken into front face, centered on PCB holder area

### Additional Components
- **Keyhole Test (`keyhole_test.scad`)**: Wall mounting test piece for IKEA pins (19mm head diameter)
- **Parameters (`parameters.scad`)**: Centralized parameter definitions for all components

### Build System
- **OpenSCAD workflow**: Separate .scad files for each component
- **Makefile**: Automated STL generation (`make` builds eink_holder.stl)
- **Visualization**: Top-view PNG rendering for design verification

## Key Lessons Learned
- **Groove positioning critical**: Complete case initially had grooves too high - must position at `case_thickness` height for proper screen seating
- **Arm spacing matters**: Complete case initially had arms too close together (211mm vs 222mm) - must match eink_holder spacing
- **PCB positioning requires iteration**: Found PCB needed +15mm higher offset for proper ribbon cable routing
- **Tendril origin matters**: Tendrils should originate from center of PCB area, not screen edges, for cleaner design
- **Visual verification essential**: Top-view PNG renders critical for catching alignment issues
- **Parameter consistency**: Centralized `parameters.scad` prevents inconsistencies between components
- **Modular vs integrated**: Both standalone components and integrated complete case serve different use cases

## Recent Updates
- Fixed complete case groove positioning and arm spacing to match working `eink_holder`
- Repositioned PCB +12mm higher and +5mm right with tendrils centered on PCB area  
- Updated arm positions to align with centered tendrils
- Added ribbon fold guide for consistent cable management (2.5cm × asymmetric width)
- Added "digink" branding text sunken into front face
- Fine-tuned screen width from 217mm to 216mm for better fit
- Added comprehensive `complete_case.scad` documentation
- All renders now saved to ./llm-pngs/ directory

## Current Status
- **E-ink holder**: Working design, successfully printed and tested
- **Complete case**: Multiple iterations printed with incremental improvements - groove positioning, PCB placement, ribbon guide, and branding complete
- **PCB holder**: Completed with configurable pin/screw mounting options (M2 hardware)
- **Parameters**: Centralized and documented for all components, screen width refined to 216mm