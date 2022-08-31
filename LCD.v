`timescale 1ns / 1ps


module LCD(
    input clk,
    output reg rs,rw,
    output en,
    output reg [7:0] dout
    );
    integer count=0;
    integer i=0;
    parameter send_data=1;
    parameter send_cmd=0;
    reg state=send_cmd;
    integer n=1000_000; //n = delay desired by lcd /(1/clock speed of board)
                        // In our case delay desired is 10 ms and feequency of board =100MHZ
                        
    
    reg [7:0] data [11:0];
    reg ent=0;
    initial begin
    ///////// command for LCD ,rs=0////////
    data[0]  <= 8'h38; //// 2lines 5x4 matrix
    data[1]  <= 8'h01; /// clear display
    data[2]  <= 8'h0E; /// Display on Cursor blinking
    data[3]  <= 8'h06; /// Increment cursor from left to right
    data[4]  <= 8'h80; /// force cusor on beging from first line
    
    ///// DATA FOR LCDrs=1 ///////
    data[5]  <= 8'h76; /// ascii value for v
    data[6]  <= 8'h65; /// e
    data[7]  <= 8'h72; ///r
    data[8]  <= 8'h69; /// i
    data[9]  <= 8'h6c; ///l
    data[10] <= 8'h65; ///0
    data[11] <= 8'h67; ///g
    
    
    
    
    end
    
always@(posedge clk)
    begin
    if(count < n) 
        count <= count +1;
    else
        begin
            count <=0;
            ent <=~ent; // slower clock to work with 
        
        end    
    
end

always@(posedge ent)
begin
case(state)
send_cmd:
begin
    if( i < 4) // five values need to be sent by command
        begin
            rs   <=1'b0;
            rw   <=1'b0;
            dout <= data[i];
            i    <=i+1;
        end
     else
         begin   
            state <=send_data;
         end 
end

send_data:
begin
    if(i < 12)
        begin
            rs   <=1'b1;
            rw   <=1'b0;
            dout <=data[i];
            i    <=i+1;
        end
     else
        begin
            i <=0;
            state <=send_cmd;
            rs <=0;
            rw <=0;
            dout <=0;
            
     
        end   

end

endcase
end
    
assign en = ent;    
endmodule
