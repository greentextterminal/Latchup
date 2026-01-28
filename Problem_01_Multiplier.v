/*
Multiplier
Design a hardware module that performs unsigned integer multiplication. Given two N-bit unsigned integers, compute their 2N-bit product.

Example: For 4-bit inputs a=5 (0101) and b=3 (0011), the output should be 15 (00001111).
*/

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

/*

 external device                  FPGA
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
  reg product_valid;   // o_valid and inversion is i_ready

  assign o_payload = product;
  assign o_valid = product_valid; // while the output is valid, we are not ready to accept new data
  assign i_ready = !product_valid; // not ready to accept new data until output side has naturally 

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      product <= 32'b0;
      product_valid <= 1'b0;
    end
    else if (i_valid && i_ready) begin
      product <= i_payload_a * i_payload_b; // compute the multiplication
      product_valid <= 1'b1;                // assert the product is ready
    end
    else if (product_valid) begin
      product_valid <= 1'b0;   // hold valid for 1 cycle, then clear
    end
  end
    
endmodule
