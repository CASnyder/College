onerror {quit -f}
vlib work
vlog -work work enhanced_prio.vo
vlog -work work Experiment3.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.enhanced_prio_vlg_vec_tst
vcd file -direction Experiment3.msim.vcd
vcd add -internal enhanced_prio_vlg_vec_tst/*
vcd add -internal enhanced_prio_vlg_vec_tst/i1/*
add wave /*
run -all
