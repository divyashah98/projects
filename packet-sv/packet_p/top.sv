module top ();
    import Packet_pkg::*;
    import IPPacket_pkg::*;
    import UDPPacket_pkg::*;
    import TCPPacket_pkg::*;
    import Checker_pkg::*;

    // Instantiate the UDP/TCP packets
    UDPPacket UDP_1;
    TCPPacket TCP_1;
    // Instantiate and create the checker class handle
    Checker C_1 = new();

    bit[7:0] data_tb[bit[10:0]];
    // Initialise the data_tb array
    initial
    begin
        for (int i = 0; i < 1500; i++)
        begin
            data_tb[i] = $urandom(i);
        end
        // Create the UDP+IP Packet
        UDP_1   = new (
                    .source_port ('h8080),          // Source port for the UDP Packet
                    .dest_port ('h1090),            // Destination port for the UDP packet
                    .udp_data_len ('d512),          // UDP Packet data length
                    .udp_data (data_tb),            // UDP Packet data
                    .header_len ('h8),              // Header length for the IP packet
                    .protocol ('h11),               // Protocol field in the IP packet
                    .source_addr ('h1234),          // Source address for the IP packet
                    .dest_addr ('h4321),            // Destination address for the IP packet
                    .ip_data_len ('d256),           // IP Packet data length
                    .ip_data (data_tb)              // IP packet data
                  );
        // Create the TCP+IP Packet
        TCP_1   = new (
                    .source_port ('h8080),          // Source port for the TCP Packet
                    .dest_port ('h1090),            // Destination port for the TCP packet
                    .seq_number ('h1eadbeef),       // Sequence number for the TCP packet
                    .ack_number ('h9009),           // Acknowledge number for the TCP packet
                    .URG ('h0),                     // URG flag
                    .ACK ('h0),                     // ACK flag
                    .PSH ('h0),                     // PSH flag
                    .RST ('h0),                     // RST flag
                    .SYN ('h0),                     // SYN flag
                    .FIN ('h0),                     // FIN flag
                    .tcp_header_len ('h9),          // TCP header len
                    .window_size ('hdeaf),          // TCP window size
                    .tcp_data_len ('d256),          // TCP Packet data length
                    .tcp_data (data_tb),            // TCP Packet data
                    .ip_header_len ('h8),           // Header length for the IP packet
                    .protocol ('h11),               // Protocol field in the IP packet
                    .source_addr ('h1234),          // Source address for the IP packet
                    .dest_addr ('h4321),            // Destination address for the IP packet
                    .ip_data_len ('d256),           // IP Packet data length
                    .ip_data (data_tb)              // IP packet data
                  );
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
        // End the simulation now
        $finish ("Simulation completed\n");

    end

endmodule
