module cache(
           input clk,
           input rst,
           input mem_read,
           input mem_write,

           input [15:0] addr,
           input [15:0] cache_data_in,
           output [11:0] fetch_addr,
           input [255:0] fetch_data,
           output [15:0] cache_data_out,
           output write_back,
           output  [11:0] wb_addr,
           output  [255:0] wb_data,
           output reg clk_out
       );

reg clk_lock;
reg [9:0] tag_reg [0:3];
reg dirty [0:3];
reg valid [0:3];
reg [15:0] cache_data [0:3] [0:15];

reg [15:0] addr_reg;
reg [15:0] cache_data_in_reg;

wire [9:0] tag;
wire [1:0] index;
wire [3:0] offset;

integer i, j;

assign tag = (~clk_lock)? addr_reg[15:6] : addr[15:6];
assign index = (~clk_lock)? addr_reg[5:4] : addr[5:4];
assign offset = (~clk_lock)? addr_reg[3:0] : addr[3:0];
assign hit = (tag_reg[index]==tag) && (valid[index]==1);
assign cache_data_out = cache_data[index][offset];
// assign cache_data_out = cache_data[addr[5:4]][addr[3:0]];
// assign wb_data = cache_data[index][offset];
assign wb_data = {  cache_data[index][15],
                    cache_data[index][14],
                    cache_data[index][13],
                    cache_data[index][12],
                    cache_data[index][11],
                    cache_data[index][10],
                    cache_data[index][9],
                    cache_data[index][8],
                    cache_data[index][7],
                    cache_data[index][6],
                    cache_data[index][5],
                    cache_data[index][4],
                    cache_data[index][3],
                    cache_data[index][2],
                    cache_data[index][1],
                    cache_data[index][0]
                   };
assign wb_addr = {tag_reg[index], index};
assign fetch_addr = {tag, index};
assign write_back = ((mem_read)||(mem_write))&&(hit==0)&&(dirty[index] == 1);

always @(posedge clk)
begin

    if ((hit == 0) && ((mem_read)||(mem_write)))
    begin
        clk_out <= 0;
    end
    else
    begin
        clk_out <= 1;
    end
	 
    if (rst)
    begin
        for (i=0; i<4; i=i+1)
        begin
            tag_reg[i] <= 0;

            valid[i] <= 0;
            dirty[i] <= 0;

            for (j=0; j<16; j=j+1)
            begin
                cache_data[i][j] <= 0;
            end
        end
        addr_reg <= 0;
        cache_data_in_reg <= 0;
        clk_lock <= 1;
        // write_back <= 0;
        // tag1 <= 0;
        // rkick <= 0;
        // rkickdata <= 0;
        // rkickaddr <= 0;
    end
    else
    begin
        cache_data_in_reg <= cache_data_in;
        addr_reg <= addr;
        if ((hit == 0) && ((mem_read)||(mem_write)))
        begin
            clk_lock <= 0;
        end
        else
        begin
            clk_lock <= 1;
        end
        if (mem_read)
        begin
            //if hit, do nothing
            if ( (valid[index] == 0) || ((valid[index] == 1) && (hit == 0)) )
                //invalid or miss
            begin
                //write back
                if (dirty[index] == 1)
                begin
                    // write_back <= 1;
                end
                //update cache with data in memory
                cache_data[index][15] <= fetch_data[15:0];
                cache_data[index][14] <= fetch_data[31:16];
                cache_data[index][13] <= fetch_data[47:32];
                cache_data[index][12] <= fetch_data[63:48];
                cache_data[index][11] <= fetch_data[79:64];
                cache_data[index][10] <= fetch_data[95:80];
                cache_data[index][9] <= fetch_data[111:96];
                cache_data[index][8] <= fetch_data[127:112];
                cache_data[index][7] <= fetch_data[143:128];
                cache_data[index][6] <= fetch_data[159:144];
                cache_data[index][5] <= fetch_data[175:160];
                cache_data[index][4] <= fetch_data[191:176];
                cache_data[index][3] <= fetch_data[207:192];
                cache_data[index][2] <= fetch_data[223:208];
                cache_data[index][1] <= fetch_data[239:224];
                cache_data[index][0] <= fetch_data[255:240];
                dirty[index] <= 0;
                valid[index] <= 1;
                tag_reg[index] <= tag;
            end
        end
        else if (mem_write)
        begin
            //invalid or miss - fetch data from memory
            if ( (valid[index] == 0) || ((valid[index]==1) && (hit == 0)) )
            begin
                cache_data[index][15] <= fetch_data[15:0];
                cache_data[index][14] <= fetch_data[31:16];
                cache_data[index][13] <= fetch_data[47:32];
                cache_data[index][12] <= fetch_data[63:48];
                cache_data[index][11] <= fetch_data[79:64];
                cache_data[index][10] <= fetch_data[95:80];
                cache_data[index][9] <= fetch_data[111:96];
                cache_data[index][8] <= fetch_data[127:112];
                cache_data[index][7] <= fetch_data[143:128];
                cache_data[index][6] <= fetch_data[159:144];
                cache_data[index][5] <= fetch_data[175:160];
                cache_data[index][4] <= fetch_data[191:176];
                cache_data[index][3] <= fetch_data[207:192];
                cache_data[index][2] <= fetch_data[223:208];
                cache_data[index][1] <= fetch_data[239:224];
                cache_data[index][0] <= fetch_data[255:240];
                dirty[index] <= 1;
                valid[index] <= 1;
                tag_reg[index] <= tag;
					 cache_data[index][offset] <= cache_data_in;
					 /*
                if (dirty[index] == 1)
                    //dirty - write back
                begin
                    write_back <= 1;
                end
					 */
            end
            /*
				if ((valid[index] == 1) && (hit == 1))
                //valid and hit - directly write
            begin
                
                dirty[index] <= 1;
            end
				*/
        end
    end
	 /*
	 if (clk_lock)
    begin
	     clk_out <= 1;
	 end
	 */
end


always @(negedge clk)
begin
    clk_out <= 0;
end

endmodule




