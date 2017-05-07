module top ();

    import simple_pkg::*;
    my_class C1;
    my_class C2;
    initial
    begin
        C1 = new("default");
        C2 = new("C2");
    end
endmodule
