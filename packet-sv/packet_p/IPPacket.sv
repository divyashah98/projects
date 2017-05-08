package IPPacket_pkg;
    // Import the base class package 
    // This allows the IP-Packet class to
    // extend from the base class
    import Packet_pkg::*;
    // Import the Data Payload package
    // This is required to create a handle
    // of the Data Payload class
    import DataPayload_pkg::*;

    class IPPacket extends PacketGen;

        // Class Properties: 
        // 160-bits (20 B)wide IP-header
        // Contains the final header info
        bit [159:0] ip_header;
        // 4-bit Version field
        // As per the internal specifications - it should be always 4
        bit [3:0]   version;
        // 4-bit Header Length (IHL)
        // Value set as per the given input during instantiation
        // Should be between 5 and 15
        bit [3:0]   header_len;
        // 8-bit DSCP (TOS)
        // Should be wired to 0 as per the specs
        bit [7:0]   dscp;
        // 16-bit Total length field
        // To be calculated from data length
        bit [15:0]  total_len;
        // 16-bits for Identification field
        // To be set to 0
        bit [15:0]  identification;
        // Single bit DF flag
        // Should be set to 1 (cannot be fragmented)
        bit         DF;
        // Single bit for MF flag
        // Since DF = 1 the datagram cannot be fragmented
        // Setting the MF = 1 (to indicate last fragement)
        bit         MF;
        // 13-bit fragment offset
        // To be set to 0
        bit [12:0]  frag_offset;
        // 8-bit TTL signal
        // To be set to 0
        bit [7:0]   TTL;
        // 8-bit protocol field
        // Should be 0x11 - UDP and 0x06 for TCP
        bit [7:0]   protocol;
        // 16-bit header checksum
        // To be calculated
        bit [15:0]  header_chksum;
        // 32-bit source IP address
        // Value set as per the given input during instantiation
        bit [31:0]  source_addr;
        // 32-bit destination IP address
        // Value set as per the given input during instantiation
        bit [31:0]  dest_addr;
        // 32-bit options field - Implemented as an
        // associative array indexed with bit[3:0] 
        // as the maximum value could be max(IHL)-5
        // where:
        // max(IHL) = 15
        // Hence max length of array would be
        // 15 -5 = 10
        // To be filled with IHL-5 32-bit words of 
        // incremental data only if IHL is greater than 5
        bit [31:0]  options [bit [3:0]];
        // Data length - 11-bit vector field
        bit [10:0]  data_len;
        // 8-bit data field - Implemented as an
        // associative array indexed with bit[10:0]
        // The max MTU (IP+TCP/UDP+Data) = 1500 B
        // Hence bits[10:0] should be sufficient
        // for any type of data payload
        bit [7:0]  data [bit [10:0]];

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit[3:0] header_len, bit [7:0] protocol, bit [31:0] source_addr, bit[31:0] dest_addr, bit[10:0] data_len, bit[7:0] data [bit [10:0]]);
            super.new();
            this.header_len     = header_len;
            this.protocol       = protocol;
            this.source_addr    = source_addr;
            this.dest_addr      = dest_addr;
            create_packet ();
        endfunction

        // Method create_packet () - Completes the packet
        // Fills in all the fields of an IP packet and
        // completes the field of the packet
        virtual function void create_packet ();
            //$display ("Source ADDR: 0x%8x\n", this.source_addr);
            this.version        = 'h4;
            this.dscp           = 'h0;
            if (this.header_len <= 5)
            begin
                // No extra options are inserted
                this.total_len      = this.header_len + this.data_len;
            end
            else
            begin
                // Options are inserted (take up (IHL-5)*4 B of space)
                this.total_len      = this.header_len + this.data_len + (this.header_len-5)<<2;
            end
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
            cal_chksum ();
            init_options ();
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

        // Method init_options () - Initialises the packet with options
        // The specifications define the following for the options field:
        // To be filled with IHL-5 32-bit words of incremental data
        // only if IHL is greater than 5
        function void init_options ();
            bit [31:0] rand_data;
            integer    loop_len;
            loop_len  = this.header_len - 5;
            rand_data = $urandom();
            if (this.header_len <= 'h5)
                return;
            for (int i = 0; i < loop_len; i++)
            begin
                this.options[i] = rand_data + i;
                //$display ("Options field - 0x%08x\n", this.options[i]);
            end
        endfunction

    endclass
endpackage
