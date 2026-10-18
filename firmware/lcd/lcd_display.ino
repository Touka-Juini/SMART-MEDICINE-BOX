from grove_rgb_lcd import *
import time

def display_message():
setText("Welcome Girls,\nLet's Start")
setRGB(0, 128, 255)  # Light blue color

try:
display_message()
time.sleep(10)  # Display for 10 seconds
setText("")     # Clear text after display
setRGB(0, 0, 0) # Turn off backlight

except KeyboardInterrupt:
setText("")     # Clear text if interrupted
setRGB(0, 0, 0) # Turn off backlight
