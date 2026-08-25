from PIL import Image
from glitch_this import ImageGlitcher

glitcher = ImageGlitcher()

image_path = "glitched_output.jpg"
image = Image.open(image_path)

glitched_image = glitcher.glitch_image(image, 10, True)

glitched_image.save("glitched_output.jpg")
print("Glitch art created and saved successfully")