import RPi.GPIO as GPIO
import os
import serial
import string
import time,sys
import pyrebase
import uuid

from pyfcm import FCMNotification
from gps import *

#------------------------------------------------------------#
# FIREBASE
config = {
  "apiKey": "AIzaSyChf1ndp4ByIfV2DwOq-if67wrguwHn4h0",
  "authDomain": "vcare-8b199.firebaseapp.com",
  "databaseURL": "https://vcare-8b199.firebaseio.com/",
  "storageBucket": "vcare-8b199.appspot.com"
}

firebase = pyrebase.initialize_app(config)

push_service = FCMNotification(api_key="AAAAMTLCQkI:APA91bF-fl_tsa5j0VS8XOc4D2Wd7Tyx48uRRV6ABQjvR2-FbnL5hVSd3RskdCpuRW4ZjRApVMzejFX5oLas8BPRjWO1Fz4_RTF7N9dQMoEkVmVQEtaAfMCoK7_PFk_PGPxcwPV4ePTu")

tokenid = "dyw85N5ji0HVuTtLE2StG3:APA91bFcdnJ_GBs6aNRRYXbLByNWxGwpxyXQ7cOWz36hwoG5gSb3ZQ4OZto2IiMPWJD3vYprP0gO0IsGVhVVa2gVIHokExqqiZbDg7xEp0Cj-ri-snxmYB7dQB6w5_cZ24pEOCnr5qDo"

#title = "Alert Motion Detect!! "
#body = "The van administrator is " + curid + "\n" + "Please Check Location >>> " + hppts + " <<<"

#------------------------------------------------------------#
# GPIO
GPIO.setmode(GPIO.BCM)

GPIO.setwarnings(False)
GPIO.setup(12, GPIO.OUT)

GPIO.setup(23, GPIO.IN) #PIR(1)
GPIO.setup(24, GPIO.IN) #PIR(2)
GPIO.setup(20, GPIO.IN) #PIR(3)
GPIO.setup(21, GPIO.IN) #PIR(4)

GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_UP) #MSWICH

#------------------------------------------------------------#
# VARIABLE
_phone = "+66825622060"
_curid = "Mr.Preecha J"
_https = ("https://maps.google.com/maps?q=")
_isConfirm = "Unconfirmed"
#------------------------------------------------------------#
# SERIALPORT
gpsd = gps(mode=WATCH_ENABLE|WATCH_NEWSTYLE)

SERIAL_PORT = "/dev/ttyUSB3"
ser = serial.Serial(SERIAL_PORT, baudrate = 9600, timeout = 5)

#------------------------------------------------------------#
print("Prepare to setup GSM func (30 second...)")
GPIO.output(12, GPIO.HIGH)
time.sleep(30)
print("RUN...")
GPIO.output(12, GPIO.LOW)

# PROGRAM
try:
    while True:
        # FIX GPSD
        report = gpsd.next()
        if report['class'] == 'TPV':
            # GPS REPORT
            print 'latitude\tlongitude\ttime utc\t\t\taltitude\tepv\tept\tspeed\tclimb'
            print getattr(report,'lat',0.0),"\t",
            print getattr(report,'lon',0.0),"\t",
            print getattr(report,'time',''),"\t",
            print getattr(report,'alt','nan'),"\t\t",
            print getattr(report,'epv','nan'),"\t",
            print getattr(report,'ept','nan'),"\t",
            print getattr(report,'speed','nan'),"\t",
            print getattr(report,'climb','nan'),"\t"
            
            GPIO.output(12, GPIO.HIGH)
            time.sleep(0.1)
            GPIO.output(12, GPIO.LOW)

            _latitude = repr(getattr(report,'lat',0.0))
            _longitude = repr(getattr(report,'lon',0.0))
            _coordinates = ("http://maps.google.com/maps?q=" + _latitude + "," + _longitude)
            time.sleep(3)

            _vid = uuid.uuid4()

            _date = (time.strftime("%A %d %B %Y"))
            _time = (time.strftime("%H:%M:%S"))

            title = "Alert Motion Detect!! "
            body = "The van admin is " + _curid + "\n" + _date + "\n" + "Time " + _time + "\n" +  "Please Check Location >>> " + _https + _latitude + "," + _longitude + " <<<"

            input_swich = GPIO.input(16)
            input_sensor = GPIO.input(23) or GPIO.input(24) or GPIO.input(20) or GPIO.input(21)

            if input_swich == True:
                print("(MSWICH, 16) STOP...")
                time.sleep(60)

            elif (input_swich == False) and (input_sensor == True):
                print("(MSWICH, 16) RUN...")
                time.sleep(1)
                
            # DIAL HPONE
                ser.write("ATD+66825622060;\r")
                print("Dialing...")
                time.sleep(30)
    
            # HANG UP PHONE
                ser.write("ATH\r")
                print("Hang up...")
                time.sleep(15)
    
            # SENT MESSAGE
                ser.write("AT+CMGF=1\r")
                print("Text mode enable...")
                time.sleep(3)
    
                ser.write('AT+CMGS="+66825622060"\r')
                msg = ("ALERT MOTION DETECT!!\r") + ("VAN SECURITY NO.001\r") + (_date) + ("\r") + (_time) + ("\r") + ("LOCATION IS >>> " + (_https) + (_latitude) + (",") + (_longitude) + (" <<<"))
                print("Sinting message...")
                time.sleep(3)

                ser.write(msg+chr(26))
                time.sleep(3)
    
                print("Message sint...")
                time.sleep(3)
                print("STOP...")
                
            # SET FIREBASE
                print("Firebase set update data...")
                db = firebase.database()

                _data = {
                "vid": (str(_vid)),
                "curid": (_curid),
                "date": (_date),
                "time": (_time),
                "coordinates": (_coordinates),
                "latitude": (_latitude),
                "longitude": (_longitude),
                "phone": (_phone),
                "isConfirm:": (_isConfirm)
                }

                db.child("vans").child(str(_vid)).set(_data)

                result = push_service.notify_single_device(registration_id=tokenid, message_title=title, message_body=body, content_available=True)

                print result
                
                print("Data sint...")
                print("LED ON...")
                GPIO.output(12, GPIO.HIGH)
                time.sleep(0.1)
                GPIO.output(12, GPIO.LOW)
                time.sleep(0.1)
                GPIO.output(12, GPIO.HIGH)
                time.sleep(0.1)
                GPIO.output(12, GPIO.LOW)
                time.sleep(0.1)
                GPIO.output(12, GPIO.HIGH)
                time.sleep(0.1)
                GPIO.output(12, GPIO.LOW)
                print("LED OFF...")
                time.sleep(3)
                
                print("END")
                time.sleep(15)

except (KeyboardInterrupt, SystemExit): # ctrl+c
    print "Done.\nExiting."
