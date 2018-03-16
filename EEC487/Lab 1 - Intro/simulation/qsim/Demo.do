onerror {quit -f}
vlib work
vlog -work work Demo.vo
vlog -work work Demo.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.eq2_vlg_vec_tst
vcd file -direction Demo.msim.vcd
vcd add -internal eq2_vlg_vec_tst/*
vcd add -internal eq2_vlg_vec_tst/i1/*
add wave /*
run -all
