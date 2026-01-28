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
  reg [15:0] a, b;
  reg [31:0] product;
  reg product_valid, accept_new_data;

  assign o_payload = product;
  assign o_valid = payload_valid;
  assign i_ready = accept_new_data;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      a <= 16'b0;
      b <= 16'b0;
      product <= 32'b0;
      payload_valid <= 1'b0;
      accept_new_data <= 1'b1;
    end
    else if (i_valid && i_ready) begin
      product <= i_payload_a * i_payload_b;
      product_valid <= 1'b1;
      accept_new_data <= 1'b0;
    end
    else begin
      accept_new_data <= 1'b0;
      product_valid <= 1'b0;
      product <= 32'b0;
    end
  end
    
endmodule
