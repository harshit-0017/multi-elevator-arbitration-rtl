# Multi-Elevator Arbitration and Control

## Overview

This project implements a four-elevator controller in Verilog RTL for a 40-floor building. The controller selects the nearest available elevator for each passenger request and manages its movement toward the requested floor.

## Features

- Nearest-elevator arbitration using absolute floor distance
- Priority-based tie-breaking using the lowest elevator ID
- Clocked elevator movement, one floor per rising clock edge
- Dynamic availability management
- Destination-floor tracking
- Reset initialization and request-valid indication
- Testbench-based functional verification

## Initial Configuration

| Elevator | Initial Floor |
|---|---:|
| Elevator 0 | 0 |
| Elevator 1 | 10 |
| Elevator 2 | 20 |
| Elevator 3 | 30 |

All elevators are initially available after reset.

## Arbitration Logic

For each available elevator:

`distance = abs(current_floor - request_floor)`

The controller selects the elevator with the minimum distance. If multiple elevators have the same minimum distance, the elevator with the lowest ID wins.

## Elevator Movement

When an elevator is assigned a request, it stores the destination floor and becomes unavailable if movement is required. Its current floor changes by one floor on each rising clock edge until the destination is reached. It then becomes available again.

## Interface

### Inputs
- `clk`
- `reset`
- `request`
- `request_floor[5:0]`

### Outputs
- `current_floor0` to `current_floor3`
- `available0` to `available3`
- `selected_elevator[1:0]`
- `request_valid`

## Verification

The testbench exercises requests for different floors, including nearest-elevator selection, tie-breaking, elevator movement, and a request at an elevator's current floor. Simulation can be performed using Icarus Verilog and GTKWave or through the Vivado simulation flow.

## Tools

- Verilog HDL
- AMD Xilinx Vivado
- Icarus Verilog
- GTKWave

## Learning Outcomes

This project demonstrates combinational arbitration, sequential RTL design, counters/state updates, resource availability control, and simulation-based verification.
