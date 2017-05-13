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
        // Define the UDP Protocol used for creating
        // the IP packet
        bit [7:0] UDP = 'h11;

        // Class Methods:
        // Method new () - overridden to get various
        // inputs from the user
        function new (bit[15:0] source_port, bit[15:0] dest_port,
                      bit[10:0] udp_data_len, bit[7:0] udp_data [bit [10:0]], 
                      bit[3:0] header_len, bit [7:0] protocol, 
                      bit [31:0] source_addr, bit[31:0] dest_addr, 
                      bit[10:0] ip_data_len, bit[7:0] ip_data [bit [10:0]]
        );
            bit[10:0] curr_len;
            super.new();
            curr_len             = 'h8;
            this.source_port     = source_port;
            this.dest_port       = dest_port;
            create_packet ();
            init_data (curr_len, udp_data_len, udp_data);
            // UDP packet has a minimum length of 8
            // bytes if no data is passed. Get the 
            // actual length by looking at the current
            // data length.
            this.udp_len         = {5'b0, D_UDP.data_len} + {5'b0, curr_len};
            // Create the IP packet for the UDP packet
            IP_UDP               = new (header_len, UDP, source_addr, dest_addr,
                                        ip_data_len, ip_data, udp_len);
            //print_pkt ();
        endfunction

        // Method create_packet () - Completes the packet
        // Fills in all the fields of an UDP packet and
        // completes the packet.
        virtual function void create_packet ();
            // The header checksum will be updated
            // by the cal_chksum method
            this.udp_chksum  = 'h0;
            // Create the UDP header by concatenating
            // all the fields together
            this.udp_header  = {this.dest_port, this.source_port, 
                                this.udp_len, this.udp_chksum};
            // Calculate the CheckSum and update the UDP header
            cal_chksum ();
            // Update the UDP header with the new chk_sum field
            this.udp_header  = {this.dest_port, this.source_port, 
                                this.udp_len, this.udp_chksum};
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
            for (int i = 0; i < 4; i++)
            begin
                //$display ("0x%4x\n", this.ip_header [i*16+:16]);
                {carry, sum} = sum + this.udp_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Perform bitwise negation on sum
            // Put the value in check sum field
            this.udp_chksum = ~sum;
        endfunction

        // Method init_data (bit[10:0] curr_len) - Adds data and 
        // verifies that the packet doesn't exceed max MTU of 1500B
        function void init_data (bit[10:0] curr_len, bit[10:0] data_len, bit[7:0] data [bit[10:0]]);
            // The curr_len variable gives us the current length
            // of the Packet combining all (i.e. IP+TCP/UDP) in B
            // Reserve 8 Bytes for UDP packet and 20 Bytes for 
            // the corresponding IP packet
            integer     mtu = 1472;
            integer     i;
            // Create an instance of the Data Packet class
            D_UDP      = new ();
            // Allocate maximum memory assuming the size
            // doesn't exceed the specified MTU
            D_UDP.data = new[data_len];
            for (i = 0; i < data_len; i++)
            begin
                if ((curr_len) < mtu)
                begin
                    // Fill in the dynamic array with the data
                    D_UDP.data[i]   = data[i];
                    // Update the current data length
                    D_UDP.data_len  = i;
                    curr_len        = curr_len++;
                end
                else
                begin
                    $warning ("Can't fill in the UDP packet with complete Data! Few Data bytes will be dropped\n");
                    return;
                end
            end
        endfunction

        //// Method print_pkt () - Prints the packet in a structured way
        //function void print_pkt ();
        //    $display ("\n********************UDP-Packet********************\n");
        //    $display ("Version:0x%08x\n", this.version);
        //    $display ("Data:\n");
        //    for (int i = 0; i < (D_IP.data.size()); i++)
        //    begin
        //        $display ("\t0x%08x\n",D_IP.data[i]);
        //    end
        //endfunction

    endclass
endpackage
