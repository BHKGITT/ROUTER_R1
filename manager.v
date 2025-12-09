`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2025 17:10:18
// Design Name: 
// Module Name: manager
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


module manager#
   (    parameter DATA_WIDTH = 32,
        parameter ADDR_WIDTH = 32,
        parameter HBURST_WIDTH = 3,
        parameter HPROT_WIDTH = 4
   )
   (
        // Global Signals 
        input           Hclk,
        input           HResetn,
        // Address and Control signals 
        output[ADDR_WIDTH -1:0] Haddr,
        output                  Hwrite,
        output[2:0]             Hsize,  // Defines Size of WR/RD Transfer(8,16,32,64,128,256,512,1024bits)
        output[HBURST_WIDTH-1:0]Hburst, // Defines no_of Transfers in Burst, how address changes
        output[HPROT_WIDTH -1:0]Hprot,  // In this not using any protection levels - tie to Zero
        output[1:0]             Htrans, // Defines Transfer type IDLE,BUSY,SEQ,NON-SEQ
        output                  Hmasterlock, // Used in Multi Master case, to access bus
        //Data Signals
        output[DATA_WIDTH-1:0]  Hwdata,
        input [DATA_WIDTH-1:0]  Hrdata,
        // Response Signals
        input                   Hready,  // if High: Previous Transfor Done, 0: Slave Inserting Wait States
        input                   Hresp    // OKAY - Transfer done , ERROR - Transfer done with Error        
    );
    
endmodule
