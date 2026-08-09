{ config, pkgs, ... }:

{
    services.power-profiles-daemon.enable = false;

    services.thermald.enable = true;

    services.tlp = {
        enable = true;
        settings = {
	    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance-performance"; #power for max battery but little performance, balance-performance for casual/home use, performance is self explanatory
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

            #PLATFORM_PROFILE_ON_BAT = "low-power";
            #PLATFORM_PROFILE_ON_AC = "balanced";

            CPU_BOOST_ON_BAT = 0;
            CPU_BOOST_ON_AC = 1;
            CPU_HWP_DYN_BOOST_ON_BAT = 0;
            CPU_HWP_DYN_BOOST_ON_AC = 1;

            USB_AUTOSUSPEND = 0;

            START_CHARGE_THRESH_BAT0 = 60; #I dont think this works
            STOP_CHARGE_THRESH_BAT0 = 90;
        };
    };
}
