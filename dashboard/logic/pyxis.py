import requests
import streamlit as st

AUTH_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJJbnRlbGlNb2R1bG8xMCIsInN1YiI6ImZkM2E1ZGJiLTBhMjUtNDg4Mi1iODc4LWQ4MzkwNjFjM2Y3YyIsImV4cCI6MTcxOTE3NTU1NX0.J2Fltus9yVX4bN5sa09DKpA86GO-ZNQpY2ReKv4GJ-M"
API_URL = "http://a22242af3513041118fe96dc96fb0ce7-1985443011.us-east-1.elb.amazonaws.com/api/v1"

def get_headers():
    return {
        "Authorization": f"Bearer {AUTH_TOKEN}"
    }

def fetch_pyxis():
    response = requests.get(API_URL + "/pyxis", headers=get_headers())
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to fetch pyxis")
        return []
    
def delete_pyxis(pyxis_id):
    response = requests.delete(API_URL + f"/pyxis/{pyxis_id}", headers=get_headers())
    print(response)
    if response.status_code == 200:
        return True
    else:
        st.error("Failed to delete pyxis data")
        return False

def register_pyxis(pyxis_name):
    response = requests.post(
        API_URL + "/pyxis", 
        headers=get_headers(),
        json={
            "label": pyxis_name,
        }
        )
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to register pyxis data")
        return []
    
def fetch_pyxis_medicines(pyxis_id):
    response = requests.get(API_URL + f"/pyxis/{pyxis_id}/medicines", headers=get_headers())
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to fetch pyxis medicines")
        return []
    
def add_medicine_to_pyxis(pyxis_id, medicine_id):
    response = requests.post(
        API_URL + f"/pyxis/{pyxis_id}/register-medicine", 
        headers=get_headers(),
        json={
            "medicines": [medicine_id],
        }
        )
    print(response)
    if response.status_code == 200:
        return True  
    else:
        st.error("Failed to add medicine to pyxis")
        return False