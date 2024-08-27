
vlog -sv -f rtl_files
vlog -sv +incdir+classes -f tb_files

vopt +acc -o top_tb_opt top_tb
vsim top_tb_opt

if { ![batch_mode] && [file exists "wave.do"] } {
  do "wave.do"
}

run -all

