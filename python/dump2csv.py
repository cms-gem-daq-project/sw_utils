#!/bin/env python

r"""
dump2csv.py
==========

.. moduleauthor:: Brian Dorney <brian.l.dorney@cern.ch>
"""

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Arguments to supply to dump2csv.py")

    parser.add_argument("infilename",type=str,help="Input ROOT file to be dumped to CSV")
    args = parser.parse_args()

    import root_numpy as rp
    import pandas as pd

    # Get the data
    dataArray = rp.root2array(filenames=args.infilename)
    dfData = pd.DataFrame(dataArray)

    # write to csv file
    outFileName = args.infilename.replace(".root",".csv")
    print("Writing data contained in {:s} to CSV Format".format(args.infilename))
    dfData.to_csv(path_or_buf=outFileName,index=False,mode='w')

    from gempython.utils.gemlogger import printGreen
    printGreen("Your data is available at:\n\t{:s}".format(outFileName))
