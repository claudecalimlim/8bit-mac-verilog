// 8-bit signed multiply-accumulate unit
// acc <= acc + a*b on every clock edge while en is high
module mac #(
    parameter ACC_W = 24
) (
    input  wire                     clk,
    input  wire                     rst_n,   // active-low async reset
    input  wire                     en,      // accumulate when high
    input  wire                     clear,   // zero the accumulator (sync)
    input  wire signed [7:0]        a,
    input  wire signed [7:0]        b,
    output reg  signed [ACC_W-1:0]  acc
);

    // 8x8 signed -> 16-bit signed product
    wire signed [15:0] product = a * b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc <= {ACC_W{1'b0}};
        else if (clear)
            acc <= {ACC_W{1'b0}};
        else if (en)
            acc <= acc + product;   // product gets sign-extended to ACC_W
    end

endmodule
