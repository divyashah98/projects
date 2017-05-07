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
    endclass

endpackage
