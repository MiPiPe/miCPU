`include "define.v"

module data_memory( clk, rst, wen, waddr, raddr, write_data, read_data);

input clk;
input rst;
input wen;
input [11:0] raddr;
input [11:0] waddr;
input [255:0] write_data;          // data input
output [255:0] read_data;    // data output
reg [`DSIZE-1:0] memory [0:4096*`ISIZE-1];
reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, fout,i, c, r, addr_mem;
reg [`ISIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;

//reg [`ISIZE-1:0] addr_r;

assign read_data = {memory[{raddr, 4'h0}],
                    memory[{raddr, 4'h1}],
                    memory[{raddr, 4'h2}],
                    memory[{raddr, 4'h3}],
                    memory[{raddr, 4'h4}],
                    memory[{raddr, 4'h5}],
                    memory[{raddr, 4'h6}],
                    memory[{raddr, 4'h7}],
                    memory[{raddr, 4'h8}],
                    memory[{raddr, 4'h9}],
                    memory[{raddr, 4'ha}],
                    memory[{raddr, 4'hb}],
                    memory[{raddr, 4'hc}],
                    memory[{raddr, 4'hd}],
                    memory[{raddr, 4'he}],
                    memory[{raddr, 4'hf}]
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
                r = $ungetc(c, fin);
                r = $fscanf(fin, "%h %h",t_addr, t_data);
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

            memory[waddr*16] <= write_data[15:0];
            memory[waddr*16+1] <= write_data[31:16];
            memory[waddr*16+2] <= write_data[47:32];
            memory[waddr*16+3] <= write_data[63:48];
            memory[waddr*16+4] <= write_data[79:64];
            memory[waddr*16+5] <= write_data[95:80];
            memory[waddr*16+6] <= write_data[111:96];
            memory[waddr*16+7] <= write_data[127:112];
            memory[waddr*16+8] <= write_data[143:128];
            memory[waddr*16+9] <= write_data[159:144];
            memory[waddr*16+10] <= write_data[175:160];
            memory[waddr*16+11] <= write_data[191:176];
            memory[waddr*16+12] <= write_data[207:192];
            memory[waddr*16+13] <= write_data[223:208];
            memory[waddr*16+14] <= write_data[239:224];
            memory[waddr*16+15] <= write_data[255:240];


            //memory[addr3] <= write_data[addr2 : addr1];
            //end
        end
    end
end

endmodule

