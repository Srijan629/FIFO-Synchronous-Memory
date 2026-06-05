`timescale 1ns / 1ps

module syn_fifo_tb;

    // Testbench Drivers
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    
    // Monitors
    wire [7:0] data_out;
    wire full;
    wire empty;

    // Instantiate Unit Under Test (UUT)
    syn_fifo #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(16),
        .ADDR_WIDTH(4)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // 100MHz Clock Generation Loop
    always #5 clk = ~clk;

    initial begin
        // Step 1: System Initialization
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        #20;
        
        // Release Reset Condition
        rst_n = 1;
        #10;

        // Step 2: Burst Write Operations (Fill up the memory array)
        repeat(16) begin
            @(posedge clk);
            wr_en = 1;
            data_in = data_in + 8'hA1;  // Generate changing hex patterns
        end
        
        @(posedge clk);
        wr_en = 0; // Check if Full Flag triggers accurately
        #20;

        // Step 3: Burst Read Operations (Drain the memory array)
        repeat(16) begin
            @(posedge clk);
            rd_en = 1;
        end
        
        @(posedge clk);
        rd_en = 0; // Check if Empty Flag triggers accurately
        #40;
        
        $finish;
    end

endmodule