module score_board(clk, reset, update, N, score, frame, done);
input clk;
input reset;
input update;
input [3:0] N;

output reg [8:0] score;
output reg [3:0] frame;
output done;

reg APD, LF;
wire FT, NF, AD;

reg [3:0] FTN, FTN1;

always @ (posedge reset)
begin
    score = 'd0;
    frame = 'd1;
    FTN = 0;
    FTN1 = 0;
end


always @ (posedge clk)
begin
    // APD Logic
    if (FT) begin
        FTN = N;
        FTN1 = 0; end
    else if (update) begin
        FTN1 = FTN;
        FTN = 0; end
    
     
    if (N == 'd10 || (FTN1 + N == 'd10))
        APD = 1'b1;
    else
        APD = 1'b0;
    
    
    
    // Score Register
    if ( AD )
        score = score + N;
    
    
    // Frame Counter
    if ( NF )
        frame = frame + 1;
       
    if (frame == 'd10)
        LF = 1'b1;
    else 
        LF = 1'b0;        
end

sb_controller SBC(clk, reset, APD, LF, update, AD, NF, FT, done);

endmodule