import os, sys, glob, math, random
import utilities

def add1(x):
    return [float(x) + 1 for x in x]

def add2(x):
    return [float(x) + 2 for x in x]

def barcode(x):
    return [[0, 1][float(y) > 0.5] for y in x]

def barcodeOffOn(x):
    return [["Off", "On"][float(y) > 0.5] for y in x]

def binarize(x):
    median = utilities.calculateMedian(x)
    return [[0.0, 1.0][float(y) > median] for y in x]

def binarizeOffOn(x):
    median = utilities.calculateMedian(x)
    return [["Off", "On"][float(y) > median] for y in x]

def calculateZscore(x):
    return utilities.zscore([float(y) for y in x])

def ceiling(x):
    return [int(math.ceil(float(y))) for y in x]

def commaSeparate(x):
    return ",".join(x)

def log(x):
    return [math.log(float(y)) for y in x]

def log2(x):
    return [math.log(float(y), 2) for y in x]

def majority(x):
    xDict = {}
    for y in x:
        xDict[y] = xDict.setdefault(y, 0) + 1

    winner = None
    winnerValue = -1
    for key in xDict.keys():
        value = xDict[key]
        if value > winnerValue:
            winner = key

    return winner

def maximum(x):
    return max([float(y) for y in x])

def mean(x):
    return [utilities.calculateMean([float(y) for y in x])]

def median(x):
    return [utilities.calculateMedian([float(y) for y in x])]

def minimum(x):
    return min([float(y) for y in x])

def null(x):
    return x

def rank(x):
    return utilities.rankSmart([float(y) for y in x])

def rankprob(x):
    length = float(len(x))
    return [float(y) / length for y in utilities.rankSmart([float(y) for y in x])]

def robustscale(x):
    median = utilities.calculateMedian([float(y) for y in x])
    iqr = utilities.calculateInterquartileRange([float(y) for y in x])

    return [(float(y) - median) / iqr for y in x]

def quant10i(x):
    quantiles = [utilities.quantile([float(y) for y in x], q/10.0) for q in range(1, 11)]

    z = []
    for y in x:
        for i in range(len(quantiles)):
            if float(y) <= quantiles[i]:
                z.append((i + 1))
                break

    return z

def quant10r(x):
    return quant10i(rank([float(y) for y in x]))

def quantnorm(x):
    random.seed(1)
    randomNorm = sorted([random.normalvariate(0, 1) for i in range(len(x))])

    return [randomNorm[float(y)] for y in rank(x)]

def selectFirst(x):
    return x[0]

def smallnoise(x):
    random.seed(1)
    randomValues = [random.random() / 10000.0 for i in range(len(x))]

    return [float(x[i]) + randomValues[i] for i in range(len(x))]

def standarddeviation(x):
    sd = utilities.calculateStandardDeviation(x)

    return [float(y) / sd for y in x]

def standardize(x):
    minValue = minimum([float(y) for y in x])
    maxValue = maximum([float(y) for y in x])
    return [((float(y) - minValue) / (maxValue - minValue)) for y in x]

def standardScore(x):
    mean = utilities.calculateMean([float(y) for y in x])
    sd = utilities.calculateStandardDeviation([float(y) for y in x])
    return [(float(y) - mean) / sd for y in x]

def subtract1(x):
    return [float(y) - 1 for y in x]

def subtractmin(x):
    minX = min([float(y) for y in x])
    return [float(y) - minX for y in x]

def sum(x):
    return [math.fsum([float(y) for y in x])]

def trimmedMean(x):
    return utilities.calculateTrimmedMean([float(y) for y in x])

def zscore(x):
    return utilities.zscore([float(y) for y in x])
