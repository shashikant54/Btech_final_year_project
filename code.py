#!/usr/bin/python
import RPi.GPIO as GPIO
import serial
import os
import sys
import time
#ser = serial.Serial('/dev/ttyAMA0', 9600, timeout = 3.0)

uprelay=6          # 31th pin gpio 6
downrelay=13                # 33th pin gpio 13 

openrelay=19               #35th pin gpio 19
closerelay=26               #37th pin gpio26
ser = serial.Serial(
              
               port='/dev/ttyAMA0',
               baudrate = 9600,
               parity=serial.PARITY_NONE,
               stopbits=serial.STOPBITS_ONE,
               bytesize=serial.EIGHTBITS,
               timeout=1
           )
 
print('Initialization')
# Main program block
GPIO.setwarnings(False)
#GPIO.setmode(GPIO.BOARD)  
GPIO.setmode(GPIO.BCM)       # Use BCM GPIO numbers
  
GPIO.setup(uprelay,GPIO.OUT)            # south red
GPIO.setup(downrelay,GPIO.OUT)          # south green
  
GPIO.setup(openrelay,GPIO.OUT)          # north red led
GPIO.setup(closerelay,GPIO.OUT)           # north red led
  
GPIO.output(uprelay,True)
GPIO.output(downrelay,True)
GPIO.output(openrelay,True)
GPIO.output(closerelay,True)
time.sleep(0.05)
GPIO.output(uprelay,False)
GPIO.output(downrelay,False)
GPIO.output(openrelay,False)
GPIO.output(closerelay,False)
print('Initz Done ')
global r3

def rx_data(val):
  if val=='U':
    print('Moving Up')
    GPIO.output(uprelay,True)
    GPIO.output(downrelay,False)
    time.sleep(1.5)
    GPIO.output(uprelay,False)
    GPIO.output(downrelay,False)
    
  elif val == 'D':
    print('Moving Down')
    GPIO.output(uprelay,False)
    GPIO.output(downrelay,True)
    time.sleep(1.5)
    GPIO.output(uprelay,False)
    GPIO.output(downrelay,False)
    
  if val=='O':
    print('Open-Action')
    GPIO.output(openrelay,True)
    GPIO.output(closerelay,False)
    time.sleep(0.5)
    GPIO.output(openrelay,False)
    GPIO.output(closerelay,False)
    
  elif val == 'C':
    print('Close-Action')
    GPIO.output(openrelay,False)
    GPIO.output(closerelay,True)
    time.sleep(0.5)
    GPIO.output(openrelay,False)
    GPIO.output(closerelay,False)
  if val=='S':
    print('Stop-Action')
    GPIO.output(uprelay,False)
    GPIO.output(downrelay,False)
    GPIO.output(openrelay,False)
    GPIO.output(closerelay,False)
  elif val == '\0':
    print('Waiting for Command') 
  
while True:
 ser.isOpen()       
 x = ser.readline()
 r3=x
 print x
 rx_data(r3)
