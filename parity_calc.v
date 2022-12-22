module parity_calc #(
    parameter WIDTH=8
) (
    input [WIDTH-1:0] P_DATA,
//    input             PAR_EN,
    input             DATA_VALID,
    input             PAR_TYP,

    input             clk,
    input             rst,

    output            parity_bit
);

wire even_parity, odd_parity;
wire data_xored;

reg [WIDTH-1:0] P_DATA_reg;

assign data_xored= ^P_DATA_reg;
assign even_parity=data_xored;
assign odd_parity=~data_xored;


assign parity_bit= (PAR_TYP)?odd_parity:even_parity;
always @(posedge clk or negedge rst) 
begin
    if(rst)
    begin
    P_DATA_reg<=P_DATA;
    end

    else
    begin
        P_DATA_reg<=0;
    end    
end
    
endmodule