
module uart_tx_tb;
parameter WIDTH =8,
          STOP  =1,
          START =0;

reg [WIDTH-1 : 0] P_DATA_tb;
reg DATA_VALID_tb;
reg PAR_EN_tb;
reg PAR_TYP_tb;

reg [7:0] p_data_temp;

reg clk_tb;
reg rst_tb;

wire Busy_tb,
    TX_OUT_tb;
    

reg temp;
integer  j;

uart_tx U0_UART_TX (
    .P_DATA(P_DATA_tb),
    .DATA_VALID(DATA_VALID_tb),
    .PAR_EN(PAR_EN_tb),
    .PAR_TYP(PAR_TYP_tb),

    .clk(clk_tb),
    .rst(rst_tb),

    .TX_OUT(TX_OUT_tb),
    .Busy(Busy_tb)
);


always #5 clk_tb=~clk_tb;

initial
begin
    clk_tb=0;
    rst_tb=0;
    PAR_EN_tb=0;
end

initial 
begin
    $dumpfile("serializer.vcd");
    $dumpvars;
    reset(); // 2
    #2
    send_parallel_data(1, 'b0101_1001); //7
    p_data_temp=U0_UART_TX.U0_serializer.prallel_serial_reg;

    #20                                 //27
    if(TX_OUT_tb == 0)
    $display("start bit is sent sucessully !");
    else
    $display("start bit is NOT sent sucessully !");


    for(j=0; j<= WIDTH-1; j=j+1)
    begin
        temp=p_data_temp[j];
        #5                            //32
        test_serial_out();           //37
    end
                                    //107
    #10                             //117
    if(TX_OUT_tb == STOP)
    $display("stop bit is sent sucessully !");
    else
    $display("stop bit is NOT sent sucessully !");
    
    #10                           //127

    //sending another parallel data
    send_parallel_data(1, 'b1000_0001); //137
    p_data_temp=U0_UART_TX.U0_serializer.prallel_serial_reg;

    #20                                 
    if(TX_OUT_tb == START)
    $display("start bit is sent sucessully !");
    else
    $display("start bit is NOT sent sucessully !");
    
    //testing serial data
    for(j=0; j<= WIDTH-1; j=j+1)
    begin
        temp=p_data_temp[j];
        #5                           
        test_serial_out();           
    end

    //testing stop bit
    #10                             
    if(TX_OUT_tb == STOP)
    $display("stop bit is sent sucessully !");
    else
    $display("stop bit is NOT sent sucessully !");
    

    #20
    //testing when no data is being sent
    for(j=0; j<= WIDTH-1; j=j+1)
    begin
        if(TX_OUT_tb == STOP && Busy_tb==0)
        $display("test succeded, NO data is sent--->TX_OUT=stop_bit && Busy=0 !!");
        else
        $display("test failed !!");
        
    end

end

task reset();
begin
    rst_tb=0;
    #2
    rst_tb=1;
end
endtask

task send_parallel_data (input ser_ld, input [WIDTH-1:0] p_data);
begin
    DATA_VALID_tb=ser_ld;
    P_DATA_tb=p_data;

    #20
    DATA_VALID_tb=0;

    if(U0_UART_TX.U0_serializer.prallel_serial_reg==p_data)
    begin
        $display("parallel sent successfuly reg= %d",U0_UART_TX.U0_serializer.prallel_serial_reg);
    end
    else
        $display("parallel NOT sent successfuly reg= %d",U0_UART_TX.U0_serializer.prallel_serial_reg);
end

endtask

task test_serial_out();
begin
    
    #5
    if (TX_OUT_tb == temp && Busy_tb == 1)
    begin
        $display("serializtion is present, p_d[0] =%d, srl_out=%d",temp,TX_OUT_tb);
    end

    else
        $display("serializtion failed,     p_d[0] =%d, srl_out=%d",temp,TX_OUT_tb);
end
endtask

endmodule