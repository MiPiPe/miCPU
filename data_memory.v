`include "define.v"

module data_memory( clk, rst, wen,ren, addr, write_data, read_data);

  input clk;
  input rst;
  input wen,ren;
  input [`ASIZE-1:0] addr;      // address input
  input [`DSIZE-1:0] write_data;          // data input
  output reg [`DSIZE-1:0] read_data;    // data output
  reg [`DSIZE-1:0] memory [0:2**`ASIZE-1];
  reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, fout,i, c, r;
reg [`ASIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;
reg [`ASIZE-1:0] addr_r;
//assign data_out = (ren)? memory[addr_r]:16'b0;

  always @(posedge clk)
    begin
      if(rst)
        begin
          addr_r =0;
          read_data=16'b0;
          fin=$fopen("dm_test.txt","r");

          for (i = 0; i < 2 ** `ASIZE; i = i + 1)
          begin
             memory[i] = 16'h0000;
          end
          //Now read in the input file
          while(!$feof(fin)) 
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
          if (ren)
            read_data =memory[addr];
            else if (wen)
            begin            // active-low write enable
              memory[addr] = write_data;
              fout = $fopen("outdata.txt","w");
              $fwrite(fout, "%h %h\n",write_data,addr);
              $fclose(fout);
            end
        end
    end

endmodule

