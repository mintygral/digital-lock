module display (
  input logic [3:0] state,
  input logic [31:0] seq,
  output logic [63:0] ss,
  output logic red, green, blue
);
  // open state
  // assign temp variable instead of ss for now
  logic [63:0] ss_temp;
  ssdec pw7(.in(seq[31:28]), .enable(state == INIT), .out(ss_temp[62:56]));
  ssdec pw6(.in(seq[27:24]), .enable(state == INIT), .out(ss_temp[54:48]));
  ssdec pw5(.in(seq[23:20]), .enable(state == INIT), .out(ss_temp[46:40]));
  ssdec pw4(.in(seq[19:16]), .enable(state == INIT), .out(ss_temp[38:32]));
  ssdec pw3(.in(seq[15:12]), .enable(state == INIT), .out(ss_temp[30:24]));
  ssdec pw2(.in(seq[11:8]), .enable(state == INIT), .out(ss_temp[22:16]));
  ssdec pw1(.in(seq[7:4]), .enable(state == INIT), .out(ss_temp[14:8]));
  ssdec pw0(.in(seq[3:0]), .enable(state == INIT), .out(ss_temp[6:0]));

  always_comb begin
    green = 0;
    red = 0;
    blue = 0;
    ss[63:0] = 64'd0;

    case({state})
      OPEN: begin
        green = 1;
        red = 0;
        blue = 0;
        ss[63:56] = 8'b00111111; // O
        ss[55:48] = 8'b01110011; // P
        ss[47:40] = 8'b01111001; // E
        ss[39:32] = 8'b00110111; // N
      end
      ALARM: begin
        green = 0;
        red = 1;
        blue = 0;
        ss[63:56] = 8'b00111001;
        ss[55:48] = 8'b01110111;
        ss[47:40] = 8'b00111000;
        ss[39:32] = 8'b00111000;
       
        ss[31:24] = 8'b01100111;
        ss[23:16] = 8'b00000110;
        ss[15:8] = 8'b00000110;  //Call 911
      end
      INIT: begin
          blue = 0;
          green = 0;
          red = 0;
          ss = ss_temp; // in init state the password will display
      end
      LS0: begin
        green = 0;
        red = 0;
        blue = 1;
        ss[63] = 1'b1;
      end
      LS1: begin green = 0; red = 0; blue = 1; ss[55] = 1'b1; end
      LS2: begin green = 0; red = 0; blue = 1; ss[47] = 1'b1; end
      LS3: begin green = 0; red = 0; blue = 1; ss[39] = 1'b1; end
      LS4: begin green = 0; red = 0; blue = 1; ss[31] = 1'b1; end
      LS5: begin green = 0; red = 0; blue = 1; ss[23] = 1'b1; end
      LS6: begin green = 0; red = 0; blue = 1; ss[15] = 1'b1; end
      LS7: begin green = 0; red = 0; blue = 1; ss[7] = 1'b1; end
      default:  begin green = 0; red = 0; blue = 0; end
    endcase
  end
endmodule
