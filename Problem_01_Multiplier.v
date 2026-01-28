// Stream-based solution component
//
// Input stream interface:
//   i_ready (output): Assert when ready to accept input
//   i_valid (input): Asserted when input data is valid
//   i_payload_* (input): Input payload fields
//
// Output interface:
//   o_valid (output): Assert when output data is valid
//   o_payload* (output): Output payload fields
//
// Handshaking: Data transfers when both ready and valid are high

module Solution (
  input wire clk,
  input wire reset,
  output wire i_ready,
  input wire i_valid,
  input wire [16-1:0] i_payload_a,
  input wire [16-1:0] i_payload_b,
  output wire [32-1:0] o_payload,
  output wire o_valid
);
  
// Define your design here
  reg [31:0] product;  // o_payload
  reg product_valid;   // o_valid
  reg accept_new_data; // i_ready

  assign o_payload = product;
  assign o_valid = product_valid;
  assign i_ready = accept_new_data;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      product <= 32'b0;
      product_valid <= 1'b0;
      accept_new_data <= 1'b1;
    end
    else if (i_valid && i_ready) begin
      product <= i_payload_a * i_payload_b; // compute the multiplication
      product_valid <= 1'b1;                // assert the product is ready
      accept_new_data <= 1'b0;              // decline new data 
    end
    else begin
      accept_new_data <= 1'b1; // reassert i_ready
      product_valid <= 1'b0;   // outside of the multiplication cycle, reset flag to 0
      product <= product;      // hold previous value
    end
  end
    
endmodule


/*

external device            FPGA
 _______________            _______________         
|              |            |              |
|            clk------------>              |
|          reset------------>              |
|        i_valid------------>              |
|    i_payload_a------------>              |
|    i_payload_b------------>              |
|              <------------i_ready        |
|              <------------o_payload      |
|              <------------o_valid        |
|______________|            |______________|

       
*/ 
