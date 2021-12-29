//CH3_WT_SEP
//입려력받은 수를 10의자리와 1의 자리로 분리
module CH3_WT_SEP(
   NUMBER,
   SEP_A, SEP_B
   );
   
   input[6:0] NUMBER;
   output[3:0] SEP_A, SEP_B;
   
   reg [3:0] SEP_A, SEP_B; //??왜 3:0

always@(NUMBER)
begin
   if(NUMBER <= 9)
      begin
         SEP_A = 0;
         SEP_B = NUMBER;
      end
   else if(NUMBER <= 19)
      begin
         SEP_A = 1;
         SEP_B = NUMBER -10;
      end
   else if(NUMBER <= 29)
		begin
			SEP_A = 2;
			SEP_B = NUMBER -20;
		end
	else if(NUMBER <= 39)
		begin
			SEP_A = 3;
			SEP_B = NUMBER -30;
		end
   else if(NUMBER <= 49)
		begin
			SEP_A = 4;
			SEP_B = NUMBER -40;
		end
	else if(NUMBER <= 59)
		begin
			SEP_A = 5;
			SEP_B = NUMBER -50;
		end
	else if(NUMBER <= 69)
		begin
			SEP_A = 6;
			SEP_B = NUMBER -60;
		end
   else if (NUMBER > 80)			
		begin
			SEP_A = 13;
			SEP_B = 13;
		end
end


endmodule
   