/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter
 *
 * An error can be injected into the design by invoking compilation with
 * the option:  +define+FORCE_LOAD_ERROR
 *
 **********************************************************************/

 // user-defined types are defined in instr_register_pkg.sv
import instr_register_pkg::*;


module instr_register (tb_ifc.DUT tbif);


  timeunit 1ns/1ns;
  instruction_t  iw_reg [0:31];  // an array of instruction_word structures
  result_t rez;

  // write to the register
  always@(posedge tbif.clk, negedge tbif.reset_n)   // write into register
    if (!tbif.reset_n) begin
      foreach (iw_reg[i])
        iw_reg[i] = '{opc:ZERO,default:0};  // reset to all zeros
    end
    else 
    if (tbif.load_en) begin
      case (tbif.opcode)
        ZERO  :rez = '0;
        PASSB :rez = tbif.operand_b;
        PASSA :rez = tbif.operand_a;
        MULT  :rez = tbif.operand_a*tbif.operand_b;
        DIV   :rez = tbif.operand_a/tbif.operand_b;
        MOD   :rez = tbif.operand_a%tbif.operand_b;
        ADD   :rez = tbif.operand_a+tbif.operand_b;
        SUB   :rez = tbif.operand_a-tbif.operand_b;
        default: rez = '0;
      endcase
      iw_reg[tbif.write_pointer] = '{tbif.opcode,tbif.operand_a,tbif.operand_b,rez};
    end

  // read from the register
  assign tbif.instruction_word = iw_reg[tbif.read_pointer];  // continuously read from register

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force tbif.operand_b = tbif.operand_a; // cause wrong value to be loaded into operand_b
end
`endif

endmodule: instr_register
