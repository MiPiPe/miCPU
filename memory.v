`include "define.v"

module memory( clk, rst, wen, addr, data_in, data_out);

  input clk;
  input rst;
  input wen;
  input [`ISIZE-1:0] addr;      // address input is 16 bit wide 
  input [`DSIZE-1:0] data_in;          // data input
  output [`DSIZE-1:0] data_out;    // data output
  reg [`DSIZE-1:0] memory [0:4096*`ISIZE-1]; //size of the memory
  reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, i, c, r;
reg [`ISIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;
reg [`ISIZE-1:0] addr_r;

assign data_out = memory[addr_r];

  always @(posedge clk)
    begin
      if(rst)
        begin
	       addr_r <=0;
  	       fin = $fopen("im_test.txt","r");
      	 while (!$feof(fin))
          begin
            c = $fgetc(fin);
            // check for comment
            if (c == "/" | c == "#" | c == "%")
              r = $fgets(line, fin);
            else
            begin
            // Push the character back to the file then read the next time
              r = $ungetc(c, fin);
              r = $fscanf(fin, "%h %h",t_addr, t_data);
              memory[t_addr]=t_data;
            end
          end
          $fclose(fin);
  	     end
      else
        begin
	       addr_r <= addr;
          if (wen)
            begin            // active-high write enable
              memory[addr] <= data_in;
            end 
	      end
    end

endmodule