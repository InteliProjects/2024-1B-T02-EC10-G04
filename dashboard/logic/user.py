import requests
import streamlit as st

AUTH_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJJbnRlbGlNb2R1bG8xMCIsInN1YiI6ImZkM2E1ZGJiLTBhMjUtNDg4Mi1iODc4LWQ4MzkwNjFjM2Y3YyIsImV4cCI6MTcxOTE3NTU1NX0.J2Fltus9yVX4bN5sa09DKpA86GO-ZNQpY2ReKv4GJ-M"
API_URL = "http://a22242af3513041118fe96dc96fb0ce7-1985443011.us-east-1.elb.amazonaws.com/api/v1"

def get_headers():
    return {
        "Authorization": f"Bearer {AUTH_TOKEN}"
    }

def fetch_users():
    response = requests.get(API_URL + "/users", headers=get_headers())
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to fetch user data")
        return []
    
def update_user_role(user_id, new_role):
    response = requests.put(API_URL + "/users/" + user_id, headers=get_headers(),
        json={"id": user_id, "role": new_role})
    return response.status_code == 200