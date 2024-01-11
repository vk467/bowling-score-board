module sb_controller(clk, reset, APD, LF, UPD, AD, NF, FT, done);
input clk, reset;
input APD, LF, UPD;
output reg AD, NF, FT, done;

reg strike, spare, OST, LSP, bonus;


parameter s0 = 'b00000, 
          s1 = 'b00001, 
          s2 = 'b00010, 
          s3 = 'b00011, 
          s4 = 'b00100,
          s5 = 'b00101,
          s6 = 'b00110,
          s7 = 'b00111,
          s8 = 'b01000,
          s9 = 'b01001,
          s10 = 'b01010,
          s11 = 'b01011,
          s12 = 'b01100,
          s13 = 'b01101,
          s14 = 'b01110,
          s15 = 'b01111,
          s16 = 'b10000,
          se = 'b10001;
          

reg [4:0] state, next ;

always @(posedge reset) 
begin
    if(reset)
    begin   
        AD = 1'b0;
        NF = 1'b0;
        FT = 1'b0;
        done = 1'b0;
        strike = 1'b0;
        spare = 1'b0;
        OST = 1'b0;
        LSP = 1'b0;
        bonus = 1'b0;
        state = s0;
    end
end
  

always @(posedge clk) begin
	case(state)        
	    s0: begin
	        NF = 1'b0;
            if (UPD)
               next = s1;
            else
               next = s0;
	    end
	    
	    s1: begin 
           if (OST)
               next = s2;
           else
               next = s3;
	    end
	    
	    s2: begin
	       AD = 1; 
           next = s3;
        end
	    
	    s3: begin
	       AD = 0;
	       FT = 1; 
           if (strike || spare)
               next = s4;
           else
               next = s5;
        end
        
        s4: begin
           AD = 1; 
           next = s5;
        end
        
        s5: begin
           AD = 1; 
           FT = 0;
           if (LSP)
               next = se;
           else
               next = s6;
        end
        
        s6: begin
           AD = 0; 
           if (APD && bonus==0)
               next = s8;
           else
               next = s7;
        end
	               
	    s7: begin
           AD = 0;
           if (UPD)
               next = s9;
           else
               next = s7;
        end
        
        s8: begin
           OST = strike;
           strike = 1'b1;
           next = s13;
        end
        
        s9: begin
           if (strike)
               next = s10;
           else
               next = s11;
        end
        
        s10: begin
           AD = 1;
           next = s11;
        end
	    
	    s11: begin
	       FT =0;
	       AD = 1;
	       OST = 0;
	       strike = 0;
	       spare = 0;
           if (APD && bonus==0)
               next = s12;
           else
               next = s13;
        end
	    
	    s12: begin
	       AD = 0;
           spare = 1'b1;
           next = s13;
        end
        
        s13: begin
           AD = 0;
           if (LF)
               next = s15;
           else
               next = s14;
        end
        
        s14: begin
           NF = 1'b1;
           next = s0;
        end
        
        s15: begin
           bonus = 1'b1;
           if (strike || spare)
               next = s16;
           else
               next = se;
        end
        
        
        s16: begin
           LSP = spare;
           spare = 0;
           strike = 0;
           next = s0;
        end
        
        se: begin
            AD = 1'b0;
            done = 1'b1;
         end
        
endcase
end

always @(posedge clk or posedge reset)begin
	if(reset)
		state <=  s0 ;
	else    			
        state <=  next ;
end 

endmodule