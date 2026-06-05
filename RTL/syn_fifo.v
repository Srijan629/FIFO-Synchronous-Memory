// Module: syn_fifo
// Description: A Synchronous FIFO Memory Block with Status Flags
module syn_fifo #(
    parameter DATA_WIDTH = 8,      // 8-bit data width per slot
    parameter FIFO_DEPTH = 16,     // 16 slots deep
    parameter ADDR_WIDTH = 4       // 2^4 = 16 addressable spaces
)(
    input  wire                  clk,       // System Clock
    input  wire                  rst_n,     // Active-low Reset
    input  wire                  wr_en,     // Write Enable
    input  wire                  rd_en,     // Read Enable
    input  wire [DATA_WIDTH-1:0] data_in,   // Input Data bus
    output reg  [DATA_WIDTH-1:0] data_out,  // Output Data bus
    output wire                  full,      // FIFO Full flag
    output wire                  empty      // FIFO Empty flag
);

    // Internal Memory Matrix Allocation
    reg [DATA_WIDTH-1:0] fifo_ram [FIFO_DEPTH-1:0];

    // Pointer Registers (+1 extra bit to handle loop rollover status)
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;

    // Internal Status Flag Generation
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // Memory Write Sequential Block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_ram[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Memory Read Sequential Block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_ram[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end

endmodule