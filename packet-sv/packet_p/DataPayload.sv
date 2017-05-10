package DataPayload_pkg;

    class DataPayload;
        
        // Class Properties:
        // Data length - 11-bit field vector
        // Length specifies the size in Bytes
        bit [10:0]  data_len;
        // Data vector - 8-bit dynamic
        // array indexed with bit [10:0]
        // as per the data_len vector
        bit [7:0]   data [];

    endclass

endpackage
