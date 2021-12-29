//SET_ARM.v
module SET_ARM(RESETN, CLK, up, douwn, shift, OK, STATE,
					HOUR, MIN, SEC,					//input	
					ARM_HOUR, ARM_MIN, ARM_SEC,	//output
					shift_num,a,
					piezo);

					
input [2:0]STATE;
input RESETN, CLK, up, douwn, shift, OK;
input [6:0]HOUR, MIN, SEC; //non's time
//input [3:0]ok_data;

//input [3:0]ampm_data;
output [6:0]ARM_HOUR, ARM_MIN, ARM_SEC;
output piezo;
output [3:0]shift_num;
wire piezo;
reg BUFF;
reg [6:0]ARM_HOUR, 	ARM_MIN, 	ARM_SEC;
reg [6:0]SAVE_HOUR, 	SAVE_MIN, 	SAVE_SEC;

reg [3:0]shift_num = 0;
reg flag;
//wire [3:0]ok_data;

output a;
reg a;

reg up_work;
//output [3:0]AMPM_DATA;

integer CNT_SOUND;
	
always @(posedge CLK)
	begin
	if(~RESETN)
		begin
			BUFF = 1'b0;
			CNT_SOUND = 0;
		end
	else
		begin
			if(CNT_SOUND >= flag)
				begin
					CNT_SOUND = 0;
					BUFF = ~BUFF;
				end
			else
				CNT_SOUND = CNT_SOUND +1;
		end
	end
assign piezo=BUFF;

always@(posedge CLK)
begin
	if(~RESETN)
		begin
		flag=500;
		a = 0;
		end
	else
		begin
			if((HOUR==SAVE_HOUR)&&(MIN==SAVE_MIN)&&(SEC == SAVE_SEC))
				begin
				flag = 1;
				a = 1;
				end
			
				
			if(OK>0 && STATE == 0)
				begin
				flag = 500;
				a = 0;
				end
		end
end
	
always@(posedge CLK) 	//when mode has changed
begin
	if(~RESETN)begin
		SAVE_HOUR=0;
		SAVE_MIN=0;
		SAVE_SEC=0;
		end
	else if(STATE ==2&&OK>0)
		begin
			SAVE_HOUR =ARM_HOUR;
			SAVE_MIN = ARM_MIN;
			SAVE_SEC = ARM_SEC;
		end
	
end
//
always@(posedge CLK) 	
begin
	if(STATE !=2)// show setting alarm
		begin
			ARM_HOUR = SAVE_HOUR;
			ARM_MIN = SAVE_MIN;
			ARM_SEC = SAVE_SEC;
		end
	else if(up)
		begin
			if(shift_num == 1)
				ARM_HOUR = (ARM_HOUR + 1)%24;
			else if(shift_num == 2)
				ARM_MIN = (ARM_MIN+1)%60;
			else if(shift_num == 3)
				ARM_SEC = (ARM_SEC+1)%60;
		end
end

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
