import os, sys, glob, shutil
import utilities

decoderFilePath = sys.argv[1]
ccleRawAllDirPath = sys.argv[2]
gskRawAllDirPath = sys.argv[3]
ccleRawSelectedDirPath = sys.argv[4]
gskRawSelectedDirPath = sys.argv[5]

decoderData = utilities.readMatrixFromFile(decoderFilePath)
decoderData.pop(0)

decoderFileDict = {}
decoderNameDict = {}

for row in decoderData:
    gskFileName = row[1]
    ccleFileName = row[4]
    name = row[0] + "_" + row[8] + "_" + row[9] + "_" + row[10]
    name = name.replace(" ", "")

    decoderFileDict[ccleFileName] = decoderFileDict.setdefault(ccleFileName, []) + [gskFileName]
    decoderNameDict[ccleFileName] = decoderNameDict.setdefault(ccleFileName, []) + [name]

for ccleFileName in decoderFileDict:
    name = decoderNameDict[ccleFileName][0]
    print name

    shutil.copy(ccleRawAllDirPath + "/" + ccleFileName + ".CEL", ccleRawSelectedDirPath + "/" + name + ".CEL")

    gskFileName = decoderFileDict[ccleFileName][0]
    shutil.copy(gskRawAllDirPath + "/" + gskFileName + ".CEL", gskRawSelectedDirPath + "/" + name + ".CEL")
