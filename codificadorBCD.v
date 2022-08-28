module codificadorBCD(input [3:0]SW, output [6:0]HEX0);

	reg [8:0] val;
	assign HEX0 = val;

	//começa com 0000 = entre andares = H
	//Se tiver mais de uma ligada da erro = E
	always @(SW) begin
	case (SW)
		3'b000: begin
			 val[0] <= 1;
			 val[1] <= 0;
			 val[2] <= 0;
			 val[3] <= 1;
			 val[4] <= 0;
			 val[5] <= 0;
			 val[6] <= 0;
		end
		 3'b001: begin
			 val[0] <= 1;
			 val[1] <= 0;
			 val[2] <= 0;
			 val[3] <= 1;
			 val[4] <= 1;
			 val[5] <= 1;
			 val[6] <= 1;
			 end
		 3'b010:begin
			 val[0] <= 0;
			 val[1] <= 0;
			 val[2] <= 1;
			 val[3] <= 0;
			 val[4] <= 0;
			 val[5] <= 1;
			 val[6] <= 0;
			 end
		 3'b011: begin
			 val[0] <= 0;
			 val[1] <= 0;
			 val[2] <= 0;
			 val[3] <= 0;
			 val[4] <= 1;
			 val[5] <= 1;
			 val[6] <= 0;
			 end
		  3'b100: begin
			 val[0] <= 1;
			 val[1] <= 0;
			 val[2] <= 0;
			 val[3] <= 1;
			 val[4] <= 1;
			 val[5] <= 0;
			 val[6] <= 0;
			 end
			 
		 default: begin
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