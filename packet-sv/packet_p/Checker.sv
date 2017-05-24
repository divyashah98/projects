package Checker_pkg;
    // Import the TCP and UDP packages
    import Packet_pkg::*;

    class Checker extends PacketGen;
        // Class Properties:
        // Class Methods:
        // Method to test the TCP packet
        function void check_tcp (bit[7:0] raw_data[],    bit[47:0] source_mac,
                                 bit[47:0] dest_mac,     bit[15:0] ether_type,
                                 bit[15:0] source_port,
                                 bit[15:0] dest_port,    bit[31:0] seq_number,
                                 bit[31:0] ack_number,
                                 bit URG,  bit ACK,      bit       PSH, 
                                 bit RST,  bit SYN,      bit       FIN,
                                 bit[15:0] window_size,
                                 bit[31:0] source_addr,  bit[31:0] dest_addr
        );
            bit[47:0]  raw_dest_mac;
            bit[47:0]  raw_source_mac;
            bit[15:0]  raw_ether_type;
            bit[15:0]  raw_source_port;
            bit[15:0]  raw_dest_port;
            bit[31:0]  raw_seq_number;
            bit[31:0]  raw_ack_number;
            bit        raw_URG;
            bit        raw_ACK;
            bit        raw_PSH;
            bit        raw_RST;
            bit        raw_SYN;
            bit        raw_FIN;
            bit[15:0]  raw_window_size;
            bit[15:0]  raw_tcp_header_chksum;
            bit[3:0]   raw_tcp_header_len;
            bit[31:0]  raw_tcp_options [];
            bit[3:0]   raw_version;
            bit[3:0]   raw_ip_header_len;
            bit[7:0]   raw_dscp;
            bit[15:0]  raw_total_len;
            bit[15:0]  raw_identification;
            bit        raw_DF;
            bit        raw_MF;
            bit[12:0]  raw_frag_offset;
            bit[7:0]   raw_TTL;
            bit[7:0]   raw_protocol;
            bit[15:0]  raw_ip_header_chksum;
            bit[31:0]  raw_source_addr;
            bit[31:0]  raw_dest_addr;
            bit[31:0]  raw_ip_options [];
            bit[7:0]   raw_tcp_data[];
            bit[159:0] tcp_header;
            bit[95:0]  tcp_pseudo_header;
            bit[10:0]  total_tcp_pkt_len;
            bit[10:0]  tcp_data_len;
            bit[159:0] ip_header;
            
            integer   i;
            integer   len;
            
            len = 0;
            // Parse the Raw data buffer
            // Copy the 48-bit MAC destination addr
            raw_dest_mac        = {raw_data[len+0], raw_data[len+1], raw_data[len+2], 
                                 raw_data[len+3], raw_data[len+4], raw_data[len+5]};
            //$display ("[MAC] Dest: %X", raw_dest_mac);                               
            // Update len to 6
            len = 6;
            // Copy the 48-bit MAC source addr
            raw_source_mac      = {raw_data[len+0], raw_data[len+1], raw_data[len+2], 
                                 raw_data[len+3], raw_data[len+4], raw_data[len+5]};
            //$display ("[MAC] Source: %X", raw_source_mac);                               
            // Update len to 12
            len = 12;
            // Copy the ether type field
            raw_ether_type      = {raw_data[len+0], raw_data[len+1]};
            //$display ("[MAC] Ether Type: %X", raw_ether_type);                               
            // Update len to 14
            len = 14;
            // Get the IP version
            raw_version         = raw_data[len][7:4];
            //$display ("[IP] Version: %X", raw_version);                               
            // Get the header length
            raw_ip_header_len   = raw_data[len][3:0];
            //$display ("[IP] IHL: %X", raw_ip_header_len);                               
            // Update len to 17
            len = 17;
            // Get the total length
            raw_total_len       = raw_data[len];
            //$display ("[IP] THL: %X", raw_total_len);                               
            // Update len to 20
            len = 20;
            // Get the DF flag
            raw_DF              = raw_data[len][6];
            //$display ("[IP] DF: %X", raw_DF);                               
            // Get the MF flag
            raw_MF              = raw_data[len][5];
            //$display ("[IP] MF: %X", raw_MF);                               
            // Update len to 22
            len = 22;
            // Get the TTL field
            raw_TTL             = raw_data[len];
            //$display ("[IP] TTL: %X", raw_TTL);                               
            // Update len to 23
            len = 23;
            // Get the protocol field
            raw_protocol        = raw_data[len];
            //$display ("[IP] Protocol: %X", raw_protocol);                               
            // Update len to 24
            len = 24;
            // Get the checksum value
            raw_ip_header_chksum   = {raw_data[len], raw_data[len+1]};
            //$display ("[IP] Checksum: %X", raw_ip_header_chksum);                               
            // Update len to 26
            len = 26;
            // Get the source address
            raw_source_addr     = {raw_data[len+0], raw_data[len+1], 
                                 raw_data[len+2], raw_data[len+3]};
            //$display ("[IP] Source Addr: %X", raw_source_addr);                               
            // Update len to 30
            len = 30;
            // Get the destination address
            raw_dest_addr       = {raw_data[len+0], raw_data[len+1], 
                                 raw_data[len+2], raw_data[len+3]};
            //$display ("[IP] Dest Addr: %X", raw_dest_addr);                               
            // Update len to 34
            len = 34;
            // Check if the options field is included
            if (raw_ip_header_len > 5)
            begin
                raw_ip_options = new [raw_ip_header_len - 5];
                // Copy the options value
                for (i = 0; i < (raw_ip_header_len - 5); i++)
                begin
                    raw_ip_options[i] = {raw_data[len+3], raw_data[len+2], 
                                      raw_data[len+1], raw_data[len+0]};
                    //$display ("[IP] Options: %X", raw_ip_options[i]);                               
                    // Update len
                    len = len + 4;
                end
            end
            // Get the TCP source port
            raw_source_port     = {raw_data[len+0], raw_data[len+1]};
            //$display ("[TCP] Source Port: %X", raw_source_port);                               
            // Update len 
            len = len + 2;
            // Get the TCP destination port
            raw_dest_port       = {raw_data[len+0], raw_data[len+1]};
            //$display ("[TCP] Dest Port: %X", raw_dest_port);                               
            // Update len 
            len = len + 2;
            // Copy the Sequence Number
            raw_seq_number      = {raw_data[len+0], raw_data[len+1],
                                   raw_data[len+2], raw_data[len+3]};
            //$display ("[TCP] Seq number: %X", raw_seq_number);                               
            // Update len 
            len = len + 4;
            // Copy the Acknowledge Number
            raw_ack_number      = {raw_data[len+0], raw_data[len+1],
                                   raw_data[len+2], raw_data[len+3]};
            //$display ("[TCP] Ack number: %X", raw_ack_number);                               
            // Update len 
            len = len + 4;
            // Get the TCP header length
            raw_tcp_header_len  = raw_data[len][7:4];
            //$display ("[TCP] IHL: %X", raw_tcp_header_len);                               
            // Update len 
            len = len + 1;
            // Get all the flags
            raw_URG             = raw_data[len][5];
            //$display ("[TCP] URG: %X", raw_URG);                               
            raw_ACK             = raw_data[len][4]; 
            //$display ("[TCP] ACK: %X", raw_ACK);                               
            raw_PSH             = raw_data[len][3]; 
            //$display ("[TCP] PSH: %X", raw_PSH);                               
            raw_RST             = raw_data[len][2]; 
            //$display ("[TCP] RST: %X", raw_RST);                               
            raw_SYN             = raw_data[len][1]; 
            //$display ("[TCP] SYN: %X", raw_SYN);                               
            raw_FIN             = raw_data[len][0]; 
            //$display ("[TCP] FIN: %X", raw_FIN);                               
            // Update len 
            len = len + 1;
            // Get the window size
            raw_window_size     = {raw_data[len+0], raw_data[len+1]};
            //$display ("[TCP] Window Size: %X", raw_window_size);                               
            // Update len 
            len = len + 2;
            // Get the TCP checksum
            raw_tcp_header_chksum = {raw_data[len+0], raw_data[len+1]};
            //$display ("[TCP] Checksum: %X", raw_tcp_header_chksum);                               
            // Update len 
            len = len + 4;
            // Calculate the TCP total packet len
            total_tcp_pkt_len = raw_tcp_header_len*4;
            // Check if the options field is included
            if (raw_tcp_header_len > 5)
            begin
                raw_tcp_options = new [raw_tcp_header_len - 5];
                // Copy the options value
                for (i = 0; i < (raw_tcp_header_len - 5); i++)
                begin
                    raw_tcp_options[i] = {raw_data[len+3], raw_data[len+2], 
                                          raw_data[len+1], raw_data[len+0]};
                    //$display ("[TCP] Options: %X", raw_tcp_options[i]);                               
                    // Update len
                    len = len + 4;
                end
            end
            // Copy the TCP data
            tcp_data_len        = (raw_total_len - ((raw_ip_header_len*4) + (raw_tcp_header_len*4)));
            raw_tcp_data        = new[tcp_data_len];
            total_tcp_pkt_len   = total_tcp_pkt_len + tcp_data_len;
            for (i = 0; i < tcp_data_len; i++)
            begin
                raw_tcp_data[i] = raw_data[len]; 
                //$display ("[TCP] Data: %X", raw_tcp_data[i]);                               
                // Update len
                len = len + 1;
            end
            // Create the TCP Pseudo header
            tcp_pseudo_header   = {{5'h0, total_tcp_pkt_len}, 8'h0, 8'h06,
                                      raw_dest_addr, raw_source_addr};
            // Create the TCP header
            tcp_header          = {({16'h0, 16'h0}),
                                  ({raw_window_size}), ({raw_tcp_header_len, 6'h0, 
                                                          raw_URG, raw_ACK, raw_PSH, 
                                                          raw_RST, raw_SYN, raw_FIN}),
                                  (raw_ack_number), (raw_seq_number), 
                                  (raw_dest_port),  (raw_source_port)};

            ip_header           = {(raw_dest_addr), (raw_source_addr), 
                                   (16'h0), 
                                   htons({8'h06, raw_TTL}), 
                                   ({1'h0, raw_DF, 
                                   raw_MF,13'h0}), (16'h0), 
                                   (raw_total_len), htons({8'h0, 
                                   raw_version, raw_ip_header_len})};

            if (raw_source_mac != source_mac)
            begin
                $fatal (1, "[MAC]: Source Addr mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_mac, raw_source_mac);
            end
            if (raw_dest_mac != dest_mac)
            begin
                $fatal (1, "[MAC]: Dest Addr mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_mac, raw_dest_mac);
            end
            if (raw_ether_type != ether_type)
            begin
                $fatal (1, "[MAC]: Ether Type mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ether_type, raw_ether_type);
            end
            if (raw_source_port != source_port)
            begin
                $fatal (1, "[TCP]: Source port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_port, raw_source_port);
            end
            if (raw_dest_port   != dest_port)      
            begin
                $fatal (1, "[TCP]: Destination port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_port, raw_dest_port);
            end
            if (raw_seq_number  != seq_number)     
            begin
                $fatal (1, "[TCP]: Sequence Number mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", seq_number, raw_seq_number);
            end
            if (raw_ack_number  != ack_number)     
            begin
                $fatal (1, "[TCP]: Ack Number mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ack_number, raw_ack_number);
            end
            if (raw_URG         != URG)            
            begin
                $fatal (1, "[TCP]: URG Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", URG, raw_URG);
            end
            if (raw_ACK         != ACK)            
            begin
                $fatal (1, "[TCP]: ACK Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ACK, raw_ACK);
            end
            if (raw_PSH         != PSH)            
            begin
                $fatal (1, "[TCP]: PSH Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", PSH, raw_PSH);
            end
            if (raw_RST         != RST)            
            begin
                $fatal (1, "[TCP]: RST Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", RST, raw_RST);
            end
            if (raw_SYN         != SYN)            
            begin
                $fatal (1, "[TCP]: SYN Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", SYN, raw_SYN);
            end
            if (raw_FIN         != FIN)            
            begin
                $fatal (1, "[TCP]: FIN Flag mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", FIN, raw_FIN);
            end
            if ((raw_tcp_header_len < 5) || (raw_tcp_header_len > 15))     
            begin
                $fatal (1, "[TCP]: Header Length not between 5 and 15. Actual: 0x%08x", raw_tcp_header_len);
            end
            if (raw_window_size != window_size)    
            begin
                $fatal (1, "[TCP]: Window Size mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", window_size, raw_window_size);
            end
            if (raw_tcp_header_chksum != cal_tcp_chksum (tcp_pseudo_header, tcp_header, raw_tcp_header_len, 
                                                         raw_tcp_options, tcp_data_len, raw_tcp_data))
            begin
                $fatal (1, "[TCP]: Check Sum failed! Expected: 0x%08x\t Actual: 0x%08X\n",cal_tcp_chksum (tcp_pseudo_header, 
                                                                                tcp_header,raw_tcp_header_len, raw_tcp_options, 
                                                                                tcp_data_len,raw_tcp_data), raw_tcp_header_chksum);
            end
            if (raw_version != 'h4)
            begin
                $fatal (1, "[IP]: Version mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", 'h4, raw_version);
            end
            if (raw_DF != 'h1)
            begin
                $fatal (1, "[IP]: DF bit not set! \n");
            end
            if ((raw_ip_header_len < 5) || (raw_ip_header_len > 15))     
            begin
                $fatal (1, "[IP]: Header Length not between 5 and 15. Actual: 0x%08x", raw_ip_header_len);
            end
            if (raw_source_addr != source_addr)
            begin
                $fatal (1, "[IP]: Source Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_addr, raw_source_addr);
            end
            if (raw_dest_addr != dest_addr)
            begin
                $fatal (1, "[IP]: Destination Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_addr, raw_dest_addr);
            end
            if (raw_protocol != 'h06)
            begin
                $fatal (1, "[IP]: Protocol field mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", 'h6, raw_protocol);
            end
            if (raw_ip_header_chksum != cal_ip_chksum (ip_header, raw_ip_header_len,
                                                       raw_ip_options))
            begin
                $fatal (1, "[IP]: Check Sum failed! Expected: 0x%08x\t Actual: 0x%08X\n",cal_ip_chksum (ip_header, 
                                                                                raw_ip_header_len,raw_ip_options),
                                                                                raw_ip_header_chksum);
            end
            
        endfunction

        function bit[15:0] cal_tcp_chksum (bit[95:0] tcp_pseudo_header, bit[159:0] tcp_header,
                                           bit[10:0] tcp_header_len, bit[31:0] tcp_options[], 
                                           bit[10:0] tcp_data_len, bit[7:0] tcp_data[]);
            // Here's how to verify the checksum:
            // 1. Add each 16-bit value together.
            // 2. Add in any carry
            // 3. The result should be 0
            bit [15:0]  sum   = 'h0;
            bit         carry = 'h0;
            // Calculate the sum over the pseudo header
            for (int i = 0; i < 6; i++)
            begin
                //$display ("0x%4x\n", tcp_pseudo_header [i*16+:16]);
                {carry, sum} = sum + tcp_pseudo_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Calculate the sum over the TCP header
            for (int i = 0; i < 10; i++)
            begin
                //$display ("0x%4x\n", tcp_header [i*16+:16]);
                {carry, sum} = sum + tcp_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Calculate the sum over the options field
            for (int i = 0; i <(tcp_header_len - 5) ; i++)
            begin
                //$display ("0x%4x\n", tcp_options[i][15:0]);
                {carry, sum} = sum + htons(tcp_options[i][15:0]);
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
                //$display ("0x%4x\n", tcp_options[i][31:16]);
                {carry, sum} = sum + htons(tcp_options[i][31:16]);
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Calculate the sum over the Data payload
            for (int i = 0; i < tcp_data_len; i = i+2)
            begin
                //$display ("0x%4x\n", htons({tcp_data[i+1], tcp_data[i]}));
                {carry, sum} = sum + htons({tcp_data[i+1], tcp_data[i]});
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Perform bitwise negation on sum
            // Return the value
            return ~sum;
        endfunction

        // Method to test the UDP packet
        function void check_udp (bit[7:0]  raw_data[],  bit[47:0] source_mac,
                                 bit[47:0] dest_mac,    bit[15:0] ether_type,
                                 bit[15:0] source_port, bit[15:0] dest_port,
                                 bit[31:0] source_addr, bit[31:0] dest_addr
        );
            bit[47:0]  raw_dest_mac;
            bit[47:0]  raw_source_mac;
            bit[15:0]  raw_ether_type;
            bit[15:0]  raw_source_port;
            bit[15:0]  raw_dest_port;
            bit[3:0]   raw_version;
            bit[3:0]   raw_ip_header_len;
            bit[7:0]   raw_dscp;
            bit[15:0]  raw_total_len;
            bit[15:0]  raw_identification;
            bit        raw_DF;
            bit        raw_MF;
            bit[12:0]  raw_frag_offset;
            bit[7:0]   raw_TTL;
            bit[7:0]   raw_protocol;
            bit[15:0]  raw_ip_header_chksum;
            bit[31:0]  raw_source_addr;
            bit[31:0]  raw_dest_addr;
            bit[31:0]  raw_ip_options [];
            bit[10:0]  udp_data_len;
            bit[7:0]   raw_udp_data[];
            bit[15:0]  raw_udp_len;
            bit[15:0]  raw_udp_header_chksum;
            bit[95:0]  udp_pseudo_header;
            bit[63:0]  udp_header;
            bit[159:0] ip_header;

            integer   i;
            integer   len;
            
            len = 0;
            // Parse the Raw data buffer
            // Copy the 48-bit MAC destination addr
            raw_dest_mac        = {raw_data[len+0], raw_data[len+1], raw_data[len+2], 
                                 raw_data[len+3], raw_data[len+4], raw_data[len+5]};
            //$display ("[MAC] Dest: %X", raw_dest_mac);                               
            // Update len to 6
            len = 6;
            // Copy the 48-bit MAC source addr
            raw_source_mac      = {raw_data[len+0], raw_data[len+1], raw_data[len+2], 
                                 raw_data[len+3], raw_data[len+4], raw_data[len+5]};
            //$display ("[MAC] Source: %X", raw_source_mac);                               
            // Update len to 12
            len = 12;
            // Copy the ether type field
            raw_ether_type      = {raw_data[len+0], raw_data[len+1]};
            //$display ("[MAC] Ether Type: %X", raw_ether_type);                               
            // Update len to 14
            len = 14;
            // Get the IP version
            raw_version         = raw_data[len][7:4];
            //$display ("[IP] Version: %X", raw_version);                               
            // Get the header length
            raw_ip_header_len   = raw_data[len][3:0];
            //$display ("[IP] IHL: %X", raw_ip_header_len);                               
            // Update len to 17
            len = 17;
            // Get the total length
            raw_total_len       = raw_data[len];
            //$display ("[IP] THL: %X", raw_total_len);                               
            // Update len to 20
            len = 20;
            // Get the DF flag
            raw_DF              = raw_data[len][6];
            //$display ("[IP] DF: %X", raw_DF);                               
            // Get the MF flag
            raw_MF              = raw_data[len][5];
            //$display ("[IP] MF: %X", raw_MF);                               
            // Update len to 22
            len = 22;
            // Get the TTL field
            raw_TTL             = raw_data[len];
            //$display ("[IP] TTL: %X", raw_TTL);                               
            // Update len to 23
            len = 23;
            // Get the protocol field
            raw_protocol        = raw_data[len];
            //$display ("[IP] Protocol: %X", raw_protocol);                               
            // Update len to 24
            len = 24;
            // Get the checksum value
            raw_ip_header_chksum   = {raw_data[len], raw_data[len+1]};
            //$display ("[IP] Checksum: %X", raw_ip_header_chksum);                               
            // Update len to 26
            len = 26;
            // Get the source address
            raw_source_addr     = {raw_data[len+0], raw_data[len+1], 
                                 raw_data[len+2], raw_data[len+3]};
            //$display ("[IP] Source Addr: %X", raw_source_addr);                               
            // Update len to 30
            len = 30;
            // Get the destination address
            raw_dest_addr       = {raw_data[len+0], raw_data[len+1], 
                                 raw_data[len+2], raw_data[len+3]};
            //$display ("[IP] Dest Addr: %X", raw_dest_addr);                               
            // Update len to 34
            len = 34;
            // Check if the options field is included
            if (raw_ip_header_len > 5)
            begin
                raw_ip_options = new [raw_ip_header_len - 5];
                // Copy the options value
                for (i = 0; i < (raw_ip_header_len - 5); i++)
                begin
                    raw_ip_options[i] = {raw_data[len+3], raw_data[len+2], 
                                      raw_data[len+1], raw_data[len+0]};
                    //$display ("[IP] Options: %X", raw_ip_options[i]);                               
                    // Update len
                    len = len + 4;
                end
            end
            // Get the UDP source port
            raw_source_port     = {raw_data[len+0], raw_data[len+1]};
            //$display ("[UDP] Source Port: %X", raw_source_port);                               
            // Update len 
            len = len + 2;
            // Get the UDP destination port
            raw_dest_port       = {raw_data[len+0], raw_data[len+1]};
            //$display ("[UDP] Dest Port: %X", raw_dest_port);                               
            // Update len 
            len = len + 2;
            // Get the UDP len
            raw_udp_len         = {raw_data[len+0], raw_data[len+1]};
            //$display ("[UDP] Len: %X", raw_udp_len);                               
            // Update len 
            len = len + 2;
            // Get the UDP checksum
            raw_udp_header_chksum = {raw_data[len+0], raw_data[len+1]};
            // Update len 
            len = len + 2;
            // Copy the UDP data
            udp_data_len        = raw_udp_len - 8;
            raw_udp_data        = new[udp_data_len];
            for (i = 0; i < udp_data_len; i++)
            begin
                raw_udp_data[i] = raw_data[len]; 
                //$display ("[UDP] Data: %X", raw_udp_data[i]);                               
                // Update len
                len = len + 1;
            end
            udp_pseudo_header   = { raw_udp_len, 8'h0, 8'h11,
                                    raw_dest_addr, raw_source_addr};
            udp_header          = {16'h0, raw_udp_len,
                                   raw_dest_port, raw_source_port}; 

            ip_header           = {(raw_dest_addr), (raw_source_addr), 
                                   (16'h0), 
                                   htons({8'h11, raw_TTL}), 
                                   ({1'h0, raw_DF, 
                                   raw_MF,13'h0}), (16'h0), 
                                   (raw_total_len), htons({8'h0, 
                                   raw_version, raw_ip_header_len})};
            
            if (raw_source_mac != source_mac)
            begin
                $fatal (1, "[MAC]: Source Addr mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_mac, raw_source_mac);
            end
            if (raw_dest_mac != dest_mac)
            begin
                $fatal (1, "[MAC]: Dest Addr mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_mac, raw_dest_mac);
            end
            if (raw_ether_type != ether_type)
            begin
                $fatal (1, "[MAC]: Ether Type mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", ether_type, raw_ether_type);
            end
            if (raw_source_port != source_port)    
            begin
                $fatal (1, "[UDP]: Source Port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_port, raw_source_port);
            end
            if (raw_dest_port   != dest_port)      
            begin
                $fatal (1, "[UDP]: Destination port mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_port, raw_dest_port);
            end
            if (raw_udp_header_chksum != cal_udp_chksum (udp_pseudo_header, udp_header,
                                                         udp_data_len, raw_udp_data))
            begin
                $fatal (1, "[UDP]: Check Sum failed! Expected: 0x%08x\t Actual: 0x%08X\n",cal_udp_chksum (udp_pseudo_header, 
                                                                                udp_header,udp_data_len,raw_udp_data),
                                                                                raw_udp_header_chksum);
            end
            if (raw_version != 'h4)
            begin
                $fatal (1, "[IP]: Version mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", 'h4, raw_version);
            end
            if (raw_DF != 'h1)
            begin
                $fatal (1, "[IP]: DF bit not set! \n");
            end
            if ((raw_ip_header_len < 5) || (raw_ip_header_len > 15))     
            begin
                $fatal (1, "[IP]: Header Length not between 5 and 15. Actual: 0x%08x", raw_ip_header_len);
            end
            if (raw_source_addr != source_addr)
            begin
                $fatal (1, "[IP]: Source Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", source_addr, raw_source_addr);
            end
            if (raw_dest_addr != dest_addr)
            begin
                $fatal (1, "[IP]: Destination Address mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", dest_addr, raw_dest_addr);
            end
            if (raw_protocol != 'h11)
            begin
                $fatal (1, "[IP]: Protocol field mismatch! Expected: 0x%08x\t Actual: 0x%08x\n", 'h11, raw_protocol);
            end
            if (raw_ip_header_chksum != cal_ip_chksum (ip_header, raw_ip_header_len,
                                                       raw_ip_options))
            begin
                $fatal (1, "[IP]: Check Sum failed! Expected: 0x%08x\t Actual: 0x%08X\n",cal_ip_chksum (ip_header, 
                                                                                raw_ip_header_len,raw_ip_options),
                                                                                raw_ip_header_chksum);
            end
        endfunction

        function bit[15:0] cal_udp_chksum (bit[95:0] udp_pseudo_header, bit[63:0] udp_header,
                                           bit[15:0] udp_data_len, bit[7:0] udp_data[]);
            // Here's how to compute a checksum:
            // 1. Put a 0 in the checksum field (create_packet does that).
            // 2. Add each 16-bit value together.
            // 3. Add in any carry
            // 4. Inverse the bits and put that in the checksum field.
            bit [15:0]  sum = 'h0;
            bit         carry = 'h0;
            // Calculate the sum over the pseudo header
            for (int i = 0; i < 6; i++)
            begin
                //$display ("0x%4x\n", udp_pseudo_header [i*16+:16]);
                {carry, sum} = sum + udp_pseudo_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            for (int i = 0; i < 4; i++)
            begin
                //$display ("0x%4x\n", udp_header [i*16+:16]);
                {carry, sum} = sum + udp_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Calculate the sum over the Data payload
            for (int i = 0; i < udp_data_len; i = i+2)
            begin
                //$display ("0x%4x\n", htons({udp_data[i+1], udp_data[i]}));
                {carry, sum} = sum + htons({udp_data[i+1], udp_data[i]});
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Perform bitwise negation on sum
            return ~sum;
        endfunction

        function bit[15:0] cal_ip_chksum  (bit[159:0] ip_header, bit[3:0] ip_header_len,
                                           bit[31:0] ip_options[]);
            // Here's how to compute a checksum:
            // 1. Put a 0 in the checksum field (create_packet does that).
            // 2. Add each 16-bit value together.
            // 3. Add in any carry
            // 4. Inverse the bits and put that in the checksum field.
            // Perform bitwise negation on sum
            bit [15:0]  sum = 'h0;
            bit         carry = 'h0;
            for (int i = 0; i < 10; i++)
            begin
                //$display ("0x%4x\n", ip_header [i*16+:16]);
                {carry, sum} = sum + ip_header [i*16+:16];
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            // Calculate the sum over the options field
            for (int i = 0; i <(ip_header_len - 5) ; i++)
            begin
                //$display ("0x%4x\n", htons(ip_options[i][15:0]));
                {carry, sum} = sum + htons(ip_options[i][15:0]);
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
                //$display ("0x%4x\n", htons(ip_options[i][31:16]));
                {carry, sum} = sum + htons(ip_options[i][31:16]);
                // Check if we have a carry
                if (carry)
                begin
                    // Add the carry back to sum
                    sum = sum + {15'h0, carry};
                end
            end
            return ~sum;
        endfunction

    endclass

endpackage
