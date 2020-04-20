#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2017.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto dbb62db1838a4d24ad916fb87cd20dbe -m64 --debug typical --relax --mt 8 -L blk_mem_gen_v8_3_6 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot blockmemory_tb_behav xil_defaultlib.blockmemory_tb xil_defaultlib.glbl -log elaborate.log
