module SET_TIME(RESETN, CLK, up, douwn, shift, OK, STATE,
					HOUR, MIN, SEC,					//input	
					SET_HOUR, SET_MIN, SET_SEC,	//output
					shift_num);

					
input [2:0]STATE;
input RESETN, CLK, up, douwn, shift, OK;
input [6:0]HOUR, MIN, SEC; //non's time
//input [3:0]ok_data;

//input [3:0]ampm_data;
output [6:0]SET_HOUR, SET_MIN, SET_SEC;
reg [6:0]SET_HOUR, SET_MIN, SET_SEC;

output [3:0]shift_num;
reg [3:0]shift_num = 0;

//wire [3:0]ok_data;

//output [3:0]AMPM_DATA;

reg [6:0]arm_hour, arm_min, arm_sec;


always@(posedge CLK) 	//when mode has changed
begin
	if(~RESETN)begin
		SET_HOUR=0;
		SET_MIN=0;
		SET_SEC=0;
		end
	else if(STATE ==0)
		begin
			SET_HOUR =HOUR;
			SET_MIN = MIN;
			SET_SEC = SEC;
		end
	else if(up)
		if(shift_num == 1)
			SET_HOUR = (SET_HOUR + 1)%24;
		else if(shift_num == 2)
			SET_MIN = (SET_MIN+1)%60;
		else if(shift_num == 3)
			SET_SEC = (SET_SEC+1)%60;
end
//


always@(posedge shift)
begin
	if(~RESETN)
				shift_num = 0;
	else
		begin
			shift_num=(shift_num)%3+1;
		end
end

endmodule
/*//
always@(posedge CLK)
begin

	if(STATE == 2 && ok_data == 1)
		begin
		work_hour = HOUR;
		work_min = MIN;
		work_sec = SEC;
		
		end
	else 
	
	if(STATE == 1 && up > 0)
		begin
			if(shift_num == 1)
				arm_hour = arm_hour +1;
				
			else if(shift_num == 2)	
				arm_min = arm_min +1;
				
			else if(shift_num == 3)
				arm_sec = arm_sec +1;
		end
end*/
//

