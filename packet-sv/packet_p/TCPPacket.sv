package TCPPacket_pkg;
    // Import the base class package 
    // This allows the TCP-Packet class to
    // extend from the base class
    import Packet_pkg::*;
    // Import the Data Payload package
    // This is required to create a handle
    // of the Data Payload class
    import DataPayload_pkg::*;

    class TCPPacket extends PacketGen;

        // Class Properties: 
        // 160-bits (20 B)wide TCP-header
        // Contains the final header info
        bit [159:0] tcp_header;
        // 16-bit Source Port number
        // Value set as per the given input 
        bit [15:0]  source_port;
        // 16-bit Destination Port number
        // Value set as per the given input 
        bit [15:0]  dest_port;
        // 32-bit Sequence Number
        // Value set as per the given input during instantiation
        bit [31:0]  seq_number;
        // 32-bit Acknowledge Number
        // Value set as per the given input during instantiation
        bit [31:0]  ack_number;
        // 4-bit Header Length (data offset)
        // Value set as per the given input during instantiation
        // Should be between 5 and 15
        bit [3:0]   header_len;
        // 1-bit URG Flag
        // Fixed to 0
        bit         URG;
        // 1-bit ACK Flag
        // FIXME: No specifications provided
        bit         ACK;
        // 1-bit PSH Flag
        // FIXME: No specifications provided
        bit         PSH;
        // 1-bit RST Flag
        // FIXME: No specifications provided
        bit         RST;
        // 1-bit SYN Flag
        // FIXME: No specifications provided
        bit         SYN;
        // 1-bit FIN Flag
        // FIXME: No specifications provided
        bit         FIN;
        // 16-bit Window Size
        // Value set as per the given input during instantiation
        bit[15:0]   window_size;
        // 16-bit TCP header checksum
        // To be calculated
        bit [15:0]  header_chksum;
        // 16-bit Urgent pointer 
        // Fixed to 0
        bit [15:0]  urg_pointer;
        // 32-bit options field - Implemented as a
        // dynamic array indexed with bit[3:0] as
        // the maximum value could be max(DOff)-5
        // where:
        // max(DOff) = 15
        // Hence max length of array would be
        // 15 -5 = 10
        // To be filled with DOff-5 32-bit words of 
        // incremental data only if DOff is greater than 5
        bit [31:0]  options [];
        // Instantiate an instance of the Data Payload 
        // class to hold the Data related information
        DataPayload D_TCP;
        // Create an instance of the IP-Packet 
        // class to hold the IP related info
        IPPacket IP_TCP;
        // Define the TCP Protocol used for creating
        // the IP packet
        bit [7:0] TCP = 'h06;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit[3:0] header_len, bit [7:0] protocol, bit [31:0] source_addr, bit[31:0] dest_addr, bit[10:0] data_len, bit[7:0] data [bit [10:0]], bit [10:0] curr_len);
            super.new();
            this.header_len     = header_len;
            this.protocol       = protocol;
            this.source_addr    = source_addr;
            this.dest_addr      = dest_addr;
            if (header_len < 6)
            begin
                // No extra options are inserted
                this.total_len      = header_len + data_len;
            end
            else
            begin
                // Options are inserted (take up (IHL-5)*4 B of space)
                this.total_len      = header_len + data_len + (header_len-5)<<2;
            end
            curr_len                = curr_len + this.total_len;
            create_packet ();
            init_options ();
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
        function void init_data (bit[10:0] curr_len, bit[10:0] data_len, bit[7:0] data [bit[10:0]]);
            // The curr_len variable gives us the current length
            // of the Packet combining all (i.e. IP+TCP/UDP) in B
            integer     mtu = 1500;
            integer     i;
            // Create an instance of the Data Packet class
            D_IP      = new ();
            // Allocate maximum memory assuming the size
            // doesn't exceed the specified MTU
            D_IP.data = new[data_len];
            for (i = 0; i < data_len; i++)
            begin
                if ((curr_len) < mtu)
                begin
                    // Fill in the dynamic array with the data
                    D_IP.data[i] = data[i];
                    curr_len     = curr_len + i;
                end
                else
                begin
                    $warning ("Can't fill in the packet with complete Data! Few Data bytes will be dropped\n");
                    return;
                end
            end
        endfunction

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
                $display ("\t0x%08x\n",this.options[i]);
            end
            $display ("Data:\n");
            for (int i = 0; i < (D_IP.data.size()); i++)
            begin
                $display ("\t0x%08x\n",D_IP.data[i]);
            end
        endfunction

    endclass
endpackage
