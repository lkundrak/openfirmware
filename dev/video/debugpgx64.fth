hex

0 value lcd-index
0 value clk-index

: .off
   3 and
   dup 0<> if
      ." +" .
   else
      drop
   then
;

: .clk-name
   dup fc and 2 rshift
   dup
   case
      d#  0 of  ." MPLL_CNTL"              endof
      d#  1 of  ." VPLL_CNTL"              endof
      d#  2 of  ." PLL_REF_DIV"            endof
      d#  3 of  ." PLL_GEN_CNTL"           endof
      d#  4 of  ." MCLK_FB_DIV"            endof
      d#  5 of  ." PLL_VCLK_CNTL"          endof
      d#  6 of  ." VCLK_POST_DIV"          endof
      d#  7 of  ." VCLK0_FB_DIV"           endof
      d#  8 of  ." VCLK1_FB_DIV"           endof
      d#  9 of  ." VCLK2_FB_DIV"           endof
      d# 10 of  ." VCLK3_FB_DIV"           endof
      d# 11 of  ." PLL_EXT_CNTL"           endof
      d# 12 of  ." DLL1_CNTL"              endof
      d# 13 of  ." VFC_CNTL"               endof
      d# 14 of  ." PLL_TEST_CNTL"          endof
      d# 15 of  ." PLL_TEST_COUNT"         endof
      d# 16 of  ." LVDS_CNTL0"             endof
      d# 17 of  ." LVDS_CNTL1"             endof
      d# 18 of  ." AGP1_CNTL"              endof
      d# 19 of  ." AGP2_CNTL"              endof
      d# 20 of  ." DLL2_CNTL"              endof
      d# 21 of  ." SCLK_FB_DIV"            endof
      d# 22 of  ." SPLL_CNTL1"             endof
      d# 23 of  ." SPLL_CNTL2"             endof
      d# 24 of  ." APLL_STRAPS"            endof
      d# 25 of  ." EXT_VPLL_CNTL"          endof
      d# 26 of  ." EXT_VPLL_REF_DIV"       endof
      d# 27 of  ." EXT_VPLL_FB_DIV"        endof
      d# 28 of  ." EXT_VPLL_MSB"           endof
      d# 29 of  ." HTOTAL_CNTL"            endof
      d# 30 of  ." BYTE_CLK_CNTL"          endof
      d# 31 of  ." TV_PLL_CNTL1"           endof
      d# 32 of  ." TV_PLL_CNTL2"           endof
      d# 33 of  ." TV_PLL_CNTL"            endof
      d# 34 of  ." EXT_TV_PLL"             endof
      d# 35 of  ." HW_DEBUG_EXT"           endof
      d# 36 of  ." PLL_V2CLK_CNTL"         endof
      d# 37 of  ." EXT_V2PLL_REF_DIV"      endof
      d# 38 of  ." EXT_V2PLL_FB_DIV"       endof
      d# 39 of  ." EXT_V2PLL_MSB"          endof
      d# 40 of  ." HTOTAL2_CNTL"           endof
      d# 41 of  ." PLL_YCLK_CNTL"          endof
      d# 42 of  ." PM_DYN_CLK_CNTL"        endof
      ( default )  ." {clk:" dup (.) type ." }"
   endcase
   drop
   .off
;

