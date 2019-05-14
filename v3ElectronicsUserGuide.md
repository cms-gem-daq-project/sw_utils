
Table of Contents
=================

   * [How to Use This Guide](#how-to-use-this-guide)
   * [Test Stand Ettiquette](#test-stand-ettiquette)
      * [Available Test Stands &amp; Their Uses](#available-test-stands--their-uses)
      * [Test Stand Infrastructure](#test-stand-infrastructure)
      * [Electronic Logbook](#electronic-logbook)
      * [Requesting Time on GEM Test Stands](#requesting-time-on-gem-test-stands)
   * [Back-end Electronics](#back-end-electronics)
      * [AMC13](#amc13)
         * [Using AMC13Tool2.exe](#using-amc13tool2exe)
            * [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot)
            * [Checking Status of a Given Crate](#checking-status-of-a-given-crate)
            * [Dumping Current Register Information](#dumping-current-register-information)
            * [Updating FW](#updating-fw)
            * [Reloading FW](#reloading-fw)
      * [CTP7](#ctp7)
         * [CTP7 Filesystem Stuck as readonly?](#ctp7-filesystem-stuck-as-readonly)
         * [Setting up a <em>new</em> CTP7](#setting-up-a-new-ctp7)
         * [Updating the Linux Image on a CTP7](#updating-the-linux-image-on-a-ctp7)
         * [The rpcsvc Service](#the-rpcsvc-service)
            * [RPC Modules and the LMDB](#rpc-modules-and-the-lmdb)
            * [Restarting syslogd](#restarting-syslogd)
         * [Using gem_reg.py](#using-gem_regpy)
            * [Getting Info About a Register](#getting-info-about-a-register)
            * [Updating the LMDB](#updating-the-lmdb)
         * [Reprogramming a CTP7](#reprogramming-a-ctp7)
            * [Only Reload FW](#only-reload-fw)
               * [v2b Hardware](#v2b-hardware)
               * [v3 Hardware](#v3-hardware)
            * [Full Recovery: recover.sh](#full-recovery-recoversh)
         * [To Update OH FW on CTP7](#to-update-oh-fw-on-ctp7)
      * [Preparing For a Power Cut](#preparing-for-a-power-cut)
      * [Recovering From a Power Cut](#recovering-from-a-power-cut)
   * [Front-end Electronics](#front-end-electronics)
      * [LV Power](#lv-power)
      * [FEASTMP](#feastmp)
      * [GBTx](#gbtx)
         * [E-link Assignment in GE1/1](#e-link-assignment-in-ge11)
         * [Programming GBTx](#programming-gbtx)
            * [Via Dongle: gbtProgrammer](#via-dongle-gbtprogrammer)
               * [Manually Writing Charge Pump Current](#manually-writing-charge-pump-current)
            * [Over Fiber: gbt.py](#over-fiber-gbtpy)
            * [Performing a GBT Phase Scan](#performing-a-gbt-phase-scan)
            * [Fusing](#fusing)
         * [GBT_READY Registers](#gbt_ready-registers)
         * [Issuing a GBT Link Reset](#issuing-a-gbt-link-reset)
      * [Slow Control ASIC (SCA)](#slow-control-asic-sca)
         * [Voltage &amp; Temperature Monitoring](#voltage--temperature-monitoring)
         * [The sca.py Tool](#the-scapy-tool)
         * [Issuing an SCA Reset](#issuing-an-sca-reset)
         * [Checking SCA Status](#checking-sca-status)
            * [Using amc_info_uhal.py](#using-amc_info_uhalpy)
            * [Using gem_reg.py](#using-gem_regpy-1)
         * [VFAT Reset Lines](#vfat-reset-lines)
      * [Optohybrid (OH) FPGA](#optohybrid-oh-fpga)
         * [Programming OH FPGA](#programming-oh-fpga)
         * [Checking Trigger Link Status](#checking-trigger-link-status)
         * [Masking VFATs From Trigger](#masking-vfats-from-trigger)
         * [Temperature Monitoring](#temperature-monitoring)
      * [VFAT3](#vfat3)
         * [General Overview of VFAT3](#general-overview-of-vfat3)
         * [DAC Monitoring](#dac-monitoring)
         * [Checking VFAT Registers](#checking-vfat-registers)
         * [Checking VFAT Synchronization](#checking-vfat-synchronization)
         * [Configuration File on CTP7](#configuration-file-on-ctp7)
   * [Building GEM Software](#building-gem-software)
      * [Build Prerequisites: The gembuild repo](#build-prerequisites-the-gembuild-repo)
      * [cmsgemos](#cmsgemos)
         * [Compiling the entire framework](#compiling-the-entire-framework)
         * [Compiling Only gempython](#compiling-only-gempython)
         * [Configuring your $ENV for testing](#configuring-your-env-for-testing)
      * [ctp7_modoules](#ctp7_modoules)
      * [gem-plotting-tools](#gem-plotting-tools)
      * [vfatqc-python-scripts](#vfatqc-python-scripts)
      * [xhal](#xhal)
         * [Post-Packing Instructions](#post-packing-instructions)
            * [Compiling the entire libary](#compiling-the-entire-libary)
            * [Compiling only the python tools](#compiling-only-the-python-tools)
            * [Compiling only the DAQ Machine C   libraries](#compiling-only-the-daq-machine-c-libraries)
         * [Legacy Pre-Packaging Instructions for Tag 3.2.2](#legacy-pre-packaging-instructions-for-tag-322)
   * [Common Slow Control Actions](#common-slow-control-actions)
      * [Checking Firmware Version](#checking-firmware-version)
      * [Checking CTP7 Mapping Register](#checking-ctp7-mapping-register)
      * [Checking Trigger Rates](#checking-trigger-rates)
      * [Getting Info About the CTP7](#getting-info-about-the-ctp7)
      * [Reading a Register Repeatedly](#reading-a-register-repeatedly)
   * [Configuring a Detector](#configuring-a-detector)
      * [Using testConnectivity.py to Configure a Detector (Recommended)](#using-testconnectivitypy-to-configure-a-detector-recommended)
         * [Routine to Establish Communication w/Detectors](#routine-to-establish-communication-wdetectors)
         * [Automatic DAC Scan, Analysis &amp; Upload of Parameters](#automatic-dac-scan-analysis--upload-of-parameters)
      * [Manually Configuring a Detector](#manually-configuring-a-detector)
      * [Using chamber_vfatDACSettings to write common register values](#using-chamber_vfatdacsettings-to-write-common-register-values)
   * [Taking Calibration &amp; Commissioning Data](#taking-calibration--commissioning-data)
      * [Getting the VFAT Mask: getVFATMask.py](#getting-the-vfat-mask-getvfatmaskpy)
      * [The Mapping File: `chamberInfo.py](#the-mapping-file-chamberinfopy)
      * [Taking Data: run_scans.py](#taking-data-run_scanspy)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

# How to Use This Guide
--------------------
Hello! Congratulations, you're taking one of the first steps to becoming an expert on the GEM DAQ Electronics. For you to get the most out of this guide there's a couple of things that we should discuss first. The first is how this guide should be used. It's broken down into several sections, each section focuses on a specific topic:

 - [Test Stand Ettiquette](#test-stand-ettiquette): how to use our test stands, not collide with other users, and most importantly the electronic logbook;
 - [Back-end Electronics](#back-end-electronics): how to use the [CTP7](#ctp7), the [AMC13](#amc13), and maybe one day the GLIB (I'm looking at you Phase II Upgrade Community);
 - [Front-end Electronics](#front-end-electronics): how [LV power](#lv-power) works, how to use the [FEASTMP](#feastmp), the [GBTx](#gbtx), the [Slow Control ASIC (SCA)](#slow-control-asic-sca), the OH FPGA, and most importantly the [VFAT3](#vfat3);
 - [Building GEM Software Tools](#building-gem-software);
 - [Configuring a Detector](#configuring-a-detector); and
 - [Taking Calibration Scans](#taking-calibration--commissioning-data);

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Test Stand Ettiquette
--------------------
It's important to realize we are all sharing a set of common equipment and are working toward a common goal. Furthermore you and your coworkers are at various skill levels and possess different degrees of familiarity with the hardware and the software. This brings us to the first important point:

- **Leave the test stand how you found it**.

This specifically refers to the:

1. Test stand infrastructure (e.g. fiber patch panels, power supplies, DAQ computer, etc...), and
2. State of software (e.g. `rpcmodules`) and firmware of backend electronics.

It can be expected that you would need to configure the front-end electronics for whatever test/developpment you are working on.  But the back-end electronics should *always* be left in a useable state for the next user (i.e. how *you* found them).

Moreover if you are not on the list of approved individuals who can modify the hardware/stand infrastructure you should not (if you are wondering if you are on this list it means you are *not*).

Failure to follow these rules makes more work for the expert team, sysadmin/test stand responsible.  Failure to conform repeatedly will result in loss of access to the test stand.

Once you realize this you should:

1. [Determing the right test stand to use](#available-test-stands--their-uses),
2. [Request time on a test stand](#requesting-time-on-gem-test-stands), and
3. Use the [appropriate e-log](#electronic-logbook) to log all activities.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Available Test Stands & Their Uses
The following 904 test stands exist.

| Stand | Location | Purpose |
| :---: | :------: | :------ |
| Coffin | Integration Side of 904 | General purpose debugging station. Supports P5 operation, general software development, firmware testing, and trigger development.  Only place combined ME1/1+GE1/1 runs can be taken. |
| V3 Electronics R&D | GEM 904 Lab | Dedicated to testing sustained operation of GE1/1 detectors. | 
| QC8 | GEM 904 Lab | Production test stand for GE1/1 qualification. |

Unless you are involved in, or performing a test for, the sustained operations group or QC8 for GE1/1 qualification you should default to using the "Coffin" setup.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Test Stand Infrastructure

Mainframes, fiber patch panels, uTCA crate numbers & names, AMC's, etc...

## Electronic Logbook

For each of the test stands described under the [Available Test Stands & Their Uses](#available-test-stands--their-uses) section a corresponding electronic logbook exists; as shown in the table below:

| Stand | E-Log |
| :---: | :---: |
| "Coffin" | [904 Integration](https://cmsonline.cern.ch/webcenter/portal/cmsonline/pages_common/elog?__adfpwp_action_portlet=623564097&__adfpwp_backurl=https%3A%2F%2Fcmsonline.cern.ch%3A443%2Fwebcenter%2Fportal%2Fcmsonline%2Fpages_common%2Felog%3FMedia-Type%3Dscreen%26Media-Feature-Scan%3D0%26Media-Feature-Orientation%3Dlandscape%26Media-Feature-Device-Height%3D1050%26Media-Feature-Height%3D789%26_afrWindowMode%3D0%26Media-Feature-Monochrome%3D0%26Font-Size%3D16%26Media-Feature-Color%3D8%26Media-Featured-Grid%3D0%26_afrLoop%3D12894451140606290%26Media-Feature-Resolution%3D192%26Media-Feature-Width%3D1680%26Media-Feature-Device-Width%3D1680%26Media-Feature-Color-Index%3D0%26Adf-Window-Id%3Dw0%26__adfpwp_mode.623564097%3D1&_piref623564097.strutsAction=%2FviewSubcatMessages.do%3FcatId%3D791%26subId%3D799%26page%3D1) |
| V3 Electronics R&D | [V3 Electronics Testing](https://cmsonline.cern.ch/webcenter/portal/cmsonline/pages_common/elog?__adfpwp_action_portlet=623564097&__adfpwp_backurl=https://cmsonline.cern.ch:443/webcenter/portal/cmsonline/pages_common/elog?__adfpwp_mode.623564097=1&_piref623564097.strutsAction=//viewSubcatMessages.do?catId=791&subId=1511&page=1&fetch=1&mode=expanded) |
| QC8 | [Cosmic Stand](https://cmsonline.cern.ch/webcenter/portal/cmsonline/pages_common/elog?__adfpwp_action_portlet=623564097&__adfpwp_backurl=https://cmsonline.cern.ch:443/webcenter/portal/cmsonline/pages_common/elog?_piref623564097.strutsAction=//viewSubcatMessages.do?catId=792&subId=793&page=1&fetch=1&mode=expanded) |

When using a test stand you should:

 1. Open an elog once you start using the stand,
 2. Show commands executed, and when relevant their outputs, 
 3. Summarize the actions taken and the result(s)/problem(s) encountered, and
 4. State when you are finished using the stand

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Requesting Time on GEM Test Stands

Each stand has it's own requisition page on SuperSAAS to manage testing and ensure we do not collide with other users.  To see the available test stands and to request time on nagivate to:

https://www.supersaas.com/schedule/GEM_904_Infrastructure

If you need time on a particular setup you need to understand what hardware you will be using.  Will this be just the front-end(s) on a given link? In this case you'll need time on the AMC in question.  Will testing involved the front-end being triggered from a trigger source coming from AMC13? Then you'll need time on the uTCA crate in question.

Before trying to modify the above schedules you'll need to first ask for the GEM 904 Shared User Password on SuperSAAS to use the scheduling tools.  To do this ask in the `System Setup` channel of the [GEM DAQ Mattermost Team](https://mattermost.web.cern.ch/signup_user_complete/?id=ax1z1hss5fdm8bpbx4hgpoc3ne). When scheduling you need to provide an:

- Your name
- Your email
- Estimated time your test will take (starting & ending time),
- Phone number you are reachable at while using the test stand, and
- Description of your test.

Your request will be submitted and then approved. Note you may only use the stand once the request has been *approved*.  Once your request has been approved and you start using the stand you still are require to make an elog entry documenting the actiosn you have taken, their outcome, and relevant commands, etc...

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Back-end Electronics
--------------------

## AMC13

The [AMC13](http://iopscience.iop.org/article/10.1088/1748-0221/8/12/C12036/meta) provides clock, timing and DAQ service to the GEM uTCA crate either from the the TCDS system (at P5) or in local loopback mode (at a test stand).

### Using `AMC13Tool2.exe`

The AMC13 can be configured by hand using the `AMC13Tool2.exe`.  To use this tool execute:

```bash
AMC13Tool2.exe -i gem.shelfXX.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml
```

Here XX is the uTCA shelf number (e.g. `XX = 01` for most setups), note this is *always* represented with two digits even if the shelf number is less than 10.  This provides a command line interface for reading/writing registers of the AMC13 and querying the status of the systme. An example successful output of the above command looks like:

```bash
AMC13Tool2.exe -i gem.shelf01.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml
Address table path "/opt/cactus/etc/amc13/" set from AMC13_ADDRESS_TABLE_PATH
Using .xml connection file...
Using AMC13 software ver:50470
Read firmware versions 0x2257 0x2e
flavor = 2  features = 0x000000b2
```

You can see all available commands inside the `AMC13Tool2.exe` by executing `help` command inside the tool.

Some useful commands are:

 - `rg` General reset,
 - `rc` Counter reset,
 - `rd` DAQ Link reset,
 - `st` Display AMC13 Status (see [Checking Status of a Given Crate](#checking-status-of-a-given-crate)),

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Enabling Clock to an AMC Slot

To enable 
```bash
AMC13Tool2.exe -i gem.shelfXX.amc13 -c $GEM_ADDRESS_TABLE_PATH/connections.xml
ws CONF.TTC.OVERRIDE_MASK 0xfff
en <slots> t
```

Here XX is the uTCA shelf number (e.g. `XX = 01` for most setups), note this is *always* represented with two digits even if the shelf number is less than 10.  The second command ensures all slots have a clock.  The third command will enable the slots of interest and place the AMC13 in loop back mode (drop the `t` for P5 operation).  Here `<slots>` is a comma and dash separated list, e.g. `en 2-5,7 t` will enable slots 2 *through* 5 and slot 7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Checking Status of a Given Crate

To check the status of a particular AMC13 enter the `AMC13Tool2.exe` and execute one of four options:

 - `st` displays the generic status menu
 - `st 2` as `st` but shows additional information about enabled AMC slots,
 - `st 3` as `st 2` but also shows clock frequency information and FPGA voltage and temperature
 - `st 99` shows all status information (large text dump)

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Dumping Current Register Information

In some cases you might need to make a dump of all information on the AMC13 (e.g. to see hardware configuration after a particular problem has occurred).  To do this execute:

```
>dump
```

This will dump the current configuration to a text file and in the terminal output the filepath will be printed.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Updating FW

Have your test stand sysadmin execute the following procedure:

 1. Get the latest file from the [AMC13 FW Page](http://ohm.bu.edu/~dgastler/CMS/AMC13-Firmware/?C=M;O=D),
 2. Program the flash of the virtex (kintex) FPGA with the `pv` (`pk`) command,
 3. Verify the flash of the virtex (kintex) FPGA with the `vv` (`vk`) command; if the verification is *not* successful do *not* continue, repeat step 2 unitl step 3 succeeds,
 4. Reconfigure the FPGA's following instructions under [Reloading FW](#reloading-fw).

Note if you execute step 4 without step 3 succeeding you could brick the board and by extension the uTCA crate. An example of a successful firmware upgrade can be found in this [elog entry](http://cmsonline.cern.ch/cms-elog/946282).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Reloading FW

To reload the FW in the AMC13 enter the `AMC13Tool2.exe` tool and execute `reconfigureFPGAs`. Note this will cause the card to be non-responsive for a small amount of time.  Additionally it will necessasitate a reload of FW of everything downlink of the AMC13 (e.g. any CTP7's in the uTCA crate, any OH's on those CTP7s, reconfiguring any VFATs on those CTP7's, etc...).  This action should typically note be done except in the most dire of circumstances (e.g. when any and all other troubleshooting actions have been attempted, and failed).  This will then require the user to re-enable the clock to all AMC slots of interest in a crate following instructions under [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## CTP7

The [Calorimeter Trigger Processor 7](http://iopscience.iop.org/article/10.1088/1748-0221/11/02/C02011/meta), or CTP7 for short, is a micro TCA AMC used by several subsystems of CMS. In the GEM project it is the present back-end AMC for GE1/1. It is responsible for slow control (register read/write), tracking data readout, and event building.  In GE1/1 case it controls up to 12 optohybrids (but the FW version your card is using may be compiled for less optohybrids).

The CTP7 runs a special 32-bit version of linux located on a 32GB flash SD card inserted on the AMC.  This is run by a 32-bit processor called a Zynq processor and features extremely fast register access to the Virtex 7 FPGA.  The linux OS is loaded from an image on the card at each boot/reboot and only those files found under:

```bash
/mnt/persistent
```

Are stored after each boot.

An important caveat is that the `root` password of the CTP7 is the same on *all* CTP7's.  So if you are a sysadmin of a given test stand *do not* share this with general users as this will enable them to have `root` privileges on any test stand (including P5) which would be extremely frowned upon.

Most actions do not ever require you to login to the linux image of the CTP7 and they are performed almost 100% from the DAQ PC itself.  However, some actions do require you to login to the linux image of a CTP7.  To do this execute, from the test stand DAQ machine, the following:

```bash
ssh gemuser@eagleXX
```

Where `eagleXX` is the network alias of the CTP7 of interest, e.g. `eagle64`.

On the CTP7 there will be two important directories:

```
/mnt/persistent/gemdaq
/mnt/persistent/rpcmodules
```

The `gemdaq` subdirectory is described below and the `rpcmodules` subdirectory is described in [RPC Modules and the LMDB](#rpc-modules-and-the-lmdb).  The `gemdaq` subdirectory looks like:

```bash
$ ll
drwxrwxrwx    2 root     root          4096 Aug 10 12:44 address_table.mdb
drwxr-sr-x    5 gemuser  1001          4096 Jun  1  2017 apps
drwxr-xr-x    2 51446    1399          4096 Aug  8 15:45 bin
drwxr-xr-x    2 51446    1399          4096 Aug  8 15:45 fw
drwxr-xr-x    5 root     root          4096 Aug 10 09:24 gbt
drwxrwxr-x    2 51446    1399          4096 Aug  8 15:45 gemloader
drwxr-xr-x    2 51446    1399          4096 Aug  8 15:45 lib
drwxr-xr-x    2 51446    1399          4096 Aug  8 15:41 oh_fw
drwxr-xr-x    3 51446    1399          4096 Aug  8 15:45 python
drwxr-xr-x    3 51446    1399          4096 Aug  8 15:41 scripts
drwxrwxrwx    2 51446    1399         12288 Aug 21 14:01 vfat3
drwxr-xr-x    2 51446    1399          4096 Aug  8 15:46 xml
```

The Lightning in Memory Database (LMDB) will be found under `address_table.mdb` folder along with a lock file to prevent simultaneous access.  Note the `address_table.mdb` folder and it's contents must have read/write permissions to *everyone* or else LMDB related actions *will* fail.  The CTP7 firmware will be found under `fw` folder and a set of symlinks will be specified there, for example:

```bash
$ ll fw   
lrwxrwxrwx    1 51446    1399            23 Aug  8 15:45 gem_ctp7.bit -> gem_ctp7_v3_5_3_4oh.bit
-rw-r--r--    1 51446    1399      28734919 Aug  3 17:37 gem_ctp7_v3_5_3_4oh.bit
```

The `GBTx` configuration files for programming over the fiber link will be found under the `gbt` folder and in relevant subfolders:

```
$ ll gbt         
drwxr-xr-x    2 root     root          4096 Aug 10 09:24 OHv3a
drwxr-xr-x    2 root     root          4096 Aug 10 09:24 OHv3b
drwxr-xr-x    2 root     root          4096 Aug 10 14:31 OHv3c
```

Configuring the `gemloader` for `BLASTER(tm)` configuration method is possible with the `gemloader_configure.sh` script which is found under the `gemloader` subdirectory.  The `gemloader` itself is a system installed executable, e.g.:

```bash
$ which gemloader
/bin/gemloader
```

The `lib` folder has a set of shared object libraries installed that are necessary for atomic transactions and logging.  The optohybrid firmware will be found under `oh_fw` and a set of symlinks will be specified there, for example:

```bash
$ ll oh_fw/
lrwxrwxrwx    1 51446    1399            22 Aug  8 15:41 optohybrid_top.bit -> optohybrid_3.1.2.B.bit
lrwxrwxrwx    1 51446    1399            22 Aug  8 15:41 optohybrid_top.mcs -> optohybrid_3.1.2.B.mcs
-rwxr-xr-x    1 gemuser  1001       5465091 Jun  1  2017 optohybrid_top_2.2.d.fb.bit
-rwxr-xr-x    1 gemuser  1001      15030033 Jun  1  2017 optohybrid_top_2.2.d.fb.mcs
```

The `python` folder contains several register interface scripts specifically the `gbt.py`, `sca.py`, and `reg_interface.py` scripts that can be used on the CTP7.  Except for `gbt.py` these scripts are typically used from the corresponding versions on the DAQ PC.  The `scripts` directory has a series of scripts that are in the `$PATH` that enable actions like reloading the CTP7 firmware or starting `ipbus` (just to name a few examples).  The `vfat3` directory for the time being contains the per `(ohN,vfatN)` configuration file specifies registers per chip (e.g. here you would edit the `CFG_IREF` for the VFAT of interest).  Within the `vfat3` directory there will be a set of configuration files and symlinks that are given by the following pattern:

```bash
lrwxrwxrwx    1 gemuser  1001            53 Aug 10 15:27 config_OHX_VFATY.txt -> /mnt/persistent/gemdaq/vfat3/config_OHX_VFATY_cal.txt
-rw-r--r--    1 gemuser  1001          1267 Aug 10 15:27 config_OHX_VFATY_cal.txt
```

The symlink is what is used by the configuration command to configure the `vfat3` in `(ohN,vfatN) = (X,Y)` position; so this must always be a valid link.  An example of how this file is expected to look can be found in the [Configuration File on CTP7](#ctp7) section.

The address table `xml` files will be found under the `xml` folder and a set of symlinks will be specified there, for example:

```bash
$ ll xml/  
-rw-r--r--    1 51446    1399      21149299 Aug  8 15:46 gem_amc_top.pickle
lrwxrwxrwx    1 51446    1399            18 Aug  8 15:45 gem_amc_top.xml -> gem_amc_v3_5_3.xml
-rw-r--r--    1 51446    1399        136064 Aug  8 15:45 gem_amc_v3_5_3.xml
-rw-r--r--    1 51446    1399        102472 Aug  8 15:41 oh_registers_3.1.2.B.xml
lrwxrwxrwx    1 51446    1399            24 Aug  8 15:41 optohybrid_registers.xml -> oh_registers_3.1.2.B.xml
```

Finally any action taken on a CTP7 should be recorded in full on the elog that corresponds to the system the card is on.  See [Electronic Logbook](#electronic-logbook) for details on which elog is of interest and how to make a proper elog. 

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### CTP7 Filesystem Stuck as readonly?

More recent linux images of the CTP7 have placed the `/mnt/persistent/` partition as `readonly`.  To resolve this the test stand sysadmin should be contacted.  The should edit:

```bash
/mnt/persistent/config/persistent_writeable
```

To contain a single line that reads `yes` and nothing else.  The next time the card boots the `/mnt/persistent` partition will be mounted as writeable.

If the system is running and cannot be rebooted (e.g. during data-taking) the following short cuts exist and can be executed by non-`root` users:

```bash
setpersistent rw # Sets partition writeable
setpersistent ro # Sets partition readonly
```

Some older versions of the linux image do *not* feature these commands, in this case the sysadmin of the test stand should mount the drives as `rw` via:

```bash
mount -o remount,rw /dev/mmcblk0p3 /mnt/persistent
mount -o remount,rw /dev/mmcblk0p1 /mnt/image
mount -o remount,rw /dev/mmcblk0p2 /mnt/image-persist
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Setting up a *new* CTP7

If the CMS GEM project has *just* received a new CTP7, or a new SD card has been placed in an CTP7 already in our possession, you will need to setup the linux partition on the card.  For this have the test stand sysadmin execute from the test stand's DAQ PC:

 1. Setup `xhal` tag `3.2.2` following instructions [here](#legacy-pre-packaging-instructions-for-tag-322),
 2. Checkout the `gemctp7user` repository:
```bash
cd $BUILD_HOME
git clone https://github.com/cms-gem-daq-project/gemctp7user.git
```
 3. Checkout the `ctp7_modules` repository and compile the shared object libraries following instructions under [ctp7_modules](#ctp7_modoules),
 4. Execute the `setup_ctp7.sh` sxcript from the `gemctp7user` repo:
```bash
cd $BUILD_HOME/gemctp7user
./setup_ctp7.sh -o X.Y.Z.Q -c A.B.C -l 4 -x 3.2.2 -a gemuser -u eagleVV
```

This will palce [optohybrid firmware](https://github.com/cms-gem-daq-project/OptoHybridv3/releases) version `X.Y.Z.Q`, [CTP7 firmware](https://github.com/evka85/GEM_AMC/releases) version `A.B.C`, `xhal` tag `3.2.2`, setup the `gemuser` account, transfer all binaries/bit files/xml's/etc... to the approrpriate locations.

You may find that `rpcsvc` may not be running at the time that the `setup_ctp7.sh` script tries to update the LMDB.  This will cause the automatic update of the LMDB to fail.  This is okay, you can just do it manually following instructions with legacy `reg_interface.py` (not `gem_reg.py`) program:

```bash
python $XHAL_ROOT/python/reg_interface/reg_interface.py -n ${ctp7host} -e update_lmdb /mnt/persistent/gemdaq/xml/gem_amc_top.xml
```

Note the instructions shown in this section reflect the "pre-packing" instructions 

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Updating the Linux Image on a CTP7

If you are not the sysadmin of this test stand you should not be executing this procedure.  If you are the sysadmin execute:

 1. Login as root (this logs in at `/home/root` which is not on the `/mnt` partition),
 2. As root execute `/sbin/reboot` to make sure there are no running processes or other active sessions (this would prevent a linux update),
 3. As `root` login again and mount the drives as `rw`:
```bash
mount -o remount,rw /dev/mmcblk0p3 /mnt/persistent
mount -o remount,rw /dev/mmcblk0p1 /mnt/image
mount -o remount,rw /dev/mmcblk0p2 /mnt/image-persist
```
 4. Place the linux image in the `root` `$HOME` directory (so that it is *not* on the `/mnt` partition), 
 5. As `root` execute `image-update linuxImageFile.img`, an example *successful* output is shown as:
```bash
root@eagle26:~# image-update LinuxImage-CTP7-GENERIC-20180529T153916-0500-4935611.img 
Ensuring /mnt/persistent is writeable.
*** Extracting Image ***

*** Verifying Signature ***
Verified OK

*** Extracting Image Contents ***

*** Running Installation Script ***

Installing Image: CTP7-GENERIC-20180529T153916-0500-4935611
Mounting image filesystem read-write
Copying boot image
Mounting image filesystem read-only
Mounting image-persist filesystem read-write
Installing stage tarball
Installing documentation
Syncing

Update complete!
Rebooting!

Broadcast message from root@eagle26 (pts/0) (Thu Aug  9 08:31:00 2018):

The system is going down for reboot NOW!
```
 6. Finally, login again (as any user) and check that the `build_id` reflects the new image, for the above example it would have printed:
```bash
eagle26:~$ cat /mnt/image-persist/build_id 
CTP7-GENERIC-20180529T153916-0500-4935611
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### The `rpcsvc` Service

Many actions on the card requie the Remote Procedure Call (RPC) service to be running and owned by the `gemuser` account.  This service is run as a system process called `rpcsvc`.  To check if this process is running login to the CTP7's linux image an execute:

```bash
eagleXX:~$ ps | grep rpcsvc
```

Example output should look like:

```bash
eagle60:~$ ps | grep rpcsvc
10994 gemuser   4040 S    rpcsvc
14004 gemuser   2796 S    grep rpcsvc
```

If you only see a line that says `grep rpcsvc` then the `rpcsvc` service is *not* running.  Additionally if you see that `rpcsvc` is running but it is not owned by the `gemuser` account then it will be configured with the *wrong* library and must be killed (either by the sysadmin using the `root` account or from a `$USER` of the other account).  Note you might find that multiple lines are returned which show multiple `rpcsvc` services.  If these are all owned by `gemuser` then this just indicates that the `rpcsvc` service is running and that one or more open `rpc` connections exist between the card and the DAQ PC.

Sometimes you may need to restart the `rpcsvc` (typically after updating the `rpcmodules` on the card), to do this execute:

```bash
killall rpcsvc && rpcsvc
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### RPC Modules and the LMDB

When a command to interface with the front-end hardware is sent from the DAQ machine this typically uses either the micro hardware access library (`uhal`) built on top of `ipbus` or the cross hardware access library (`xhal`) built on top of `rpcsvc` (and using `TCP/IP` communication).  An RPC message is sent to the CTP7 and the Zynq processor on the CTP7 will load a function that is defined in a shared object library (`*.so`) file under `/mnt/persistent/rpcmodules`. These shared object libraries are referred to as `rpcmodules`.  For more detailes please see the [README of the ctp7_mopdules](https://github.com/cms-gem-daq-project/ctp7_modules/blob/develop/README.md) repository.

On a production machine these will be the following set (although more may be present in the future):

```bash
$ ll /mnt/persistent/rpcmodules/
-rwxr-xr-x    1 root    root        49093 Oct  9 16:48 amc.so
-rwxr-xr-x    1 root    root       140180 Oct  9 16:48 calibration_routines.so
-rwxr-xr-x    1 root    root        95769 Oct  9 16:48 daq_monitor.so
-rwxr-xr-x    1 root    root        13917 Oct  9 16:48 extras.so
-rwxr-xr-x    1 root     root        102207 Sep 13  2017 memory.so
-rwxr-xr-x    1 root     root        122365 Sep 13  2017 optical.so
-rwxr-xr-x    1 root    root       102929 Oct  9 16:48 optohybrid.so
-rwxr-xr-x    1 root     root        108849 Sep 13  2017 rpctest.so
-rwxr-xr-x    1 root    root        97422 Oct  9 16:48 utils.so
-rwxr-xr-x    1 root    root        84989 Oct  9 16:48 vfat3.so
```

While on a development system these will be a set of symlinks that point to a user editable area, for example `eagle64`:

```
$ ll /mnt/persistent/rpcmodules/
lrwxrwxrwx    1 root     root            47 Oct  1 12:15 amc.so -> /mnt/persistent/gemuser/rpcmoduleTesting/amc.so
lrwxrwxrwx    1 root     root            64 Oct  1 12:15 calibration_routines.so -> /mnt/persistent/gemuser/rpcmoduleTesting/calibration_routines.so
lrwxrwxrwx    1 root     root            55 Oct  3 12:09 daq_monitor.so -> /mnt/persistent/gemuser/rpcmoduleTesting/daq_monitor.so
lrwxrwxrwx    1 root     root            50 Oct  1 12:15 extras.so -> /mnt/persistent/gemuser/rpcmoduleTesting/extras.so
-rwxr-xr-x    1 root     root        102207 Sep 13  2017 memory.so
-rw-r--r--    1 root     root        611328 Jun 27 09:07 modules.tar
-rwxr-xr-x    1 root     root        122365 Sep 13  2017 optical.so
lrwxrwxrwx    1 root     root            54 Oct  1 12:16 optohybrid.so -> /mnt/persistent/gemuser/rpcmoduleTesting/optohybrid.so
-rwxr-xr-x    1 root     root        108849 Sep 13  2017 rpctest.so
lrwxrwxrwx    1 root     root            49 Oct  1 12:16 utils.so -> /mnt/persistent/gemuser/rpcmoduleTesting/utils.so
lrwxrwxrwx    1 root     root            49 Oct  1 12:16 vfat3.so -> /mnt/persistent/gemuser/rpcmoduleTesting/vfat3.so
```

With the user editable area being `/mnt/persistent/gemuser/rpcmoduleTesting/`.

The LMDB is a database that the `rpcmodules` query when functions are launched on the CTP7.  The `rpcmodules` are segmented into what are referred to as local or remote/non-local modules.  The local version has `someStringLocal()` always in it's function name and is only ever executed from the CTP7.  The non-local module receives the RPC Message from the host DAQ PC, calls the corresponding local function(s) and returns and RPC response to the host machine.  Note that no terminal output appears on the host machine during the execution of either the local or non-local `rpcmodules`.  Instead the developer will have configured the functions to log actions on the CTP7's log file which is available on the CTP7 at:

```
/var/log/messages
```

Note that this file is *not* found under the `/mnt/persistent` partition and is re-written everytime the card reboots. To ensure log information is not lost the DAQ PC is configured to have a version of this file found under:

```
/var/log/remote/eagleXX/messages.log
```

Where `eagleXX` is the network alias of the CTP7 (e.g. `eagle64`). This file is written to disk on the DAQ PC and will persist through crashes/reboots of the CTP7 (so no information will be lost). You can see the most recent information found in the log file via:

```bash
tail -25 /var/log/messages
```

This will display the last 25 lines in the log file on the CTP7 (executed as `gemuser` on the CTP7). Use the `tail` command similarly to view the log on the DAQ PC.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Restarting `syslogd`

In some weird cases `syslogd` will not be running after the CTP7 boots.  This will cause the log file:

```
/var/log/messages
```

To not be created or written to.  To resolve this ask your sysadmin to execute:

```bash
/sbin/syslogd -R 192.168.0.180 -L -s 1024 -b 8
```

And they should see the process running, e.g.

```bash
root@eagle63:~# ps l | grep syslog
S     0  9161     1  2792    64 0:0   13:31 00:00:00 /sbin/syslogd -R
192.168.0.180 -L -s 1024 -b 8
S     0  9163  9146  2796   288 pts4  13:32 00:00:00 grep syslog
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Using `gem_reg.py`

The `gem_reg.py` tool is a command line interface which allows you to perform several actions on GEM hardware: 

 1. Atomic transactions (register read/write),
 2. Getting information about a register, and
 3. LMDB on the CTP7

The first two actions will typically be performed by any user, whereas the third action should only be performed by the sysadmin of the test stand in question.

To get started you should first connect to the CTP7 of interest:

```bash
gem_reg.py
% gem_reg.py
Open pickled address table if available  /opt/cmsgemos/etc/maps/amc_address_table_top.pickle...
Starting CTP7 Register Command Line Interface. Please connect to CTP7 using connect <hostname> command unless you use it directly at the CTP7
CTP7 > connect eagleXX
eagleXX > 
```

You will now have opened an rpc connection to the CTP7 whose network alias is `eagleXX`.  Note that the `rpcsvc` service must be running on the CTP7 and *owned* by the `gemuser` account (not the `texas` account).  If `rpcsvc` is not running or it is running and owned by the `texas` account you may find the connection fails.

You can see available commands by looking at the `help` menu.  This is viewable by calling `help`.  Some of the most useful commands are:

 - `connect` opens an RPC connection to a CTP7,
 - `doc` prints additional information about a command (e.g. `doc <full node name>`),
 - `exit` exits the `gem_reg.py` interface (or press `Ctrl+D`),
 - `help` prints the help menu or `help <cmd>` the command specific help menu,
 - `kw` reads all node names containing a substring,
 - `read` reads a given node name,
 - `readAddress` reads a given address and displays the corresponding node,
 - `rwc` reads a string segmented by the wildcard character `*`, and
 - `write` writes a value to a node name.

Here a node is a particular point in the xml address table, nodes typicall go as `string1.string2.string3` and so on.  Here `string2` is the parent node of `string3` and the daughter node of `string1`.

Note while running `gem_reg.py` while issuing a KeyboardInterrupt (i.e. pressing `Ctrl+C`) this will *not* terminate `gem_reg.py` but it *will* kill the rpc connection, a new connection must be opened with the `connect` command afterward.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Getting Info About a Register

To get the documentation for a given register you need to call `doc` on the full node name, for example:

```bash
eagle26 > doc GEM_AMC.OH.OH2.GEB.VFAT23.CFG_RUN
Name: GEM_AMC.OH.OH2.GEB.VFAT23.CFG_RUN
Description: SLEEP/RUN mode (0 = SLEEP, 1 = RUN)
Address: 0x0052bb00
Permission: rw
Mask: 0x00000001
Module: False
Parent: GEM_AMC.OH.OH2.GEB.VFAT23
None
```

Here the above are:
 - `Description` is the register documentation, 
 - `Address` is the register address in the CTP7 address space,
 - `Permissions` indicate read-only (`r`), write-only (`w`), or both read & write (`rw`),
 - `Mask` indicates the register mask, all registers in the CTP7 address space are 32-bit registers and registers may be shared by multiple nodes.  This indicates the bits of the given `Address` that this node occupies,
 - `Parent` the parent node.

Note that if you write to a given address (e.g. as in an `rpc` module) without using the node name you need to carefull apply the mask or you risk changing the value of other nodes which share the same 32-bit register. 

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Updating the LMDB

This action should only ever be taken by the sysadmin of the test stand.

Whenever the FW of either the CTP7 or the OH changes such that a new xml address table is generated (e.g. new node names are added, new addresses are added, or existing nodes (addresses) have their addresses (nodes) altered, FW is compiled for more optohybrids) then the LMDB must be updated.  If the FW update does not include changes to the xml address table then this action does *not* need to be taken).  To update the LMDB launch `gem_reg.py` from the *DAQ PC* and after connecting execute:

```bash
update_lmdb /mnt/persistent/gemdaq/xml/gem_amc_top.xml
```

If an error was reported when trying to update the lmdb than it has failed and you must investigate the problem, solve it, and then update the lmdb again. Note even though this references `gem_amc_top.xml` and not `optohybrid_registers.xml` it **will** update the OH registers in the LMDB due to how the software functions.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Reprogramming a CTP7

All v3 electronics systems use AMC firmware version `3.X.Y` or higher while legacy v2b systems uses firmware versions strictly from the `1.A.B` series.

#### Only Reload FW

##### v2b Hardware

The v2b hardware is considered end-of-life and legacy system.  Little to no support is available for this hardware. If your CTP7 is connected to a v2b hardware then you'll need to use:

```bash
cold_boot.sh
```

It is critical to ensure that all `GTH Status` values (0 through 35) return `0x7`.  If `0x6` is returned then you'll need to call `cold_boot.sh` again.  If any other value is returned (e.g. `0x0`) the CTP7 may not be receiving a clock from the `AMC13` and you'll need to check that the AMC13 is configured correctly, see instructions under [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot)

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

##### v3 Hardware

The v3 hardware requires a different polarity of come of the CXP's on the CTP7, in this case one should call on the CTP7:

```bash
cold_boot_invert_tx.sh
```

As in the v2b case it is critical to ensure that all `GTH Status` values (0 through 35) return `0x7`.  If `0x6` is returned then you'll need to call `cold_boot_invert_tx.sh` again.  If any other value is returned (e.g. `0x0`) the CTP7 may not be receiving a clock from the `AMC13` and you'll need to check that the AMC13 is configured correctly, see instructions under [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot)

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Full Recovery: `recover.sh`

If you need to perform a full recovery (e.g. after a reboot of the CTP7 or a power cut) simply execute:

```bash
recover.sh
```

This will be a symlink to either `recover_v2.sh` or `recover_v3.sh` in the `/mnt/persistent/gemdaq/scripts` directory and will have been correctly set by your test stand's sysadmin.  This will:

 - Reload the FW, 
 - start `ipbus`, 
 - start `rpcsvc`, 
 - place the OH FW into the CTP7 RAM for PROM-less (e.g. `BLASTER(tm)` programming), and 
 - disable forwarding of TTC resets to the front-end.

Again, it is critical to ensure that all `GTH Status` values (0 through 35) return `0x7`.  If `0x6` is returned then you'll need to call `cold_boot_invert_tx.sh` (`cold_boot.sh`) if you are working with v3 (v2b) electronics.  If any other value is returned (e.g. `0x0`) the CTP7 may not be receiving a clock from the `AMC13` and you'll need to check that the AMC13 is configured correctly, see instructions under [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot).  Sometimes this will not enable `rpcsvc` or `ipbus` correctly.  After calling `recover.sh` it is important to check if `rpcsvc` and `ipbus` are running on the card.

An example of a successful recovery is illustrated in this [elog entry](http://cmsonline.cern.ch/cms-elog/1060543).

Note that if you are calling this after the card has been rebooted or power cycled you should ensure the `texas` account is not the owner of the `rpcsvc` service.  You might have to login as the `texas` account and issue `killall rpcsvc` then logout and login under the `gemuser` account to issue the recover command.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### To Update OH FW on CTP7

The following requires knowledge of the `root` password of the CTP7.  If you do not know the `root` password you should not be executing this procedure.  Please call the sysadmin of your test stand and ask to have this done for you.

 0. Begin by creating an elog entry in the relevant  elog explaining what you are about to do (e.g. for 904 "Coffin" Integration stand use the "904 Integration" elog, for QC8/V3 Electronics R&D use the `DAQ Station` Elog under `Quality Control`, for P5 use `Slice Test`.)
 1. Login to the DAQ machine of interest (i.e. `gem904qc8daq` or `gem904daq01`)
 2. Navigate to the [Release Page of the OptohybridV3 FW Repo](https://github.com/cms-gem-daq-project/OptoHybridv3/releases)
 3. Select the release you are interested in, they are labeled as `3.X.Y.{A|B|C}` (note `OHv3a` and `OHv3b` can use the same firmware, but `OHv3c` uses different FW, the changes are largely in default FW values).
 4. Navigate to the firmware directory on the 904 NAS for OH FW: `cd /data/bigdisk/GEMDAQ_Documentation/system/firmware/files/OptoHybrid/V3/OHv3{a|b|c}_firmware`.
 5. Download the `OH_3.X.Y.{A|B|C}.tar.gz` file from the release to the NAS area on 904, do this via: `wget https://github.com/cms-gem-daq-project/OptoHybridv3/releases/download/3.X.Y.{A|B|C}/OH_3.X.Y.{A|B|C}.tar.gz`
 6. Unpack the archive by executing: `tar -zxf OH_3.X.Y.{A|B|C}.tar.gz`, this will create a subfolder `OH_3.X.Y.{A|B|C}`.
 7. Navigate to this subfolder: `cd OH_3.X.Y.{A|B|C}`.
 8. Upload the `*.bit` file to the CTP7: `scp OH_3.X.Y.{A|B|C}.bit root@eagleXX:/mnt/persistent/gemdaq/oh_fw` where XX is the serial number of the CTP7.
 9. Upload the `*.mcs` file to the CTP7: `scp OH_3.X.Y.{A|B|C}.mcs root@eagleXX:/mnt/persistent/gemdaq/oh_fw` where XX is the serial number of the CTP7.
 10. Upload the the xml address table to the CTP7: `scp oh_registers_3.X.Y.{A|B|C}.xml root@eagleXX:/mnt/persistent/gemdaq/xml`
 11. Login to the CTP7 of interest: `ssh gemuser@eagleXX`
 12. Become root: `su root`
 13. Navigate to the OH FW directory on the CTP7: `cd /mnt/persistent/gemdaq/oh_fw`
 14. Update the `*.bit` file symlink: `ln -sf OH_3.X.Y.{A|B|C}.bit optohybrid_top.bit`
 15. Update the `*.mcs` file symlink: `ln -sf OH_3.X.Y.{A|B|C}.mcs optohybrid_top.mcs`
 16. Navigate to the xml address table directory on the CTP7: `cd /mnt/persistent/gemdaq/xml`
 17. Update the optohybrid registers xml symlink: `ln -sf oh_registers_3.X.Y.xml optohybrid_registers.xml`
 18. Make sure the symlinks you created on the CTP7 in steps 14, 15 & 17 are valid,
 19. On the DAQ machine navigate to the `$GEM_ADDRESS_TABLE_PATH` (e.g. execute `cd /opt/cmsgemos/etc/maps`),
 20. Now update the optohybrid registers xml symlink: `ln -sf /data/bigdisk/GEMDAQ_Documentation/system/firmware/files/OptoHybrid/V3/OHv3b_firmware/OH_3.X.Y.{A|B|C}/oh_registers_3.X.Y.{A|B|C}.xml optohybrid_registers.xml`
 21. Make sure the symlink you created in step 20 is valid
 22. On the daq machine delete the pickle file found under `$GEM_ADDRESS_TABLE_PATH` (e.g. execute `rm /opt/cmsgemos/etc/maps/amc_address_table_top.pickle`).
 23. Create a new pickle file on the DAQ machine, to do this execute: `gem_reg.py`, this will automatically create a new pickle file under `$GEM_ADDRESS_TABLE_PATH`.  Then exit the tool by typing `exit`.
 24. Uploade the new pickle file to the CTP7: `scp /opt/cmsgemos/etc/maps/amc_address_table_top.pickle root@eagleXX:/mnt/persistent/gemdaq/xml/gem_amc_CTP7FW.3.A.B_OHFW3.X.Y.{A|B|C}.pickle` where 3.A.B is the CTP7 FW version and 3.X.Y is the OH FW version (for intergers `A`,`B`,`X` and `Y`.)
 25. As `root` on the CTP7 navigate to the xml address folder: `cd /mnt/persistent/gemdaq/xml`,
 26. As `root` open the pickle file with a text editor: `vi gem_amc_CTP7FW.3.A.B_OHFW3.X.Y.{A|B|C}.pickle`.
 27. AS `root` replace the third line of the pickle file:
```
q^A]q^B(]q^C(U^GGEM_AMCq^D(creg_utils.reg_interface.common.reg_xml_parser
```
to match:
```
q^A]q^B(]q^C(U^GGEM_AMCq^D(crw_reg
```
Note **do not copy paste this, you _must_ manually type it**.  If you copy/paste you may insert a hidden unicode character (e.g. newline) that will cause the file to **not** be parsed correctly and any register access action will fail.

 28. As `gemuser` on the CTP7 load the new OH FW into the CTP7 RAM by executing: 
```bash
cd /mnt/persistent/gemdaq/gemloader
./gemloader_configure.sh
```
 29. If the address space has changed you must update the `LMDB` on the CTP7, see [Updating the LMDB](#updating-the-lmdb).
 30. To confirm that the update was successful reprogram all optohybrids following instructions under [Programming OH FPGA](#programming-oh-fpga).
    - Note this will kill any running process on the hardware, but if you're updating FW no one should be using the system anyway.
 31.  Summarize the actions you took in the elog entry you have already opened.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Preparing For a Power Cut

In order to safely prepare a GEM test stand for a planned power cut execute:

 1. Power down the High Voltage.
     - Use the opportunity to power down other sensitive equipment, such as PMT's.
 2. Power down the Low Voltage.
 3. Place the µTCA modules in extraction mode:
     - Gently pull the hot swap tab on all AMC's, including the AMC13. Wait until the blue LED stays on solid on each AMC's.
     - Gently pull the hot swap tab on the MCH. Again, wait until the blue LED stays solid on.
 5. Power down the µTCA crate Power Modules one at a time. Find the AC/DC converters powering the PM's and turn them off one at a time. They can either be built in the crate or external to the crate. In the first case, a switch is present on the crate front panel.
 6. Finally, power off the DAQ computer.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Recovering From a Power Cut

To recover a GEM test stand after a power cut execute:

 1. Ensure the uTCA crate and associated hardware all have power.
     - E.g. the crate, network switches, DAQ computer, etc...
 2. Start the DAQ computer first, then:
     - Ensure that the `sysmgr`, `xinetd` and `dnsmasq` services are correctly started. You can use the `systemctl status <service name>` command to check each service status. The `Active` field must report `active (running)`.
     - If any of the services is not started, you can start it manually with the following command `sudo systemctl start <service name>`.
 3. Power on the µTCA crate. If the power cut was planned, undo the actions from the [previous section](#preparing-for-a-power-cut):
     - Power on the µTCA crate Power Modules one at a time.
     - Push the hot swap tab on the MCH and wait for the blue LED to turn off.
     - Push the hot swap tabs on the AMC's, including the AMC13, and wait for the blue LED's to turn off.
 4. Enter the AMC13 tool and enable clocks to the AMC of interest by following instructions under [Enabling Clock to an AMC Slot](#enabling-clock-to-an-amc-slot),
 5. For each CTP7 login as `texas` and execute: `killall rpcsvc`
     - Right now on boot the CTP7 linux core will start `rpcsvc` as the `texas` user and this is not gauranteed to have the correct `$ENV` for the `rpcmodules` on the card.
 6. For each CTP7 login as `gemuser` and execute the step: `recover.sh`
     - Check to make sure that all values in the `GTH Status` column are `0x7`.  If not you will need to [Reload the CTP7 FW](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#v3-hardware) until all `GTH Status` column values are `0x7`.
     - Check to make sure `rpcsvc` is running as `gemuser` by executing `ps | grep rpcsvc`.  If `rpcsvc` is not running launch it manually as `gemuser` by executing: `rpcsvc`
     - Check to make sure `ipbus` is running as `gemuser` by executing `ps | grep ipbus`.  If `ipbus` is not running launch it manually as `gemuser` by executing: `ipbus`.
 7. For each CTP7 from the DAQ machine try to read the FW address of the CTP7:
     - Execute: `gem_reg.py`
     - From inside the `gem_reg.py` tool execute: `connect eagleXX` where `XX` is the number of the CTP7 of interest
     - From inside the `gem_reg.py` tool execute: `kw RELEASE` this should display the FW release of the CTP7, if `0xdeaddead` are shown for any entries of the CTP7 registers (e.g. those lines that do _**not**_ have `OHX` in the name for `X` some integer) the CTP7 is not programmed correctly.

These instructions assume you are working with a system that is setup for v3 electronics.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Front-end Electronics
--------------------

## LV Power

Two LV settings are recommended depending on what equipment you have available.  If your power supply can go beyond 8V (e.g. A3016HP) then use `8V` at the LV terminals of the detector.  Here the system should draw ~3A when fully configured (VFATs in sleep mode) and increase to ~3.5A when VFATs are in run mode.

If your power supply cannot supply higher than 8V (e.g. A3016) than use 6.5V at the LV terminals of the detector.  Here the system will draw closer to ~5.5A when fully configured (VFATs in sleep mode) and move to ~6A when VFATs are placed in run mode.  Note the FEASTs here will be much less efficient and may overheat easily.  Normally this happens to the F1 and/or F2 FEASTs which respectively supply the FPGA core voltage or VTRx/VTTx power.  It's recommended to have a fan over these FEASTs and heat sinks on *all* FEASTs.

Note the voltage at the power supply will *not* be the voltage at the terminals, especially if your cable is long.  It is recommended to use a voltage drop compensating power supply with sense wires at the LV cable connector to the detector patch panel.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## FEASTMP

The [FEASTMP](https://project-dcdc.web.cern.ch/project-dcdc/public/Documents/FEASTMod_Datasheet.pdf) is a radiation hard DC-DC power converter used by many systems at CERN to convert high input voltage into low output voltage.  The GE1/1 design (both long & short detectors) each use 10 FEASTs:

- F1 1.0V powers FPGA core voltage
- F2 2.55V provides power to VTTx/VTRx,
- F3 1.55V provides power to GBTx and SCA chips,
- F4 1.86V provides power to EPROM (not loaded in OHv3c systems),
- F5 ???
- F6 ???
- FQA, FQB, FQC, FQD, 1.2V providing digital and analog power to 6 VFAT3s each.

Again it is recommended to apply heat sinks to *all* FEASTs and specifically to air cool with a fan F1 and F2.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## GBTx

The [GBTx](http://iopscience.iop.org/article/10.1088/1748-0221/10/03/C03034/meta) is a radiation hard gigabit transceiver for optical links which provides simultaneous transfer of readout data, timing and trigger signals, as well as slow control and monitoring information.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### E-link Assignment in GE1/1

For the GE1/1 optohybrid v3 (any version) the correspondence between vfat position by software (SW) number, vfat position by hardware (HW) number, GBTx number, and GBTx e-link number is given by the following table:

| VFAT Pos (SW) | VFAT Pos (HW) | GBTx | E-Link |
| :-----------: | :-----------: | :--: | :----: |
| 0  | 24 | 1 | 5 |
| 1  | 23 | 1 | 9 |
| 2  | 22 | 1 | 2 |
| 3  | 21 | 1 | 3 |
| 4  | 20 | 1 | 1 |
| 5  | 19 | 1 | 8 |
| 6  | 18 | 1 | 6 |
| 7  | 17 | 0 | 6 |
| 8  | 16 | 1 | 4 |
| 9  | 15 | 2 | 1 |
| 10 | 14 | 2 | 5 |
| 11 | 13 | 2 | 4 |
| 12 | 12 | 0 | 3 |
| 13 | 11 | 0 | 2 |
| 14 | 10 | 0 | 1 |
| 15 | 9  | 0 | 0 |
| 16 | 8  | 1 | 7 |
| 17 | 7  | 2 | 8 |
| 18 | 6  | 2 | 6 |
| 19 | 5  | 2 | 7 |
| 20 | 4  | 2 | 2 |
| 21 | 3  | 2 | 3 |
| 22 | 2  | 2 | 9 |
| 23 | 1  | 0 | 8 |

Please note that GBTx0 doesn't use all its e-links for VFAT communication as it is also responsible for SCA & FPGA communication on the optohybrid v3 (any version).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Programming GBTx

#### Via Dongle: `gbtProgrammer`

To program a GBTx using the USB dongle programmer ensure that the `I2C` jumper is enabled (e.g. closed circuit) then:

 1. launch the programmer software by executing `gbtProgrammer` from terminal, 
 2. an error window stating `No WindowsLookAndFeel` will pop up, this is normal, press "okay",
 3. if an error message loads after the main GUI loads stating: `No GBTX detected!` then execute the substeps here, if not proceed to step 4,
    - Close the programmer software, 
    - Disconnect the USB cable from the dongle (this ensures the dongle powers off), 
    - Reconnect the USB cable to the dongle (the light should blink), then
    - Repeat steps 1-3
 4. Press `Import i...` to import the configuration file, if a warning window pops up asking you to upgrade the dongle SW press `No`,
 5. In the open dialog box that loads change the `Files of Type` selection from `XML` to `txt`
 6. If you do not see the GBT configuration file you're looking for navigate to (on GEM 904 machines only):
    - `/data/bigdisk/GEMDAQ_Documentation/system/OptoHybrid/V3/GBT_Files/`
 7. Select the configuration file of interest note that files are named `GBTX_OHv3Y_GBT_Z_*.txt` where `Y = {a,b,c}` for optohybrid version and `Z = {0,1,2}` for GBTx index
    - Each GBTx will have a different configuration, additionally optohybrids on long & short detectors will also have a different configuration so you must select the right file for the corresponding hardware
 8. Press `Write GBTX`, finally
 9. Press `Read GBTX` if the readback state is anything but `idle 18h` then programming failed.

In some cases the readback state will read `idle 18h` but communication with the GBTx will not be good.  To check this:

 1. Navigate to the `Monitoring` tab,
 2. Press the `Monitor!` button, wait some time, the red and blue lines can take any values, but they must be *flat* and unchanging in time, if not, there’s a problem, then
 3. Stop monitoring by pressing `Monitor!` button again.

Note that while monitoring is running the USB cable will induce a large amount of noise into the front-end electronics.  This will be detected by scurves having a much larger width.  If monitoring is running, your noise will be higher and this can disturb data-taking.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

##### Manually Writing Charge Pump Current

Ask the sysadmin of your test stand if it is necessary to change the charge pump current value of the GBT after programming with the USB dongle, if so while having `gbtProgrammer` open execute:

 1. Navigate to the `Advanced mode` tab, 
 2. In the bottom right corner, insert `35` as `Register #` and the press `READ`.
 3. The correct value should be `F2` and usually it’s already in the register. 
 4. If it’s not, insert `F2` the click Write (hex) value, press `WRITE` and repeat step 2.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Over Fiber: `gbt.py`

To program the GBTx over the fiber link it must be at least minimally fused (so that it locks to the fiber link) and the `I2C` jumper for the GBTx in question must *not* be in place (e.g. open circuit).  Before proceeding please check that the GBTx communication is good by following instructions to check the GBTx status on a given ON under Section [GBT_READY Registers](#gbt_ready-registers).  Once communication is enabled exectue the following procedure:

1. login to the CTP7 of choice as `gemuser` (e.g. `ssh gemuser@eagle60`),
2. Once logged in, to configure GBT `X` of OH `Y` execute:
```
gbt.py Y X config <config file>
```

The GBTx will now be programmed. The GBT config files a CTP7 can be found under:

```
/mnt/persistent/gemdaq/gbt
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Performing a GBT Phase Scan

Again, the GBTx must be at least minimally fused (so that it locks to the fiber link) and the `I2C` jumper for the GBTx in question must *not* be in place (e.g. open circuit).  Before proceeding please check that the GBTx communication is good by following instructions to check the GBTx status on a given ON under Section [GBT_READY Registers](#gbt_ready-registers).  Once communication is enabled exectue the following procedure:

```
gbt.py Y X v3b-phase-scan <config file> 2>&1 | tee $HOME/oh_Y_gbt_X_phase_scan.txt
```

This will scan all phases for all e-links on this GBTx and report whether the phase is good (bad) if the `SYNC_ERR_CNT` of the VFAT on that e-link is `0x1` (`0x0`).  Note that while the above says `v3b-phase-scan` it is good for any v3 optohybrid version. The GBT config files a CTP7 can be found under:

```
/mnt/persistent/gemdaq/gbt
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Fusing

This can only be done with the USB dongle and this should be done only by true hardware experts with consent of GEM DAQ team (if you are wondering if you fall in this category it probably means you should not be fusing GBTs) as this process is irreversible and if done incorrectly could brick communication with one or more VFATs, the FPGA, or the entire front-end electronics. To fuse a GBTx launch the `gbtProgrammer` software and then execute the following procedure:

 1. `Import` config file,
 2. `Write GBT`,
 3. `Read GBT`,
 4. State should be `idle 18h`, if not stop and investigate,
 5. Go to `Monitoring` tab
 6. Press `Monitor!`, wait some time, the red and blue lines can take any values, but they must be “flat” and unchanging in time, if not, there’s a problem
 7. Stop monitoring (press `Monitor!` button a second time)
 8. Leave the `gbtProgrammer` window running
 9. In a separate terminal in `gem_reg.py` verify that the `GBT_READY` register of this GBTx is `0x1`, 
 10. Issue a link reset then read the errors flags for this GBTx (NOT ready, was not ready) to ensure they are `0x0`,
 11. Check that `SYNC_ERR_CNT` of all VFATs on this GBTx are `0x0` and the counters do not roll up,
     - See [E-link Assignment in GE1/1](#e-link-assignment-in-ge11) for GBTx-VFAT correspondence
 12. Check that you have slow control with all VFATs on this GBTx by executing `kw CFG_RUN <OH Number>` only `0x0` should be returned for the VFATs on this GBTx, if not there is a problem,
     - In rare cases `SYNC_ERR_CNT` are all `0x0` but VFAT communication is dead),
 13. Go back to the `gbtProgrammer` window,
 14. Go to the `Fuse My GBT` tab,
 15. Click `Update view`,
 16. Make sure all rows in the table are green,
     - The last row is a test register and it’s okay if it’s red,
 17. Click `Select non zero val…`
 18. Check the `enable…` box inside the `Fuse GBTX` box, this enables fusing,
 19. Check the `fuse upda…` check box inside the `Fuse GBTX` box, this fuses the GBTx such that after power on reset it loads it’s fuse settings (not doing this means fusing was useless :D),
 20. Click `Fuse` button in the `Fuse GBTX` box,
 21. Close the `gbtProgrammer` software,
 22. Power off the OHv3,
 23. Leaving the USB dongle connected to the GBTx of your OHv3, disconnect the usb cable from the dongle,
     - Failure to do this will leave the GBTx partially powered from the USB cable and result in a "funky” unusable state,
 24. Power on the OHv3,
 25. Plug the USB cable back into the dongle,
 26. Launch `gbtProgrammer`,
 27. Import the config file that you used for fusing,
 28. Click `Read GBTx` and check state is `idle 18h`,
 29. Go to the `Fuse My GBTx` tab,
 30. Click `Update View`, then
 31. Check if all rows in table are green (it could be that the last row is red…it’s okay if it’s only this one).

The GBTx is now fused.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### GBT_READY Registers

There are a set of registers for each optohybrid in the CTP7 FW that provide information about the GBTx status.  To read these reigsters for the X^th optohybrid from `gem_reg.py` execute:

```
kw OH_LINKS.OHX.GBT
```

For example a healthy set of GBTx chios would have the GBT ready register as `0x1` and all the error registers as `0x0`:

```
eagle60 > kw OH_LINKS.OH1.GBT
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT0_READY                         0x00000001
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT1_READY                         0x00000001
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT2_READY                         0x00000001
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT0_WAS_NOT_READY                 0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT1_WAS_NOT_READY                 0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT2_WAS_NOT_READY                 0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT0_RX_HAD_OVERFLOW               0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT1_RX_HAD_OVERFLOW               0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT2_RX_HAD_OVERFLOW               0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT0_RX_HAD_UNDERFLOW              0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT1_RX_HAD_UNDERFLOW              0x00000000
0x65800800 r    GEM_AMC.OH_LINKS.OH1.GBT2_RX_HAD_UNDERFLOW              0x00000000
```

If `GBTY_READY` is not `0x1` or `GBTY_WAS_NOT_READY` stays `0x1` after [Issuing a GBT Link Reset](#issuing-a-gbt-link-reset) then your communication is probably *not* good.  Check the following:

 - The electronics are powered,
 - The TX from the CTP7 to the GBTx is going into the left position (OH is oriented with FPGA facing you and VTTx/VTRx are pointing towards the floor) of the VTRx that corresponds to this GBTx, or
 - The TX from the GBTx to the CTP7 makes it to the CTP7 fiber patch panel.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Issuing a GBT Link Reset

To reset the GBT links and send the VFAT synchronization command execute:

```
write GEM_AMC.GEM_SYSTEM.CTRL.LINK_RESET 0x1
```

If your GBTx communication is stable this will reset the following registers to `0x0`:

 - `GBTY_WAS_NOT_READY`,
 - `GBTY_RX_HAD_OVERFLOW`,
 - `GBTY_RX_HAD_UNDERFLOW`, and
 - `SYNC_ERR_CNT`.

This will be applied to all optohybrids and VFATs on the CTP7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Slow Control ASIC (SCA)

### Voltage & Temperature Monitoring
"Comming to a guide near you soon"

### The `sca.py` Tool

The `sca.py` is a command line tool for sending a variety of commands to the SCA.  For a description of the possible commands and their calling syntax execute `sca.py -h` for more information.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Issuing an SCA Reset

To issue an SCA reset execute the following from the DAQ PC:

```bash
sca.py r cardName ohMask
```

For example:

```bash
sca.py r eagle60 0x3
```

This will issue an SCA reset to OH's 0 and 1 on `eagle60`.

If a red error message appears for one or more of the OH's in your `ohMask` re-issue the SCA reset until no red error messages appear. For subsequent SCA resets issued in this way you can use the same `ohMask` or modify it to remove the healthy OH's.  If continuing to issue an sca reset does not resolve the issue (i.e. red error messages continue to appear) there is a problem and you probably lost communication.  In this case check the status of `GBT0` on each of the problem GBTs using instructions under [GBT_READY Registers](#gbt_ready-registers), if GBTX is either not ready or was not ready you may need to either issue a GBTx link reset (see [Issuing a GBT Link Reset](#issuing-a-gbt-link-reset)), re-program GBT0 (see [Programming GBTx](#programming-gbtx)), or in rare cases power cycle and start from scratch.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Checking SCA Status

There are two registers of great importance for checking SCA communication.  They are:

```
GEM_AMC.SLOW_CONTROL.SCA.STATUS.READY
GEM_AMC.SLOW_CONTROL.SCA.STATUS.CRITICAL_ERROR
```

Each is a 12 bit register with the N^th bit corresponding to the N^th optohybrid.  In the case of `READY` if the N^th bit is raised high (e.g. it equals 1) it means the link is ready and communication is most likely stable (although in some cases the READY bit for a given optohybrid is 1 but slow control is not possible).  In the case of `CRITICAL_ERROR` if the N^th bit is raised high (e.g. it equals 1) it means the SCA controller on the N^th optohybrid has encountered a critical error and needs an SCA reset.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Using `amc_info_uhal.py`

You can get the SCA status on all optohybrids on a CTP7 from `amc_info_uhal.py` command.  Execute:

```bash
amc_info_uhal.py --shelf=X -sY
```

The relevant SCA output for all optohybrids on the CTP7 in slot `Y` of shelf `X` will look like:

```bash
--=======================================--
-> GEM SYSTEM SCA INFORMATION
--=======================================--

READY             0x000003fc
CRITICAL_ERROR    0x00000000
NOT_READY_CNT_OH00 0x00000001
NOT_READY_CNT_OH01 0x00000001
NOT_READY_CNT_OH02 0x00000002
NOT_READY_CNT_OH03 0x00000002
NOT_READY_CNT_OH04 0x00000002
NOT_READY_CNT_OH05 0x00000002
NOT_READY_CNT_OH06 0x00000002
NOT_READY_CNT_OH07 0x00000002
NOT_READY_CNT_OH08 0x00000002
NOT_READY_CNT_OH09 0x00000002
NOT_READY_CNT_OH10 0x00000001
NOT_READY_CNT_OH11 0x00000001
```

Note that `ipbus` service must be running on the CTP7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Using `gem_reg.py`

You can get the SCA status on all optohybrids on a CTP7 from `gem_reg.py` using the following command, with example output:

```
eagleXX > rwc SCA*READY
0x66c00400 r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.READY                   0x00000002
0x66c00408 r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.NOT_READY_CNT_OH0       0x00000001
0x66c0040c r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.NOT_READY_CNT_OH1       0x00000002
0x66c00410 r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.NOT_READY_CNT_OH2       0x00000001
0x66c00414 r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.NOT_READY_CNT_OH3       0x00000001
eagle60 > read GEM_AMC.SLOW_CONTROL.SCA.STATUS.CRITICAL_ERROR
0x66c00404 r    GEM_AMC.SLOW_CONTROL.SCA.STATUS.CRITICAL_ERROR          0x00000000
```

Here we see that SCA READY is `0x2` so only OH1 has stable communication and no links are in error (critical error is `0x0`).

Note that `rpcsvc` must be running on the CTP7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### VFAT Reset Lines

In the OHv3c version the VFAT reset lines are controlled by the SCA and not the OH FPGA.  In CTP7 firmware versions higher than 3.5.2 the resets will automatically be lifted and no user action is required.  On older CTP7 FW versions to lift the VFAT resets first program the OHv3c FPGA following instructions under Section [Programming OH FPGA](#programming-oh-fpga) then execute:

 1. From the DAQ machine execute `sca.py eagleXX ohMask gpio-set-direction 0x0fffff8f`,
 2. From the DAQ machine execute `sca.py eagleXX ohMask gpio-set-output 0xf00000f0`,
 3. from the DAQ machine send a GBTx link reset, see Section [Issuing a GBT Link Reset](#issuing-a-gbt-link-reset),
 4. Then check the status of the GBT's in `gem_reg.py` (`kw OH_LINKS.OH0.GBT`),
 5. Report the status of link good of all VFATs (`kw LINK_GOOD 0`),
 6. Report the status of sync error counters of all VFATs (`kw SYNC_ERR_CNT 0`),
 7. Check for slow control of al VFATs (`kw CFG_RUN 0`)

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Optohybrid (OH) FPGA

Unlike the OHv2b the OHv3 FPGA is not responsible for slow control or data transfer of tracking data from the VFATs.  The OHv3 deals only with sending the VFAT trigger data to the CSC TMB and GEM CTP7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Programming OH FPGA

To program the FPGA we recommend the "PROM-less" or `BLASTER(tm)` method.  To program the OH FPGA execute the following:

 1. Power the LV,
 2. Program all GBTs on the OHv3 via one of the methods under [Programming GBTx](#programming-gbtx),
    - In the rare case that the GBTx's on your OH are fully fused proceed to step 3
 3. Issue an sca reset following instructions under [Issuing an SCA Reset](#issuing-an-sca-reset),
 4. From `gem_reg.py` on the DAQ PC connect to the CTP7 of interest with `connect eagleXX` and then enable the TTC generator via `write GEM_AMC.TTC.GENERATOR.ENABLE 1`,
 5. From `gem_reg.py` send a single TTC hard reset to program the FPGA with the `BLASTER(tm)` via `write GEM_AMC.TTC.GENERATOR.SINGLE_HARD_RESET 1`
    - Note this will issue this reset to *all* optohybrids on this CTP7 which *will* stop any existing data taking, crashing any scans, and wipe out any present configuration
 6. Check that the FW is loaded into all optohybrids present by following instructions at [Checking Firmware Version],
 7. From `gem_reg.py` disable the TTC generator via `write GEM_AMC.TTC.GENERATOR.ENABLE 0`,
    - This is important, while the TTC generator is enabled the CTP7 will *ignore* all TTC commands from the backplane

If you see in step 6 that the FW is not loaded in any of the optohybrids of interest (or you where expecting a different OH FW version) it is likely that either the OH FW is *not* loaded into the CTP7 RAM or that a different version of OH FW is loaded into the CTP7 RAM.  To resolve this login to the CTP7 and execute:

```bash
cd /mnt/persistent/gemdaq/gemloader
./gemloader_configure.sh
```

Then repeat step 5 again.  Note sometimes the OH FW does not load successfully into the CTP7 RAM and the call of `gemloader_configure.sh` must be repeated several times.  If however after this the FW is not loading onto one or more optohybrids check to make sure you have communication with the SCA of interest by following instructions under Section [Checking SCA Status](#checking-sca-status).  If you're SCA communication is good and the FW is still not loading double check that the TTC Generator is enabled by reading the value of the `GEM_AMC.TTC.GENERATOR.ENABLE`.  If the TTC Generator is enabled, the SCA status is good, and the OH FW is in the CTP7 RAM check to make sure GBT0 is still good, see [GBT_READY Registers](#gbt_ready-registers).  If GBT0 is no longer good then programming the FPGA will not be possible (as this is through GBT0).  In this case you may need to start the procedure again from step 1.  One final check would be to ensure the CTP7 Mapping register has the correct value, see [Checking CTP7 Mapping Register](#checking-ctp7-mapping-register).

If after all these you are still *unable* to program the FPGA the linux image of your CTP7 may be to old, contact your test stand's sysadmin.  Although typically this is not the case.

Failure to program the FPGA in our experience usually comes from:

 1. Hardware problem,
 2. Failure to execute the procedure in the correct order

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Checking Trigger Link Status

To check the status of the OH-CTP7 trigger link for OHY execute:

```
kw GEM_AMC.TRIGGER.OHY.LINK
```

Where `Y` is an integer representing the OH number.  A healthy link should come back as:

```
eagleXX > kw GEM_AMC.TRIGGER.OHY.LINK
0x66000e80 r    GEM_AMC.TRIGGER.OHY.LINK0_SBIT_OVERFLOW_CNT             0x00000000
0x66000e80 r    GEM_AMC.TRIGGER.OHY.LINK1_SBIT_OVERFLOW_CNT             0x00000000
0x66000e84 r    GEM_AMC.TRIGGER.OHY.LINK0_MISSED_COMMA_CNT              0x00000000
0x66000e84 r    GEM_AMC.TRIGGER.OHY.LINK1_MISSED_COMMA_CNT              0x00000000
0x66000e8c r    GEM_AMC.TRIGGER.OHY.LINK0_OVERFLOW_CNT                  0x00000000
0x66000e8c r    GEM_AMC.TRIGGER.OHY.LINK1_OVERFLOW_CNT                  0x00000000
0x66000e90 r    GEM_AMC.TRIGGER.OHY.LINK0_UNDERFLOW_CNT                 0x00000000
0x66000e90 r    GEM_AMC.TRIGGER.OHY.LINK1_UNDERFLOW_CNT                 0x00000000
0x66000e94 r    GEM_AMC.TRIGGER.OHY.LINK0_SYNC_WORD_CNT                 0x00000000
0x66000e94 r    GEM_AMC.TRIGGER.OHY.LINK1_SYNC_WORD_CNT                 0x00000000
``` 

If your link does not look like the above the link is not healthy.  First try reseting the counters and then reading them again by executing:

```
write GEM_AMC.TRIGGER.CTRL.CNT_RESET  1
kw GEM_AMC.TRIGGER.OHY.LINK
```

If your link still does not match the example above try the following:

 1. If the trigger fiber is accessible as a stand alone fiber (e.g. not in an MTP12 bundle) check that there is red light in both ends of the fiber coming from the OHv3. If so issue a reset, if not
    - the board may not be on,
    - the fiber may be faulty,
    - the VTTx may be faulty, or
    - the VTTX may not be receiving the correct voltage, check that the 2.5V pin on the OH; with no load it should be between [2.45, 2.66]V.
 2. Try reloading the firmware to the OHv3 by following instructions under Section [Programming OH FPG], in rare cases the Trigger block of the OH FW does not start properly.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Masking VFATs From Trigger

You can write a 24 bit mask to `GEM_AMC.OH.OHX.FPGA.TRIG.CTRL.VFAT_MASK` to mask a given set of VFATs from the trigger, having a 1 in the N^th bit means the N^th VFAT will be masked.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Temperature Monitoring

The OH has the FPGA core temperature accessible from the sysmon registers in the OHv3 address table and nine PT100 sensors located around the board.  These PT100 sensors are read by the SCA when monitoring is enabled, see [Voltage & Temperature Monitoring].

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## VFAT3

For an indepth guide on the VFAT3 please consult the VFAT3 Manual availabe [here](https://espace.cern.ch/cms-project-GEMElectronics/VFAT3/Forms/AllItems.aspx).  The VFAT3 is a much more complicated ASIC than VFAT2 and requires a little bit more knowledge to successfully use.  While the VFAT3 manual should serve as the end-all-be-all reference on the ASIC here we present some useful information.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### General Overview of VFAT3

The VFAT3 has three gain settings of it's preamplifier (low, medium, high), two comparator modes ("arming", aka leading-edge, or CFD), several shaping times, two on ASIC 10-bit ADC's for DAC monitoring, and an internal temperature sensor.  For the chip to function correctly and for all bias currents/voltages to be set properly the `CFG_IREF` value must be set such that the reference current is 10 uA. The VFAT3 team has calibration each chip and determined this value for us.  So all we need to do is to use this the provided value.  However this value is unique per each VFAT and care should be taken to ensure it is properly assigned.

The VFAT3 also has a hardware e-fuse which specifies the unique chip ID as a 32-bit integer.  In GE1/1 values 0 to 5000 are expected.

You can change the gain settings of the preamp by writing the following set of registers:

```
#High VFAT3 preamp gain                                                                                                                                                                                               
CFG_RES_PRE = 1
CFG_CAP_PRE = 0
#Medium VFAT3 preamp gain
CFG_RES_PRE = 2
CFG_CAP_PRE = 1
#Low VFAT3 preamp gain
CFG_RES_PRE = 4
CFG_CAP_PRE = 3 
```

It is recommended to use the medium preamp gain setting as it was shown that the high gain setting causes strange behavior due to either saturation, after pulsing, or cross-talk.  To switch the comparator modes write teh following set of registers:

```
#Comparator Mode - CFD
CFG_SEL_COMP_MODE = 0
CFG_FORCE_EN_ZCC = 0
#Comparator Mode - ARM
CFG_SEL_COMP_MODE = 1
CFG_FORCE_EN_ZCC = 0
```

It is recommended to use the comparator in CFD mode. If using the comparator in CFD mode than the shaping time should be set to the maximum to try to integrate the full pulse charge for the CFD technique. If the comparator is used in arming mode than the shaping time should be set to the minimum to trigger the comparator as fast as possible (when pulse is over threshold).  These two can be accomplished via:

```
# For comparator in CFD mode
CFG_FP_FE = 0x7
CFG_PT = 0xf
# For comparator in arming mode
CFG_FP_FE = 0x0
CFG_PT = 0x1 
```

The calibration module can inject charge either in current injection of voltage step pulsing.  Both modes use the same circuit but are compliments of one and other (e.g. high current injection is low voltage step).  From s-curve results in the lab we have not see a difference between these two modes and voltage step pulsing is typically used by default.

Both the comparator and the calibration module can be configured to look at (inject) either positve or negative polarity pulses.  For calibration scans to be effective the polarity of the calibration module must match the polarity expected by the comparator.  Additionally during data taking the polarity the comparator should match the polarity of the GEM signal (i.e. negative polarity).  To ensure there are no mistakes both polarities are set such that:

```
CFG_SEL_POL = 0x1
CFG_CAL_SEL_POL = 0x1
```

To ensure proper temperature reading and any DAC monitoring the `CFG_VREF_ADC` must be set such that this is as close to 1.0V as possible (again provided by VFAT3 team at production time).  The `HV3b_V2` hybrids only have the internal temperature sensor on the VFAT3 ASIC while `HV3b_V3` and `V4` hybrids have an external PT100 sensor for monitoring temperature.

The comparator has two voltage DAC registers for specifying the voltage on the comparator (note this should *not* be confused with the threshold, that's the 50% point on an scurve where the channel responds to charge 50% of the time at fixed comparator voltage setting).  One value is the `CFG_THR_ARM_DAC` and the other is the `CFG_THR_ZCC_DAC`.  The later must be calibrated for proper channel trimming; the former is of little concern since this is not used in either arming or CFD comparator modes.  For more details on comparator voltage settings see the VFAT3 manual.

Finally there are a few calibration coefficients that are needed:

- `CAL_DACM`, slope in `y=mx+b` for converting `CFG_CAL_DAC` to `fC`,
- `CAL_DACB`, as `CAL_DACM` but for intercept,
- `ADC0M`, slope in `y=mx+b` for converting ADC counts to `mV` for ADC0,
- `ADC0B`, as `ADC0M` but for intercept,
- `ADC1M`, as `ADC0M` but for `ADC1`,
- `ADC1B`, as `ADC0B` but for `ADC1`,
- `CAL_THR_ARM_DAC_M`, slope in `y=mx+b` for converting `CFG_THR_ARM_DAC` to `fC` (needed for trimming),
- `CAL_THR_ARM_DAC_B`, as `CAL_THR_ARM_DAC_M` but for intercept.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### DAC Monitoring

The VFAT3 has two internal 10 bit SAR ADCs.  They each use two difference voltage references:

 - `ADC0` uses the internal reference derived from the bandgap,
 - `ADC1` uses an external reference tied to the input digital voltage (DVDD)

These can monitor the following values:

|   Monitor Sel |   State   |   Register Name VFAT3 Manual  |   Bits    |   Min |   Max |   Register Name GEM XML Address Table |   Note    |
|   :---------: |   :---:   |   :------------------------:  |   :--:    |   :-: |   :-: |   :---------------------------------: |   :---    | 
|   1   |   Calib IDC   |   GBL_CFG_CAL_0   |   [9:2]   |   0   |   0xff    |   CFG_CAL_DAC   |       |
|   2   |   Preamp InpTran  |   GBL_CFG_BIAS_1  |   [7:0]   |   0   |   0xff    |   CFG_BIAS_PRE_I_BIT  |       |
|   3   |   Pream LC    |   GBL_CFG_BIAS_2  |   [13:8]  |   0   |   0x3f    |   CFG_BIAS_PRE_I_BLCC |       |
|   4   |   Preamp FC   |   GBL_CFG_BIAS_1  |   [13:8]  |   0   |   0x3f    |   CFG_BIAS_PRE_I_BSF  |       |
|   5   |   Shap FC |   GBL_CFG_BIAS_3  |   [15:8]  |   0   |   0xff    |   CFG_BIAS_SH_I_BFCAS |       |
|   6   |   Shap Inpair |   GBL_CFG_BIAS_3  |   [7:0]   |   0   |   0xff    |   CFG_BIAS_SH_I_BDIFF |       |
|   7   |   SD Inpair   |   GBL_CFG_BIAS_4  |   [7:0]   |   0   |   0xff    |   CFG_BIAS_SD_I_BDIFF |       |
|   8   |   SD FC   |   GBL_CFG_BIAS_5  |   [7:0]   |   0   |   0xff    |   CFG_BIAS_SD_I_BFCAS |       |
|   9   |   SD SF   |   GBL_CFG_BIAS_5  |   [13:8]  |   0   |   0x3f    |   CFG_BIAS_SD_I_BSF   |       |
|   10  |   CFD Bias1   |   GBL_CFG_BIAS_0  |   [5:0]   |   0   |   0x3f    |   CFG_BIAS_CFD_DAC_1  |       |
|   11  |   CFD Bias2   |   GBL_CFG_BIAS_0  |   [11:6]  |   0   |   0x3f    |   CFG_BIAS_CFD_DAC_2  |       |
|   12  |   CFD Hyst    |   GBL_CFG_HYS |   [5:0]   |   0   |   0x3f    |   CFG_HYST    |       |
|   13  |   CFD Ireflocal   |   -   |   -   |   -   |   -   |   -   |   Fixed value, no register    |
|   14  |   CFD ThArm   |   GBL_CFG_THR |   [7:0]   |   0   |   0xff    |   CFG_THR_ARM_DAC |       |
|   15  |   CFD ThZcc   |   GBL_CFG_THR |   [15:8]  |   0   |   0xff    |   CFG_THR_ZCC_DAC |       |
|   16  |   SLVS Ibias  |   GBL_CFG_BIAS_6  |   [11:6]  |   0   |   0xff    |   ?   |   Does not appear in Section 7.5 Registers    |
|   32  |   BGR |   -   |   -   |   -   |   -   |   -   |   Fixed value, no register    |
|   33  |   Calib Vstep |   GBL_CFG_CAL_0   |   [9:2]   |   0   |   0xff    |   CFG_CAL_DAC   |       |
|   34  |   Preamp Vref |   GBL_CFG_BIAS_2  |   [7:0]   |   0   |   0xff    |   CFG_BIAS_PRE_VREF   |       |
|   35  |   Vth Arm |   GBL_CFG_THR |   [7:0]   |   0   |   0xff    |   CFG_THR_ARM_DAC |       |
|   36  |   Vth ZCC |   GBL_CFG_THR |   [15:8]  |   0   |   0xff    |   CFG_THR_ZCC_DAC |       |
|   37  |   V Tsens Int |   -   |   -   |   -   |   -   |   -   |   Fixed value, no register    |
|   38  |   V Tsens Ext |   -   |   -   |   -   |   -   |   -   |   Fixed value, no register    |
|   39  |   ADC_Vref    |   GBL_CFG_CTR_4   |   [9:8]   |   0   |   0x3 |   CFG_ADC_VREF    |       |
|   40  |   ADC VinM    |   -   |   -   |   -   |   -   |   -   |   Fixed value, no register    |
|   41  |   SLVS Vref   |   GBL_CFG_BIAS_6  |   [5:0]   |   0   |   0x3f    |   ?   |   Does not appear in Section 7.5 Registers    |

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Checking VFAT Registers

Presently `vfat_info_uhal.py` does not have functionality for monitoring v3 electronics.  In the meantime you can get information on VFATY of OHX from `gem_reg.py` by executing:

```
kw GEM_AMC.OH.OHX.GEB.VFATY.CFG_
read GEM_AMC.OH.OHX.GEB.VFATY.HW_CHIP_ID
```

This will print the values of all global registers for this vfat.  Information about the channel register for channel `Z` can be obtained via:

```
kw GEM_AMC.OH.OHX.GEB.VFATY.VFAT_CHANNELS.CHANNELZ
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Checking VFAT Synchronization

To check if the VFATs are synchronized on OHY from `gem_reg.py` execute:

```
kw SYNC_ERR_CNT Y
kw CFG_RUN Y
```

Where `Y` is an integer representing the OH number.  Any VFAT whose sync error counter is non-zero implies non-stable communication.  In rare cases the sync error counters can all be `0x0` but communication may still not be good (i.e. you're on the edge of a good/bad phase for that GBT elink).  This is what the second keyword read (`kw`) is for checking, it is a slow control command to the VFATs directly.  If `0xdeaddead` is returned for any `CFG_RUN` value this indicates you do not have good communication.  

Typical causes of bad communication are:

 - the vfat is not physically present on the hardware,
 - the gbt phase setting for that e-link is bad, or
 - there is a problem with the hardware (VFAT, OH, or GEB).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Configuration File on CTP7

The `confChamber.py` tool, see [Configuring a Detector](#configuring-a-detector), can be used to apply a common DAC setting to *all* VFATs for a given register.  

The script `replace_paramater.sh` can be used to apply a unique, per VFAT, value to a given register. The script must be run as user `gemuser` on the ctp7 in order to have permission to edit the configuration files. The per VFAT mode of the script is invoked with
```
./replace_parameter.sh -f <FILENAME> <REGISTER> <LINK>
```
where the input file format is the same as the output of `anaDACScan.py`. As an example
```
./replace_parameter.sh -f ~/NominalDACValues_GE11-X-S-INDIA-0002/2018.10.31.14.27/NominalDACValues.txt BIAS_PRE_VREF 0
```
will cause each line of the file ` ~/NominalDACValues_GE11-X-S-INDIA-0002/2018.10.31.14.27/NominalDACValues.txt` to be parsed, and if, for example, one line of the file is `6 102`, then the value of the register `BIAS_PRE_VREF` will be replaced by `102` in the config file for VFAT `6`.

The VFAT configuration files can also be manually edited, an example is shown below:

```bash
eagle26:/mnt/persistent/gemdaq$ more vfat3/config_OH3_VFAT9_cal.txt
dacName/C:dacVal/I
PULSE_STRETCH           7
SYNC_LEVEL_MODE         0
SELF_TRIGGER_MODE       0
DDR_TRIGGER_MODE        0
SPZS_SUMMARY_ONLY       0
SPZS_MAX_PARTITIONS     0
SPZS_ENABLE             0
SZP_ENABLE              0
SZD_ENABLE              0
TIME_TAG                0
EC_BYTES                0
BC_BYTES                0
FP_FE                   7
RES_PRE                 1
CAP_PRE                 0
PT                     15
EN_HYST                 1
SEL_POL                 1
FORCE_EN_ZCC            0
FORCE_TH                0
SEL_COMP_MODE           1
VREF_ADC                3
MON_GAIN                0
MONITOR_SELECT          0
IREF                   32
THR_ZCC_DAC            10
THR_ARM_DAC           200
HYST                    5
LATENCY                45
CAL_SEL_POL             1
CAL_PHI                 0
CAL_EXT                 0
CAL_DAC               200
CAL_MODE                1
CAL_FS                  0
CAL_DUR               200
BIAS_CFD_DAC_2         40
BIAS_CFD_DAC_1         40
BIAS_PRE_I_BSF         13
BIAS_PRE_I_BIT        150
BIAS_PRE_I_BLCC        25
BIAS_PRE_VREF          86
BIAS_SH_I_BFCAS       250
BIAS_SH_I_BDIFF       150
BIAS_SH_I_BFAMP         0
BIAS_SD_I_BDIFF       255
BIAS_SD_I_BSF          15
BIAS_SD_I_BFCAS       255
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Building GEM Software
--------------------
Building CMS GEM Online software is *only* supported on GEM DAQ 904 machines.
Please note that you need to set the `BUILD_HOME` environment variable before building. Set this to be the folder in which you git clone `cmsgemos`. For example using bash: `export BUILD_HOME=~/Path/To/Folder`.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Build Prerequisites: The gembuild repo

For *all* repositories *except* `cmsgemos` you'll need to get the `config/` directory from the `gembuild` repository.  To do this once you've cloned the repository of interest execute:

```bash
cd <repo folder>
git submodule init
git submodule update
```

periodically the `gembuild` repository may change and you may need to update the `config` folder in your local versions, to do this execute:

```bash
cd <repo folder>
git submodule update
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## `cmsgemos`

### Compiling the entire framework

To do a complete compile execute:

```bash
cd cmsgemos
source setup/etc/profile.d/gemdaqenv.sh
git tag <tag number>
make clean -j8 && make cleanrpm -j8
make debug -j8
make rpm
```

For each subpackage you will find both a `*.rpm` and a `*.tgz` file inside an `rpm/` subdirectory inside the subdirectory.  For example for `gempython` you'll find under `cmsgemos/gempython/rpm` many files, but the most recent versions of the following files:

```bash
-rw-r--r--. 1 user group  49K Sep 19 11:18 cmsgemos_gempython-*.tgz
-rw-r--r--. 1 user group 2.1K Sep 19 11:18 cmsgemos_gempython-debuginfo-*.cc7.python2.7.x86_64.rpm
-rw-r--r--. 1 user group 106K Sep 19 11:18 cmsgemos_gempython-*.cc7.python2.7.x86_64.rpm
```

will be of interest to you.  The wildcard `*` will have the information on the tag number (for the `*.tgz file) and tag number plus git commit (for `*.rpm` files).

The `*.rpm` file can be installed on a DAQ machine, or upgrade an existing installed version (assuming the tag number is higher than the existing installed version), with `yum` and in the case of `gempython` a `*.tgz` file which can be installed into a python `virtualenv` with `pip`.

If you are generating an installable `rpm` for a DAQ machine it's best to check with `GEM RC` what tag should be used. 

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Compiling Only `gempython`

In many cases you will be interested in only compiling `gempython` to do this execute:

```bash
cd cmsgemos
source setup/etc/profile.d/gemdaqenv.sh
git tag <tag number>
make clean
make gempython
cd gempython
make rpm
```

If you are generating an installable `rpm` for a DAQ machine it's best to check with `GEM RC` what tag should be used. 

If you are not interested in generating the `rpm` you can substitute `make pip` for the last line.  To install this into your `virtualenv` after activating your `venv` execute:

```bash
pip install cmsgemos/gempython/rpm/cmsgemos_gempython-<version>.tgz --no-deps
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Configuring your `$ENV` for testing

It's important to keep in mind `cmsgemos` has several dependencies which you may be required to set by hand.  If you are looking to test changes to only `cmsgemos` or some SW package "downstream" of cmsgemos (e.g. `vfatqc-python-scripts`) then you may use the system installed dependencies.  If you have already configured your `virtualenv` with the installed packages then you can either setup the `$ENV` by hand, or you can use the [setup_gemdaq.sh](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/scripts/setup_gemdaq.sh) script via:

```bash
cd <your working directory>
source setup_gemdaq.sh
```

Note if this is your first time calling `setup_gemdaq.sh` please first call the help menu to see how to setup a `virtualenv` using this script.  An example is presently provided [here](https://github.com/cms-gem-daq-project/gem-plotting-tools#setup); in this example a `python` `virtualenv` will be setup and the `cmsgemos_gempython` and `gempython_gemplotting` packages will be installed inside of it.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## `ctp7_modoules`

Execute:

```bash
export LD_LIBRARY_PATH=/opt/xdaq/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/wiscrpcsvc/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/rwreg/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/xhal/lib:$LD_LIBRARY_PATH
export PETA_STAGE=/data/bigdisk/sw/peta-stage/
source /data/bigdisk/sw/Xilinx/SDK/2016.2/settings64.sh
export XHAL_ROOT=$BUILD_HOME/xhal/
cd ctp7_modules/
make clean && make rpm
```

You will create `*.rpm` files in the following subdirectories:

```
ctp7_modules/rpm
```

This will also compile the shared object libraries (e.g. `rpcmodules`) under the subdirectory:

```
ctp7_modules/lib
```

These `*.so` files can be uploaded to the `CTP7` by the test stand sysadmin (for production test stands) or developers (for development test stands).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## `gem-plotting-tools`

Execute the following:

```bash
cd gem-plotting-tools
git tag <tag number>
make clean && make rpm
```

this will generate the following files:

```bash
% ll gem-plotting-tools/rpm
-rw-r--r--. 1 user group 226K Mar 12 13:55 gempython_gemplotting-*.tgz
-rw-r--r--. 1 user group 308K Mar 12 13:55 gempython_gemplotting-*.src.rpm
-rw-r--r--. 1 user group 320K Mar 12 13:55 gempython_gemplotting-*.noarch.rpm
```

The wildcard `*` will have the information on the tag number (for the `*.tgz` file) and tag number plus git commit (for `*.rpm` files).  The `rpm` can be used to install the `gemplotting` package onto your DAQ machine or upgrade an existing version (assuming the tag number is higher than the existing version).  The `*.tgz` file can be used to install the `gemplotting` package into your `virtualenv` by executing:

```bash
pip install -U gem-plotting-tools/rpm/gempython_gemplotting-<tag number>.tgz
```

Note it is assumed you've already activated your `virtualenv`

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## `vfatqc-python-scripts`

Execute the following:

```bash
cd vfatqc-python-scripts
git tag <tag number>
make clean && make rpm
```

Note branches deriving from `rpc-playground` presently require their tag to be set manually in `vfatqc-python-scripts/Makefile` and are not correctly picked up from the `git` tag number, look for lines:

```
VFATQC_VER_MAJOR=X
VFATQC_VER_MINOR=Y
VFATQC_VER_PATCH=Z
``` 

this will generate the following files:

```bash
% ll vfatqc-python-scripts/rpm 
-rw-r--r--. 1 user group  42K Sep 19 11:56 gempython_vfatqc-*.tar.gz
-rw-r--r--. 1 user group 1.9K Sep 19 11:56 gempython_vfatqc-debuginfo-*centos7.python2.7.x86_64.rpm
-rw-r--r--. 1 user group  89K Sep 19 11:56 gempython_vfatqc-*centos7.python2.7.x86_64.rpm
```

The wildcard `*` will have the information on the tag number (for the `*.tar.gz` or `*.tgz` file) and tag number plus git commit (for `*.rpm` files).  The `rpm` can be used to install the `vfatqc` package onto your DAQ machine or upgrade an existing version (assuming the tag number is higher than the existing version).  The `*.tar.gz` or `*.tgz` file (you may only see one depending on which branch you are developing from, `develop` or `rpc-playground`) can be used to install the `vfatqc` package into your `virtualenv` by executing:

```bash
pip install -U vfatqc-python-scripts/rpm/gempython_vfatqc-<tag number>.tar.gz
```

Note it is assumed you've already activated your `virtualenv`

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## `xhal`

### Post-Packing Instructions

To set the computing environment execute:

```bash
export PETA_STAGE=/data/bigdisk/sw/peta-stage
source /data/bigdisk/sw/Xilinx/SDK/2016.2/settings64.sh
source /opt/rh/devtoolset-6/enable
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Compiling the entire libary

It is assumed you have setup the computing environment, the execute the following:

```bash
cd xhal
git tag <tag number>
make clean && make rpm
```

If you are generating an installable `rpm` for a DAQ machine it's best to check with `GEM RC` what tag should be used. 

This will create `*.rpm`, and in some cases `*.tgz`, files in the following sub-directories:

```bash
xhal/python/reg_interface_gem/rpm 
xhal/xhalarm/rpm
xhal/xhalcore/rpm
```

It will also place a set of `*.so` libraries under:

```bash
xhal/xhalarm/lib
xhal/xhalcore/lib
```

Typically you will not be interested in files under `xhal/xhalarm` unless you are also responsible for maintaining your test stand's backend electronics (e.g. `CTP7`, `GLIB` or other `AMC`).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Compiling only the python tools

It is assumed you have setup the computing environment. To compile only the python tools execute:

```bash
cd xhal/python
git tag <tag number>
make clean && make rpm
```

This will generate the following files:

```bash
% ll xhal/python/reg_interface_gem/rpm 
-rw-r--r--. 1 user group  19K Sep 17 15:02 reg_interface_gem-*.centos7.python2.7.noarch.rpm
-rw-r--r--. 1 user group 7.7K Sep 17 15:02 reg_interface_gem-*.tgz
-rw-r--r--. 1 user group  20K Sep 17 15:02 reg_interface_gem-*.peta_linux.python2.7.noarch.rpm
```

The wildcard `*` will have the information on the tag number (for the `*.tgz file) and tag number plus git commit (for `*.rpm` files).

The `peta_linux` file is an `rpm` designed to be installed on the back-end card's linux image (e.g. `CTP7`).  The `*.tgz` file is a python package which can be installed into a `virtualenv` via:

```bash
pip install -I xhal/python/reg_interface_gem/rpm/reg_interface_gem-<tag number>.tgz
```

and the `centos7` `rpm` can be used to install the `reg_interface_gem` package onto your DAQ machine or upgrade an existing version (assuming the tag number is higher than the existing version).  Note that `reg_interface_gem` `rpm` requires the `reg_interface` package from the `reg_utils` repository.

Note it is assumed in the `pip install` command shown above that you have already activated your python `virtualenv`.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

#### Compiling only the DAQ Machine C++ libraries

It is assumed you have setup the computing environment. To compile only the C++ libraries execute:

```bash
cd xhal/xhalcore
git tag <tag number>
make clean && make rpm
```

This will generate the following files:

```bash
% ll xhal/xhalcore/lib 
-rwxr-xr-x. 1 user group 1.1M Sep 19 10:50 libxhal.so
-rwxr-xr-x. 1 user group 615K Sep 19 15:48 librpcman.so
% ll xhal/xhalcore/rpm 
-rw-r--r--. 1 user group  11K Sep 19 15:48 xhal-devel-*.centos7.gcc6_3_1.x86_64.rpm
-rw-r--r--. 1 user group 2.3M Sep 19 15:48 xhal-*.centos7.gcc6_3_1.x86_64.rpm
```

The wildcard `*` will have the information on the tag number (for the `*.tgz file) and tag number plus git commit (for `*.rpm` files).

The `rpm` file can be installed onto your DAQ machine via `yum` or upgrade an existing installed package (assuming the tag number is higher than the existing version).

If you are performing local tests to changes made to `XHAL` you need to ensure your `LD_LIBRARY_PATH` includes the `xhal/xhalcore/lib` directory (and no other directory that would include the libraries shown, e.g. a system directory under `/opt/xhal/lib`).  You can add the `XHAL` libraries to your `LD_LIBRARY_PATH` by executing:

```bash
cd xhal/xhalcore/lib
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
```

Note this only appends `LD_LIBRARY_PATH` it does *not* remove a pre-existing path (e.g. `/opt/xhal/lib`) from `LD_LIBRARY_PATH` to do this execute:

```bash
echo $LD_LIBRARY_PATH
```

Copy the output of that `echo` commad and remove `/opt/xhal/lib` from the text and then set it to:

```bash
export LD_LIBRARY_PATH=<text from echo command>
cd xhal/xhalcore/lib
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Legacy Pre-Packaging Instructions for Tag 3.2.2

Note the shell variable `BUILD_HOME` is expected to exist and be the top level directory in the area where all your SW repositories are checked out and built from.

```bash
cd $BUILD_HOME
git clone https://github.com/cms-gem-daq-project/xhal.git
cd $BUILD_HOME/xhal
export LD_LIBRARY_PATH=/opt/xdaq/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/wiscrpcsvc/lib:$LD_LIBRARY_PATH
git checkout tags/3.2.2
cd xhal
source setup.sh
python .github/get_binaries.py -t 3.2.2 -l .github/uploads.cfg
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Common Slow Control Actions
--------------------
## Checking Firmware Version

To get the firmware version of a CTP7 and all its programmed OH's from `gem_reg.py` execute:

```
kw RELEASE
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Checking CTP7 Mapping Register

One major difference between OHv3a and {OHv3b, OHv3c} is that OHv3a uses a different set of e-links to communicate with the OH FPGA on GBT0.  The mapping the CTP7 uses is hard coded in the FW but can be toggled between OHv3a and {OHv3b, OHv3c} behavior.  The default behavior in recent CTP7 FW releases is {OHv3b, OHv3c} and this implies the mapping register is `0x1`:

```
eagle60 > kw MAPPING
0x66400044 rw   GEM_AMC.GEM_SYSTEM.VFAT3.USE_OH_V3B_MAPPING             0x00000001
```

Writing this register to `0x0` will switch to `OHv3a` e-link assignment.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Checking Trigger Rates

To see some useful trigger information on the CTP7, in `gem_reg.py` execute `kw GEM_AMC.TRIGGER.OHX` for your OH of interest and several registers displaying the rate, sbit cluster info, and link health registers (mentioned above) will be shown.  Execute `doc <register>` to learn more about each register.

To see the trigger rate each VFAT is sending on OHX execute in `gem_reg.py`:

```
kw GEM_AMC.OH.OHX.FPGA.TRIG.CNT.VFAT
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Getting Info About the CTP7

If your CTP7 is in shelf `X` slot `Y` execute:

```
amc_info_uhal.py --shelf=X -sY
```

This will print various info about the board, the DAQ link status, the TTC status, and the SCA status. Note that `ipbus` must be running on the CTP7.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Reading a Register Repeatedly

If you would like to repeatedly read the same register (e.g. in order to determine the rate of bits being flipped) execute:

```
repeated_reg_read.py REGISTER_NAME X Y --card eagleXX
```

This will read register `REGISTER_NAME` `X` times, pausing `Y` microseconds between each read. Results are written to terminal and also an output text file: `[filename].txt`. `Y` should be set to >= 250 microseconds.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Configuring a Detector
--------------------

## Using `testConnectivity.py` to Configure a Detector (Recommended)

The `testConnectivity.py` script is a routine which allows you to establish communication with the frontend electronics for one or more detectors.  It can be used to automatically scan all VFAT3 DACs involved in the analog portion of the front-end; it will also automatically analyze this data to determine the correct DAC settings needed to determine the proper bias current and voltages for each DAC.  Finally, it can be used to automatically launch an scurve and analyze the data.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Routine to Establish Communication w/Detectors

Assuming your back-end electronics are setup correctly you can configure the front-end electronics by executing the following steps:

1. Power the LV of your detector(s),
2. Determine the `shelf` number of your uTCA crate,
3. Determine the `SLOT` of your AMC in the uTCA crate with the shelf number from step 2,
2. Determine the `ohMask` of your detector(s) on your AMC in slot `SLOT`,
   - Here the `ohMask` is a 12 bit number where a 1 in the N^th bit means "consider this OH."  So an `ohMask = 0xc4c` would mean to use OH's 2, 3, 6, 10 and 11.
3. The execute:

```bash
testConnectivity.py --skipDACScan --skipScurve --nPhaseScans=100 SHELF SLOT OHMASK 2>&1 | tee connectivityLog.log
```

For each OH in `ohMask` this will:

1. Check GBT communication & program GBTs,
2. Check SCA communication & Reset SCAs,
3. Program FPGA & Check Communication,
   - Note this will issue a TTC hard reset to all OH's on the AMC in question; this will *wipe* out the frontend configuration and kill any running scan and stop any data-taking process.
4. Scan GBT Phases & Set Each VFAT to a good phase, and
5. Synchronize all VFATs and check VFAT communication.

If you would like to start at a later step use the option `-f X` where `X` is the desired starting step, e.g. `-f 3` will start by programming the FPGA and checking FPGA communication (in this case it would be assumed that steps 1 & 2 have been completed by an earlier call of `testConnectivity.py` or by manual intervention).

You can add the option `-i` to ignore VFAT synchronization errors.

You can add the option `-a` to accept a bad trigger link status (e.g. trigger link fibers are not connected).

You are now ready to issue a configure command.  The configure command is done with `confChamber.py`:

```bash
confChamber.py cardName -gX
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

### Automatic DAC Scan, Analysis & Upload of Parameters

First upload the correct `CFG_IREF` values to the VFAT3 configuration files on the CTP7 in slot `SLOT` and prepare the `ADC0` calibration file under `${DATA_PATH}/${DETECTOR_SER_NO}/calFile_ADC0_{DETECTOR_SER_NO}.txt` for each detector defined in [chamber_config](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#the-mapping-file-chamberinfopy) dictionary. Note if the VFAT3's you're using have their chipID encoded with the [Reed-Muller Encoding Algorithm](https://en.wikipedia.org/wiki/Reed%E2%80%93Muller_code) and they are found in the VFAT3 production DB then you do not need to upload the `CFG_IREF` values yourself or prepare the `calFile_ADC0_{DETECTOR_SER_NO}.txt` file as this will be done for you.

Then if you execute either:

```bash
testConnectivity.py --skipScurve SHELF SLOT OHMASK 2>&1 | tee connectivityLog.log
```

or 

```bash
testConnectivity.py -f5 --skipScurve SHELF SLOT OHMASK 2>&1 | tee connectivityLog.log
```

this will automatically perform a DAC scan, analyze the DAC scan results, and then upload the register values to the VFAT3 configuration files on the CTP7 in slot `SLOT`.

You are now ready to issue a configure command.  The configure command is done with `confChamber.py`:

```bash
confChamber.py cardName -gX
```

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Manually Configuring a Detector

Assuming your back-end electronics are setup correctly you can configure the front-end electronics by executing the following steps:

1. Power the LV of your detector(s),
2. If the GBTx chips of your optohybrid(s) are not fully fused, program the GBTx chips, see [Programming GBTx](#programming-gbtx),
3. Program the FPGA of the optohybrid(s), see [Programming OH FPGA](#programming-oh-fpga),
4. Issue a GBTx link reset, see [Issuing a GBT Link Reset](#issuing-a-gbt-link-reset),
5. Check the VFATs are all synchronized on your optohybrid(s), see [Checking VFAT Synchronization](#checking-vfat-synchronization),

You are now ready to issue a configure command.  The configure command is done with `confChamber.py`:

```bash
confChamber.py cardName -gX
```

This will issue an RPC call to the CTP7 whose network alias is `cardName` and load all the per VFAT3 configuration settings in each of the VFAT3 configuration files (see [Configuration File on CTP7](#configuration-file-on-ctp7)) for optohybrid `X`. Note it is important to have edited each of these files to ensure the `CFG_IREF` value for your VFATs on all your optohybrid(s) is the unique value each chip needs.  

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Using `chamber_vfatDACSettings` to write common register values

While some registers must be set by hand or by the `replace_parameter.sh` script described in [Configuration File on CTP7](#configuration-file-on-ctp7) since they are unique to each VFAT (e.g. `CFG_IREF` or registers that control a VFAT3's analog chain) some registers can be safely applied to all VFATs (e.g. setting the comparator mode, see [General Overview of VFAT3](#general-overview-of-vfat3)).  To do this easily, and without having to tediously modify many text files on the CTP7 the `chamber_vfatDACSettings` dictionary exists for this purpose. The `chamber_vfatDACSettings` dictionary is a nested dictionary found in the `system_specific_constants.py` file under `$PYTHONPATH` of your system:

```bash
% $ locate system_specific_constants.py
/home/gemuser/gemdaq/config/system_specific_constants.py
```

The `chamber_vfatDACSettings` dictionary is a nested dictionary where the outer key is the geographic address (e.g. `ohKey`)-a tuple `(shelf,slot,link)` which specifices uTCA shelf number, AMC slot number, and optohybrid number-and the inner dictionary uses (key,value) pairs of (register name, value), example:

```python
chamber_vfatDACSettings = {    
        (1,4,2):{
            "CFG_PULSE_STRETCH":3,
            "CFG_LATENCY":97,
            "CFG_RES_PRE":2,
            "CFG_CAP_PRE":1,
            },
        (1,4,3):{
            "CFG_PULSE_STRETCH":3,
            "CFG_LATENCY":98,
            "CFG_RES_PRE":2,
            "CFG_CAP_PRE":1,
            },
        (1,4,6):{
            "CFG_PULSE_STRETCH":3,
            "CFG_LATENCY":99,
            "CFG_RES_PRE":2,
            "CFG_CAP_PRE":1,
            }
    }
```

With these settings a call of `confChamber.py` will overwrite the values of:

 - `CFG_PULSE_STRETCH`,
 - `CFG_LATENCY`,
 - `CFG_RES_PRE`, and
 - `CFG_CAP_PRE`

registers in the [Configuration File on CTP7](#configuration-file-on-ctp7) for all VFATs for optohybrids 0 through 2. 

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

# Taking Calibration & Commissioning Data
--------------------

Calibration and commissioning scans can be taken with the `run_scans.py` interface.  Unlike the v2b case the OH FPGA is no longer controlling the taking of calibration scans, nor is it generating a TTC stream.  The CTP7 generates the TTC stream or forwards a TTC stream from the AMC13.  This means that all optohybrids on a given CTP7 receive a common TTC stream.  This means you cannot be taking data with routine A with OHX and simultaneously take data with routine B with OHY.

Additionally the scan routines rely on several blocks of the CTP7 FW:

 - `SBIT_MONITOR`
 - `VFAT_DAQ_MONITOR`,
 - etc...
 
These blocks can only receive information from one optohybrid at a time and thus almost all scans presently have to be run in series; they *cannot* be run in parallel.  This will change as the SW tools develop.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Getting the VFAT Mask: `getVFATMask.py`

In some cases you may not have a fully instrumented setup (e.g. less than 24 VFATs) or you may not be able to communicate with all 24 VFATs for one reason or another.  In this case you will need to mask either the non-responsive VFATs or those that are not physically present (otherwise scan applications will crash). "Newer" scan applications will automatically determine which VFATs are good or bad for you; however older scans will require you to provide a VFAT mask, a 24 bit number where the N^th bit corresponds to the N^th VFAT and a value of 1 indicates the VFAT should be skipped. 

However to make things simplier, especially for newer users a tool has been provided to determine the VFAT mask for you:

```bash
getVFATMask.py -c eagleXX -gY
Open pickled address table if available  /opt/cmsgemos/etc/maps/amc_address_table_top.pickle...
Initializing AMC eagleXX
The VFAT Mask you should use for OHY is: <some hex number>
```

Here the `getVFATMask.py` tool was given `eagleXX` `OHY` and returns `some hex number` that is the VFAT mask for this optohybrid.

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## The Mapping File: `chamberInfo.py

The `chamberInfo.py` file in addition to defining the `chamber_vfatDACSettings` dictionary (see [Using `chamber_vfatDACSettings` to write common register values](#using-chamber_vfatdacsettings-to-write-common-register-values)) also defines three other dictionaries: `chamber_config`, `GEBtype` and `chamber_vfatMask`.  These dictionaries allow automatic discovery of detector serial numbers, data paths, chamber type, and vfat mask.  As mentioned the `chamberInfo.py` file is either a symlink in the system installed package (which points to a user editable area):

```bash
% ll /usr/lib/python2.7/site-packages/gempython/gemplotting/mapping/chamberInfo.py
lrwxrwxrwx. 1 root root 62 Jul  9 09:49 /usr/lib/python2.7/site-packages/gempython/gemplotting/mapping/chamberInfo.py -> /home/gemuser/gemdaq/gem-plotting-tools/mapping/chamberInfo.py
```

or it is installed inside your python `virtualenv` under:

```bash
$VIRTUAL_ENV/lib/python2.7/site-packages/gempython/gemplotting/mapping/chamberInfo.py
```

The key values of the `chamber_config`, `GEBtype` and `chamber_vfatMask` are always the optohybrid number, this enables the three dictionaries to be easily linked (without having to keep track of `tuple` indices) and enable you to define your test stand by specifying which detector is on which optical link (e.g. optohybrid number), the detector type (i.e. "long" or "short") and the VFAT mask needed (usually use `0x0`).

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)

## Taking Data: `run_scans.py`

Once the dictionaries in `chamberInfo.py` are correctly configured, see:

 - [Using `chamber_vfatDACSettings` to write common register values](#using-chamber_vfatdacsettings-to-write-common-register-values), and
 - [The Mapping File: `chamberInfo.py](#the-mapping-file-chamberinfopy)

You're now able to use the command line interface tool `run_scans.py` for automatically launching scan applications for your test stand.  The `run_scan.py` will for each uncommented link (optohybrid number) in `chamber_config` dictionary:

 - Create a scandate directory in the correct data path under: `$DATA_PATH/chamber_config[ohN]`,
 - Set the permissions on this directory so anyone in the `gemuser` group can `write` or `read`,
 - Call the scan application and configure it with the correct inputs,
 - Create a log file of the scan, and 
 - Set the permissions on the output files so anyone in the `gemuser` group can read them.

The `run_scans.py` tool accepts different commands, each command represents a different scan application and has it's own positional (mandatory) and optional arguments.  You can calling the help menu of `run_scans.py` via:

```bash
run_scans.py -h
```

Will display each of the possible input commands and provide a brief description of them.  You can call the help menu of each of the commands in `run_scans.py` by calling:

```bash
run_scans.py COMMAND -h
```

For example calling the help menu for the scurve command would look like:

```bash
run_scans.py scurve -h
usage: run_scans.py scurve [-h] [--chMax CHMAX] [--chMin CHMIN] [-l LATENCY]
                           [-m MSPL] [-n NEVTS] [--vfatmask VFATMASK]
                           cardName ohMask

positional arguments:
  cardName              hostname of the AMC you are connecting too, e.g.
                        'eagle64'
  ohMask                ohMask to apply, a 1 in the n^th bit indicates the
                        n^th OH should be considered

optional arguments:
  -h, --help            show this help message and exit
  --chMax CHMAX         Specify maximum channel number to scan
  --chMin CHMIN         Specify minimum channel number to scan
  -l LATENCY, --latency LATENCY
                        Setting of CFG_LATENCY register
  -m MSPL, --mspl MSPL  Setting of CFG_PULSE_STRETCH register
  -n NEVTS, --nevts NEVTS
                        Number of events for each scan position
  --vfatmask VFATMASK   If specified this will use this VFAT mask for all
                        unmasked OH's in ohMask. Here this is a 24 bit number,
                        where a 1 in the N^th bit means ignore the N^th VFAT.
                        If this argument is not specified VFAT masks are taken
                        from chamber_vfatMask of chamberInfo.py
```

Happy calibrating and commissioning!

[Top](https://github.com/cms-gem-daq-project/sw_utils/blob/develop/v3ElectronicsUserGuide.md#table-of-contents)
