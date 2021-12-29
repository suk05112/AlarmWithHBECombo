//CH3_WATCH.V
/*
module CH3_WATCH(
   RESETN, CLK,
LCD_DATA, LCD_E, LCD_RW, LCD_RS
   );*/
	/*
   module CH3_WATCH(
	RESETN, CLK, SET_HOUR, SET_MIN, SET_SEC, 
	HOUR, MIN, SEC,
	STATE, OK, piezo, hello,
	DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1
   );
	*/
	 module CH3_WATCH(RESETN, CLK, o_data,
					SET_HOUR, SET_MIN, SET_SEC, 
					HOUR, MIN, SEC,
					STATE,  hello, OK);
					
   input RESETN, CLK;
	input [6:0]SET_HOUR, SET_MIN, SET_SEC;
	input o_data;
	input [2:0]STATE;
	//input ok_data;
	input OK;
	
	output [6:0]HOUR, MIN, SEC;
	//output [3:0]ampm_data;
	//output [7:0]DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1;
	//output [7:0]AP_DATA;
	
	
	output [7:0]hello;
	reg [7:0]hello;
	
	
	
	integer CNT_SOUND;
	
	wire [7:0]AP_DATA;
	//wire [3:0]H10, H1, M10, M1, S10, S1; 
	//wire [7:0]DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1;
	
	integer TIME;
   integer CNT;
   integer CNT_SCAN;
   
   reg[6:0] HOUR, MIN, SEC;
   reg ampm =0;
	reg [3:0] ampm_data;

   reg [6:0]alarm_hour = 3,alarm_min = 30, alarm_sec = 0;
	reg [3:0] alarm_ap =4'b1010;
   
   always@(posedge CLK)
   begin
      if(~RESETN)
         CNT = 0;
      else
         begin
            if(CNT >=9999)
               CNT = 0;
            else
               CNT = CNT + 1;
         end
   end
   //1초를 생성하기 위해 cnt를 999까지 count
	

 always@(posedge CLK)
   begin
      if(~RESETN)
         SEC = 0;
      else
         begin
				if(OK>0 && STATE == 1)
						SEC = SET_SEC;
            else if(CNT == 9999)
               begin
                  if(SEC >=59)
                     SEC = 0;
                  else
                     SEC = SEC + 1;
               end
         end
   end
   
   always@(posedge CLK)
   begin
      if(~RESETN)
         
         MIN = 0;
      else
         begin
				if(OK>0 && STATE == 1)
						MIN = SET_MIN;
            else if((CNT == 9999)&&(SEC ==59))
               begin
                  if(MIN >=59)
                     MIN = 0;
						else
                     MIN = MIN + 1;
               end
				
         end
   end
   
 always@(posedge CLK)
   begin
      if(~RESETN) begin
         HOUR = 0;
			TIME = 0;
			end
      else
         begin
				if(OK>0&& STATE == 1)
						HOUR = SET_HOUR;
            else if((CNT == 9999)&&(SEC ==59)&&(MIN==59))
               begin
                  if(HOUR > 23)
                     HOUR = 0;
                  else
                     HOUR = HOUR + 1;
						/*	
						if(HOUR<12) //AM
							begin
							TIME = HOUR;
							ampm_data = 4'b1010;
							end
							
						else if(HOUR == 12)
							begin
							TIME = HOUR;
							ampm_data = 4'b1100;
							end
							
						else if(HOUR == 24)
							begin
							TIME = 0;
							ampm_data = 4'b1010;
							end

						else	//PM
							begin
							TIME = HOUR-12;	
							ampm_data = 4'b1100;
							end
						*/
					end 
         end
   end
	
	

	endmodule
		/* //
	always@(posedge CLK)
	begin
		if(TIME == 3&& MIN == 30) //&& SEC == 0)// && ampm_data == alarm_ap)
			//piezo = BUFF;
			hello = 8'b00100001;
		else
			hello = 8'b00010110;
	end
	
	CH3_WT_SEP S_SEP(SEC, S10, S1);
   CH3_WT_SEP M_SEP(MIN, M10, M1);
   CH3_WT_SEP H_SEP(TIME, H10, H1);
	
/*
	CH3_WT_DECODER H10_DECODE(H10,DEC_H10);
	CH3_WT_DECODER H1_DECODE(H1,DEC_H1);
	CH3_WT_DECODER M10_DECODE(M10,DEC_M10);
	CH3_WT_DECODER M1_DECODE(M1,DEC_M1);
	CH3_WT_DECODER S10_DECODE(S10,DEC_S10);
	CH3_WT_DECODER S1_DECODE(S1,DEC_S1);
	CH3_WT_DECODER apdata(ampm_data, AP_DATA);
*/	

/*
   CH3_WT_SEP S_SEP(SEC, S10, S1);
   CH3_WT_SEP M_SEP(MIN, M10, M1);
   CH3_WT_SEP H_SEP(HOUR, H10, H1);
	

	CH3_WT_DECODER H10_DECODE(H10,DEC_H10);
	CH3_WT_DECODER H1_DECODE(H1,DEC_H1);
	CH3_WT_DECODER M10_DECODE(M10,DEC_M10);
	CH3_WT_DECODER M1_DECODE(M1,DEC_M1);
	CH3_WT_DECODER S10_DECODE(S10,DEC_S10);
	CH3_WT_DECODER S1_DECODE(S1,DEC_S1);
	
	CH3_WT_VFD DISPLAY(DEC_DATA,LCD_DATA, RESETN, CLK, LCD_RW, LCD_RS, LCD_E,DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1);
		
   endmodule
	
/*
   always @(posedge CLK)
	begin
		if(~RESETN)
			begin
				NUM=0;
				CNT_SCAN=0;
			end
		else
			begin
				if(CNT_SCAN>=5)
					CNT_SCAN=0;
				else
					CNT_SCAN=CNT_SCAN+1;
				case(CNT_SCAN)
					0:
						begin
							NUM=H10;
							
						end
					1:
						begin
							NUM=H1;
							//sel = 4'b0001;//1

						end
					2:
						begin
							NUM=M10;
							//sel = 4'b0010;//2

						end
					3:
						begin
							NUM=M1;
							//sel = 4'b0011;//3

						end
					4:
						begin
							NUM=S10;
							//sel = 4'b0100;//4
	
						end
					5:
						begin
							NUM=S1;
							//sel = 4'b0101;//5

						end
					default:
						begin
							NUM=0;

						end
				endcase
			end
	end

*/	