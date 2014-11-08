`include "define.v"

module data_memory( clk, rst, wen,ren, addr, write_data, read_data);

input clk;
input rst;
input wen,ren;
input [`ISIZE-1:0] addr;      // address input
input [`DSIZE-1:0] write_data;          // data input
output [`DSIZE-1:0] read_data;    // data output
reg [`DSIZE-1:0] memory [0:4096*`ISIZE-1];
reg [8*`MAX_LINE_LENGTH:0] line; /* Line of text read from file */

integer fin, fout,i, c, r;
reg [`ISIZE-1:0] t_addr;
reg [`DSIZE-1:0] t_data;
//reg [`ISIZE-1:0] addr_r;

assign read_data = (ren)? memory[addr] : 16'h0000;

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
                memory[t_addr]=t_data;
                fout = $fopen("dm_init.txt","a");
                $fwrite(fout, "read from %h: %h\n",t_addr,t_data);
                $fclose(fout);
            end
        end
        $fclose(fin);
    end
    else
    begin
        /*if (ren)
        begin
          addr_r <= addr;
        fout = $fopen("dm_read.txt","a");
          $fwrite(fout, "read: %h from address %h\n",memory[addr], addr);
          $fclose(fout);
        end
        else */
        if (wen)
        begin            // active-low write enable
            memory[addr] <= write_data;
            fout = $fopen("dm_write.txt","a");
            $fwrite(fout, "write: %h to address %h\n",write_data, addr);
            $fclose(fout);
        end
    end
end

endmodule

