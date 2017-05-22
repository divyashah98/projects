module top ();
    import Packet_pkg::*;
    import IPPacket_pkg::*;
    import UDPPacket_pkg::*;
    import TCPPacket_pkg::*;
    import MAC_pkg::*;
    import Checker_pkg::*;

    // Instantiate the UDP/TCP packets
    UDPPacket UDP_1;
    TCPPacket TCP_1;
    MACPacket MAC_1;
integer f,i,j, len;
    // Instantiate and create the checker class handle
    Checker C_1 = new();

    bit[7:0] data_tb[bit[10:0]];
    // Raw packet containing the following packets
    //      - MAC
    //      - TCP/UDP
    //      - IP
    bit [7:0] raw_data [];
    // Initialise the data_tb array
    initial
    begin
			f = $fopen("output.txt","w");
        for (int i = 0; i < 16; i++)
        begin
            data_tb[i] = i;//$urandom(i);
        end
        // Creat the MAC packet
        MAC_1   = new (
                    .dest_mac ('h00_A0_12_01_01_01),
                    .source_mac ('h00_A0_12_01_01_02)
                  );
        // Create the UDP+IP Packet
        UDP_1   = new (
                    .source_port ('h8080),          // Source port for the UDP Packet
                    .dest_port ('h1090),            // Destination port for the UDP packet
                    .udp_data_len ('d12),          // UDP Packet data length
                    .udp_data (data_tb),            // UDP Packet data
                    .header_len ('h8),              // Header length for the IP packet
                    .protocol ('h11),               // Protocol field in the IP packet
                    .source_addr ('h1234),          // Source address for the IP packet
                    .dest_addr ('h4321),            // Destination address for the IP packet
                    .ip_data_len ('d6),           // IP Packet data length
                    .ip_data (data_tb)              // IP packet data
                  );
        // Create UDP raw pkt
        create_udp_rawpkt (MAC_1, UDP_1);
        // Create the TCP+IP Packet
        TCP_1   = new (
                    .source_port ('d11),          // Source port for the TCP Packet
                    .dest_port ('d55),            // Destination port for the TCP packet
                    .seq_number ('d1),       // Sequence number for the TCP packet
                    .ack_number ('d2),           // Acknowledge number for the TCP packet
                    .URG ('h0),                     // URG flag
                    .ACK ('h0),                     // ACK flag
                    .PSH ('h1),                     // PSH flag
                    .RST ('h0),                     // RST flag
                    .SYN ('h0),                     // SYN flag
                    .FIN ('h0),                     // FIN flag
                    .tcp_header_len ('h5),          // TCP header len
                    .window_size ('d3),           // TCP window size
                    .tcp_data_len ('d16),          // TCP Packet data length
                    .tcp_data (data_tb),            // TCP Packet data
                    .ip_header_len ('h5),           // Header length for the IP packet
                    .protocol ('h11),               // Protocol field in the IP packet
                    .source_addr ('h0a2a5aa9),          // Source address for the IP packet
                    .dest_addr ('h0a0000eb),            // Destination address for the IP packet
                    .ip_data_len ('d0),           // IP Packet data length
                    .ip_data (data_tb)              // IP packet data
                  );
        // Create TCP raw pkt
        create_tcp_rawpkt (MAC_1, TCP_1);
        len = (raw_data.size()/16);
        
        if (raw_data.size%16)
            len = len + 1;
        
        for(j=0;j<len;j++) begin
            $fwrite(f,"%04X  ",j*16);
            for (i = 0; i < 16; i++) begin
                if ((j*16 + i) < raw_data.size())
                $fwrite(f," %02X",raw_data[i+j*16]);
            end
            $fwrite(f,"\n");
        end

        // Call the Checker methods to check the packets
        // Check the TCP packet by calling check_tcp
        C_1.check_tcp (
                    .TCP (TCP_1),                   // Pass the created TCP packet
                    .source_port ('h8080),          // Expected source port
                    .dest_port ('h1090),            // Expected destination port
                    .seq_number ('h1eadbeef),       // Expected Sequence number for the TCP packet
                    .ack_number ('h9009),           // Expected Acknowledge number for the TCP packet
                    .URG ('h0),                     // Expected URG flag
                    .ACK ('h0),                     // Expected ACK flag
                    .PSH ('h0),                     // Expected PSH flag
                    .RST ('h0),                     // Expected RST flag
                    .SYN ('h0),                     // Expected SYN flag
                    .FIN ('h0),                     // Expected FIN flag
                    .window_size ('hdeaf),          // Expected TCP window size
                    .source_addr ('h1234),          // Expected Source address for the IP packet
                    .dest_addr ('h4321)             // Expected Destination address for the IP packet
        );
        // Check the UDP packet by calling check_udp
        C_1.check_udp (
                    .UDP (UDP_1),                   // Pass the created UDP packet
                    .source_port ('h8080),          // Expected source port
                    .dest_port ('h1090),            // Expected destination port
                    .source_addr ('h1234),          // Expected Source address for the IP packet
                    .dest_addr ('h4321)             // Expected Destination address for the IP packet
        );
		  $fclose(f);  
		  #10
        // End the simulation now
        $finish ("Simulation completed\n");

    end

    // Method to create a raw UDP packet with MAC
    function void create_udp_rawpkt (MACPacket MAC, UDPPacket UDP);
        integer i;
        // Assign memory to the raw data array
        raw_data = new [UDP.total_pkt_len + 14];
        // Copy the MAC data into the raw data array
        for (i = 0; i < 14; i++)
        begin
            raw_data[i] = MAC.mac_header [i*8+:8];
        end
        // Copy the UDP data into the raw data array
        for (i = 0; i < UDP.total_pkt_len; i++)
        begin
            raw_data[i+14] = UDP.raw_pkt_data[i];
        end
    endfunction

    // Method to create a raw TCP packet with MAC
    function void create_tcp_rawpkt (MACPacket MAC, TCPPacket TCP);
        integer i;
        // Assign memory to the raw data array
        raw_data = new [TCP.total_pkt_len + 14];
        // Copy the MAC data into the raw data array
        for (i = 0; i < 14; i++)
        begin
            raw_data[i] = MAC.mac_header [i*8+:8];
        end
        // Copy the UDP data into the raw data array
        for (i = 0; i < TCP.total_pkt_len; i++)
        begin
            raw_data[i+14] = TCP.raw_pkt_data[i];
        end
        // Copy the UDP data into the raw data array
        //for (i = 0; i < raw_data.size(); i++)
        //begin
        //    $display ("Raw pkt: 0x%02x", raw_data[i]);
        //end
    endfunction
endmodule
