module ALU(
    clk,
    rst_n,
    valid,
    ready,
    mode,
    in_A,
    in_B,
    out
);

    // Definition of ports
    input         clk, rst_n;
    input         valid;
    input  [1:0]  mode; // mode: 0: mulu, 1: divu, 2: and, 3: or
    output        ready;
    input  [31:0] in_A, in_B;
    output [63:0] out;

    // Definition of states
    parameter IDLE = 3'd0;
    parameter MUL  = 3'd1;
    parameter DIV  = 3'd2;
    parameter AND = 3'd3;
    parameter OR = 3'd4;
    parameter OUT  = 3'd5;

    // Todo: Wire and reg if needed
    reg  [ 2:0] state, state_nxt;
    reg  [ 4:0] counter, counter_nxt;
    reg  [63:0] shreg, shreg_nxt;
    reg  [31:0] alu_in, alu_in_nxt;
    reg  [32:0] alu_out;

    // Todo: Instatiate any primitives if needed

    // Todo 5: Wire assignments
    assign out=shreg;
    // Combinational always block
    // Todo 1: Next-state logic of state machine
    always @(*) begin
        case(state)
            IDLE: begin
                counter = 0;
                if(valid)
                    if(mode==0)
                        state_nxt = MUL;
                    else if(mode==1)
                        state_nxt = DIV;
                    else if(mode==2)
                        state_nxt = AND;
                    else if(mode==3)
                        state_nxt = OR;
                else
                    state_nxt = IDLE;

            end
            MUL : begin
                if( counter != 31)
                    begin
                        state_nxt = MUL;
                    end
                else
                    begin
                        state_nxt = OUT;
                    end
            end
            DIV : begin
                if( counter != 31)
                    begin
                        state_nxt = DIV;
                    end
                else
                    begin
                        state_nxt = OUT;
                    end
            end  
            AND : begin
                state_nxt = OUT;
            end
            OR  : begin
                state_nxt = OUT;
            end
            OUT : begin
                state_nxt = IDLE;
            end
            default : begin
                state_nxt = IDLE;
            end
        endcase
    end
    // Todo 2: Counter
    always @(*) begin
        case(state)
            MUL: begin
                counter_nxt = counter + 1;
            end
            DIV: begin
                counter_nxt = counter + 1;
            end
            default: counter_nxt = 0; 
    end


    // ALU input
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) alu_in_nxt = in_B;
                else       alu_in_nxt = 0;
            end
            OUT : alu_in_nxt = 0;
            default: alu_in_nxt = alu_in;
        endcase
    end

    // Todo 3: ALU output
    always @(*) begin
        case(state)
            MUL: begin
                alu_out = shreg[63:32]+ alu_in;
            end
            DIV : begin
                alu_out = shreg[63:32]- alu_in;
                
            end
            AND : begin
                alu_out = shreg[31:0] ^ alu_in;
                
            end
            OR : begin
                alu_out = shreg[31:0] | alu_in;
            end
            default: 
        endcase
    end
    // Todo 4: Shift register
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid) shreg_nxt[31:0] = in_A;
                else       shreg_nxt[31:0] = 0;
            end
            MUL: begin
                if(shreg[0]) begin 
                    shreg_nxt[63:32] = alg_out;
                    shreg_nxt[31:0] = shreg[31:0];
                end
                else begin
                    shreg_nxt = shreg;
                end
                shreg_nxt = shreg_nxt >> 1 ;
                
            end
            DIV : begin
                if(shreg[63:32] > alu_in) begin 
                    shreg_nxt[63:32] = alg_out;
                    shreg_nxt[31:0] = shreg[31:0];
                    shreg_nxt = shreg_nxt << 1;
                    shreg_nxt[0]=1; 
                end
                else begin
                    shreg_nxt = shreg;
                    shreg_nxt = shreg_nxt << 1;
                    shreg_nxt[0]=0; 
                end
                
            end
            default: 
        endcase
    end
    // Todo: Sequential always block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= state_nxt;
            alu_in <= alu_in_nxt;
            counter <= counter_nxt;
            shreg <= shreg_nxt;
        end
    end

endmodule