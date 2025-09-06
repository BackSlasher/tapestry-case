# EPDiy Case Design Project

## Overview
Created a 3D printed case system for EPDiy project that holds an e-ink screen and PCB connected by ribbon cable.

## Design Components

### E-ink Holder (`eink_holder.scad`)
- **Minimal arm design**: 3 arms (left: 6mm, right: 6mm, bottom: 4mm thick)
- **Groove system**: 2mm deep grooves centered in arms with 1.5mm walls on each side
- **No window**: Active area fully exposed for visibility
- **Back structure**: 60×60mm central mounting area connected via 10mm wide tendrils
- **Dimensions**: 10mm arm length, 2mm back plate thickness
- **Screen specs**: 220×196mm total, assumes 2mm thickness + 0.5mm clearance

### PCB Holder (`pcb_holder.scad`) 
- **Mounting**: 4 standoffs at positions (27.5,12), (122.5,12), (27.5,62), (122.5,62)
- **No ribbon window**: Ribbon loops up and around (no direct cutout needed)
- **Dimensions**: 138.5×78mm base to encompass all mounting holes
- **Hardware**: M3 screws, 5mm standoffs with countersink

### Build System
- **OpenSCAD workflow**: Separate .scad files for each component
- **Makefile**: Automated STL generation (`make` builds eink_holder.stl)
- **Visualization**: Top-view PNG rendering for design verification

## Key Lessons Learned
- KiCad PCB file was incomplete - use instruction specifications instead
- Tendril connections must be calculated to properly connect center to arms
- Groove positioning should be centered in arms (not top/bottom)
- Visual verification via rendered PNGs essential for alignment checking
- Minimal material usage while maintaining structural integrity

## Current Status
- E-ink holder STL generated and printing in progress
- PCB holder design completed with verified mounting hole alignment
- All design files and documentation updated