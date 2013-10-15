import os, sys, glob
import utilities

inFilePath = sys.argv[1]
outFilePath = sys.argv[2]

data = utilities.readMatrixFromFile(inFilePath)

headerItems = data[0]

def extractClass(classValue):
    modified = classValue[:classValue.find(".")]

    return "_".join([x for x in modified.split("_")][2:])

classes = [extractClass(headerItem) for headerItem in headerItems]
classes[0] = "Class"

data.append(classes)

utilities.writeMatrixToFile(data, outFilePath)
