SHELL		 = /bin/tcsh
RM               = rm -f
LOC              = $(PWD)
TAMC             = tamc
###TAMC             = /data43/ralf/tamc/tamc
TAF              = taf
###TAF              = ~fastopt/bin/taf
DEST             = .
SOURCE_CODE      = ../bin
ADJOINT_SCRIPT   = ../adjoint
BASE             = ..
PKG		= $(BASE)/pkg
#
ADTAMCFLAGS      = -reverse -admark ad -i4 -r4
ADTAFFLAGS       = -reverse -admark ad -i4 -r4 \
			-l taf_ad.log -flow taf_ad_flow.log -nonew_arg
FTLTAMCFLAGS     = -forward -ftlmark g_ -i4 -r4
FTLTAFFLAGS      = -forward -ftlmark g_ -i4 -r4 \
			-l taf_ftl.log -flow taf_ftl_flow.log -nonew_arg
SVDTAMCFLAGS     = -reverse -forward -pure -i4 -r4
SVDTAFFLAGS      = -reverse -forward -pure -i4 -r4 \
			-flow taf_flow.log -nonew_arg
#
# further useful options: -warn_step -flow taf_flow.log
# NB: the svd option recommended in the TAMC manual doesn't work.

DIFF_FLAGS       = -toplevel the_main_loop		\
		   -input  '    xx_theta_dummy		\
				xx_salt_dummy		\
                                xx_tr1_dummy		\
				xx_hflux_dummy		\
				xx_sflux_dummy		\
				xx_tauu_dummy		\
				xx_tauv_dummy		\
				xx_atemp_dummy		\
				xx_aqh_dummy		\
				xx_uwind_dummy		\
				xx_vwind_dummy		\
				xx_obcsn_dummy		\
				xx_obcss_dummy		\
				xx_obcsw_dummy		\
				xx_obcse_dummy		\
			 	xx_sst_dummy		\
			 	xx_sss_dummy		\
			 	xx_diffkr_dummy		\
			 	xx_kapgm_dummy		\
			 	xx_efluxy_dummy		\
			 	xx_efluxp_dummy'	\
                   -output 'fc'

ADTAMCFLAG         = $(ADTAMCFLAGS) $(DIFF_FLAGS)
ADTAFFLAG          = $(ADTAFFLAGS)  $(DIFF_FLAGS)

FTLTAMCFLAG         = $(FTLTAMCFLAGS) $(DIFF_FLAGS)
FTLTAFFLAG          = $(FTLTAFFLAGS)  $(DIFF_FLAGS)

SVDTAMCFLAG         = $(SVDTAMCFLAGS) $(DIFF_FLAGS)
SVDTAFFLAG          = $(SVDTAFFLAGS)  $(DIFF_FLAGS)

