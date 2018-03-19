#/usr/bin/python
from predicates import *
from simple_rules import *

rules = simple_rules()
TRANSFER_PROGRESS = rules.add('connected() and file_transfer','print \'sending\'')

rules.chain()
rules.dump()

disconnect()

rules.chain()
rules.dump()
