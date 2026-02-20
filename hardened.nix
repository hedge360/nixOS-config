{ config, pkgs, ... }:

{
    fileSystems."~" = {
        device = "/dev/sda2";
        fsType = "ext4";
        options = [ "noexec" "nosuid" "nodev" ];
    };
    fileSystems."/var" = {
        device = "/dev/sda2";
        fsType = "ext4";
        options = [ "noexec" "nosuid" "nodev" ];
    };
    fileSystems."/tmp" = {
        device = "/dev/sda2";
        fsType = "ext4";
        options = [ "noexec" "nosuid" "nodev" ];
    };
    fileSystems."/srv" = {
        device = "/dev/sda2";
        fsType = "ext4";
        options = [ "noexec" "nosuid" "nodev" ];
    };
}