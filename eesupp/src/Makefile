# $Header$
# $Name$

# Makefile for generate eesupp source code from templates.
# Why do we do this?  Answer: saves typing!

RL_FILES = exch_xy_rl.F  exch_uv_xy_rl.F  exch_z_xy_rl.F  \
           exch_xyz_rl.F exch_uv_xyz_rl.F exch_z_xyz_rl.F \
           exch_xy_rl.F exch_xyz_rl.F \
           exch_rl.F \
           exch_rl_cube.F exch_uv_rl_cube.F exch_z_rl_cube.F

RS_FILES = exch_xy_rs.F  exch_uv_xy_rs.F  exch_z_xy_rs.F  \
           exch_xyz_rs.F exch_uv_xyz_rs.F exch_z_xyz_rs.F \
           exch_xy_rs.F exch_xyz_rs.F \
           exch_rs.F \
           exch_rs_cube.F exch_uv_rs_cube.F exch_z_rs_cube.F

all: $(RL_FILES) $(RS_FILES)

clean:
	-rm -f $(RL_FILES) $(RS_FILES)

# exch_xy_rx
exch_xy_rl.F: exch_xy_rx.template
	sed 's/RX/RL/g' $< > $@
exch_xy_rs.F: exch_xy_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_xyz_rx
exch_xyz_rl.F: exch_xyz_rx.template
	sed 's/RX/RL/g' $< > $@
exch_xyz_rs.F: exch_xyz_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_uv_xy_rx
exch_uv_xy_rl.F: exch_uv_xy_rx.template
	sed 's/RX/RL/g' $< > $@
exch_uv_xy_rs.F: exch_uv_xy_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_uv_xyz_rx
exch_uv_xyz_rl.F: exch_uv_xyz_rx.template
	sed 's/RX/RL/g' $< > $@
exch_uv_xyz_rs.F: exch_uv_xyz_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_x_xy_rx
exch_z_xy_rl.F: exch_z_xy_rx.template
	sed 's/RX/RL/g' $< > $@
exch_z_xy_rs.F: exch_z_xy_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_z_xyz_rx
exch_z_xyz_rl.F: exch_z_xyz_rx.template
	sed 's/RX/RL/g' $< > $@
exch_z_xyz_rs.F: exch_z_xyz_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_rx
exch_rl.F: exch_rx.template
	sed 's/RX/RL/g' $< > $@
exch_rs.F: exch_rx.template
	sed 's/RX/RS/g' $< > $@

# exch_rx_cube
exch_rl_cube.F: exch_rx_cube.template
	sed 's/RX/RL/g' $< > $@
exch_rs_cube.F: exch_rx_cube.template
	sed 's/RX/RS/g' $< > $@

# exch_uv_rx_cube
exch_uv_rl_cube.F: exch_uv_rx_cube.template
	sed 's/RX/RL/g' $< > $@
exch_uv_rs_cube.F: exch_uv_rx_cube.template
	sed 's/RX/RS/g' $< > $@

# exch_z_rx_cube
exch_z_rl_cube.F: exch_z_rx_cube.template
	sed 's/RX/RL/g' $< > $@
exch_z_rs_cube.F: exch_z_rx_cube.template
	sed 's/RX/RS/g' $< > $@
