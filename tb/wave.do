onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/clk
add wave -noupdate -divider {Memory interface}
add wave -noupdate -radix unsigned /top_tb/mem_if/address
add wave -noupdate /top_tb/mem_if/byteenable
add wave -noupdate /top_tb/mem_if/read
add wave -noupdate /top_tb/mem_if/readdata
add wave -noupdate /top_tb/mem_if/readdatavalid
add wave -noupdate /top_tb/mem_if/waitrequest
add wave -noupdate /top_tb/mem_if/write
add wave -noupdate /top_tb/mem_if/writedata
add wave -noupdate -divider {Converter Byte -> Word}
add wave -noupdate -radix unsigned /top_tb/DUT/mem_w_if/address
add wave -noupdate /top_tb/DUT/mem_w_if/read
add wave -noupdate /top_tb/DUT/mem_w_if/byteenable
add wave -noupdate /top_tb/DUT/mem_w_if/write
add wave -noupdate /top_tb/DUT/mem_w_if/writedata
add wave -noupdate /top_tb/DUT/mem_w_if/readdatavalid
add wave -noupdate /top_tb/DUT/mem_w_if/readdata
add wave -noupdate /top_tb/DUT/mem_w_if/waitrequest
add wave -noupdate -divider {AMM registers}
add wave -noupdate -radix unsigned {/top_tb/DUT/mem_dmx_if[0]/address}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/read}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/byteenable}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/write}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/writedata}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/readdatavalid}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/readdata}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[0]/waitrequest}
add wave -noupdate -divider {AMM memory}
add wave -noupdate -radix unsigned {/top_tb/DUT/mem_dmx_if[1]/address}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/read}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/byteenable}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/write}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/writedata}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/readdatavalid}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/readdata}
add wave -noupdate {/top_tb/DUT/mem_dmx_if[1]/waitrequest}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1202 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1129 ns} {1267 ns}
