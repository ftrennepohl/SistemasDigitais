module codificadorBCDMotor(input [1:0]SW, output [6:0]HEX0);

	reg [8:0] val;
	assign HEX0 = val;

	//00 = parado
    //01 = subindo
    //10 = descendo
    //11 = erro
	always @(SW) begin
	case (SW)
		 4'b00: begin
			 val[0] <= 0;
			 val[1] <= 0;
			 val[2] <= 1;
			 val[3] <= 1;
			 val[4] <= 0;
			 val[5] <= 0;
			 val[6] <= 0;
			 end
		 4'b01:begin
			 val[0] <= 0;
			 val[1] <= 1;
			 val[2] <= 0;
			 val[3] <= 0;
			 val[4] <= 1;
			 val[5] <= 0;
			 val[6] <= 0;
			 end
		 4'b10: begin
			 val[0] <= 1;
			 val[1] <= 0;
			 val[2] <= 0;
			 val[3] <= 0;
			 val[4] <= 0;
			 val[5] <= 1;
			 val[6] <= 0;
			 end
		  4'b11: begin
			 val[0] <= 0;
			 val[1] <= 1;
			 val[2] <= 1;
			 val[3] <= 0;
			 val[4] <= 0;
			 val[5] <= 0;
			 val[6] <= 0;
			 end
		endcase
	end
endmodule