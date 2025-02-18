module fsm (
  input logic clk, rst,
  input logic [4:0] keyout,
  input logic [31:0] seq,
  output state_t state
);
  state_t next_state;
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1) begin
      state <= INIT;
    end
    else begin
      state <= next_state;
    end
  end
 
  always_comb begin
    next_state = state;
    case(state)
      INIT: if (keyout == 5'd16) begin next_state = LS0; end // 16 = W
        else begin next_state = INIT; end  
      LS0: if (keyout == {1'd0, seq[31:28]}) begin next_state = LS1; end
        else begin next_state = ALARM; end  
      LS1: if (keyout == {1'd0, seq[27:24]}) begin next_state = LS2; end
        else begin next_state = ALARM; end  
      LS2: if (keyout == {1'd0, seq[23:20]}) begin next_state = LS3;end
        else begin next_state = ALARM; end
      LS3: if (keyout == {1'd0, seq[19:16]}) begin next_state = LS4;end
        else begin next_state = ALARM; end  
      LS4: if (keyout == {1'd0, seq[15:12]}) begin next_state = LS5;end
        else begin next_state = ALARM; end  
      LS5: if (keyout == {1'd0, seq[11:8]}) begin next_state = LS6;end
        else begin next_state = ALARM; end  
      LS6: if (keyout == {1'd0, seq[7:4]}) begin next_state = LS7; end
        else begin next_state = ALARM; end  
      LS7: if (keyout == {1'd0, seq[3:0]}) begin next_state = OPEN;end  // 8 = open
        else begin next_state = ALARM; end  
      OPEN: if (keyout == 16) begin next_state = LS0; end  // alarm = 9
        //else begin next_state = ALARM; end
      ALARM: begin next_state = ALARM; end
      default: next_state = INIT;
    endcase
  end
endmodule
