%sudo apt update //libraru instalation
%sudo apt install python3-rpi.gpio //library instalation

import RPi.GPIO as GPIO # controlling GPIO pins
import time

GPIO.setmode(GPIO.BOARD)
servo_pin = 03
GPIO.setup(servo_pin, GPIO.OUT)

pwm = GPIO.PWM(servo_pin, 50)
pwm.start(0)

def set_angle(angle):
duty = 2 + (angle / 18)
GPIO.output(servo_pin, True)
pwm.ChangeDutyCycle(duty)
time.sleep(1)
GPIO.output(servo_pin, False)
pwm.ChangeDutyCycle(0)

try:
set_angle(0)
time.sleep(2)
set_angle(90)
time.sleep(2)
set_angle(180)
time.sleep(2)
pwm.stop()
GPIO.cleanup()

% python3 raspberry.py //
