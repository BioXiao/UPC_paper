import os, sys, glob
import utilities

def pearson(x, y):
    return utilities.calculatePearsonCoefficient(x, y)

def spearman(x, y):
    return utilities.calculateSpearmanCoefficient(x, y)

matrix1FilePath = sys.argv[1]
matrix2FilePath = sys.argv[2]
byRow = sys.argv[3] == "True"
compareFunction = getattr(sys.modules[__name__], sys.argv[4])
outFilePath = sys.argv[5]

matrix1 = utilities.readMatrixFromFile(matrix1FilePath)
matrix2 = utilities.readMatrixFromFile(matrix2FilePath)

colNames = matrix1.pop(0)
matrix2.pop(0)

if byRow:
    print "byRow Not yet implemented"
    exit()
else:
    results = []

    for colIndex in range(1, len(matrix1[0])):
        values1 = [float(row[colIndex]) for row in matrix1]
        values2 = [float(row[colIndex]) for row in matrix2]

        result = compareFunction(values1, values2)
        results.append(result)

    outFile = open(outFilePath, 'w')
    for x in results:
        outFile.write(str(x) + "\n")
    outFile.close()

    #print "Mean: %.5f" %  utilities.calculateMean(results)
    #print "Min: %.5f" %  min(results)
    #print "Max: %.5f" %  max(results)
