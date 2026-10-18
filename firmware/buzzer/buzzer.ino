import RPi.GPIO as GPIO
import time

buzzer_pin = 18  # GPIO 18 (physical pin 12 on the Raspberry Pi)
GPIO.setmode(GPIO.BCM)
GPIO.setup(buzzer_pin, GPIO.OUT)

try:
while True:
GPIO.output(buzzer_pin, GPIO.HIGH)  # Turn buzzer on
time.sleep(1)  # Buzzer on for 1 second
GPIO.output(buzzer_pin, GPIO.LOW)   # Turn buzzer off
time.sleep(1)  # Buzzer off for 1 second

except KeyboardInterrupt:
GPIO.cleanup()  # Clean up GPIO settings on exit