: .lcd-name
   dup fc and 2 rshift
   dup
   case
      h# 00 of  ." CONFIG_PANEL"           endof
      h# 01 of  ." LCD_GEN_CTRL"           endof
      h# 02 of  ." DSTN_CONTROL"           endof
      h# 03 of  ." HFB_PITCH_ADDR"         endof
      h# 04 of  ." HORZ_STRETCHING"        endof
      h# 05 of  ." VERT_STRETCHING"        endof
      h# 06 of  ." EXT_VERT_STRETCH"       endof
      h# 07 of  ." LT_GIO"                 endof
      h# 08 of  ." POWER_MANAGEMENT"       endof
      h# 09 of  ." ZVGPIO"                 endof
      h# 0a of  ." ICON_CLR0"              endof
      h# 0b of  ." ICON_CLR1"              endof
      h# 0c of  ." ICON_OFFSET"            endof
      h# 0d of  ." ICON_HORZ_VERT_POSN"    endof
      h# 0e of  ." ICON_HORZ_VERT_OFF"     endof
      h# 0f of  ." ICON2_CLR0"             endof
      h# 10 of  ." ICON2_CLR1"             endof
      h# 11 of  ." ICON2_OFFSET"           endof
      h# 12 of  ." ICON2_HORZ_VERT_POSN"   endof
      h# 13 of  ." ICON2_HORZ_VERT_OFF"    endof
      h# 14 of  ." LCD_MISC_CNTL"          endof
      h# 1c of  ." APC_CNTL"               endof
      h# 1d of  ." POWER_MANAGEMENT_2"     endof
      h# 25 of  ." ALPHA_BLENDING"         endof
      h# 27 of  ." APC_CTRL_IO"            endof
      h# 28 of  ." TEST_IO"                endof
      h# 29 of  ." TEST_OUTPUTS"           endof
      h# 2a of  ." DP1_MEM_ACCESS"         endof
      h# 2b of  ." DP0_MEM_ACCESS"         endof
      h# 2c of  ." DP0_DEBUG_A"            endof
      h# 2d of  ." DP0_DEBUG_B"            endof
      h# 2e of  ." DP1_DEBUG_A"            endof
      h# 2f of  ." DP1_DEBUG_B"            endof
      h# 30 of  ." DPCTRL_DEBUG_A"         endof
      h# 31 of  ." DPCTRL_DEBUG_B"         endof
      h# 32 of  ." MEMBLK_DEBUG"           endof
      h# 33 of  ." SCRATCH_PAD_4"          endof
      h# 34 of  ." SCRATCH_PAD_5"          endof
      h# 35 of  ." SCRATCH_PAD_6"          endof
      h# 36 of  ." SCRATCH_PAD_7"          endof
      h# 37 of  ." SCRATCH_PAD_8"          endof
      h# 38 of  ." APC_LUT_KL"             endof
      h# 39 of  ." APC_LUT_MN"             endof
      h# 3a of  ." APC_LUT_OP"             endof
      ( default )  ." {lcd:" dup (.) type ." }"
   endcase
   drop
   .off
;


