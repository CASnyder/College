onerror {quit -f}
vlib work
vlog -work work bcd_inc.vo
vlog -work work Experiment4.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.bcd_inc_vlg_vec_tst
vcd file -direction Experiment4.msim.vcd
vcd add -internal bcd_inc_vlg_vec_tst/*
vcd add -internal bcd_inc_vlg_vec_tst/i1/*
add wave /*
run -all
