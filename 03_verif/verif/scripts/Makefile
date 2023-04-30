all: clean analysis_rtl analysis_ben runsim

analysis_rtl:
	vlogan -full64 -work lab_rtl +v2k -f $(WORKAREA)/03_verif/verif/scripts/rtl.f \
		-l $(WORKAREA)/03_verif/sim_result/rtl_vlog.log +define+VCS


analysis_ben:
	vlogan -full64 -work lab_ben +v2k -timescale=1ns/1ps -f $(WORKAREA)/03_verif/verif/scripts/ben.f \
		-l $(WORKAREA)/03_verif/sim_result/ben_vlog.log \
		+define+VCS \
		+define+LOG_DIR=$(WORKAREA)/03_verif/sim_result/


runsim:
	vcs +vcs+dumpvars -full64 +v2k -R -debug_access+r+w +no_notifier +notimingcheck +nospecify \
		-f $(WORKAREA)/03_verif/verif/scripts/rtl.f \
		$(WORKAREA)/03_verif/verif/sv/testtop.v \
		-l $(WORKAREA)/03_verif/sim_result/sim.log


clean:
	rm -rf work

