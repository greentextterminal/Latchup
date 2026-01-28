/*
Division
Design a hardware module that performs unsigned integer division. Given a dividend and divisor, compute both the quotient and remainder.

The module should handle division by zero by returning maximum values (all 1s) for both quotient and remainder.

Example: For dividend=17 and divisor=5, the output should be quotient=3 and remainder=2.
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

  external device                     FPGA
 ___________________            _______________         
|                  |            |              |
|                clk------------>              |
|              reset------------>              |
|            i_valid------------>              |
| i_payload_dividend-----/32---->              |
|  i_payload_divisor-----/32---->              |
|                  <------------i_ready        |
|                  <-----/32----o_payload_1    |
|                  <-----/32----o_payload_2    |
|                  <------------o_valid        |
|__________________|            |______________|
       
*/ 

module Solution (
  input wire clk,
  input wire reset,
  output wire i_ready,
  input wire i_valid,
  input wire [32-1:0] i_payload_dividend,
  input wire [32-1:0] i_payload_divisor,
  output wire [32-1:0] o_payload_1, // quotient
  output wire [32-1:0] o_payload_2, // remainder
  output wire o_valid
);

// Define your design here
  reg [31:0] quotient;   // o_payload_1
  reg [31:0] remainder;  // o_payload_2
  reg computation_valid; // o_valid and inversion is i_ready

  assign o_payload_1 = quotient;
  assign o_payload_2 = remainder;
  assign o_valid = computation_valid; // while the output is valid, we are not ready to accept new data
  assign i_ready = !computation_valid; // not ready to accept new data until output side has naturally 

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      quotient <= 32'b0;
      computation_valid <= 1'b0;
    end
    else if (i_valid && i_ready) begin
      // handling the division by 0 case
      if (!|i_payload_divisor) begin 
        quotient  <= {32{1'b1}};
        remainder <= {32{1'b1}};
        computation_valid <= 1'b1; // assert the values are ready
      end
      else begin
        quotient  <= i_payload_dividend / i_payload_divisor; // compute the division
        remainder <= i_payload_dividend % i_payload_divisor; // compute the remainder
        computation_valid <= 1'b1;                           // assert the computations are ready
      end
    end
    else if (computation_valid) begin
      computation_valid <= 1'b0;   // hold valid for 1 cycle, then clear
    end
  end

endmodule
