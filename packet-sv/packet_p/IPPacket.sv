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
        // Setting the MF = 0 (to indicate last fragement)
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
        // 32-bit options field - Implemented as a
        // dynamic array indexed with bit[3:0] as
        // the maximum value could be max(IHL)-5
        // where:
        // max(IHL) = 15
        // Hence max length of array would be
        // 15 -5 = 10
        // To be filled with IHL-5 32-bit words of 
        // incremental data only if IHL is greater than 5
        bit [31:0]  options [];
        // Create an instance of the Data Payload 
        // class to hold the Data related information
        DataPayload D_IP;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit[3:0] header_len, bit [7:0] protocol, bit [31:0] source_addr, bit[31:0] dest_addr, bit[10:0] data_len, bit[7:0] data [bit [10:0]], bit [10:0] curr_len);
            super.new();
            this.header_len     = header_len;
            this.protocol       = protocol;
            this.source_addr    = source_addr;
            this.dest_addr      = dest_addr;
            this.total_len      = curr_len + header_len*4;
            //init_data (curr_len, data_len, data);
            // Update the total len field depending on the 
            // data length
            //this.total_len    = this.total_len + {5'b0, D_IP.data_len};
            create_packet ();
            init_options ();
            // Calculate the CheckSum and update the IP header
            cal_chksum ();
            //print_pkt ();
        endfunction

        // Method create_packet () - Completes the packet
        // Fills in all the fields of an IP packet and
        // completes the packet
        virtual function void create_packet ();
            //$display ("Source ADDR: 0x%8x\n", this.source_addr);
            this.version        = 'h4;
            this.dscp           = 'h0;
            this.identification = 'h0;
            this.DF             = 'h1;
            this.MF             = 'h0;
            this.frag_offset    = 'h0;
            this.TTL            = 'h1;
            // The header checksum will be updated
            // by the cal_chksum method
            this.header_chksum  = 'h0;
            // Create the IP header by concatenating
            // all the fields together
            this.ip_header      = {(this.dest_addr), (this.source_addr), 
                                   (this.header_chksum), 
                                   ({this.protocol, this.TTL}), 
                                   ({this.frag_offset, this.MF, 
                                   this.DF, 1'h0}), (this.identification), 
                                   (this.total_len), ({this.dscp, 
                                   this.version, this.header_len})};
        endfunction                                   

        // Method cal_chksum () - Calculates the header checksum
        // Puts the calculated checksum into the header_chksum field
        function void cal_chksum ();
            // Here's how to compute a checksum:
            // 1. Put a 0 in the checksum field (create_packet does that).
            // 2. Add each 16-bit value together.
            // 3. Add in any carry
            // 4. Inverse the bits and put that in the checksum field.
            bit [15:0]  sum = 'h0;
            bit         carry = 'h0;
            for (int i = 0; i < 10; i++)
            begin
                //$display ("0x%4x\n", this.ip_header [i*16+:16]);
                {carry, sum} = sum + this.ip_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Perform bitwise negation on sum
            // Put the value in check sum field
            this.header_chksum = ~sum;
            // Update the IP header with the new chk_sum field
            this.ip_header      = {htonl(this.dest_addr), htonl(this.source_addr), 
                                   htons(this.header_chksum), 
                                   ({this.protocol, this.TTL}), 
                                   htons({1'h0, this.DF, 
                                   this.MF,this.frag_offset}), htons(this.identification), 
                                   htons(this.total_len), ({this.dscp, 
                                   this.version, this.header_len})};
        endfunction

        // Method init_options () - Initialises the packet with options
        // The specifications define the following for the options field:
        // To be filled with IHL-5 32-bit words of incremental data
        // only if IHL is greater than 5
        function void init_options ();
            bit [31:0] rand_data;
            integer    loop_len;
            loop_len     = this.header_len - 5;
            rand_data    = $urandom();
            if (this.header_len < 'h6)
                return;
            this.options = new [loop_len];
            for (int i = 0; i < loop_len; i++)
            begin
                this.options[i] = rand_data + i;
            end
        endfunction

        // Method init_data (bit[10:0] curr_len) - Adds data and 
        // verifies that the packet doesn't exceed max MTU of 1500B
        //function void init_data (bit[10:0] curr_len, bit[10:0] data_len, bit[7:0] data [bit[10:0]]);
        //    // The curr_len variable gives us the current length
        //    // of the Packet combining all (i.e. IP+TCP/UDP) in B
        //    integer     mtu = 1500;
        //    integer     i;
        //    // Create an instance of the Data Packet class
        //    D_IP      = new ();
        //    // Allocate maximum memory assuming the size
        //    // doesn't exceed the specified MTU
        //    D_IP.data = new[data_len];
        //    for (i = 0; i < data_len; i++)
        //    begin
        //        if ((curr_len) < mtu)
        //        begin
        //            // Fill in the dynamic array with the data
        //            D_IP.data[i]    = data[i];
        //            // Update the current data length
        //            D_IP.data_len   = i+1;
        //            curr_len        = curr_len + 1;
        //        end
        //        else
        //        begin
        //            $warning ("Can't fill in the IP packet with complete Data! Few Data bytes will be dropped\n");
        //            return;
        //        end
        //    end
        //endfunction

        // Method print_pkt () - Prints the packet in a structured way
        function void print_pkt ();
            $display ("\n********************IP-Packet********************\n");
            $display ("Version:0x%08x\n", this.version);
            $display ("IHL:0x%08x\n", this.header_len);
            $display ("DSCP:0x%08x\n", this.dscp);
            $display ("Total Length:0x%08x\n", this.total_len);
            $display ("Identification:0x%08x\n", this.identification);
            $display ("DF:0x%08x\n", this.DF);
            $display ("MF:0x%08x\n", this.MF);
            $display ("Fragment Offset:0x%08x\n", this.frag_offset);
            $display ("Checksum:0x%08x\n", this.header_chksum);
            $display ("Source Address:0x%08x\n", this.source_addr);
            $display ("Destination Address:0x%08x\n", this.dest_addr);
            $display ("Options:\n");
            for (int i = 0; i < (this.options.size()); i++)
            begin
                $display ("\t0x%08x",this.options[i]);
            end
            $display ("Data:\n");
            for (int i = 0; i < (D_IP.data.size()); i++)
            begin
                $display ("\t0x%08x",D_IP.data[i]);
            end
        endfunction

    endclass
endpackage
