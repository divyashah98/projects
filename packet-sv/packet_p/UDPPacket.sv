package UDPPacket_pkg;
    // Import the base class package 
    // This allows the TCP-Packet class to
    // extend from the base class
    import Packet_pkg::*;
    // Import the Data Payload package
    // This is required to create a handle
    // of the Data Payload class
    import DataPayload_pkg::*;
    // Import the IP Packet package
    // This is required to create a handle
    // of the IPPacket class
    import IPPacket_pkg::*;

    class UDPPacket extends PacketGen;

        // Class Properties: 
        // 64-bits (8 B)wide UDP-header
        // Contains the final header info
        bit [63:0] udp_header;
        // 16-bit Source Port number
        // Value set as per the given input 
        bit [15:0]  source_port;
        // 16-bit Destination Port number
        // Value set as per the given input 
        bit [15:0]  dest_port;
        // 16-bits for UDP length field
        // To be calculated from data_len
        bit [15:0]  udp_len;
        // 16-bit UDP checksum
        // To be calculated
        bit [15:0]  udp_chksum;
        // Create an instance of the Data Payload 
        // class to hold the Data related information
        DataPayload D_UDP;
        // Create an instance of the IP-Packet 
        // class to hold the IP related info
        IPPacket IP_UDP;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit[15:0] source_port, bit[15:0] dest_port,
                      bit[10:0] udp_data_len, bit[7:0] udp_data [bit [10:0]], 
                      bit[3:0] header_len, bit [7:0] protocol, 
                      bit [31:0] source_addr, bit[31:0] dest_addr, 
                      bit[10:0] ip_data_len, bit[7:0] ip_data [bit [10:0]], 
        );
            super.new();
            bit[10:0] curr_len   = 'h8;
            this.source_port     = source_port;
            this.dest_port       = dest_port;
            // UDP packet has a minimum length of 8
            // bytes if no data is passed. Get the 
            // actual length by looking at the current
            // data length.
            this.udp_len         = udp_data_len + this.udp_len;
            create_packet ();
            init_data (curr_len, data_len, data);
            print_pkt ();
        endfunction

        // Method create_packet () - Completes the packet
        // Fills in all the fields of an IP packet and
        // completes the field of the packet
        virtual function void create_packet ();
            //$display ("Source ADDR: 0x%8x\n", this.source_addr);
            this.version        = 'h4;
            this.dscp           = 'h0;
            this.identification = 'h0;
            this.DF             = 'h1;
            this.MF             = 'h1;
            this.frag_offset    = 'h0;
            this.TTL            = 'h0;
            // The header checksum will be updated
            // by the cal_chksum method
            this.header_chksum  = 'h0;
            // Create the IP header by concatenating
            // all the fields together
            this.ip_header      = {this.dest_addr, this.source_addr, 
                                   this.header_chksum, this.protocol, 
                                   this.TTL, this.frag_offset, this.MF, 
                                   this.DF, 1'h0, this.identification, 
                                   this.total_len, this.dscp, 
                                   this.header_len, this.version};
            // Calculate the CheckSum and update the IP header                                   
            cal_chksum ();
            // Update the IP header with the new chk_sum field
            this.ip_header      = {this.dest_addr, this.source_addr, 
                                   this.header_chksum, this.protocol, 
                                   this.TTL, this.frag_offset, this.MF, 
                                   this.DF, 1'h0, this.identification, 
                                   this.total_len, this.dscp, 
                                   this.header_len, this.version};
        endfunction

        // Method cal_chksum () - Calculates the header checksum
        // Puts the calculated checksum into the header_chksum field
        function void cal_chksum ();
            // Here's how to compute a checksum:
            // 1. Put a 0 in the checksum field (create_packet does that).
            // 2. Add each 16-bit value together.
            // 3. Add in any carry
            // 4. Inverse the bits and put that in the checksum field.
            bit [16:0]  sum = 'h0;
            this.header_chksum = 'h0;
            for (int i = 0; i < 10; i++)
            begin
                //$display ("0x%4x\n", this.ip_header [i*16+:16]);
                sum = sum + this.ip_header [i*16+:16];
                // Check if we have a carry
                if (sum[16])
                begin
                    // Add the carry back to sum
                    sum = sum + {16'h0, sum[16]};
                end
            end
            // Perform bitwise negation on sum
            // Put the value in check sum field
            this.header_chksum = ~sum;
        endfunction

        // Method print_pkt () - Prints the packet in a structured way
        function void print_pkt ();
            $display ("\n********************UDP-Packet********************\n");
            $display ("Version:0x%08x\n", this.version);
            $display ("Data:\n");
            for (int i = 0; i < (D_IP.data.size()); i++)
            begin
                $display ("\t0x%08x\n",D_IP.data[i]);
            end
        endfunction

    endclass
endpackage
