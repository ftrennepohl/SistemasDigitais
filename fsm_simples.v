module FSM(
input clk,
input [5:0]SW,
input [3:0]KEY,
output reg [1:0]estado_motor
);

wire [2:0]andarAtual = getAndarAtual(SW);
wire [2:0]andarAlvo = getAndarAtual(KEY);

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

always @(posedge clk) begin
    if(andarAtual < andarAlvo && !SW[4] && !SW[5]) estado_motor <= 01;
    else if(andarAtual > andarAlvo && !SW[4] && !SW[5]) estado_motor <= 10;
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
    KEY <= 4'b1000;
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