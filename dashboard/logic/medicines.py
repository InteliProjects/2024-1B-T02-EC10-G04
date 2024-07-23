import requests
import streamlit as st
import pandas as pd

AUTH_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJJbnRlbGlNb2R1bG8xMCIsInN1YiI6ImZkM2E1ZGJiLTBhMjUtNDg4Mi1iODc4LWQ4MzkwNjFjM2Y3YyIsImV4cCI6MTcxOTE3NTU1NX0.J2Fltus9yVX4bN5sa09DKpA86GO-ZNQpY2ReKv4GJ-M"
API_URL = "http://a22242af3513041118fe96dc96fb0ce7-1985443011.us-east-1.elb.amazonaws.com/api/v1"


def get_headers():
    return {
        "Authorization": f"Bearer {AUTH_TOKEN}"
    }

def register_medicine(medicine, batch, stripe):
    response = requests.post(
        API_URL + "/medicines", 
        headers=get_headers(),
        json={
            "batch": batch,
            "name": medicine,
            "stripe": stripe,
        }
        )
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to register medicines data")
        return []
    
def fetch_medicines():
    response = requests.get(API_URL + "/medicines", headers=get_headers())
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to fetch medicines data")
        return []
    
def delete_medication(medication_id):
    response = requests.delete(API_URL + f"/medicines/{medication_id}", headers=get_headers())
    if response.status_code == 200:
        return True
    else:
        st.error("Failed to delete medicines data")
        return False