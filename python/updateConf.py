#!/bin/env python

r"""
updateNewConf.py
==========

.. moduleauthor:: Brian Dorney <brian.l.dorney@cern.ch>
"""

from gempython.utils.gemlogger import printYellow, printRed

def getChConfigFileDict(chamber_config, scandate, debug=False, takeFromSCurve=True):
    """
    Returns a dictionary of chConfig files.

    chamber_config  - Dictionary whose key values are geographic address, e.g. (shelf,slot,link), and values are detector serial numbers
    scandate        - Either None or a string specifying the scandate of the files of interest, in YYYY.MM.DD.hh.mm format
    debug           - Prints debugging information if True
    """
    fileDict = {}

    from gempython.gemplotting.utils.anaInfo import tree_names
    from gempython.gemplotting.utils.anautilities import getDirByAnaType
    import os
    listOfFoundFiles = [ ]
    for geoAddr,cName in chamber_config.iteritems():
        if takeFromSCurve:
            filename = "{}/{}/SCurveData/chConfig.txt".format(getDirByAnaType("scurve",cName),scandate)
        else:
            filename = "{}/{}/ThresholdScanData/chConfig_MasksUpdated.txt".format(getDirByAnaType("thresholdch",cName),scandate)

        # Check that this file is not in listOfFoundFiles
        if ((filename not in listOfFoundFiles) and os.path.isfile(filename)):
            fileDict[cName]=filename
            listOfFoundFiles.append(filename)
        else:
            if debug:
                printYellow("filename not found: {}".format(filename))
        pass

    return fileDict

def getVFATConfigFileDict(chamber_config, scandate, debug=False):
    """
    Returns a dictionary of vfatConfig files.

    chamber_config  - Dictionary whose key values are geographic address, e.g. (shelf,slot,link), and values are detector serial numbers
    scandate        - Either None or a string specifying the scandate of the files of interest, in YYYY.MM.DD.hh.mm format
    debug           - Prints debugging information if True
    """
    fileDict = {}

    from gempython.gemplotting.utils.anaInfo import tree_names
    from gempython.gemplotting.utils.anautilities import getDirByAnaType
    import os
    listOfFoundFiles = [ ]
    for geoAddr,cName in chamber_config.iteritems():
        filename = "{}/{}/vfatConfig.txt".format(getDirByAnaType("sbitRateor",cName),scandate)

        # Check that this file is not in listOfFoundFiles
        if ((filename not in listOfFoundFiles) and os.path.isfile(filename)):
            fileDict[cName]=filename
            listOfFoundFiles.append(filename)
        else:
            if debug:
                printYellow("filename not found: {}".format(filename))
        pass

    return fileDict

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Arguments to supply to updateConf.py")

    parser.add_argument("-d","--debug",action="store_true",help="prints additional debugging information")
    parser.add_argument("-c","--chConfigScandate",type=str,help="Scandate in YYYY.MM.DD.hh.mm format, or the string 'current', for the scurve measurement to take chConfig from for all detectors",default=None)
    parser.add_argument("--updatedChConfig",action="store_true",help="The 'chConfigScandate' argument is understood to come from an updated chConfig produced with joint analysis of scurve and tracking data threshold scan measurements; here the scandate is understood as the date of the tracking data threshold scan")
    parser.add_argument("-v","--vfatConfigScandate",type=str,help="Scandate in YYYY.MM.DD.hh.mm format, or the string 'current', for SBIT Threshold measurement to take vfatConfig from for all detectors",default=None)
    args = parser.parse_args()

    from gempython.gemplotting.utils.anautilities import getDataPath
    dataPath = getDataPath()

    import logging
    from gempython.utils.gemlogger import getGEMLogger
    gemlogger = getGEMLogger(__name__)
    gemlogger.setLevel(logging.ERROR)

    import os,sys
    from gempython.gemplotting.mapping.chamberInfo import chamber_config
    from gempython.utils.wrappers import runCommand
    if args.chConfigScandate is None and args.vfatConfigScandate is None:
        printRed("No scandates provided for either chConfig or vfatConfig. Nothing to do, exiting")
        sys.exit(os.EX_USAGE)
    if args.chConfigScandate is not None:
        chConfigDict = getChConfigFileDict(chamber_config, args.chConfigScandate, args.debug, not args.updatedChConfig)
        for cName,chConfig in chConfigDict.iteritems():
            cmd = ["ln","-sf",chConfig,"{}/configs/chConfig_{}.txt".format(dataPath,cName)]
            runCommand(cmd)
            pass
        pass
    if args.vfatConfigScandate is not None:
        vfatConfigDict = getVFATConfigFileDict(chamber_config, args.vfatConfigScandate, args.debug)
        for cName,vfatConfig in vfatConfigDict.iteritems():
            cmd = ["ln","-sf",vfatConfig,"{}/configs/vfatConfig_{}.txt".format(dataPath,cName)]
            runCommand(cmd)
            pass
        pass

    print("All config links updated, please cross-check via:\n\tll $DATA_PATH/configs")
