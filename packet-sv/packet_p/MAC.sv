package MAC_pkg;
    // Create the MAC class
    class MAC;

        // Class Properties:
        // 32-bit MAC source address
        bit [31:0]  source_mac;
        // 32-bit MAC destination address
        bit [31:0]  dest_mac;
        //  16-bit Ether type 
        // Fixed to 0x0800 (IPv4)
        bit [15:0]  ether_type;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit [31:0] source_mac, bit[31:0] dest_mac, bit[15:0] ether_type);
            this.source_mac     = source_mac;
            this.dest_mac       = dest_mac;
            this.ether_type     = 'h0800;
        endfunction
    endclass

endpackage
