// CH3_WT_DECODER.V

module CH3_WT_DECODER(NUM,DEC_DATA);

input [3:0]NUM; 
output DEC_DATA;
reg [7:0] DEC_DATA;
wire [3:0] NUM;

//reg [6:0] BUFF;

always @(NUM)
 begin
   case (NUM)
      4'b0000 : DEC_DATA = 8'b00110000;   //0
      4'b0001 : DEC_DATA = 8'b00110001;   //1
      4'b0010 : DEC_DATA = 8'b00110010;   //2
      4'b0011 : DEC_DATA = 8'b00110011;   //3
      4'b0100 : DEC_DATA = 8'b00110100;   //4
      4'b0101 : DEC_DATA = 8'b00110101;   //5
      4'b0110 : DEC_DATA = 8'b00110110;   //6
      4'b0111 : DEC_DATA = 8'b00110111;   //7
      4'b1000 : DEC_DATA = 8'b00111000;   //8
      4'b1001 : DEC_DATA = 8'b00111001;   //9
		4'b1010 : DEC_DATA = 8'b01000001;   //A
		4'b1100 : DEC_DATA = 8'b01010000;   //P
		4'b1101 : DEC_DATA = 8'b00100000;	//12 =' '
      default : DEC_DATA = 8'b00100000; //NULL
   endcase 
end

endmodule