# Source files for the MITgcmUV
SRC_MODEL	= \
		$(PKG)/autodiff/read_write.flow	\
		$(PKG)/autodiff/read_write_fld.flow	\
		$(PKG)/autodiff/read_write_rec.flow	\
		$(PKG)/autodiff/cg2d.flow		\
		$(PKG)/autodiff/diags.flow		\
		$(PKG)/autodiff/debug.flow		\
		$(PKG)/autodiff/do_the_model_io.flow	\
		$(PKG)/autodiff/dummy_in_stepping.flow	\
		$(PKG)/autodiff/eesupp.flow		\
		$(PKG)/autodiff/active_file.flow	\
		$(PKG)/autodiff/write_state.flow	\
		$(PKG)/autodiff/ecco_check_exp.flow	\
		$(PKG)/autodiff/exch_ad.flow		\
		$(PKG)/autodiff/exch_z_ad.flow		\
		$(PKG)/autodiff/exch_uv_ad.flow		\
		$(PKG)/autodiff/global_sum_ad.flow	\
		$(PKG)/autodiff/global_max_ad.flow	\
		$(PKG)/autodiff/initialisation.flow	\
		$(PKG)/autodiff/mdsio.flow		\
		$(PKG)/autodiff/monitor.flow		\
		$(PKG)/autodiff/obcs.flow		\
		$(PKG)/autodiff/checkpoint.flow		\
		$(PKG)/autodiff/print_message.flow	\
		$(PKG)/autodiff/open_copy_data_file.flow\
		$(PKG)/autodiff/timeave.flow		\
		  		  				\
		$(SOURCE_CODE)/adams_bashforth2.f		\
		$(SOURCE_CODE)/calc_buoyancy.f			\
		$(SOURCE_CODE)/calc_common_factors.f		\
		$(SOURCE_CODE)/calc_diffusivity.f		\
		$(SOURCE_CODE)/calc_div_ghat.f			\
		$(SOURCE_CODE)/calc_grad_phi_surf.f		\
		$(SOURCE_CODE)/calc_gs.f			\
		$(SOURCE_CODE)/calc_gt.f			\
		$(SOURCE_CODE)/calc_gtr1.f			\
		$(SOURCE_CODE)/calc_ivdc.f			\
		$(SOURCE_CODE)/calc_phi_hyd.f			\
		$(SOURCE_CODE)/calc_viscosity.f			\
		$(SOURCE_CODE)/convect.f			\
		$(SOURCE_CODE)/convective_adjustment.f		\
		$(SOURCE_CODE)/convective_adjustment_ini.f	\
		$(SOURCE_CODE)/correction_step.f		\
		$(SOURCE_CODE)/cycle_tracer.f			\
		$(SOURCE_CODE)/different_multiple.f		\
		$(SOURCE_CODE)/do_fields_blocking_exchanges.f	\
		$(SOURCE_CODE)/dynamics.f			\
		$(SOURCE_CODE)/external_forcing.f		\
		$(SOURCE_CODE)/external_forcing_surf.f		\
		$(SOURCE_CODE)/find_alpha.f			\
		$(SOURCE_CODE)/find_rho.f			\
		$(SOURCE_CODE)/freeze.f				\
								\
		$(SOURCE_CODE)/calc_grad_phi_hyd.f              \
		$(SOURCE_CODE)/comm_stats.f                     \
		$(SOURCE_CODE)/convective_weights.f             \
		$(SOURCE_CODE)/convectively_mixtracer.f         \
		$(SOURCE_CODE)/diags_phi_hyd.f                  \
		$(SOURCE_CODE)/diags_phi_rlow.f                 \
		$(SOURCE_CODE)/do_stagger_fields_exchanges.f    \
		$(SOURCE_CODE)/external_fields_load.f           \
		$(SOURCE_CODE)/integr_continuity.f              \
								\
		$(SOURCE_CODE)/gad_advection.f			\
		$(SOURCE_CODE)/gad_biharm_x.f			\
		$(SOURCE_CODE)/gad_biharm_y.f			\
		$(SOURCE_CODE)/gad_c2_adv_r.f			\
		$(SOURCE_CODE)/gad_c2_adv_x.f			\
		$(SOURCE_CODE)/gad_c2_adv_y.f			\
		$(SOURCE_CODE)/gad_c4_adv_r.f			\
		$(SOURCE_CODE)/gad_c4_adv_x.f			\
		$(SOURCE_CODE)/gad_c4_adv_y.f			\
		$(SOURCE_CODE)/gad_calc_rhs.f			\
		$(SOURCE_CODE)/gad_del2.f			\
		$(SOURCE_CODE)/gad_diff_r.f			\
		$(SOURCE_CODE)/gad_diff_x.f			\
		$(SOURCE_CODE)/gad_diff_y.f			\
		$(SOURCE_CODE)/gad_dst3_adv_x.f                 \
		$(SOURCE_CODE)/gad_dst3_adv_y.f                 \
		$(SOURCE_CODE)/gad_dst3_adv_r.f			\
		$(SOURCE_CODE)/gad_dst3fl_adv_x.f               \
		$(SOURCE_CODE)/gad_dst3fl_adv_y.f               \
		$(SOURCE_CODE)/gad_dst3fl_adv_r.f		\
		$(SOURCE_CODE)/gad_fluxlimit_adv_r.f		\
		$(SOURCE_CODE)/gad_fluxlimit_adv_x.f		\
		$(SOURCE_CODE)/gad_fluxlimit_adv_y.f		\
		$(SOURCE_CODE)/gad_grad_x.f			\
		$(SOURCE_CODE)/gad_grad_y.f			\
		$(SOURCE_CODE)/gad_u3_adv_r.f			\
		$(SOURCE_CODE)/gad_u3_adv_x.f			\
		$(SOURCE_CODE)/gad_u3_adv_y.f			\
								\
		$(SOURCE_CODE)/grad_sigma.f			\
		$(SOURCE_CODE)/impldiff.f			\
		$(SOURCE_CODE)/ini_autodiff.f			\
		$(SOURCE_CODE)/ini_cartesian_grid.f		\
		$(SOURCE_CODE)/ini_cg2d.f			\
		$(SOURCE_CODE)/ini_communication_patterns.f     \
		$(SOURCE_CODE)/ini_cori.f			\
		$(SOURCE_CODE)/ini_curvilinear_grid.f		\
		$(SOURCE_CODE)/ini_depths.f			\
		$(SOURCE_CODE)/ini_fields.f			\
		$(SOURCE_CODE)/ini_forcing.f			\
		$(SOURCE_CODE)/ini_grid.f			\
		$(SOURCE_CODE)/ini_linear_phisurf.f		\
		$(SOURCE_CODE)/ini_masks_etc.f			\
		$(SOURCE_CODE)/ini_mixing.f			\
		$(SOURCE_CODE)/ini_p_ground.f			\
		$(SOURCE_CODE)/ini_pnh.f			\
		$(SOURCE_CODE)/ini_pressure.f                   \
		$(SOURCE_CODE)/ini_psurf.f			\
		$(SOURCE_CODE)/ini_salt.f			\
		$(SOURCE_CODE)/ini_spherical_polar_grid.f	\
		$(SOURCE_CODE)/ini_theta.f			\
		$(SOURCE_CODE)/ini_tr1.f			\
		$(SOURCE_CODE)/ini_dynvars.f			\
		$(SOURCE_CODE)/ini_vel.f			\
		$(SOURCE_CODE)/ini_vertical_grid.f		\
		$(SOURCE_CODE)/initialise_varia.f		\
		$(SOURCE_CODE)/integrate_for_w.f		\
		$(SOURCE_CODE)/modeldata_example.f		\
								\
		$(SOURCE_CODE)/mom_fluxform.f			\
		$(SOURCE_CODE)/mom_hdissip.f			\
		$(SOURCE_CODE)/mom_vecinv.f			\
		$(SOURCE_CODE)/mom_calc_hfacz.f			\
		$(SOURCE_CODE)/mom_calc_ke.f			\
		$(SOURCE_CODE)/mom_calc_rtrans.f		\
		$(SOURCE_CODE)/mom_calc_strain.f		\
		$(SOURCE_CODE)/mom_calc_tension.f		\
		$(SOURCE_CODE)/mom_cdscheme.f			\
		$(SOURCE_CODE)/mom_u_adv_uu.f			\
		$(SOURCE_CODE)/mom_u_adv_vu.f			\
		$(SOURCE_CODE)/mom_u_adv_wu.f			\
		$(SOURCE_CODE)/mom_u_bottomdrag.f		\
		$(SOURCE_CODE)/mom_u_coriolis.f			\
		$(SOURCE_CODE)/mom_u_coriolis_nh.f		\
		$(SOURCE_CODE)/mom_u_del2u.f			\
		$(SOURCE_CODE)/mom_u_metric_nh.f		\
		$(SOURCE_CODE)/mom_u_metric_sphere.f		\
		$(SOURCE_CODE)/mom_u_rviscflux.f		\
		$(SOURCE_CODE)/mom_u_sidedrag.f			\
		$(SOURCE_CODE)/mom_u_xviscflux.f		\
		$(SOURCE_CODE)/mom_u_yviscflux.f		\
		$(SOURCE_CODE)/mom_v_adv_uv.f			\
		$(SOURCE_CODE)/mom_v_adv_vv.f			\
		$(SOURCE_CODE)/mom_v_adv_wv.f			\
		$(SOURCE_CODE)/mom_v_bottomdrag.f		\
		$(SOURCE_CODE)/mom_v_coriolis.f			\
		$(SOURCE_CODE)/mom_v_del2v.f			\
		$(SOURCE_CODE)/mom_v_metric_nh.f		\
		$(SOURCE_CODE)/mom_v_metric_sphere.f		\
		$(SOURCE_CODE)/mom_v_rviscflux.f		\
		$(SOURCE_CODE)/mom_v_sidedrag.f			\
		$(SOURCE_CODE)/mom_v_xviscflux.f		\
		$(SOURCE_CODE)/mom_v_yviscflux.f		\
		$(SOURCE_CODE)/mom_vi_calc_absvort3.f		\
		$(SOURCE_CODE)/mom_vi_calc_hdiv.f		\
		$(SOURCE_CODE)/mom_vi_calc_ke.f			\
		$(SOURCE_CODE)/mom_vi_calc_relvort3.f		\
		$(SOURCE_CODE)/mom_vi_coriolis.f		\
		$(SOURCE_CODE)/mom_vi_del2uv.f			\
		$(SOURCE_CODE)/mom_vi_hdissip.f			\
		$(SOURCE_CODE)/mom_vi_u_coriolis.f		\
		$(SOURCE_CODE)/mom_vi_u_grad_ke.f		\
		$(SOURCE_CODE)/mom_vi_u_vertshear.f		\
		$(SOURCE_CODE)/mom_vi_v_coriolis.f		\
		$(SOURCE_CODE)/mom_vi_v_grad_ke.f		\
		$(SOURCE_CODE)/mom_vi_v_vertshear.f		\
		  						\
		$(SOURCE_CODE)/packages_init_variables.f	\
		$(SOURCE_CODE)/plot_field.f			\
		$(SOURCE_CODE)/pressure_for_eos.f		\
		$(SOURCE_CODE)/quasihydrostaticterms.f		\
		$(SOURCE_CODE)/solve_for_pressure.f		\
		$(SOURCE_CODE)/state_summary.f			\
		$(SOURCE_CODE)/timestep.f			\
		$(SOURCE_CODE)/the_correction_step.f		\
		$(SOURCE_CODE)/thermodynamics.f			\
		$(SOURCE_CODE)/timestep_tracer.f		\
		$(SOURCE_CODE)/swfrac.f				\
		$(SOURCE_CODE)/update_etah.f			\
		  						\
		$(SOURCE_CODE)/kpp_calc.f			\
		$(SOURCE_CODE)/kpp_calc_diff.f			\
		$(SOURCE_CODE)/kpp_calc_visc.f			\
		$(SOURCE_CODE)/kpp_do_diags.f			\
		$(SOURCE_CODE)/kpp_init.f			\
		$(SOURCE_CODE)/kpp_open_diags.f			\
		$(SOURCE_CODE)/kpp_routines.f			\
		$(SOURCE_CODE)/kpp_transport_s.f		\
		$(SOURCE_CODE)/kpp_transport_t.f		\
		  						\
		$(SOURCE_CODE)/gmredi_calc_diff.f		\
		$(SOURCE_CODE)/gmredi_calc_psi_b.f		\
		$(SOURCE_CODE)/gmredi_calc_tensor.f		\
		$(SOURCE_CODE)/gmredi_calc_uvflow.f		\
		$(SOURCE_CODE)/gmredi_calc_wflow.f		\
		$(SOURCE_CODE)/gmredi_diags.f			\
		$(SOURCE_CODE)/gmredi_init.f			\
		$(SOURCE_CODE)/gmredi_rtransport.f		\
		$(SOURCE_CODE)/gmredi_slope_limit.f		\
		$(SOURCE_CODE)/gmredi_slope_psi.f		\
		$(SOURCE_CODE)/gmredi_xtransport.f		\
		$(SOURCE_CODE)/gmredi_ytransport.f		\
								\
		  						\
		$(SOURCE_CODE)/cost_aqh.f			\
		$(SOURCE_CODE)/cost_argo_salt.f			\
		$(SOURCE_CODE)/cost_argo_theta.f		\
		$(SOURCE_CODE)/cost_atemp.f			\
		$(SOURCE_CODE)/cost_atlantic.f			\
		$(SOURCE_CODE)/cost_averagesfields.f		\
		$(SOURCE_CODE)/cost_averagesfinal.f		\
		$(SOURCE_CODE)/cost_averagesflags.f		\
		$(SOURCE_CODE)/cost_averagesinit.f		\
		$(SOURCE_CODE)/cost_ctds.f			\
		$(SOURCE_CODE)/cost_ctdt.f			\
                $(SOURCE_CODE)/cost_drift.f			\
                $(SOURCE_CODE)/cost_drifter.f			\
                $(SOURCE_CODE)/cost_driftw.f			\
		$(SOURCE_CODE)/cost_final.f			\
		$(SOURCE_CODE)/cost_forcing.f			\
		$(SOURCE_CODE)/cost_geoid.f			\
		$(SOURCE_CODE)/cost_heatflux.f			\
		$(SOURCE_CODE)/cost_hyd.f			\
		$(SOURCE_CODE)/cost_initvaria.f			\
		$(SOURCE_CODE)/cost_init_barfiles.f		\
		$(SOURCE_CODE)/cost_merstress.f			\
		$(SOURCE_CODE)/cost_readers.f			\
		$(SOURCE_CODE)/cost_readsssfields.f		\
		$(SOURCE_CODE)/cost_readsstfields.f		\
		$(SOURCE_CODE)/cost_readscatxfields.f          	\
		$(SOURCE_CODE)/cost_readscatyfields.f		\
		$(SOURCE_CODE)/cost_readtopex.f			\
		$(SOURCE_CODE)/cost_readtopexmean.f		\
		$(SOURCE_CODE)/cost_salt.f			\
		$(SOURCE_CODE)/cost_salt0.f			\
		$(SOURCE_CODE)/cost_saltflux.f			\
		$(SOURCE_CODE)/cost_scat.f			\
		$(SOURCE_CODE)/cost_ssh.f			\
		$(SOURCE_CODE)/cost_ssh_mean.f			\
		$(SOURCE_CODE)/cost_sss.f			\
		$(SOURCE_CODE)/cost_sst.f			\
		$(SOURCE_CODE)/cost_theta.f			\
		$(SOURCE_CODE)/cost_theta0.f			\
		$(SOURCE_CODE)/cost_uwind.f			\
		$(SOURCE_CODE)/cost_vwind.f			\
		$(SOURCE_CODE)/cost_xbt.f			\
		$(SOURCE_CODE)/cost_zonstress.f			\
		$(SOURCE_CODE)/cost_obcs.f			\
		$(SOURCE_CODE)/cost_obcsn.f			\
		$(SOURCE_CODE)/cost_obcss.f			\
		$(SOURCE_CODE)/cost_obcsw.f			\
		$(SOURCE_CODE)/cost_obcse.f			\
		$(SOURCE_CODE)/cost_ice.f			\
                $(SOURCE_CODE)/sw_ptmp.f                        \
                $(SOURCE_CODE)/sw_adtg.f                        \
		$(SOURCE_CODE)/cost_kapgm.f			\
		$(SOURCE_CODE)/cost_readargot.f			\
		$(SOURCE_CODE)/cost_readargos.f			\
		$(SOURCE_CODE)/cost_ctdtclim.f			\
		$(SOURCE_CODE)/cost_ctdsclim.f			\
		$(SOURCE_CODE)/cost_readtmifields.f		\
		$(SOURCE_CODE)/cost_tmi.f			\
		  						\
		$(SOURCE_CODE)/ctrl_get_gen.f			\
		$(SOURCE_CODE)/ctrl_get_gen_rec.f		\
		$(SOURCE_CODE)/ctrl_getobcsn.f			\
		$(SOURCE_CODE)/ctrl_getobcss.f			\
		$(SOURCE_CODE)/ctrl_getobcsw.f			\
		$(SOURCE_CODE)/ctrl_getobcse.f			\
		$(SOURCE_CODE)/ctrl_getrec.f			\
		$(SOURCE_CODE)/ctrl_init_variables.f		\
		$(SOURCE_CODE)/ctrl_map_ini.f			\
		  						\
		$(SOURCE_CODE)/ecco_init.f			\
		$(SOURCE_CODE)/ecco_the_main_loop.f		\
		  						\
		$(SOURCE_CODE)/exf_init.f			\
		$(SOURCE_CODE)/exf_init_runoff.f		\
		$(SOURCE_CODE)/exf_readparms.f			\
		$(SOURCE_CODE)/exf_summary.f			\
		$(SOURCE_CODE)/exf_bulkformulae.f		\
		$(SOURCE_CODE)/exf_bulkcdn.f			\
		$(SOURCE_CODE)/exf_bulkqsat.f			\
		$(SOURCE_CODE)/exf_bulkrhn.f			\
		$(SOURCE_CODE)/exf_getffields.f			\
		$(SOURCE_CODE)/exf_getffieldrec.f		\
		$(SOURCE_CODE)/exf_getforcing.f			\
		$(SOURCE_CODE)/exf_mapfields.f			\
		$(SOURCE_CODE)/exf_getobcs.f			\
		$(SOURCE_CODE)/exf_getsurfacefluxes.f		\
		$(SOURCE_CODE)/exf_swapffields.f		\
		$(SOURCE_CODE)/exf_filter_rl.f			\
		$(SOURCE_CODE)/exf_filter_rs.f			\
		$(SOURCE_CODE)/exf_set_gen.f			\
		$(SOURCE_CODE)/exf_set_obcs.f			\
								\
		$(SOURCE_CODE)/exf_clim_init.f			\
		$(SOURCE_CODE)/exf_clim_readparms.f		\
		$(SOURCE_CODE)/exf_clim_summary.f		\
		$(SOURCE_CODE)/exf_getclim.f			\
		$(SOURCE_CODE)/exf_set_climsalt.f		\
		$(SOURCE_CODE)/exf_set_climtemp.f		\
		$(SOURCE_CODE)/exf_set_climsss.f		\
		$(SOURCE_CODE)/exf_set_climsst.f		\
								\
		$(SOURCE_CODE)/cal_addtime.f			\
		$(SOURCE_CODE)/cal_checkdate.f			\
		$(SOURCE_CODE)/cal_compdates.f			\
		$(SOURCE_CODE)/cal_convdate.f			\
		$(SOURCE_CODE)/cal_copydate.f			\
		$(SOURCE_CODE)/cal_daysformonth.f		\
		$(SOURCE_CODE)/cal_dayspermonth.f		\
		$(SOURCE_CODE)/cal_fulldate.f			\
		$(SOURCE_CODE)/cal_getdate.f			\
		$(SOURCE_CODE)/cal_getmonthsrec.f		\
		$(SOURCE_CODE)/cal_intdays.f			\
		$(SOURCE_CODE)/cal_intmonths.f			\
		$(SOURCE_CODE)/cal_intsteps.f			\
		$(SOURCE_CODE)/cal_intyears.f			\
		$(SOURCE_CODE)/cal_isleap.f			\
		$(SOURCE_CODE)/cal_monthsforyear.f		\
		$(SOURCE_CODE)/cal_monthsperyear.f		\
		$(SOURCE_CODE)/cal_nstepday.f			\
		$(SOURCE_CODE)/cal_numints.f			\
		$(SOURCE_CODE)/cal_printdate.f			\
		$(SOURCE_CODE)/cal_printerror.f			\
		$(SOURCE_CODE)/cal_stepsforday.f		\
		$(SOURCE_CODE)/cal_stepsperday.f		\
		$(SOURCE_CODE)/cal_subdates.f			\
		$(SOURCE_CODE)/cal_timeinterval.f		\
		$(SOURCE_CODE)/cal_timepassed.f			\
		$(SOURCE_CODE)/cal_timestamp.f			\
		$(SOURCE_CODE)/cal_toseconds.f			\
		$(SOURCE_CODE)/cal_weekday.f			\
								\
		$(SOURCE_CODE)/obcs_apply_sloc.f		\
		$(SOURCE_CODE)/obcs_apply_tloc.f		\
		$(SOURCE_CODE)/obcs_apply_ts.f			\
		$(SOURCE_CODE)/obcs_apply_uv.f			\
		$(SOURCE_CODE)/obcs_calc.f			\
		$(SOURCE_CODE)/obcs_init_variables.f		\
		$(SOURCE_CODE)/obcs_sponge.f			\
								\