: .reg0-name
   dup 3fc and 2 rshift
   dup
   case
      h# 00 of  ." CRTC_H_TOTAL_DISP"      endof
      h# 01 of  ." CRTC_H_SYNC_STRT_WID"   endof
      h# 02 of  ." CRTC_V_TOTAL_DISP"      endof
      h# 03 of  ." CRTC_V_SYNC_STRT_WID"   endof
      h# 04 of  ." CRTC_VLINE_CRNT_VLINE"  endof
      h# 05 of  ." CRTC_OFF_PITCH"         endof
      h# 06 of  ." CRTC_INT_CNTL"          endof
      h# 07 of  ." CRTC_GEN_CNTL"          endof
      h# 08 of  ." DSP_CONFIG"             endof
      h# 09 of  ." DSP_ON_OFF"             endof
      h# 0a of  ." TIMER_CONFIG"           endof
      h# 0b of  ." MEM_BUF_CNTL"           endof
      h# 0d of  ." MEM_ADDR_CONFIG"        endof
      h# 0e of  ." CRT_TRAP"               endof
      h# 10 of  ." OVR_CLR"                endof
      h# 11 of  ." OVR_WID_LEFT_RIGHT"     endof
      h# 12 of  ." OVR_WID_TOP_BOTTOM"     endof
      h# 13 of  ." PM_VGA_DSP_CONFIG"      endof
      h# 14 of  ." PM_VGA_DSP_ON_OFF"      endof
      h# 15 of  ." DSP2_CONFIG"            endof
      h# 16 of  ." DSP2_ON_OFF"            endof
      h# 17 of  ." CRTC2_OFF_PITCH"        endof
      h# 18 of  ." CUR_CLR0"               endof
      h# 19 of  ." CUR_CLR1"               endof
      h# 1a of  ." CUR_OFFSET"             endof
      h# 1b of  ." CUR_HORZ_VERT_POSN"     endof
      h# 1c of  ." CUR_HORZ_VERT_OFF"      endof
      h# 1e of  ." GP_IO"                  endof
      h# 1f of  ." HW_DEBUG"               endof
      h# 20 of  ." SCRATCH_REG0"           endof
      h# 21 of  ." SCRATCH_REG1"           endof
      h# 22 of  ." SCRATCH_REG2"           endof
      h# 23 of  ." SCRATCH_REG3"           endof
      h# 24 of  ." CLOCK_CNTL"             endof
      h# 25 of  ." CONFIG_STAT1"           endof
      h# 26 of  ." CONFIG_STAT2"           endof
      h# 28 of  ." BUS_CNTL"               endof
      h# 29 of  ." LCD_INDEX"              endof
      h# 2a of  ." LCD_DATA"               endof
      h# 2b of  ." EXT_MEM_CNTL"           endof
      h# 2c of  ." MEM_CNTL"               endof
      h# 2d of  ." MEM_VGA_WP_SEL"         endof
      h# 2e of  ." MEM_VGA_RP_SEL"         endof
      h# 30 of  ." DAC_REGS"               endof
      h# 31 of  ." DAC_CNTL"               endof
      h# 34 of  ." GEN_TEST_CNTL"          endof
      h# 35 of  ." CUSTOM_MACRO_CNTL"      endof
      h# 37 of  ." CONFIG_CNTL"            endof
      h# 38 of  ." CONFIG_CHIP_ID"         endof
      h# 39 of  ." CONFIG_STAT0"           endof
      h# 3a of  ." CRC_SIG"                endof
      h# 40 of  ." DST_OFF_PITCH"          endof
      h# 41 of  ." DST_X"                  endof
      h# 42 of  ." DST_Y"                  endof
      h# 43 of  ." DST_Y_X"                endof
      h# 44 of  ." DST_WIDTH"              endof
      h# 45 of  ." DST_HEIGHT"             endof
      h# 46 of  ." DST_HEIGHT_WIDTH"       endof
      h# 47 of  ." DST_X_WIDTH"            endof
      h# 48 of  ." DST_BRES_LNTH"          endof
      h# 49 of  ." DST_BRES_ERR"           endof
      h# 4a of  ." DST_BRES_INC"           endof
      h# 4b of  ." DST_BRES_DEC"           endof
      h# 4c of  ." DST_CNTL"               endof
      h# 4d of  ." DST_Y_X_ALIAS"          endof
      h# 4e of  ." TRAIL_BRES_ERR"         endof
      h# 4f of  ." TRAIL_BRES_INC"         endof
      h# 50 of  ." TRAIL_BRES_DEC"         endof
      h# 51 of  ." LEAD_BRES_LNTH"         endof
      h# 52 of  ." Z_OFF_PITCH"            endof
      h# 53 of  ." Z_CNTL"                 endof
      h# 54 of  ." ALPHA_TST_CNTL"         endof
      h# 60 of  ." SRC_OFF_PITCH"          endof
      h# 61 of  ." SRC_X"                  endof
      h# 62 of  ." SRC_Y"                  endof
      h# 63 of  ." SRC_Y_X"                endof
      h# 64 of  ." SRC_WIDTH1"             endof
      h# 65 of  ." SRC_HEIGHT1"            endof
      h# 66 of  ." SRC_HEIGHT1_WIDTH1"     endof
      h# 67 of  ." SRC_X_START"            endof
      h# 68 of  ." SRC_Y_START"            endof
      h# 69 of  ." SRC_Y_X_START"          endof
      h# 6a of  ." SRC_WIDTH2"             endof
      h# 6b of  ." SRC_HEIGHT2"            endof
      h# 6c of  ." SRC_HEIGHT2_WIDTH2"     endof
      h# 6d of  ." SRC_CNTL"               endof
      h# 80 of  ." HOST_DATA_0"            endof
      h# 81 of  ." HOST_DATA_1"            endof
      h# 82 of  ." HOST_DATA_2"            endof
      h# 83 of  ." HOST_DATA_3"            endof
      h# 84 of  ." HOST_DATA_4"            endof
      h# 85 of  ." HOST_DATA_5"            endof
      h# 86 of  ." HOST_DATA_6"            endof
      h# 87 of  ." HOST_DATA_7"            endof
      h# 88 of  ." HOST_DATA_8"            endof
      h# 89 of  ." HOST_DATA_9"            endof
      h# 8a of  ." HOST_DATA_10"           endof
      h# 8b of  ." HOST_DATA_11"           endof
      h# 8c of  ." HOST_DATA_12"           endof
      h# 8d of  ." HOST_DATA_13"           endof
      h# 8e of  ." HOST_DATA_14"           endof
      h# 8f of  ." HOST_DATA_15"           endof
      h# 90 of  ." HOST_CNTL"              endof
      h# 91 of  ." BM_HOSTDATA"            endof
      h# 92 of  ." BM_ADDR|BM_DATA"        endof
      h# 93 of  ." BM_GUI_TABLE_CMD"       endof
      h# a0 of  ." PAT_REG0"               endof
      h# a1 of  ." PAT_REG1"               endof
      h# a2 of  ." PAT_CNTL"               endof
      h# a8 of  ." SC_LEFT"                endof
      h# a9 of  ." SC_RIGHT"               endof
      h# aa of  ." SC_LEFT_RIGHT"          endof
      h# ab of  ." SC_TOP"                 endof
      h# ac of  ." SC_BOTTOM"              endof
      h# ad of  ." SC_TOP_BOTTOM"          endof
      h# ae of  ." USR1_DST_0FF_PITCH"     endof
      h# af of  ." USR2_DST_0FF_PITCH"     endof
      h# b0 of  ." DP_BKGD_CLR"            endof
      h# b1 of  ." DP_FOG_CLR"             endof
      h# b2 of  ." DP_WRITE_MSK"           endof
      h# b4 of  ." DP_PIX_WIDTH"           endof
      h# b5 of  ." DP_MIX"                 endof
      h# b6 of  ." DP_SRC"                 endof
      h# b7 of  ." DP_FRGD_CLR_MIX"        endof
      h# b8 of  ." DP_FRGD_BKGD_CLR"       endof
      h# ba of  ." DST_X_Y"                endof
      h# bb of  ." DST_WIDTH_HEIGHT"       endof
      h# bc of  ." USR_DST_PITCH"          endof
      h# be of  ." DP_SET_GUI_ENGINE2"     endof
      h# bf of  ." DP_SET_GUI_ENGINE"      endof
      h# c0 of  ." CLR_CMP_CLR"            endof
      h# c1 of  ." CLR_CMP_MSK"            endof
      h# c2 of  ." CLR_CMP_CNTL"           endof
      h# c3 of  ." FIFO_STAT"              endof
      h# cc of  ." GUI_TRAJ_CNTL"          endof
      h# ce of  ." GUI_STAT"               endof
      h# e6 of  ." COMPOSITE_SHADOW_ID"    endof
      ( default )  ." {blk0:" dup (.) type ." }"
   endcase
   drop
   .off
