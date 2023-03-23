/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/
import instr_register_pkg::*;
module instr_register_test(tb_ifc.TEST tbif, input logic clk, output logic reset_n);
    // user-defined types are defined in instr_register_pkg.sv


  timeunit 1ns/1ns;

  //procedura prin care se initializeaza segventa de generare a numerelor random
  int seed = 77777;
  parameter NumberOfTransaction = 20;

  initial begin
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    tbif.write_pointer  = 5'h00;         // initialize write pointer
    tbif.read_pointer   = 5'h1F;         // initialize read pointer
    tbif.load_en        = 1'b0;          // initialize load control line
    reset_n       <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge clk) ;     // hold in reset for 2 clock cycles
    reset_n        = 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    //@(posedge clk) load_en = 1'b1;  // enable writing to register
    repeat (NumberOfTransaction ) begin
      @(posedge clk) begin
        tbif.load_en <= 1'b1;
        randomize_transaction;
      end
      @(negedge clk) print_transaction;
    end
    @(posedge clk) tbif.load_en = 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<NumberOfTransaction; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back


      //@(posedge clk) read_pointer = i;
      @(posedge clk) tbif.read_pointer = $unsigned($random(seed))%32;
      @(negedge clk) print_results;
    end

    @(posedge clk) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  end

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //



    //static int temp = 0;
    tbif.operand_a     <= $random(seed)%16;                 // between -15 and 15
    tbif.operand_b     <= $unsigned($random(seed))%16;            // between 0 and 15
    tbif.opcode        <= opcode_t'($unsigned($random(seed))%8);  // between 0 and 7, cast to opcode_t type
    tbif.write_pointer <= $unsigned($random(seed))%32;
    //write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", tbif.write_pointer);
    $display("  opcode = %0d (%s)", tbif.opcode, tbif.opcode.name);
    $display("  operand_a = %0d",   tbif.operand_a);
    $display("  operand_b = %0d\n", tbif.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", tbif.read_pointer);
    $display("  opcode = %0d (%s)", tbif.instruction_word.opc, tbif.instruction_word.opc.name);
    $display("  operand_a = %0d",   tbif.instruction_word.op_a);
    $display("  operand_b = %0d\n", tbif.instruction_word.op_b);
    $display("  rez = %0d\n", tbif.instruction_word.rez);
  endfunction: print_results

endmodule: instr_register_test
