package Packet_pkg;

    // Create the PacketGen base class
    // The base class would be inherited
    // by every packet type. Declare all the
    // functions used by other packets here as
    // virtual functions.
    class PacketGen; 

        // In new just call the create_packet function
        // This is just required to maintain similarity
        // between the different class implementations
        function new ();
            create_packet();
        endfunction

        // Don't do anything here. This function
        // would be overriden by every child class
        virtual function void create_packet ();
        endfunction

        // Function to convert the element into
        // big endian form. The size of the 
        // element is 16-bits here (2 bytes)
        function bit [15:0] htons (bit [15:0] host_pkt);
            integer i;
            bit [15:0] net_pkt;

            net_pkt = {host_pkt[7:0], host_pkt[15:8]};
            return net_pkt;
        endfunction

        // Function to convert the element into
        // little endian form. The size of the 
        // element is 16-bits here (2 bytes)
        function bit [15:0] ntohs (bit [15:0] net_pkt);
            integer i;
            bit [15:0] host_pkt;

            host_pkt = {net_pkt[7:0], net_pkt[15:8]};
            return net_pkt;
        endfunction

        // Function to convert the element into
        // big endian form. The size of the 
        // element is 32-bits here (4 bytes)
        function bit [31:0] htonl (bit [31:0] host_pkt);
            integer i;
            bit [31:0] net_pkt;

             net_pkt = {host_pkt[7:0],   host_pkt[15:8],
                        host_pkt[23:16], host_pkt[31:24]}; 
            return net_pkt;
        endfunction

        // Function to convert the element into
        // big endian form. The size of the 
        // element is 48-bits here (6 bytes)
        function bit [47:0] htonll (bit [47:0] host_pkt);
            integer i;
            bit [47:0] net_pkt;

             net_pkt = {host_pkt[7:0],   host_pkt[15:8],
                        host_pkt[23:16], host_pkt[31:24], 
                        host_pkt[39:32], host_pkt[47:40]};
            return net_pkt;
        endfunction
    endclass

endpackage
