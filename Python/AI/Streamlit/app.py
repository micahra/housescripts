#!/opt/homebrew/bin/python3

# This script uses Streamlit to create a private visual chat window in your browser. It includes model caching so the huge 9B parameter structure stays persistently inside your RAM instead of reloading on every page click.
# run this app with streamlit run app.py after all necessary dependencies have been created

import streamlit as st
import torch
from PIL import Image
from transformers import AutoProcessor, AutoModelForCausalLM

MODEL_ID = "empero-ai/Qwythos-9B-Claude-Mythos-5-1M"

# Streamlit page layout configurations
st.set_page_config(page_title="Qwythos 9B Local Chat UI", page_icon="🤖", layout="wide")
st.title("🤖 Qwythos-9B Local Multimodal Chat Window")
st.caption("Running natively offline on MacBook Pro M5 Max GPU Acceleration")

# Cache the resource loaders so it only runs once upon application launch
@st.cache_resource
def load_llm_components():
    device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
    processor = AutoProcessor.from_pretrained(MODEL_ID, trust_remote_code=True)
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_ID,
        torch_dtype=torch.float16,
        device_map={"": device},
        trust_remote_code=True
    )
    return processor, model, device

processor, model, device = load_llm_components()

# Initialize session state tracking for message memory history
if "chat_history" not in st.session_state:
    st.session_state.chat_history = []

# Sidebar panel layout handling image uploads
with st.sidebar:
    st.header("Multimodal Inputs")
    uploaded_file = st.file_uploader("Upload an image to discuss", type=["png", "jpg", "jpeg"])
    
    if uploaded_file:
        st.image(uploaded_file, caption="Active Image Context", use_container_width=True)
    
    if st.button("Clear Chat History"):
        st.session_state.chat_history = []
        st.rerun()

# Render persistent historical chat message windows
for message in st.session_state.chat_history:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# User interactive messaging input field
if user_input := st.chat_input("Ask Qwythos a question..."):
    
    # Render user prompt inside the chat interface
    with st.chat_message("user"):
        st.markdown(user_input)
    
    st.session_state.chat_history.append({"role": "user", "content": user_input})
    
    # Process the system generating workflow blocks
    with st.chat_message("assistant"):
        status_placeholder = st.empty()
        status_placeholder.markdown("*Qwythos is thinking...*")
        
        try:
            # Build input dictionary payload matching chat structure
            content_payload = []
            active_images = []
            
            if uploaded_file:
                pil_image = Image.open(uploaded_file).convert("RGB")
                active_images.append(pil_image)
                content_payload.append({"type": "image"})
                
            content_payload.append({"type": "text", "text": user_input})
            
            conversation = [{"role": "user", "content": content_payload}]
            text_prompt = processor.apply_chat_template(conversation, tokenize=False, add_generation_prompt=True)
            
            # Map parameters into runtime framework
            inputs = processor(
                text=[text_prompt], 
                images=active_images if active_images else None, 
                return_tensors="pt"
            ).to(device)
            
            with torch.no_grad():
                output_ids = model.generate(
                    **inputs,
                    max_new_tokens=1024,
                    temperature=0.7,
                    do_sample=True
                )
                
            generated_ids = [output_ids[0][len(inputs.input_ids[0]):]]
            response = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
            
            # Replace placeholder text with final model generation
            status_placeholder.markdown(response)
            st.session_state.chat_history.append({"role": "assistant", "content": response})
            
        except Exception as e:
            status_placeholder.error(f"An execution breakdown occurred: {str(e)}")


