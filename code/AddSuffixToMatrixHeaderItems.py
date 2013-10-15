import os, sys, glob
import utilities

inFilePath = sys.argv[1]
suffix = sys.argv[2]
outFilePath = sys.argv[3]

data = utilities.readMatrixFromFile(inFilePath)
data[0] = [x + suffix for x in data[0]]
utilities.writeMatrixToFile(data, outFilePath)
