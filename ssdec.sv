module ssdec(
    input logic [3:0] in,
    input logic enable, //sss
    output logic [6:0]out
  );


  always_comb begin
    out = 7'b0000000;
    if (enable == 1) begin
    case({in})
    4'b0000: begin out = 7'b0111111; end // none
    4'b0001: begin out = 7'b0000110; end // one
    4'b0010: begin out = 7'b1011011; end // two
    4'b0011: begin out = 7'b1001111; end  // three
    4'b0100: begin out = 7'b1100110; end  // four
    4'b0101: begin out = 7'b1101101; end  // five
    4'b0110: begin out = 7'b1111101; end  // six
    4'b0111: begin out = 7'b0000111; end  // seven
    4'b1000: begin out = 7'b1111111; end  // eight
    4'b1001: begin out = 7'b1100111; end  // nine -- checked!!!
    4'b1010: begin out = 7'b1110111; end  // A
    4'b1011: begin out = 7'b1111100; end  // b
    4'b1100: begin out = 7'b0111001; end  // C
    4'b1101: begin out = 7'b1011110; end  // d
    4'b1110: begin out = 7'b1111001; end  // E
    4'b1111: begin out = 7'b1110001; end  // F -- checked!!!
    default: begin out = 7'b0000000; end
    endcase
    end
  end

endmodule
