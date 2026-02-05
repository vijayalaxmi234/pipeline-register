`timescale 1ns/1ps

module pipeline_register_tb;

    parameter WIDTH = 8;

    reg clk;
    reg rst_n;

    // Input interface
    reg                  in_valid;
    wire                 in_ready;
    reg  [WIDTH-1:0]     in_data;

    // Output interface
    wire                 out_valid;
    reg                  out_ready;
    wire [WIDTH-1:0]     out_data;

    // Instantiate DUT
    pipeline_register #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_data(in_data),
        .out_valid(out_valid),
        .out_ready(out_ready),
        .out_data(out_data)
    );


    always #5 clk = ~clk;

 
    initial begin
       
        $dumpfile("dump.vcd");
        $dumpvars(0, pipeline_register_tb);

        clk = 0;
        rst_n = 0;
        in_valid = 0;
        in_data = 0;
        out_ready = 0;

        // Reset
        #20;
        rst_n = 1;

        // Case 1: Normal transfer
        #10;
        in_valid = 1;
        in_data  = 8'hA5;
        out_ready = 1;

        #10;
        in_valid = 0;

        // Case 2: Backpressure
        #10;
        in_valid = 1;
        in_data  = 8'h3C;
        out_ready = 0;   /

        #20;             
        out_ready = 1;   
        #10;
        in_valid = 0;

        // Case 3: Continuous streaming
        #10;
        out_ready = 1;
        in_valid = 1;
        in_data  = 8'h55;

        #10;
        in_data  = 8'hAA;

        #10;
        in_data  = 8'hFF;

        #10;
        in_valid = 0;

        #30;
        $finish;
    end

endmodule
