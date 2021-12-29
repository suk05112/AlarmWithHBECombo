//CH3_WATCH.V
module top(
   RESETN, CLK,
	LCD_DATA, LCD_E, LCD_RW, LCD_RS, piezo, chmod, OK, up, down, shift
   );
   
   input RESETN, CLK;
	input chmod, OK, shift;
	input up, down;
	
   output LCD_DATA;
	output LCD_E, LCD_RS, LCD_RW;
	output piezo;	
	
	wire LCD_E, LCD_RW, LCD_RS;	
	wire RESETN, CLK;
	wire [7:0]LCD_DATA;
	
	
	wire [6:0]HOUR, MIN, SEC;
	wire [6:0]SET_HOUR, SET_MIN, SET_SEC;
	wire [6:0]ARM_HOUR, ARM_MIN, ARM_SEC;
	wire [7:0]OUT1, OUT2, OUT3;//NON, NOW, ARM
	wire [7:0]VFD_H10, VFD_H1, VFD_M10, VFD_M1, VFD_S10, VFD_S1;//VFD DATA
	
	wire [3:0]ampm_data;	//befor decode
	wire [7:0] AP_DATA; //after decode

	wire piezo;
	
	wire[3:0]shift_now, shift_arm;
	wire[7:0]shift_;
	//wire [6:0]o_data; //after decode ok_data
	wire [2:0]STATE;

	
	
//////////////////////////////    WATCH(NON)   ///////////////////////////////////////////////		
	CH3_WATCH WAHCH(RESETN, CLK, o_data,
				SET_HOUR, SET_MIN, SET_SEC, //input
				HOUR, MIN, SEC,				//output
				STATE,  hello, OK
				);
	
///////////////////////////////    MODE NOW   ////////////////////////////////////////////	
	SET_TIME NOW_set(RESETN, CLK, up, douwn, shift, OK, STATE,
					HOUR, MIN, SEC,											//input
					SET_HOUR, SET_MIN, SET_SEC,
					shift_now	//output
					);
					
					
///////////////////////////////    MODE ARM   ////////////////////////////////////////////
	SET_ARM ARM_set(RESETN, CLK, up, douwn, shift, OK, STATE,
					HOUR, MIN, SEC,					//input	
					ARM_HOUR, ARM_MIN, ARM_SEC,	//output
					shift_arm,a,
					piezo);

	
/////////////////////////////////    CHMANGE MODE   //////////////////////////////////////	
	
	
	Change_Mode ch_mod(CLK, RESETN, chmod, OK, shift, up, down, STATE,
						shift_now, shift_arm,
						OUT1, OUT2, OUT3,					//output
						HOUR, MIN, SEC,					//input
						SET_HOUR, SET_MIN, SET_SEC,	//input
						ARM_HOUR, ARM_MIN, ARM_SEC,
						VFD_H10, VFD_H1, VFD_M10, VFD_M1, VFD_S10, VFD_S1, shift_);		//output
						
				
/////////////////////////////////    DISPLAY   //////////////////////////////////////	
						
	CH3_WT_VFD DISPLAY(RESETN, CLK, 
							//DEC_H10,DEC_H1,DEC_M10,DEC_M1,DEC_S10,DEC_S1, 
							VFD_H10, VFD_H1, VFD_M10, VFD_M1, VFD_S10, VFD_S1,
							LCD_DATA, LCD_RW, LCD_RS, LCD_E, AP_DATA, OUT1, OUT2, OUT3, shift_, a);
							

	
	endmodule
	
	
