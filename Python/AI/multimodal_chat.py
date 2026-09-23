#!/opt/homebrew/bin/python3

# This script loads the model into your MacBook Pro's 128GB Unified Memory and offloads execution directly to the Apple Silicon GPU framework (mps).


import torch
from PIL import Image
from transformers import AutoProcessor, AutoModelForCausalLM

# Define model ID from HuggingFace
MODEL_ID = "empero-ai/Qwythos-9B-Claude-Mythos-5-1M"

print("Loading model and processor onto Apple Silicon (MPS)...")
# Target Mac hardware acceleration via 'mps'
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

# Load processor and model optimized for Mac memory
processor = AutoProcessor.from_pretrained(MODEL_ID, trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained(
    MODEL_ID,
    torch_dtype=torch.float16,  # Optimal precision for M-series chips
    device_map={"": device},    # Force allocation directly onto Apple Silicon GPU
    trust_remote_code=True
)

# --- Define Your Inputs ---
# Update this path to target any local photo on your Mac
image_path = "sample_image.png" 
prompt_text = "Analyze this image and explain what you see in detail."

try:
    # 1. Open the image file using Pillow
    image = Image.open(image_path).convert("RGB")
    
    # 2. Structure the prompt following the Qwen text+vision format
    # The special tag `<|image_pad|>` instructs the model where to align visual tokens
    conversation = [
        {
            "role": "user",
            "content": [
                {"type": "image"},
                {"type": "text", "text": prompt_text}
            ]
        }
    ]
    
    # Format chat syntax cleanly
    text_prompt = processor.apply_chat_template(conversation, tokenize=False, add_generation_prompt=True)
    
    # 3. Process inputs into tensors
    inputs = processor(text=[text_prompt], images=[image], return_tensors="pt").to(device)
    
    print("\nGenerating response...")
    # 4. Generate the response
    with torch.no_grad():
        output_ids = model.generate(
            **inputs,
            max_new_tokens=512,
            temperature=0.7,
            do_sample=True
        )
    
    # Trim the prompt tokens to isolate just the generated answer
    generated_ids = [output_ids[0][len(inputs.input_ids[0]):]]
    response = processor.batch_decode(generated_ids, skip_special_tokens=True, clean_up_tokenization_spaces=False)[0]
    
    print("\n=== Model Response ===")
    print(response)

except FileNotFoundError:
    print(f"\n[Error] Could not find the file: '{image_path}'. Ensure an image exists at this path or update the script variable.")
