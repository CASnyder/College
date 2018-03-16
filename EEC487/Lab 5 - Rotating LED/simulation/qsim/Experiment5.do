onerror {quit -f}
vlib work
vlog -work work counter1.vo
vlog -work work Experiment5.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.counter3_vlg_vec_tst
vcd file -direction Experiment5.msim.vcd
vcd add -internal counter3_vlg_vec_tst/*
vcd add -internal counter3_vlg_vec_tst/i1/*
add wave /*
run -all
