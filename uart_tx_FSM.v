
module uart_tx_FSM #(
    parameter 
    WIDTH=8,
    STOP=1,
    START =0,

    LIFT_SER_LOAD=0,
    SEL_START=1,
    SEL_STP=2,
    SEL_SRL=3,
    SEL_PAR=4
) (
   input DATA_VALID,
   input SRL_done,
   input PAR_EN,
   input [3:0] counter,
   
   input clk,
   input rst,

   output reg serializer_load,
   output reg [1:0] sel_line,
   output reg       start_signal,
   output reg [2:0] current_state
);



reg [2:0] next_state;


always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        current_state<=0;
    end

    else
    begin
        current_state<=next_state;
    end
end




always @(*) 
begin
    serializer_load=0;
    sel_line=0;
    start_signal=0;

    if(current_state == LIFT_SER_LOAD)
    begin
        serializer_load=1;
        sel_line=SEL_STP;
        start_signal=0;
    end

    else if(current_state == SEL_START)
    begin
        serializer_load=0;
        sel_line=SEL_START;
        start_signal=0;
    end

    else if(current_state == SEL_SRL)
    begin
        serializer_load=0;
        sel_line=SEL_SRL;
        start_signal=0;
    end

    else if(current_state == SEL_PAR)
    begin
        serializer_load=0;
        sel_line=SEL_PAR;
        start_signal=0;
    end

    else if(current_state == SEL_STP)
    begin
        serializer_load=0;
        sel_line=SEL_STP;
        start_signal=0;
    end
end





always @(*) 
begin
    case (current_state)
        LIFT_SER_LOAD:
        begin
            if(!DATA_VALID)
            next_state=SEL_START;
            else
            next_state=LIFT_SER_LOAD;
        end 

        SEL_START:
        begin
            next_state=SEL_SRL;
        end
        
        SEL_SRL:
        begin
            if(counter == WIDTH)
            begin
                if(!PAR_EN)
                next_state=SEL_STP;
                else
                next_state=SEL_PAR;
            end
            else
            next_state=SEL_SRL;
        end
        
        SEL_PAR:
        begin
            next_state=SEL_STP;
        end

        SEL_STP:
        begin
            if(DATA_VALID)
            next_state=LIFT_SER_LOAD;
            else
            next_state=SEL_STP;
        end
 
    endcase
end


endmodule