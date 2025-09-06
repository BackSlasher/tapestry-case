# Makefile for epdiy case STL generation

# Default target - build all STLs
all: eink_holder.stl pcb_holder.stl complete_case.stl

# Generate STL files from SCAD files (with parameter dependencies)
eink_holder.stl: eink_holder.scad parameters.scad
	openscad --render --export-format=stl -o $@ $<

pcb_holder.stl: pcb_holder.scad parameters.scad
	openscad --render --export-format=stl -o $@ $<

complete_case.stl: complete_case.scad parameters.scad eink_holder.scad pcb_holder.scad
	openscad --render --export-format=stl -o $@ $<

# Clean generated files
clean:
	rm -f *.stl

# Clean PNG render files
clean-png:
	rm -f *.png

# Individual targets for convenience
eink: eink_holder.stl
pcb: pcb_holder.stl  
complete: complete_case.stl

# Force rebuild
.PHONY: all clean clean-png eink pcb complete