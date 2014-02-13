OPNET_SYS=/usr/opnet/17.1.A/sys
OPNET_INC=$(OPNET_SYS)/include
OPNET_LIB=$(OPNET_SYS)/pc_intel_linux64/lib/

all:sim

run:sim
	LD_LIBRARY_PATH=$(OPNET_LIB) ertms_test.project/ertms_test-scenario1.dev64.i1.sim -ef ertms_test-scenario1-DES-1 -noprompt

mod:
	modeler&

edit:
	gedit ertms_cosim_ctrl.c&

anim:
	op_vuanim&

clean:
	rm ertms_cosim_ctrl.o ertms_test.project/ertms_test-scenario1.dev64.i1.sim

sim:ertms_test.project/ertms_test-scenario1.dev64.i1.sim

ertms_test.project/ertms_test-scenario1.dev64.i1.sim:ertms_test.project/ertms_test-scenario1.nt.m ertms_desc.sd ertms_mobility_manager.nd.m ertms_esd.esd.m ertms_cosim_ctrl.o ertms_mobility.pr.m 
	op_mksim -net_name ertms_test-scenario1 

ertms_cosim_ctrl.o:ertms_cosim_ctrl.c
	gcc -m64 -c $^ -I$(OPNET_INC) -DHOST_PC_INTEL_LINUX


