# Simple forward chaining algorithm
from predicates import *

class rule:
    def __init__(self,predicate,action):
        self.current = None
        self.flipped = None
        self.predicate = predicate
        self.action = action
    def reset(self):
        self.flipped = None
    def eval(self):
        aux = self.current
        if(not self.flipped):
            self.current = eval(self.predicate)
            self.flipped = (aux!=self.current)
            if(self.current and self.flipped):
                exec(self.action)

class simple_rules:
    def __init__(self,maxiters=10):
        self.rules = []
        self.maxiters = maxiters
    def add(self,pred,action):
        self.rules.append(rule(pred,action))
        return len(self.rules)
    def check(self,n):
        return self.rules[n-1].current
    def flipped(self,n):
        return self.rules[n-1].flipped
    def chain(self):
        for r in self.rules:
            r.reset()
        for it in range(0,self.maxiters): # Limit iterations in case we have infinte loops
            something_changed = False
            for r in self.rules:
                r.eval()
                something_changed = (something_changed or r.flipped)
            if (not something_changed):
                break
        if ((it==self.maxiters) and something_changed):
            raise NameError('forward chaining maximun loop iterations reached.')
    def dump(self):
        for r in self.rules:
            print 'rule:',r.predicate,',value:',r.current,',flipped:',r.flipped
