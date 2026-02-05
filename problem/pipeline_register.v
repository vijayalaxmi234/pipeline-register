module pipeline_register
(
    clk,
    rst_n,
    in_valid,
    in_ready,
    in_data,
    out_valid,
    out_ready,
    out_data
);

parameter WIDTH = 32;

input clk;
input rst_n;

input in_valid;
output in_ready;
input [WIDTH-1:0] in_data;

output out_valid;
input out_ready;
output [WIDTH-1:0] out_data;

reg [WIDTH-1:0] data_q;
reg valid_q;

assign in_ready  = ~valid_q | out_ready;
assign out_valid = valid_q;
assign out_data  = data_q;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        valid_q <= 1'b0;
        data_q  <= 0;
    end
    else
    begin
        if (in_valid && in_ready)
        begin
            data_q  <= in_data;
            valid_q <= 1'b1;
        end
        else if (out_ready && valid_q)
        begin
            valid_q <= 1'b0;
        end
    end
end

endmodule
