`timescale 1ns / 1ps

module part1_without_pipeline_test;

// Inputs
reg clk;
reg rst;

// Instantiate the Unit Under Test (UUT)
part1_without_pipeline uut (
                           .clk(clk),
                           .rst(rst)
                       );

always #15 clk = ~clk;
initial begin
    // Initialize Inputs
    clk = 0;
    rst = 0;
    // Wait 100 ns for global reset to finish
    #100;
    #25 rst =1;
    #25 rst=0;
    // Add stimulus here

end

endmodule

