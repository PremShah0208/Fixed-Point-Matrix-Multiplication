// Testbench for verifying Fixed-Point Q4.4 3x3 matrix multiplication

module testbench_fixed_point_matrix_multiply;

  //signals for uut port
  reg [71:0] matrix_A;
  reg [71:0] matrix_B;		//3×3 matrix of 8-bit Q4.4 values
  wire [143:0] matrix_result;
  
  //Instantiate dut
  fixed_point_matrix_multiply uut (
    .matrix_A(matrix_A),
    .matrix_B(matrix_B),
    .matrix_result(matrix_result)
  );
  
  //loop indices
  integer i, j, k;
  
  reg [15:0] expected_result [0:2][0:2];	//Golden reference 
  reg [7:0] temp_A [0:2][0:2];		//temporary storage input 
  reg [7:0] temp_B [0:2][0:2];
  reg [15:0] temp_result [0:2][0:2];//temporary storage ouput
  
initial begin
  $vcdpluson;
  // Define matrices (fixed-point Q4.4)
  matrix_A = {8'd4, 8'd5, 8'd6, 
              8'd4, 8'd5, 8'd6, 
              8'd4, 8'd5, 8'd6};
  //matrix_A: rows = [0.25, 0.3125, 0.375] in Q4.4
  
  matrix_B = {8'd4, 8'd5, 8'd6, 
              8'd4, 8'd5, 8'd6, 
              8'd4, 8'd5, 8'd6};
  //matrix_B: rows = [0.25, 0.3125, 0.375] in Q4.4
  
  //unpack inputs into 2D arrays
  {temp_A[0][0], temp_A[0][1], temp_A[0][2], temp_A[1][0], temp_A[1][1], temp_A[1][2], temp_A[2][0], temp_A[2][1], temp_A[2][2]} = matrix_A;
  {temp_B[0][0], temp_B[0][1], temp_B[0][2], temp_B[1][0], temp_B[1][1], temp_B[1][2], temp_B[2][0], temp_B[2][1], temp_B[2][2]} = matrix_B;

  // Compute expected results manually (Q4.4 multiplication)
  for(i = 0; i < 3; i = i + 1) begin
    for(j = 0; j < 3; j = j + 1) begin
      expected_result[i][j] = 0;
      for(k = 0; k < 3; k = k + 1) begin
        expected_result[i][j] = expected_result[i][j] + ((temp_A[i][k] * temp_B[k][j]) >> 4);
      end
    end
  end
  
  #10; // Wait for multiplication to complete

  //unpack output into temp 2D array
  {temp_result[0][0], temp_result[0][1], temp_result[0][2], temp_result[1][0], temp_result[1][1], temp_result[1][2], temp_result[2][0], temp_result[2][1], temp_result[2][2]} = matrix_result;

  // Display matrices and verify results
  $display("Matrix A (Q4.4 format):");
  for(i=0; i<3; i=i+1)
    $display("%d %d %d", temp_A[i][0], temp_A[i][1], temp_A[i][2]);
  $display("Matrix B (Q4.4 format):");
  for(i=0; i<3; i=i+1)
    $display("%d %d %d", temp_B[i][0], temp_B[i][1], temp_B[i][2]);
  $display("Calculated Result (Q4.4 format):");
  for(i=0; i<3; i=i+1)
    $display("%d %d %d", temp_result[i][0], temp_result[i][1], temp_result[i][2]);

  $display("Expected Result (Q4.4 format):");
  for(i=0; i<3; i=i+1)
    $display("%d %d %d", expected_result[i][0], expected_result[i][1], expected_result[i][2]);

  #10 $finish;
end

endmodule