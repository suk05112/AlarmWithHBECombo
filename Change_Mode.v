module Change_Mode(CLK, RESETN, chmod, OK, shift, up, down, STATE,
						shift_now, shift_arm,
						OUT1, OUT2, OUT3,
						HOUR, MIN, SEC,
						SET_HOUR, SET_MIN, SET_SEC,
						ARM_HOUR, ARM_MIN, ARM_SEC,
						VFD_H10, VFD_H1, VFD_M10, VFD_M1, VFD_S10, VFD_S1, shift_);
						

input CLK, RESETN, chmod, OK;
input shift, up, down;
input [3:0]shift_now, shift_arm;
input [6:0]HOUR, MIN, SEC;
input [6:0]SET_HOUR, SET_MIN, SET_SEC;
input [6:0]ARM_HOUR, ARM_MIN, ARM_SEC;

//reg [6:0]a,b,c;
reg [6:0]VFD_H, VFD_M, VFD_S;
wire [3:0]H10, H1, M10, M1, S10, S1;

wire shift, up, down;
//output count_but;
output [7:0]OUT1;
output [7:0]OUT2;
output [7:0]OUT3;
output [7:0]VFD_H10, VFD_H1, VFD_M10, VFD_M1, VFD_S10, VFD_S1;
output STATE;
output [7:0]shift_;
reg [3:0]ok_data;

reg [7:0]OUT1;
reg [7:0]OUT2;
reg [7:0]OUT3;

reg[2:0]STATE;
integer space;
parameter 
		NONE = 3'b000,
		NOW = 3'b001,
      ARM = 3'b010;

integer CNT;
reg [7:0]count_but = 0;
/*
always@(posedge CLK)
begin
	a = SET_HOUR;
	b = MIN;
	c = SEC;
end*/

always@(posedge OK)
begin
	if(ok_data>3)
		ok_data = 0;
	else
		ok_data = ok_data +1;
end

always@(posedge chmod)
	begin
		if(RESETN== 1'b0)
			count_but = 0;
		else
			begin
				if (count_but > 3)
						count_but = 0;
				else
					count_but = count_but + 1;
			end
	end
	
//change state
always@(posedge CLK)
begin 
   if(RESETN ==1'b0)
      STATE = NONE;
   else
      begin
         case(STATE)
            NONE:
					if(count_but == 1)
						STATE = NOW;
					
            NOW:
					if(count_but == 2)
						STATE = ARM;
					
            ARM:
					if(count_but == 3)
						STATE = NONE;

            default: STATE = NONE;
         endcase
      end
end

//show out	
always@(posedge CLK)
begin   
   if(RESETN == 1'b0)
      CNT =0;
   else begin
		space = (space + 1)%10000;
      case(STATE)
            NONE:
					begin
						OUT1 = 8'b01001110;
						OUT2 = 8'b01001111;
						OUT3 = 8'b01001110;
						VFD_H = HOUR;
						VFD_M = MIN;
						VFD_S = SEC;
						//OUT = count_but;
					end
            NOW:
					begin
						OUT1 = 8'b01001110;
						OUT2 = 8'b01001111;
						OUT3 = 8'b01010111;
						/*
							VFD_H = SET_HOUR;
							VFD_M = SET_MIN;	
							VFD_S = SET_SEC;*/
						if(up)
							space=0;
						if(shift_now == 1)
							if(space < 5000)
								VFD_H = SET_HOUR;
							else
								VFD_H = 90;
						else
							VFD_H = SET_HOUR;
							
						if(shift_now == 2)
							if(space < 5000)
								VFD_M = SET_MIN;
							else
								VFD_M = 90;
						else
							VFD_M = SET_MIN;
						
						if(shift_now == 3)
							if(space < 5000)
								VFD_S = SET_SEC;
							else
								VFD_S = 90;
						else
							VFD_S = SET_SEC;
						
						//OUT = count_but;
					end
            ARM:
					begin
						OUT1 = 8'b01000001;
						OUT2 = 8'b01010010;
						OUT3 = 8'b01001101;
						if(up)
							space=0;
						if(shift_now == 1)
							if(space < 5000)
								VFD_H = ARM_HOUR;
							else
								VFD_H = 90;
						else
							VFD_H = ARM_HOUR;
							
						if(shift_now == 2)
							if(space < 5000)
								VFD_M = ARM_MIN;
							else
								VFD_M = 90;
						else
							VFD_M = ARM_MIN;
						
						if(shift_now == 3)
							if(space < 5000)
								VFD_S = ARM_SEC;
							else
								VFD_S = 90;
						else
							VFD_S = ARM_SEC;
							
						/*VFD_H = ARM_HOUR;
						VFD_M = ARM_MIN;
						VFD_S = ARM_SEC;*/
						//OUT = count_but;
					end
            default:
					begin
						OUT1 = 8'b01001110;
						OUT2 = 8'b01001111;
						OUT3 = 8'b01001110;
						
						//VFD_H = HOUR;
						//VFD_M = MIN;
						//VFD_S = SEC;
						//OUT = count_but;
					end
					
      endcase
		end
end

/*
SET_TIME NOW_set(RESETN, CLK, up, douwn, shift, OK, STATE,
					HOUR, MIN, SEC,
					SET_HOUR, SET_MIN, SET_SEC,ok_data, shift_num
					);
					
CH3_WATCH WAHCH(RESETN, CLK, o_data,
					SET_HOUR, SET_MIN, SET_SEC, 
					HOUR, MIN, SEC,
					STATE,  piezo, hello, ok_data
					//DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1
					);
					

					


(RESETN, CLK, up, douwn, shift, o_data,
				SET_HOUR, SET_MIN, SET_SEC,
				HOUR, MIN, SEC,ampm_data,
				);
				*/
				
					
				
CH3_WT_SEP S_SEP(VFD_H, H10, H1);
CH3_WT_SEP M_SEP(VFD_M, M10, M1);
CH3_WT_SEP H_SEP(VFD_S, S10, S1);
	
CH3_WT_DECODER H10_DECODE(H10,VFD_H10);
CH3_WT_DECODER H1_DECODE(H1,VFD_H1);
CH3_WT_DECODER M10_DECODE(M10,VFD_M10);
CH3_WT_DECODER M1_DECODE(M1,VFD_M1);
CH3_WT_DECODER S10_DECODE(S10,VFD_S10);
CH3_WT_DECODER S1_DECODE(S1,VFD_S1);

CH3_WT_DECODER apdata(shift_num, shift_);
CH3_WT_DECODER okdata(ok_data, o_data);
endmodule