#		$(SOURCE_CODE)/advect.f				\
#		$(SOURCE_CODE)/budget.f				\
#		$(SOURCE_CODE)/diffus.f				\
#		$(SOURCE_CODE)/dynsolver.f			\
#		$(SOURCE_CODE)/groatb.f				\
#		$(SOURCE_CODE)/growth.f				\
#		$(SOURCE_CODE)/ostres.f				\
#		$(SOURCE_CODE)/seaice_check.f			\
#		$(SOURCE_CODE)/seaice_do_diags.f		\
#		$(SOURCE_CODE)/seaice_get_forcing.f		\
#		$(SOURCE_CODE)/seaice_init.f			\
#		$(SOURCE_CODE)/seaice_model.f			\
#		$(SOURCE_CODE)/seaice_pickup.f			\
#		$(SOURCE_CODE)/seaice_readparms.f		\
#		$(SOURCE_CODE)/seaice_exch.f                    \
#		$(SOURCE_CODE)/lsr.f
#		$(SOURCE_CODE)/adi.f


#--------------------------------------------------------
# rules
#--------------------------------------------------------

small_f:
	cd $(SOURCE_CODE); $(MAKE) depend; $(MAKE) small_f

allcode:
	cd $(DEST) ; cat $(SRC_MODEL) >! tamc_code_ecco.f

