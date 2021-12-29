module CH3_WT_VFD(
	RESETN, CLK, 
	DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1,
	LCD_DATA, LCD_RW, LCD_RS, LCD_E, AP_DATA,
	OUT1, OUT2, OUT3, shift,a
);

//input [7:0]NUM;
input a;
input CLK, RESETN;
input [7:0]OUT1, OUT2, OUT3, shift;
wire [7:0]OUT1, OUT2, OUT3;
//input sel;
//wire [3:0]sel;
input [7:0]DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1;
//wire DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1;
input [7:0]AP_DATA;
//input [7:0]hello;

output LCD_RS, LCD_RW,LCD_E;
output [7:0]LCD_DATA;

reg LCD_RS, LCD_RW;

reg [7:0]LCD_DATA;
wire LCD_E;

reg[2:0]STATE;

parameter 
      DELAY= 3'b000,
      FUNCTION_SET = 3'b001,
      ENTRY_MODE = 3'b010,
      DISP_ONOFF = 3'b011,
      LINE1 = 3'b100,
	   LINE2 = 3'b101;
      //DELAY_T = 3'b110;
      //CLEAR_DISP = 3'b110;


integer CNT;

always@(posedge CLK)
begin 
   if(RESETN ==1'b0)
      STATE = DELAY;
   else
      begin
         case(STATE)
            DELAY:
               if(CNT ==70) STATE = FUNCTION_SET;
            FUNCTION_SET:
               if(CNT ==30) STATE = DISP_ONOFF;
            DISP_ONOFF:
               if(CNT ==30) STATE = ENTRY_MODE;
            ENTRY_MODE:
               if(CNT ==30) STATE = LINE1;
					
            LINE1:
               if(CNT ==20) STATE = LINE1;
					
            LINE2:
               if(CNT ==20) STATE = LINE1;
				
            /*DELAY_T:
               if(CNT == 400) STATE = LINE1;*/
            /*CLEAR_DISP:
               if(CNT == 200) STATE = LINE1;*/
            default: STATE = DELAY;
         endcase
      end
end

always@(posedge CLK)
begin   
   if(RESETN == 1'b0)
      CNT =0;
   else 
      case(STATE)
            DELAY:
               if(CNT >=70) CNT =0;
               else CNT = CNT+1;
            FUNCTION_SET:
               if(CNT >=30) CNT =0;
               else CNT = CNT+1;
            DISP_ONOFF:
               if(CNT >=30) CNT =0;
               else CNT = CNT+1;
            ENTRY_MODE:
               if(CNT >=30) CNT =0;
               else CNT = CNT+1;
            LINE1:
               if(CNT >=20) CNT =0;
               else CNT = CNT+1;
					
            LINE2:
               if(CNT >=20) CNT =0;
               else CNT = CNT+1;
					
            /*DELAY_T:
               if(CNT>= 400) CNT =0;
               else CNT = CNT+1;
            CLEAR_DISP:
               if(CNT >= 200) CNT =0;
               else CNT = CNT+1;*/
            default:CNT=0;
         endcase
end

always@(posedge CLK)
begin
   if(RESETN== 1'b0)
      begin   
         LCD_RS=1'b1;
         LCD_RW=1'b1;
         LCD_DATA = 8'b00000010;
      end
   else
      begin
         case(STATE)
            FUNCTION_SET :
               begin
                  LCD_RS=1'b0;
                  LCD_RW=1'b0;
                  LCD_DATA = 8'b00110100; // 8'b00110100=only line 1
               end
					
            DISP_ONOFF:
               begin
                  LCD_RS=1'b0;
                  LCD_RW=1'b0;
                  LCD_DATA = 8'b00001100;
               end
					
            ENTRY_MODE:
               begin
                  LCD_RS=1'b0;
                  LCD_RW=1'b0;
                  LCD_DATA = 8'b00000110;
               end
             LINE1:
               begin
                  LCD_RW = 1'b0; 
                  case(CNT)            
                     0:
									begin   
										LCD_RS=1'b0;
										LCD_DATA = 8'b10000000;
									end
                     1:							
									begin   
										LCD_RS=1'b1;
										LCD_DATA = DEC_H10;
									end
                     2:
									begin  
										LCD_RS=1'b1; 
										LCD_DATA = DEC_H1;
									end								
                     3:
									begin   
										LCD_RS=1'b1;
										LCD_DATA = 8'b00111010; // :
									end						
                     4:
								//if(sel == 2)
								//if(CNT_SCAN == 2)
									begin   
										LCD_RS=1'b1;
										LCD_DATA = DEC_M10;
									end								
                     5:
									begin   
										LCD_RS=1'b1;
										//LCD_DATA = ;//M1
										LCD_DATA = DEC_M1;
									end
                     6:
									begin   
										LCD_RS=1'b1; 
										LCD_DATA = 8'b00111010; // :
									end								
                     7:
									begin   
										LCD_RS=1'b1;
										LCD_DATA = DEC_S10;	
																		
									end
                     8:

									begin   
										LCD_RS=1'b1;
									   LCD_DATA = DEC_S1;//S1
																			
									end
                     9:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     10:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     11:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = AP_DATA;
                        end
                     12:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b01001101; //M
                        end
                     13:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = a;
                        end
                     14:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = OUT1;
                        end
                     15:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = OUT2;
                        end
                     16:
                        begin   
                           LCD_RS=1'b1;
                           //LCD_DATA = 8'b00100000;
									LCD_DATA = OUT3;
                        end
                     default:
                        begin
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;		//' '
                        end
                     endcase
               end
           
            LINE2:
               begin
                  LCD_RW=1'b0;
                  
                  case(CNT)
                     0:
                        begin   
                           LCD_RS=1'b0;
                           LCD_DATA = 8'b11000000;
                        end
                     1:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     2:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b01001101; 
                        end
                     3:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00010000; 
                        end
                     4:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     5:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     6:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     7:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     8:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     9:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     10:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     11:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     12:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     13:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     14:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     15:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     16:
                        begin   
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     default:
                        begin
                           LCD_RS=1'b1;
                           LCD_DATA = 8'b00100000;
                        end
                     endcase
               end


            /*DELAY_T:
               begin
                  LCD_RS=1'b0;
                  LCD_RW=1'b0;
                  LCD_DATA = 8'b00000010;
               end
					
            CLEAR_DISP:
               begin
                  LCD_RS=1'b0;
                  LCD_RW=1'b0;
                  LCD_DATA = 8'b00000001;
               end*/
               
            default:
               begin
                  LCD_RS=1'b1;
                  LCD_RW=1'b1;
                  LCD_DATA = 8'b00000000;
               end
         endcase
   end 
end

assign LCD_E = !CLK;

endmodule
