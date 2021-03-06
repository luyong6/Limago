/************************************************
BSD 3-Clause License

Copyright (c) 2019, HPCN Group, UAM Spain (hpcn-uam.es)
All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

************************************************/

module axi4stream_constant #(
    parameter C_AXI_TDATA_WIDTH = 512  ,
    parameter C_AXI_TSTRB_WIDTH = 512/8,
    /**
    * 0: Send nothing
    * 2: Send the same value (C_PATTERN_SEED) forever
    * 1: Send a counter (which is incremented with every transaction)
    */
    parameter C_PATTERN         = 0    ,
    parameter C_PATTERN_SEED    = 0
) (
    input  wire                         CLK          , // Clock
    input  wire                         RST_N        , // Rst (active low level)
    output reg  [C_AXI_TDATA_WIDTH-1:0] M_AXIS_TDATA ,
    output reg                          M_AXIS_TLAST ,
    output reg  [C_AXI_TSTRB_WIDTH-1:0] M_AXIS_TSTRB ,
    output reg                          M_AXIS_TVALID,
    input  wire                         M_AXIS_TREADY
);
    always @(posedge CLK or negedge RST_N) begin
        if(~RST_N) begin
            M_AXIS_TDATA  <= 'h0;
            M_AXIS_TLAST  <= 'h0;
            M_AXIS_TSTRB  <= 'h0;
            M_AXIS_TVALID <= 'h0;
        end else begin
            if(M_AXIS_TREADY) begin
                M_AXIS_TDATA  <= C_PATTERN == 1 ? C_PATTERN_SEED : M_AXIS_TDATA;
                M_AXIS_TLAST  <= 'h1;
                M_AXIS_TSTRB  <= {C_AXI_TSTRB_WIDTH{1'b1}};
                M_AXIS_TVALID <= C_PATTERN>0;
            end
        end
    end

endmodule