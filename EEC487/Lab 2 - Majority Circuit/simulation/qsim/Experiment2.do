onerror {quit -f}
vlib work
vlog -work work maj.vo
vlog -work work Experiment2.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.maj_vlg_vec_tst
vcd file -direction Experiment2.msim.vcd
vcd add -internal maj_vlg_vec_tst/*
vcd add -internal maj_vlg_vec_tst/i1/*
add wave /*
run -all
