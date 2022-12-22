
//1-make busy output and edit the code according to that
//2- busy && !serializer_load
//3- generate busy

module serializer #(  //passed testing
    parameter 
    WIDTH=8,

    LIFT_SER_LOAD=0,
    SEL_START=1,
    SEL_STP=2,
    SEL_SRL=3,
    SEL_PAR=4
) (
    input [WIDTH-1 : 0]  P_DATA,
    input                serializer_load,
    input                start_signal,
    input [2:0]          current_state,

    input clk ,
    input rst ,

    output  reg          Busy,
    output  reg          SRL_OUT,
//    output  reg          SRL_done,
    output reg [3:0]     counter
);

reg [WIDTH-1 : 0] prallel_serial_reg;


//prallel_serial_reg && SRL_OUT assigning block
always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        prallel_serial_reg<=0;
        SRL_OUT<=0;
    end
    
    //we could have used Busy inside this condition 
    //but Busy is 1 not only during transmmision but also during start bit
    else if(counter < WIDTH && !serializer_load & !start_signal) //??
    begin
        {prallel_serial_reg[6:0],SRL_OUT}<= prallel_serial_reg;
    end

    else if(serializer_load == 1)
    begin
        prallel_serial_reg<=P_DATA;
    end
end




//Busy assigning block
always @(*) 
begin
  
  if(counter < WIDTH+2 && !serializer_load && counter>0) 
      begin
        Busy=1;
      end

  else if (serializer_load)  
      begin
        Busy=0;
      end

  else if(counter == 0) 
      begin  
        Busy=0;
      end
  else
     begin
      Busy=1;
     end

end


//counter assigning blocks
always @(posedge clk or negedge rst) 
begin
    if(!rst)
    begin
        counter<=0;
    end

    else
    begin
     //if serializer_load is 0  ,SRL_done will not change  
     
     if(counter < WIDTH+2 && !serializer_load 
     && (current_state == SEL_START || current_state == SEL_SRL || (current_state == SEL_STP && counter == WIDTH+1)))
      begin
        counter<=counter+1;
      end

     else if(counter == WIDTH+2) // srl_done must not be1 until parity bit is sent
      begin  //at this time FSM will set serializer load to 1
        counter<=0;
      end
    end
end

endmodule