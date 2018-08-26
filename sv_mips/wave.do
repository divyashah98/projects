onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group car -radix hexadecimal /lab5_tb/MCU/C0/clk
add wave -noupdate -expand -group car -radix hexadecimal /lab5_tb/MCU/C0/reset
add wave -noupdate -expand -group IF -radix hexadecimal /lab5_tb/MCU/C0/pc
add wave -noupdate -expand -group IF -radix hexadecimal /lab5_tb/MCU/C0/instr_data
add wave -noupdate -expand -group ID -radix hexadecimal /lab5_tb/MCU/C0/opcode
add wave -noupdate -expand -group ID -radix hexadecimal /lab5_tb/MCU/C0/rf_outa
add wave -noupdate -expand -group ID -radix hexadecimal /lab5_tb/MCU/C0/rf_outb
add wave -noupdate -expand -group EX -radix hexadecimal /lab5_tb/MCU/C0/alu_in_a
add wave -noupdate -expand -group EX -radix hexadecimal /lab5_tb/MCU/C0/alu_in_b
add wave -noupdate -expand -group EX -radix hexadecimal /lab5_tb/MCU/C0/alu_out
add wave -noupdate -expand -group W_REG -radix hexadecimal /lab5_tb/MCU/C0/fetch_data_a
add wave -noupdate -expand -group W_REG -radix hexadecimal /lab5_tb/MCU/C0/fetch_data_b
add wave -noupdate -expand -group RWB -radix hexadecimal /lab5_tb/MCU/C0/rf_data_in
add wave -noupdate -expand -group instr_reg -radix hexadecimal /lab5_tb/MCU/C0/instr_reg
add wave -noupdate -expand -group instr_reg -radix hexadecimal /lab5_tb/MCU/C0/nxt_instr_reg
add wave -noupdate -expand -group control -radix hexadecimal /lab5_tb/MCU/C0/state
add wave -noupdate -expand -group control -radix hexadecimal /lab5_tb/MCU/C0/nxt_state
add wave -noupdate -expand -group RF -radix hexadecimal /lab5_tb/MCU/C0/nxt_rf_data_in
add wave -noupdate -radix hexadecimal -childformat {{{/lab5_tb/MCU/C0/RF/RF[15]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[14]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[13]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[12]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[11]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[10]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[9]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[8]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[7]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[6]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[5]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[4]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[3]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[2]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[1]} -radix hexadecimal} {{/lab5_tb/MCU/C0/RF/RF[0]} -radix hexadecimal}} -subitemconfig {{/lab5_tb/MCU/C0/RF/RF[15]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[14]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[13]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[12]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[11]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[10]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[9]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[8]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[7]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[6]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[5]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[4]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[3]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[2]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[1]} {-height 16 -radix hexadecimal} {/lab5_tb/MCU/C0/RF/RF[0]} {-height 16 -radix hexadecimal}} /lab5_tb/MCU/C0/RF/RF
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {418650000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {881066 ps} {2503718 ps}
