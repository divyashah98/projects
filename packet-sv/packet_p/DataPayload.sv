package DataPayload_pkg;

    class DataPayload;
        
        // Class Properties:
        // Data length - 11-bit field vector
        // Length specifies the size in Bytes
        bit [10:0]  data_len;
        // Data vector - 8-bit of associative
        // array indexed with bit [10:0] to
        // as per the data_len vector
        bit [7:0]   data [bit [10:0]];

        // Class Methods:
        // Method new () - overridden to get both
        // data length and data as the input from
        // the user
        function new (bit [10:0] data_len, bit[7:0] data [bit [10:0]]);
            // Initialise the class properties with the given inputs
            this.data_len = data_len;
            this.data     = data;
        endfunction

    endclass

endpackage
