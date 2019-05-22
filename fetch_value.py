#!/bin/bash
# Copyright 2019 Peggy Sylopp
# All rights reserved
# This file is part of the twilight framework  
# The twilight framework is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# @version 0.1
# @date 22.05.2019
# 2019 pexlab.space, Berlin
#
# The  twilight framework is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. 
#
# You should have received a copy of the GNU AFFERO General Public License along with the liketohear-framework. If not, see http://www.gnu.org/licenses/.


#!/usr/bin/env python

from time import sleep
import sys
import pytai as tai
from smbus import SMBus
import os


# log_file = "logfile_daten.txt"

def get_new_filename():
  i = 0
  while True:
    fn = "logfile_daten{}.txt".format(i)
    if not os.path.isfile(fn):
      break
    i += 1
  return fn
      

def getValue():
  response = i2c.read_byte(42)
  if not response: return
  return response

def logvalue(log_file, value):
  try:
    logfile = open(log_file,'a',1)
  except IOError:
    sys.stderr.write("Error - can't open logfile: \"%s\"\n" % log_file)
    sys.exit()
  print ("log: %s:TROPF$%s#%s:%s") % (tai.now().to_tai64_ext(), "1", "1", value)
  logfile.write("%s:TROPF$%s#%s:%s\n" % (tai.now().to_tai64_ext(), "1", "1", value))
  logfile.flush()
  logfile.close()

print 'start'
logfile = get_new_filename()
print("Logging into file '{}'".format(logfile))
i2c = SMBus(1)
while (1):
  print 'loop'
  VALUE = getValue()
  print("value = %s") % (VALUE)
  if VALUE:
    logvalue(logfile, VALUE)
  sleep(5)