;

: .reg1-name
   dup 3fc and 2 rshift
   dup
   case
      h# 1c of  ." SNAPSHOT_VH_COUNTS"     endof
      h# 1d of  ." SNAPSHOT_F_COUNT"       endof
      h# 1e of  ." N_VIF_COUNT"            endof
      h# 1f of  ." SNAPSHOT_VIF_COUNT"     endof
      h# 2c of  ." SNAPSHOT2_VH_COUNTS"    endof
      h# 2d of  ." SNAPSHOT2_F_COUNT"      endof
      h# 2e of  ." N_VIF2_COUNT"           endof
      h# 2f of  ." SNAPSHOT2_VIF_COUNT"    endof
      h# 51 of  ." CRT_HORZ_VERT_LOAD"     endof
      h# 52 of  ." AGP_BASE"               endof
      h# 53 of  ." AGP_CNTL"               endof
      h# 5c of  ." GUI_CMDFIFO_DEBUG"      endof
      h# 5d of  ." GUI_CMDFIFO_DATA"       endof
      h# 5e of  ." GUI_CNTL"               endof
      h# 60 of  ." BM_FRAME_BUF_OFFSET"    endof
      h# 61 of  ." BM_SYSTEM_MEM_ADDR"     endof
      h# 62 of  ." BM_COMMAND"             endof
      h# 63 of  ." BM_STATUS"              endof
      h# 6e of  ." BM_GUI_TABLE"           endof
      h# 6f of  ." BM_SYSTEM_TABLE"        endof
      ( default )  ." {blk1:" dup (.) type ." }"
   endcase
   drop
   .off
