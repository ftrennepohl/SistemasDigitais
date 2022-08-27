module SD_Final(
input [5:0]SW,
input [3:0]KEY,
output [6:0]HEX0,
output [6:0]HEX1,
output [6:0]HEX2
);

reg clk;
reg [3:0]andarAtual;
reg [2:0]andarAlvo;
reg [1:0]estado_motor;
reg [1:0]aux;

codificadorBCDMotor(estado_motor, HEX0);
codificadorBotao(andarAlvo, HEX1);
codificadorBCD(andarAtual, HEX2);

function automatic [2:0] getAndarAtual(input [3:0]a);
        begin
            case (a)
                4'b0001: getAndarAtual = 3'd1;
                4'b0010: getAndarAtual = 3'd2;
                4'b0100: getAndarAtual = 3'd3;
                4'b1000: getAndarAtual = 3'd4;
                default: getAndarAtual = 3'd0; // erro, não tem como ter andar 0
            endcase
        end
endfunction

always #1 clk=~clk;

always @(KEY) begin
	if (andarAlvo == 0) andarAlvo <= 3'd1;
	else if(~KEY[0]) andarAlvo <= 3'b001;
	else if(~KEY[1]) andarAlvo <= 3'b010;
	else if(~KEY[2]) andarAlvo <= 3'b011;
	else if(~KEY[3]) andarAlvo <= 3'b100;
end

always @(SW) andarAtual = getAndarAtual(SW);


always @(posedge clk) begin
	 if(andarAtual==4'b0000 && estado_motor == 2'b00) estado_motor = aux;
	 else if(andarAtual != 4'b0000 && andarAtual < andarAlvo && !SW[4] && !SW[5])begin
		estado_motor <= 2'b01;
		aux = estado_motor;
	 end
	 else if(andarAtual!=4'b0000 && andarAtual > andarAlvo && !SW[4] && !SW[5])begin
		estado_motor <= 2'b10;
		aux = estado_motor;
	 end
	 else if (andarAtual == andarAlvo)begin
		estado_motor <= 2'b00;
		aux = estado_motor;
	 end
	 //end
 end

endmodule