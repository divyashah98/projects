module top ();
    import Packet_pkg::*;
    import IPPacket_pkg::*;

    IPPacket IP_1;
    bit[7:0] data_tb[bit[10:0]];
    initial
    begin
        IP_1 = new ('ha, 'h11, 'h10, 'h10, 'h12, data_tb, 'd1498) ;
    end
endmodule