admodeltamc:
	cd $(DEST) ; $(TAMC) $(ADTAMCFLAG) tamc_code_ecco.f	\
           >! tamc_code_ecco_ad.prot

admodeltaf:
	cd $(DEST) ; $(TAF) $(ADTAFFLAG) tamc_code_ecco.f

ftlmodeltamc:
	cd $(DEST) ; $(TAMC) $(FTLTAMCFLAG) tamc_code_ecco.f	\
           >! tamc_code_ecco_ftl.prot

ftlmodeltaf:
	cd $(DEST) ; $(TAF) $(FTLTAFFLAG) tamc_code_ecco.f

svdmodeltaf:
	cd $(DEST) ; $(TAF) $(SVDTAFFLAG) tamc_code_ecco.f

adchange:
	cp $(PKG)/autodiff/adjoint_model.F_template	\
           $(PKG)/autodiff/adjoint_model.F ;		\
	${ADJOINT_SCRIPT}/adjoint_sed.com 		\
           >! tamc_code_ecco_sed_ad.f ;  			\
        cp $(PKG)/autodiff/adjoint_model.F		\
           $(PKG)/autodiff/adjoint_model.F_old ;	\
        cat tamc_code_ecco_sed_ad.f >> $(PKG)/autodiff/adjoint_model.F

ftlchange:
	cp $(PKG)/autodiff/tangentlinear_model.F_template	\
           $(PKG)/autodiff/tangentlinear_model.F ;		\
	cp $(PKG)/autodiff/tangentlinear_model.F		\
           $(PKG)/autodiff/tangentlinear_model.F_old ;		\
        cat tamc_code_ecco_ftl.f >> $(PKG)/autodiff/tangentlinear_model.F

bothchange:   adchange ftlchange

adrestore:
	cp $(PKG)/autodiff/adjoint_model.F_template	\
           $(PKG)/autodiff/adjoint_model.F

ftlrestore:
	cp $(PKG)/autodiff/tangentlinear_model.F_template	\
           $(PKG)/autodiff/tangentlinear_model.F

bothrestore: adrestore ftlrestore

adtamc:  adrestore ftlrestore small_f allcode admodeltamc

adtaf:  adrestore ftlrestore small_f allcode admodeltaf

ftltamc:  adrestore ftlrestore small_f allcode ftlmodeltamc

ftltaf:  adrestore ftlrestore small_f allcode ftlmodeltaf

bothtaf:  bothrestore small_f allcode admodeltaf ftlmodeltaf

svdtaf:  adrestore ftlrestore small_f allcode svdmodeltaf

