`timescale 1ns / 1ps


module part2_with_cache_test;

// Inputs
reg clk;
reg rst;

// Instantiate the Unit Under Test (UUT)
part2_with_cache uut (
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
    #100 rst =1;
    #100 rst = 0;
    // Add stimulus here

end

endmodule
