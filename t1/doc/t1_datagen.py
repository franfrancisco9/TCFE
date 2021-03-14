#!/usr/bin/python
#
#    lab_datagen: script to generate lab assignment data
#
#    FOLLOW THE COMMENTS IN CAPITALS BELOW TO EDIT THIS SCRIPT FOR A NEW QUIZ


import math
import random

class Var:
    def __init__(self, name, val, tol):
        self.name = name;
        self.val = val + random.random()*(val*float(tol)/100)
        
    def printVar(self):
        print self.name, "=", self.val, "\n",
        
class Prob:
    def __init__(self, number, weight):
        self.number = number
        self.varList = []
        self.weight = weight
        
    def printProb(self):
        print "Values: ",
        for i in range(len(self.varList)):
            self.varList[i].printVar()
        print "\n\n"
            
    def addVar(self, var):
        self.varList.append(var)

class DataSet:
    def __init__(self, number):
        random.seed(number)
        self.probList = []

        #ENTER ERROR TOLERANCE IN % FOR ANSWERS 
        self.errtol = 1 
        
        #
        #ADD PROBLEMS AND THEIR VARIABLES HERE
        #
        
        self.prob = Prob(1, 1) #problem number and weight in mark
        self.prob.addVar(Var("R1", 1, 5)) #var name, value, variation in %
        self.prob.addVar(Var("R2", 2, 5))
        self.prob.addVar(Var("R3", 3, 5))
        self.prob.addVar(Var("R4", 4, 5))
        self.prob.addVar(Var("R5", 3, 5))
        self.prob.addVar(Var("R6", 2, 5))
        self.prob.addVar(Var("R7", 1, 5))
        self.prob.addVar(Var("Va", 5, 5))
        self.prob.addVar(Var("Id", 1, 5))
        self.prob.addVar(Var("Kb", 7, 5))
        self.prob.addVar(Var("Kc", 8, 5))

        self.probList.append(self.prob)
    
    def printDataSet(self):
        nprobs = len(self.probList)
        print "Units for the values: V, mA, kOhm and mS\n\n"
        for i in range(nprobs):
            self.probList[i].printProb()

def main():
    #init test
    number = input("\n\nPlease enter the lowest student number in your group: \n")
    print
    print
    dataset = DataSet(number)

    #print test
    dataset.printDataSet()
    
if __name__ == "__main__": main()


