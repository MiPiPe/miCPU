`include "define.v"

module data_memory( clk, rst, wen, addr, write_data, read_data);

input clk;
input rst;
input wen;
input [11:0] addr;      // address input
input [255:0] write_data;          // data input
output [255:0] read_data;    // data output
reg [`DSIZE-1:0] memory [0:4096*`ISIZE-1];
reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, fout,i, c, r, addr_mem;
reg [`ISIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;

//reg [`ISIZE-1:0] addr_r;

assign read_data = {memory[{addr, 4'h0}],
                    memory[{addr, 4'h1}],
                    memory[{addr, 4'h2}],
                    memory[{addr, 4'h3}],
                    memory[{addr, 4'h4}],
                    memory[{addr, 4'h5}],
                    memory[{addr, 4'h6}],
                    memory[{addr, 4'h7}],
                    memory[{addr, 4'h8}],
                    memory[{addr, 4'h9}],
                    memory[{addr, 4'ha}],
                    memory[{addr, 4'hb}],
                    memory[{addr, 4'hc}],
                    memory[{addr, 4'hd}],
                    memory[{addr, 4'he}],
                    memory[{addr, 4'hf}]
                };

always @(posedge clk)
begin
    if(rst)
    begin
        //addr_r <=0;
        fin=$fopen("dm_test.txt","r");
        while(!$feof(fin))
        begin
            c = $fgetc(fin);
            // check for comment
            if (c == "/" | c == "#" | c == "%")
                r = $fgets(line, fin);
            else
            begin
                // Push the character back to the file then read the next time
                // r = $ungetc(c, fin);
                // r = $fscanf(fin, "%h %h",t_addr, t_data);
                memory[t_addr] = t_data;
                // fout = $fopen("dm_init.txt","a");
                // $fwrite(fout, "read from %h: %h\n",t_addr,t_data);
                // $fclose(fout);
            end
        end
        $fclose(fin);
    end
    else
    begin
        if (wen)
        begin      
            //for (i=0; i<16; i = i + 1)
            //begin
					//addr_mem = addr * 16 + i;
					
				memory[addr*16] <= write_data[15:0];
				memory[addr*16+1] <= write_data[31:16];
				memory[addr*16+2] <= write_data[47:32];
				memory[addr*16+3] <= write_data[63:48];
				memory[addr*16+4] <= write_data[79:64];
				memory[addr*16+5] <= write_data[95:80];
				memory[addr*16+6] <= write_data[111:96];
				memory[addr*16+7] <= write_data[127:112];
				memory[addr*16+8] <= write_data[143:128];
				memory[addr*16+9] <= write_data[159:144];
				memory[addr*16+10] <= write_data[175:160];
				memory[addr*16+11] <= write_data[191:176];
				memory[addr*16+12] <= write_data[207:192];
				memory[addr*16+13] <= write_data[223:208];
				memory[addr*16+14] <= write_data[239:224];
				memory[addr*16+15] <= write_data[255:240];
					
					
                //memory[addr3] <= write_data[addr2 : addr1];
            //end
        end
    end
end

endmodule

