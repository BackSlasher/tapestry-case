We're working on a case that holds a pcb on one end, and a e-ink screen on the other.
There is a ribbon connecting the two.

# PCB
Width: 97mm, height: 55mm
PCB kicad url: `https://vroland.github.io/epdiy-hardware/boards/epdiy-v7.kicad_pcb`

Mounting holes location relative to the pcb:
27.5mm x, 12mm y
122.5mm x, 12mm y
27.5mm x, 62mm y
122.5mm x, 62mm y

The PCB plate should have no walls.
The ribbon is connecting on one of the wide sides (97mm), 7mm from the corner.

# Eink
There is a dimension of the eink including the non-active part:
Width: 220mm
Height: 158mm

The active part:
12mm from the left of the non-active part
12mm from the top of the non-active part
Width: 202.8mm
Height: 139.4mm 

Above the screen, there is a thicker ribbon. 
Width: 182mm 
Height: 20mm
It starts 20mm to the left of the non-active part, sticking from the top.

Above the thicker ribbon, the riboon connecting to the pcb exists.
The ribbon starts 20mm to the left of the thicker ribbon.
Width: 17mm
Height: 20mm

The screen's front side should be visible

# Instructions
I want you to create a case to hold both components, so that the pcb is on the back of the e-ink screen, and the e-ink screen is on the back of the pcb.
The pcb will be mounted using screws, with the mounting holes as above.
The screen will be slided into place from the top, as there are no mounting holes
Screen and pcb holder will be positioned so that the ribbon connecting the two will easily reach both.

## Design Implementation Notes

### E-ink Holder Design
The e-ink holder should use a minimal arm design:
- **Three arms**: Left (6mm thick), right (6mm thick), and bottom (4mm thick)
- **Arm length**: 10mm extending from the screen edge
- **Groove system**: Each arm has a centered groove (2mm deep) with 1.5mm walls on each side to securely hold the screen edges
- **No window**: The active area should be fully exposed (no covering window)
- **Back structure**: Central mounting area (60×60mm) connected to arms via thin tendrils (10mm wide)
- **Thickness**: 2mm for back plate and tendrils
- **Screen thickness**: Assume 2mm + 0.5mm clearance

### PCB Holder Design  
- **Mounting**: Use the specified hole positions exactly as given in instructions
- **No walls**: PCB holder is a flat mounting plate only
- **Ribbon cutout**: 20×10mm opening at 7mm from corner on 97mm side
- **Standoffs**: 5mm high with M3 screw holes and countersink for screw heads

### Build System
- Use OpenSCAD for 3D modeling
- Include Makefile for automatic STL generation
- Separate files: `eink_holder.scad`, `pcb_holder.scad`, `complete_case.scad`

### Key Lessons Learned
- KiCad PCB file may be incomplete - use the mounting hole specifications from instructions
- Ensure tendril connections are properly calculated to connect center to arms
- Groove positioning should be centered in arms, not at bottom or top
- Minimal material usage while maintaining structural integrity
