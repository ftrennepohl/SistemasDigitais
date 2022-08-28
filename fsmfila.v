module fsmfila(
input [5:0]SW,
input [3:0]KEY,
output [6:0]HEX0,
output [6:0]HEX1,
output [6:0]HEX2
);

reg [2:0]andarAtual;
reg [3:0]andaresSelecionados;
reg [2:0]andarAlvo;
reg [1:0]estado_motor;
reg [1:0]aux;

codificadorBCDMotor(estado_motor, HEX0);
codificadorBotao(andarAlvo, HEX1);
codificadorBCD(andarAtual, HEX2);

function automatic [2:0] switchParaAndar(input [3:0]a);
        begin
            case (a)
                4'b0001: switchParaAndar = 3'd1;
                4'b0010: switchParaAndar = 3'd2;
                4'b0100: switchParaAndar = 3'd3;
                4'b1000: switchParaAndar = 3'd4;
                default: switchParaAndar = 3'd0; // erro, não tem como ter andar 0
            endcase
        end
endfunction

function automatic [2:0] proxAndar(input [2:0]atual, input [3:0]selecionados, input [2:0]motor);
    integer i;
    reg flag;
    case(atual)
        3'd1: begin
            // Elevador no 1º andar: procura andar selecionado p/ cima
            i = 2;
            while(i < 5 && selecionado == 0) begin
                if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i + 1;
            end
            if(!flag) proxAndar = atual;
        end
        3'd2, 3'd3: begin
            // Se motor subindo, procura andar selecionado p/ cima
            if(motor == 2'b01) begin
                i = atual + 1;
                while(i < 5 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i + 1;
                end
            end
            // Se motor subindo, procura andar selecionado p/ baixo
            else if(motor == 2'b10) begin
                i = atual - 1;
                while(i > 0 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i - 1;
                end
            end
            else begin
                // Se motor parado:
                // Se for 2º andar, procura andar p/ baixo, e se não encontrar, p/ cima
                if(atual == 3'd2) begin
                    while(i > 0 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i - 1;
                    end
                    if (!flag)
                    while(i < 5 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i + 1;
                    end
                end
                else begin
                    // Se for 3º andar, procura andar p/ cima, e se não encontrar, p/ baixo
                    i = atual + 1;
                    while(i < 5 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i + 1;
                    end
                    if(!flag)
                    while(i > 0 && !selecionado) begin
                    if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i - 1;
                    end
                end
            end
        end
        3'd4: begin
            // Elevador no 4º andar: procura andar selecionado p/ baixo
            i = 3;
            while(i > 0 && selecionado == 0) begin
                if(selecionados[i]) begin
                        proxAndar = i;
                        flag = 1;
                    end
                    i = i - 1;
            end
        end
    endcase
endfunction

always #1 clk=~clk;

always @(KEY) begin
	if (andarAlvo == 0) andarAlvo <= 3'd1;
	else if(~KEY[0]) andaresSelecionados[0] <= 1;
	else if(~KEY[1]) andaresSelecionados[1] <= 1;
	else if(~KEY[2]) andaresSelecionados[2] <= 1;
	else if(~KEY[3]) andaresSelecionados[3] <= 1;
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