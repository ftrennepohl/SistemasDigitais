module botaoInput(
input [3:0]KEY, 
output reg [3:0]botoesPressionados
);

    always @(KEY) begin
        case (KEY)
            4'b0001: botoesPressionados[0] = 1;
            4'b0010: botoesPressionados[1] = 1;
            4'b0100: botoesPressionados[2] = 1;
            4'b1000: botoesPressionados[3] = 1;
        endcase
    end
endmodule

module FSM(
input [5:0]SW,
input [3:0]KEY,
output [1:0]estado_motor);


    wire andarAtual = getAndarAtual(SW);
    witre [3:0] valorBotao;
    wire andarMaisProx = getAndarMaisProx(andarAtual, valorBotao);

    botaoInput botao(
    KEY,
    valorBotao
    );
    
    function automatic integer getAndarAtual(input [3:0]a);
        begin
            case (a)
                4'b0001: getAndarAtual = 1;
                4'b0010: getAndarAtual = 2;
                4'b0100: getAndarAtual = 3;
                4'b1000: getAndarAtual = 4;
                default: getAndarAtual = 0; // erro, não tem como ter andar 0
            endcase
        end
    endfunction

    function automatic integer getAndarMaisProx(input atual, input [3:0]btn);
        integer dist1;
        integer dist2; 
        integer dist3; 
        integer dist4;
        begin
            if(btn[0]) dist1 = (1 - atual);
            if(btn[1]) dist2 = (2 - atual);
            if(btn[2]) dist3 = (3 - atual);
            if(btn[3]) dist4 = (4 - atual);

            if(dist1 != 0 && dist1 < dist2 && dist1 < dist3 && dist1 < dist4) getAndarMaisProx = 1;
            else if(dist2 != 0 && dist2 < dist1 && dist2 < dist3 && dist2 < dist4) getAndarMaisProx = 2;
            else if(dist3 != 0 && dist3 < dist1 && dist3 < dist2 && dist3 < dist4) getAndarMaisProx = 3;
            else if(dist4 != 0 && dist4 < dist1 && dist4 < dist2 && dist4 < dist3) getAndarMaisProx = 4;
            else getAndarMaisProx = atual;
        end
    endfunction

    reg [1:0]estado_motor = 2'b00; // 00 = parado, 01 = desce, 10 = sobe, 11 = falha

    always @(SW) begin
    // Se andar atual > botão pressionado
    if(andarAtual > andarMaisProx) estado_motor <= 10;
    // Se andar atual < botão pressionado
    else if (andarAtual < andarMaisProx) estado_motor <= 01;
    // Se andar atual = botão pressionado
    else begin
        valorBotao[andarAtual-1] <= 0;
        estado_motor <= 00;
        end
    end
    
endmodule