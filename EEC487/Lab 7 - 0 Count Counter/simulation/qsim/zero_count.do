onerror {quit -f}
vlib work
vlog -work work zero_count.vo
vlog -work work zero_count.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.zero_top_vlg_vec_tst
vcd file -direction zero_count.msim.vcd
vcd add -internal zero_top_vlg_vec_tst/*
vcd add -internal zero_top_vlg_vec_tst/i1/*
add wave /*
run -all
