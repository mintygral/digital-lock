`timescale 1ms/10ps
module tb;

 typedef enum logic [3:0] {
    LS0 = 0, LS1 = 1, LS2 = 2, LS3 = 3, LS4 = 4, LS5 = 5, LS6 = 6, LS7 = 7,
    OPEN = 8,
    ALARM = 9,
    INIT = 10
  } state_t;


// inputs
logic strobe;
logic rst;
logic [16:0] in;
initial strobe = 0;
always strobe = #50 ~strobe;
logic [4:0] keyout;

// outputs
// logic [4:0] keyout;
state_t current_state;
// logic [31:0] password;

logic [4:0] testdata [];

fsm unlock(.clk(strobe), 
        .rst(rst), 
        .keyout(keyout),
        .seq(32'h12345678),
        .state(current_state));
        
initial begin 
    $dumpfile("sim.vcd");
    $dumpvars(0, tb);
    #10;
    rst = 0; 
    keyout = 0;
    toggle_rst(); 
    //Test case 1: fully correct
    #10;
    testdata = '{5'd16, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8};

    // Test case 2: incorrect, does not reset
    #10;
    testdata = '{5'd16, 5'd1, 5'd2, 5'd3, 5'd3, 5'd5, 5'd6, 5'd7, 5'd8};
    sendstream(testdata);

    // Test case 3: incorrect, does reset
    #10;
    testdata = '{5'd16, 5'd1, 5'd2, 5'd3, 5'd3, 5'd16, 5'd16, 5'd1, 5'd2};
    sendstream(testdata);
    #10 $finish;
    $display("Simulation finished.");

    // Test case 4: incorrect, starts off with reset, resets again
    #10;
    testdata = '{5'd16, 5'd1, 5'd2, 5'd3, 5'd3, 5'd16, 5'd16, 5'd1, 5'd2};
    sendstream(testdata);
  
    // Test case 5: spam reset button (stays at z)
    #10;
    testdata = '{5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16};
    sendstream(testdata);

    // Test case 5: toggle between init and alarm, and then correct 
    #10;
    testdata = '{5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd16, 5'd1, 5'd2};
    sendstream(testdata);

    #10 $finish;
    $display("Simulation finished.");
end

task toggle_rst; 
    rst = 0; #10;
    rst = 1; #10;
    rst = 0; #10;
endtask

task send_key;
    input logic [4:0] keytosend;
    begin 
        @ (negedge strobe);
        keyout = keytosend;
        @ (posedge strobe);
        #10;
    end
endtask

task sendstream;
    input logic [4:0] stream [];
    begin 
        for (integer keynum = 0; keynum < stream.size(); keynum++) begin
            send_key(stream[keynum]); end
    end
endtask


endmodule
