/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc ();
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  //signals
  operand_t operand_a,operand_b;
  opcode_t opcode;
  address_t write_pointer, read_pointer;
  instruction_t instruction_word;
  logic load_en;

  //modports
  modport DUT (
  input load_en, operand_a, operand_b, opcode, write_pointer, read_pointer,
  output instruction_word
  );
  
  modport TEST (
    input instruction_word,
    output load_en, operand_a, operand_b, opcode, write_pointer, read_pointer
  );


endinterface: tb_ifc

