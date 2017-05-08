module top ();
    import Packet_pkg::*;
    import IPPacket_pkg::*;

    PacketGen C1;
    IPPacket C2;
    bit[7:0] data_tb[bit[10:0]];
    initial
    begin
        C1 = new ;
        C2 = new ('ha, 'h11, 'h10, 'h10, 'h12, data_tb) ;
    end
endmodule
