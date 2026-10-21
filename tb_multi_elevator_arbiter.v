`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 02:08:20 PM
// Design Name: 
// Module Name: tb_multi_elevator_arbiter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

module tb_multi_elevator_arbiter;

    reg clk;
    reg reset;
    reg request;
    reg [5:0] request_floor;

    wire [5:0] current_floor0;
    wire [5:0] current_floor1;
    wire [5:0] current_floor2;
    wire [5:0] current_floor3;

    wire available0;
    wire available1;
    wire available2;
    wire available3;

    wire [1:0] selected_elevator;
    wire request_valid;

    multi_elevator_arbiter dut (
        .clk(clk),
        .rst(reset),
        .request(request),
        .request_floor(request_floor),

        .current_floor0(current_floor0),
        .current_floor1(current_floor1),
        .current_floor2(current_floor2),
        .current_floor3(current_floor3),

        .available0(available0),
        .available1(available1),
        .available2(available2),
        .available3(available3),

        .selected_elevator(selected_elevator),
        .request_valid(request_valid)
    );

    always #5 clk = ~clk;

    task send_request(input [5:0] floor);
        begin
            @(posedge clk);
            #1;
            request_floor = floor;
            request = 1'b1;

            @(posedge clk);

            $display("Time=%0t | Request=%0d | Selected=E%0d | Valid=%b",
                     $time, floor, selected_elevator, request_valid);

            @(posedge clk);
            #1;
            request = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_multi_elevator_arbiter);

        clk = 0;
        reset = 1;
        request = 0;
        request_floor = 0;

        #12;
        reset = 0;

        $display("RESET RELEASED");
        $display("E0=%0d E1=%0d E2=%0d E3=%0d",current_floor0,current_floor1,current_floor2,current_floor3);

        send_request(6'd24);

        wait(available2 == 1'b0);
        $display("E2 BUSY");

        wait(available2 == 1'b1);
        $display("E2 REACHED FLOOR %0d", current_floor2);

        send_request(6'd5);

        wait(available0 == 1'b0);
        $display("E0 BUSY");

        wait(available0 == 1'b1);
        $display("E0 REACHED FLOOR %0d", current_floor0);

        send_request(6'd30);

        if (selected_elevator == 2'd3)
            $display("E3 SELECTED");
        else
            $display("ERROR: E3 NOT SELECTED");

        #20;

        $display("SIMULATION COMPLETE");

        $finish;
    end

endmodule
