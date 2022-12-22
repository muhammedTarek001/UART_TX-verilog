module uart_tx #(
    parameter
    WIDTH=8,
    STOP=1,
    START =0,

    //sel_line probable values
    LIFT_SER_LOAD=0,
    SEL_START=1,
    SEL_STP=2,
    SEL_SRL=3,
    SEL_PAR=4
) (
    input [WIDTH-1:0] P_DATA,
    input             DATA_VALID,
    input             PAR_EN,
    input             PAR_TYP,

    input             clk,
    input             rst,

    output reg         TX_OUT,
    output             Busy

);



wire parity_bit;
//serializer o/p signals
wire SRL_OUT;
// wire SRL_done;
wire [3:0] counter;

//FSM o/p signals
wire[1:0] sel_line;
wire serializer_load;
wire start_signal;
wire [2:0] current_state;

//two FF's to make Busy synchronous to data frame



uart_tx_FSM U0_FSM (
    .DATA_VALID(DATA_VALID),
    .SRL_done(SRL_done),
    .PAR_EN(PAR_EN),
    .counter(counter),

    .clk(clk),
    .rst(rst),
    
    .current_state(current_state),
    .serializer_load(serializer_load),
    .sel_line(sel_line),
    .start_signal(start_signal)
);

serializer U0_serializer(
    .P_DATA(P_DATA),
    .serializer_load(serializer_load),
    .start_signal(start_signal),
    .current_state(current_state),

    .clk(clk), .rst(rst),

    .counter(counter),
    .Busy(Busy),
    .SRL_OUT(SRL_OUT)
   
);

parity_calc U0_PARITY (
    .P_DATA(P_DATA),
    .PAR_TYP(PAR_TYP),
    
    .clk(clk), .rst(rst),

    .parity_bit(parity_bit)
);

//we will build fsm

//     LIFT_SER_LOAD=0
//     SEL_START=1,
//     SEL_STP=2,
//     SEL_SRL=3,
//     SEL_PAR=4


always @(posedge clk or negedge rst) 
begin
if(rst)
begin
case (sel_line)
    SEL_START: TX_OUT<=START;
    SEL_STP:   TX_OUT<=STOP;
    SEL_SRL:   TX_OUT<=SRL_OUT;
    SEL_PAR: begin if(PAR_EN) TX_OUT<=parity_bit; else TX_OUT<=STOP; end
endcase
end

else
TX_OUT<=STOP;
    
end

endmodule