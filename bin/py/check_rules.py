#/usr/bin/python
from predicates import *
from simple_rules import *

rules = simple_rules()
rules.set_debug(False)

rules.add('connected() and ft_standing()','begin_transfer()','')
rules.add('(not connected()) and ft_inprogress()','abort_transfer()','')
rules.add('connected() and ft_aborted()','resume_transfer()','')

rules.fact('connect()')
rules.fact('request_ft()')
rules.fact('disconnect()')
rules.fact('connect()')
