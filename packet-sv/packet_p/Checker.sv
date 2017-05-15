package Checker_pkg;
    // Import the TCP and UDP packages
    import TCPPacket_pkg::*;
    import UDPPacket_pkg::*;
    import IPPacket_pkg::*;
    // Import the Data Payload package as well
    import DataPayload_pkg::*;

    class Checker;
        // Class Properties:
        // Class Methods:
        // Method to test the TCP packet
        function void check_tcp (TCPPacket TCP,         bit[15:0] source_port,
                                bit[15:0] dest_port,    bit[31:0] seq_number,
                                bit[31:0] ack_number,
                                bit URG,  bit ACK,      bit       PSH, 
                                bit RST,  bit SYN,      bit       FIN,
                                bit[15:0] window_size,
                                bit[31:0] source_addr,  bit[31:0] dest_addr
        );
            if (TCP.source_port != source_port)
            begin
                $fatal (1, "TCP: Source port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_port, TCP.source_port);
            end
            if (TCP.dest_port   != dest_port)      
            begin
                $fatal (1, "TCP: Destination port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_port, TCP.dest_port);
            end
            if (TCP.seq_number  != seq_number)     
            begin
                $fatal (1, "TCP: Sequence Number mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", seq_number, TCP.seq_number);
            end
            if (TCP.ack_number  != ack_number)     
            begin
                $fatal (1, "TCP: Ack Number mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ack_number, TCP.ack_number);
            end
            if (TCP.URG         != URG)            
            begin
                $fatal (1, "TCP: URG Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", URG, TCP.URG);
            end
            if (TCP.ACK         != ACK)            
            begin
                $fatal (1, "TCP: ACK Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ACK, TCP.ACK);
            end
            if (TCP.PSH         != PSH)            
            begin
                $fatal (1, "TCP: PSH Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", PSH, TCP.PSH);
            end
            if (TCP.RST         != RST)            
            begin
                $fatal (1, "TCP: RST Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", RST, TCP.RST);
            end
            if (TCP.SYN         != SYN)            
            begin
                $fatal (1, "TCP: SYN Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", SYN, TCP.SYN);
            end
            if (TCP.FIN         != FIN)            
            begin
                $fatal (1, "TCP: FIN Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", FIN, TCP.FIN);
            end
            if ((TCP.header_len < 5) || (TCP.header_len > 15))     
            begin
                $fatal (1, "TCP: Header Length not between 5 and 15. Actual: 0x%08x", TCP.header_len);
            end
            if (TCP.window_size != window_size)    
            begin
                $fatal (1, "TCP: Window Size mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", window_size, TCP.window_size);
            end
            if (validate_chksum (10, TCP.tcp_header))
            begin
                $fatal (1, "TCP: Checker Sum failed! Should have been zero but got 0x%08X\n", validate_chksum(10, TCP.tcp_header));
            end
            check_ip (TCP.IP_TCP, 'h06, source_addr, dest_addr);
            
        endfunction

        // Method to test the UDP packet
        function void check_udp (UDPPacket UDP, 
                                 bit[15:0] source_port, bit[15:0] dest_port,
                                 bit[31:0] source_addr, bit[31:0] dest_addr
        );
            if (UDP.source_port != source_port)    
            begin
                $fatal (1, "UDP: Source Port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_port, UDP.source_port);
            end
            if (UDP.dest_port   != dest_port)      
            begin
                $fatal (1, "UDP: Destination port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_port, UDP.dest_port);
            end
            if (validate_chksum (4, UDP.udp_header))
            begin
                $fatal (1, "UDP: Check Sum failed! Should have been zero but got 0x%08X\n", validate_chksum(4, UDP.udp_header));
            end
            check_ip (UDP.IP_UDP, 'h11, source_addr, dest_addr);

        endfunction

        // Method to test the IP packet
        function void check_ip (IPPacket IP,
                                bit[7:0] protocol,
                                bit[31:0] source_addr, bit[31:0] dest_addr
        );
            if (IP.version != 'h4)
            begin
                $fatal (1, "IP: Version mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", 'h4, IP.version);
            end
            if (IP.DF != 'h1)
            begin
                $fatal (1, "IP: DF bit not set! \n");
            end
            if (IP.source_addr != source_addr)
            begin
                $fatal (1, "IP: Source Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_addr, IP.source_addr);
            end
            if (IP.dest_addr != dest_addr)
            begin
                $fatal (1, "IP: Destination Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_addr, IP.dest_addr);
            end
            if (IP.protocol != protocol)
            begin
                $fatal (1, "IP: Protocol field mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", protocol, IP.protocol);
            end
            if (validate_chksum (10, IP.ip_header))
            begin
                $fatal (1, "IP: Check Sum failed! Should have been zero but got 0x%08X\n", validate_chksum(10, IP.ip_header));
            end

        endfunction

        // Method to calculate the check sum
        // It returns the calculated check sum value
        function bit[15:0] validate_chksum (integer loop_len, bit[159:0] header);
            // Here's how to verify the checksum:
            // 1. Add each 16-bit value together.
            // 2. Add in any carry
            // 3. The result should be 0
            bit [15:0]  sum = 'h0;
            bit         carry = 'h0;
            for (int i = 0; i < loop_len; i++)
            begin
                //$display ("Current header: 0x%04x\n", header[i*16+:16]);
                {carry, sum} = sum + header [i*16+:16];
                //$display ("Current Sum: 0x%05x\n", sum);
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                    //$display ("Sum after carry: 0x%05x\n", sum);
                end
            end
            // Perform bitwise negation on sum 
            // Return the sum value
            return ~sum;
        endfunction
    endclass

endpackage