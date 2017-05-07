module top ();
    import Packet_pkg::*;
    import IPPacket_pkg::*;

    PacketGen C1;
    IPPacket C2;
    initial
    begin
        C1 = new ;
        C2 = new ('h4, 'h11, 'h10, 'h10, 'h12, 'h0 ) ;
    end
endmodule
