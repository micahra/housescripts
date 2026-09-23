#!/opt/homebrew/bin/python3

from PIL import Image
import requests

# 1. Pillow opens the image (from a local path or a URL)
image = Image.open(requests.get("https://example.com", stream=True).raw)

# 2. You can use Pillow to inspect or modify it if needed
print(image.size)  # Outputs width and height
print(image.format)  # Outputs JPEG, PNG, etc.

# 3. The processor then takes the Pillow image object and turns it into math for the model
# inputs = processor(images=image, text="Describe this image", return_tensors="pt")
