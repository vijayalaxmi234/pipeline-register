module pipeline_register 
(
    parameter WIDTH = 32
)
(
    input                  clk,
    input                  rst_n,

    // Input interface
    input                  in_valid,
    output                 in_ready,
    input  [WIDTH-1:0]     in_data,

    // Output interface
    output                 out_valid,
    input                  out_ready,
    output [WIDTH-1:0]     out_data
);

    reg [WIDTH-1:0] data_q;
    reg             valid_q;

    //------------------------------------------
    // Ready/Valid Assignments
    //------------------------------------------
    assign in_ready  = ~valid_q | out_ready;
    assign out_valid = valid_q;
    assign out_data  = data_q;

    //------------------------------------------
    // Sequential Logic
    //------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_q <= 1'b0;
            data_q  <= {WIDTH{1'b0}};
        end
        else begin
            // Accept new data
            if (in_valid && in_ready) begin
                data_q  <= in_data;
                valid_q <= 1'b1;
            end
            // Downstream consumes data
            else if (out_ready && valid_q) begin
                valid_q <= 1'b0;
            end
        end
    end

endmodule
