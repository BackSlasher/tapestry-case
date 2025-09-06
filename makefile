# Makefile for epdiy case STL generation

# Default target
all: eink_holder.stl

# Generate STL from SCAD file
eink_holder.stl: eink_holder.scad
	openscad --render --export-format=stl -o $@ $<

# Clean generated files
clean:
	rm -f *.stl

# Force rebuild
.PHONY: all clean