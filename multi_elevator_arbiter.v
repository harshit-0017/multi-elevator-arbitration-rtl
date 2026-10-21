module multi_elevator_arbiter (
    input clk, rst,request,
    input  [5:0] request_floor,

    output reg [5:0] current_floor0,
    output reg  [5:0] current_floor1,
    output reg  [5:0] current_floor2,
    output reg  [5:0] current_floor3,

    output reg available0,
    output reg available1,
    output reg available2,
    output reg available3,

    output reg [1:0] selected_elevator,
    output reg       request_valid
);

    reg [5:0] dest0, dest1, dest2, dest3;
    reg [5:0] d0, d1, d2, d3;
    reg [5:0] min_distance;

    always @(*) begin
        d0=(current_floor0>=request_floor)? current_floor0-request_floor: 
                                            request_floor-current_floor0;
        d1=(current_floor1>=request_floor)? current_floor1-request_floor: 
                                            request_floor-current_floor1;
        d2=(current_floor2>=request_floor)? current_floor2-request_floor: 
                                            request_floor-current_floor2;
        d3=(current_floor3>=request_floor)? current_floor3-request_floor: 
                                            request_floor-current_floor3;

        selected_elevator = 2'd0;
        request_valid = 1'b0;
        min_distance = 6'd63;

        if(request) begin
        if (available0 && d0 < min_distance) begin
            min_distance = d0;
            selected_elevator = 2'd0;
            request_valid = 1'b1;
        end

        if (available1 && d1 < min_distance) begin
            min_distance = d1;
            selected_elevator = 2'd1;
            request_valid = 1'b1;
        end

        if (available2 && d2 < min_distance) begin
            min_distance = d2;
            selected_elevator = 2'd2;
            request_valid = 1'b1;
        end

        if (available3 && d3 < min_distance) begin
            min_distance = d3;
            selected_elevator = 2'd3;
            request_valid = 1'b1;
        end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_floor0 <= 6'd0;
            current_floor1 <= 6'd10;
            current_floor2 <= 6'd20;
            current_floor3 <= 6'd30;

            dest0 <= 6'd0;
            dest1 <= 6'd10;
            dest2 <= 6'd20;
            dest3 <= 6'd30;

            available0 <= 1'b1;
            available1 <= 1'b1;
            available2 <= 1'b1;
            available3 <= 1'b1;
        end
        else begin
            //for E0
            if (available0 && request && request_valid && selected_elevator == 2'd0) begin
                dest0 <= request_floor;
                if (current_floor0 != request_floor)
                    available0 <= 1'b0;
            end
            else if (!available0) begin
                if (current_floor0 < dest0) begin
                    current_floor0 <= current_floor0 + 1'b1;
                    if (current_floor0 + 1'b1 == dest0) available0 <= 1'b1;
                end
            else if (current_floor0 > dest0) begin
                current_floor0 <= current_floor0 - 1'b1;
                if (current_floor0 - 1'b1 == dest0) available0 <= 1'b1;
                end
            end

            //for E1
            if (available1 && request && request_valid && selected_elevator == 2'd1) begin
                dest1 <= request_floor;
                if (current_floor1 != request_floor) available1 <= 1'b0;
            end
            else if (!available1) begin
                if (current_floor1 < dest1) begin
                    current_floor1 <= current_floor1 + 1'b1;
                    if (current_floor1 + 1'b1 == dest1) available1 <= 1'b1;
                end
                else if (current_floor1 > dest1) begin
                    current_floor1 <= current_floor1 - 1'b1;
                    if (current_floor1 - 1'b1 == dest1) available1 <= 1'b1;
                end
            end

            //for E2
            if (available2 && request && request_valid && selected_elevator == 2'd2) begin
                dest2 <= request_floor;
                if (current_floor2 != request_floor) available2 <= 1'b0;
            end
            else if (!available2) begin
                if (current_floor2 < dest2) begin
                    current_floor2 <= current_floor2 + 1'b1;
                    if (current_floor2 + 1'b1 == dest2) available2 <= 1'b1;
                end
                else if (current_floor2 > dest2) begin
                    current_floor2 <= current_floor2 - 1'b1;
                    if (current_floor2 - 1'b1 == dest2) available2 <= 1'b1;
                end
            end

            //E3
            if (available3 && request && request_valid && selected_elevator == 2'd3) begin
                dest3 <= request_floor;
                if (current_floor3 != request_floor) available3 <= 1'b0;
            end
            else if (!available3) begin
                if (current_floor3 < dest3) begin
                    current_floor3 <= current_floor3 + 1'b1;
                    if (current_floor3 + 1'b1 == dest3) available3 <= 1'b1;
                end
                else if (current_floor3 > dest3) begin
                    current_floor3 <= current_floor3 - 1'b1;
                    if (current_floor3 - 1'b1 == dest3) available3 <= 1'b1;
                end
            end


        end
        
    end

endmodule