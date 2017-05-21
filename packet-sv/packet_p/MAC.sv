package MAC_pkg;
    import Packet_pkg::*;
    // Create the MAC class
    class MACPacket extends PacketGen;

        // Class Properties:
        // 112-bit long MAC header
        bit [111:0] mac_header;
        // 48-bit MAC source address
        bit [47:0]  source_mac;
        // 48-bit MAC destination address
        bit [47:0]  dest_mac;
        //  16-bit Ether type 
        // Fixed to 0x0800 (IPv4)
        bit [15:0]  ether_type;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit [47:0] source_mac, bit[47:0] dest_mac);
            this.source_mac     = source_mac;
            this.dest_mac       = dest_mac;
            this.ether_type     = 'h0800;
            // Create the MAC header
            mac_header          = { htons (this.ether_type),
                                    htonll(this.source_mac), 
                                    htonll(this.dest_mac)};
        endfunction


    endclass

endpackage
