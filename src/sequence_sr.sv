module sequence_sr (
  input logic clk, rst, en,
  input logic [4:0] in,
  output logic [31:0] out
);

  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1) begin
        out <= 32'd0;
    end
    else begin if (en == 1 && in < 16) begin
      out <= (en == 1 && in < 5'd16) ? {out[27:0], in[3:0]} : out;
      end
    end
  end
endmodule