;


: .xval
	>r
	3 and
	dup 4 r@ - swap -  2* spaces
	swap r> 2* u.r
	2* 1+ spaces
;

: .clk<b   ."  | " swap over 1 .xval  ." cb! "  .clk-name cr  ;
: .lcd<l
   dup 1c = if  2drop exit  then \ Silence LT_GIO (lot of output on bit-banging DCC I2C)
   ."  | " swap over 4 .xval  ." ll! "  .lcd-name cr
;

: .reg0<b
   dup h# 91 = if  drop  fc and   to clk-index  exit  then
   dup h# 92 = if  drop  clk-index .clk<b       exit  then
   dup h# a4 = if  drop  2 lshift to lcd-index  exit  then
   ."  | " swap over 1 .xval  ." 0b! "  .reg0-name cr
;

: .reg0<w  ."  | " swap over 2 .xval  ." 0w! "  .reg0-name cr  ;

: .reg0<l
   dup h# a8 = if  drop  lcd-index .lcd<l       exit  then
   ."  | " swap over 4 .xval  ." 0l! "  .reg0-name cr
;

: .reg1<b  ."  | " swap over 1 .xval  ." 1b! "  .reg1-name cr  ;
: .reg1<w  ."  | " swap over 2 .xval  ." 1w! "  .reg1-name cr  ;
: .reg1<l  ."  | " swap over 4 .xval  ." 1l! "  .reg1-name cr  ;



: .clk>b   ."  | " swap over 1 .xval  ." cb@ "  .clk-name cr  ;
: .lcd>l   
   dup 1c = if  2drop exit  then \ Silence LT_GIO (lot of output on bit-banging DCC I2C)
   ."  | " swap over 4 .xval  ." ll@ "  .lcd-name cr  
;

: .reg0>b
   dup h# 92 = if  drop  clk-index .clk>b       exit  then
   dup h# a4 = if  drop  2 lshift to lcd-index  exit  then
   ."  | " swap over 1 .xval  ." 0b@ "  .reg0-name cr
;

: .reg0>w  ."  | " swap over 2 .xval  ." 0w@ "  .reg0-name cr  ;

: .reg0>l
   dup h# a8 = if  drop  lcd-index .lcd>l       exit  then
   ."  | " swap over 4 .xval  ." 0l@ "  .reg0-name cr
;

: .reg1>b  ."  | " swap over 1 .xval  ." 1b@ "  .reg1-name cr  ;
: .reg1>w  ."  | " swap over 2 .xval  ." 1w@ "  .reg1-name cr  ;
: .reg1>l  ."  | " swap over 4 .xval  ." 1l@ "  .reg1-name cr  ;

: addr
   " address" " get-property" eval
   if  ." Not mapped" abort  then
   decode-int -rot 2drop
;

: .blk0
   ." Block 0:" cr
   addr 7ffc00 +
   100 0 do
      i 2 u.r ." : "
      i 4 * over + rl@ 8 u.r
      space
      i 4 * .reg0-name cr
   loop
   drop
;

: .blk1
   ." Block 1:" cr
   addr 7ff800 +
   100 0 do
      i 2 u.r ." : "
      i 4 * over + rl@ 8 u.r
      space
      i 4 * .reg1-name cr
   loop
   drop
;

: .clk
   ." CLK:" cr
   addr 7ffc90 +
   40 0 do
      i 2 u.r ." : "
      i 2 lshift  over 1 +  rb!  \ Clock index (data R/O)
      dup 2 + rb@  2 u.r         \ Clock data
      space
      i 4 * .clk-name cr
   loop
   drop
;

: .lcd
   ." LCD:" cr
   addr 7ffca4 +
   40 0 do
      i 2 u.r ." : "
      i  over  rb!    \ LCD index
      dup 4 + rl@  8 u.r  \ LCD data
      space
      i 4 * .lcd-name cr
   loop
   drop
;

: .regs
   .blk0 cr
   .blk1 cr
   .clk cr
   .lcd
;
