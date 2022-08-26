module FSM(
input clk,
input [5:0]SW,
input [3:0]KEY,
output reg [1:0]estado_motor
);

reg [2:0]andarAtual;
reg andaresSelecionados[3:0];
reg [2:0]teste;
reg [2:0]teste1;
reg [2:0]teste2;
reg [2:0]teste3;
reg [2:0]andarAlvo;



function automatic [2:0] switchParaAndar(input [3:0]a);
    // converte a entrada dos switches para números dos andares 
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

function automatic [2:0] andarMaisProx(input andar1, input andar2, input andar3, input andar4);
    reg dist1;
    reg dist2;
    reg dist3;
    reg dist4;
    begin
        dist1 = 0;
        dist2 = 0;
        dist3 = 0;
        dist4 = 0;

        // distancia entre cada andar e o andar atual (valor absoluto)
        if(andar1) dist1 = (andarAtual > 3'd1)? andarAtual - 3'd1 : 3'd1 - andarAtual;
        if(andar2) dist2 = (andarAtual > 3'd2)? andarAtual - 3'd2 : 3'd2 - andarAtual;
        if(andar3) dist3 = (andarAtual > 3'd3)? andarAtual - 3'd3 : 3'd3 - andarAtual;
        if(andar4) dist4 = (andarAtual > 3'd4)? andarAtual - 3'd4 : 3'd4 - andarAtual;

        teste = dist1;
        teste1 = dist2;
        teste2 = dist3;
        teste3 = dist4;
        
        /*if(dist1 != 0 && dist1 <= dist2 && dist1 <= dist3 && dist1 <= dist4) andarMaisProx = 1;
        else if(dist2 != 0 && dist2 <= dist1 && dist2 <= dist3 && dist2 <= dist4) andarMaisProx = 2;
        else if(dist3 != 0 && dist3 <= dist1 && dist3 <= dist2 && dist3 <= dist4) andarMaisProx = 3;
        else if(dist4 != 0 && dist4 <= dist1 && dist4 <= dist2 && dist4 <= dist3) andarMaisProx = 4;*/
    end
endfunction

always @(SW) begin
    andarAtual = switchParaAndar(SW);
    andarAlvo = andarMaisProx(andaresSelecionados[0], andaresSelecionados[1], andaresSelecionados[2], andaresSelecionados[3]);
end

always @(KEY) begin
    if(KEY[0]) andaresSelecionados[0] = 1;
    if(KEY[1]) andaresSelecionados[1] = 1;
    if(KEY[2]) andaresSelecionados[2] = 1;
    if(KEY[3]) andaresSelecionados[3] = 1;
end

always @(posedge clk) begin
    // motor subindo
    if(andarAtual < andarAlvo && !SW[4] && !SW[5]) estado_motor <= 01;
    // motor descendo
    else if(andarAtual > andarAlvo && !SW[4] && !SW[5]) estado_motor <= 10;
    // motor parado
    else estado_motor <= 00;
end
endmodule

module tb_FSM;
reg clk = 0;
reg [5:0]SW;
reg [3:0]KEY;
wire [1:0]estado_motor;

FSM f(
    clk,
    SW,
    KEY,
    estado_motor
);

always #1 clk=~clk;

initial begin
    $dumpfile("tb_FSM.vcd");
    $dumpvars(0, tb_FSM);
end

initial begin
    #2
    SW[5:0] <= 6'b000001;
    #2
    KEY <= 4'b1000;
    #2
    KEY <= 4'b0100;
    #2
    SW[5:0] <= 6'b000010;
    #2
    SW[5:0] <= 6'b000100;
    #2
    SW[5:0] <= 6'b001000;
    #2
    $finish(2);
end

endmodule