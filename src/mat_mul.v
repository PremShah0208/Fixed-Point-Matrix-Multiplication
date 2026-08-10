// Fixed-Point Q4.4 3x3 Matrix Multiplication in Verilog
module fixed_point_matrix_multiply(
  input [71:0] matrix_A,
  input [71:0] matrix_B,			//3×3 matrix of 8-bit Q4.4 values
  output reg [143:0] matrix_result	//3×3 matrix of 16-bit Q4.4 products
);
  
  integer row, col, idx;			//loop indices for dot-product
  reg [7:0] A [0:2][0:2];			
  reg [7:0] B [0:2][0:2];			//two 3×3 arrays of 8-bit registers
  reg [15:0] result [0:2][0:2];		//3×3 array of 16-bit register
  
  always @(*) begin
    // Convert input arrays into 3x3 matrices
    {A[0][0], A[0][1], A[0][2],
     A[1][0], A[1][1], A[1][2],
     A[2][0], A[2][1], A[2][2]} = matrix_A;

    {B[0][0], B[0][1], B[0][2],
     B[1][0], B[1][1], B[1][2],
     B[2][0], B[2][1], B[2][2]} = matrix_B;

    // Perform fixed-point matrix multiplication (Q4.4 format)
    for (row = 0; row < 3; row = row + 1) begin
        for (col = 0; col < 3; col = col + 1) begin
            result[row][col] = 0;
            for (idx = 0; idx < 3; idx = idx + 1) begin
                // Multiply and shift to maintain fixed-point format Q4.4
                result[row][col] = result[row][col] + ((A[row][idx] * B[idx][col]) >> 4);
            end
        end
    end

    // Convert result matrix back into a flat array
    matrix_result = {result[0][0], result[0][1], result[0][2],
                     result[1][0], result[1][1], result[1][2],
                     result[2][0], result[2][1], result[2][2]};
end

endmodule

