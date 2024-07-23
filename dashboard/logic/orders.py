import requests
import streamlit as st
import pandas as pd

AUTH_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJJbnRlbGlNb2R1bG8xMCIsInN1YiI6ImZkM2E1ZGJiLTBhMjUtNDg4Mi1iODc4LWQ4MzkwNjFjM2Y3YyIsImV4cCI6MTcxOTE3NTU1NX0.J2Fltus9yVX4bN5sa09DKpA86GO-ZNQpY2ReKv4GJ-M"
API_URL = "http://a22242af3513041118fe96dc96fb0ce7-1985443011.us-east-1.elb.amazonaws.com/api/v1"


def get_headers():
    return {
        "Authorization": f"Bearer {AUTH_TOKEN}"
    }

def fetch_orders():
    response = requests.get(API_URL + "/orders", headers=get_headers())
    if response.status_code == 200:
        return response.json()  
    else:
        st.error("Failed to fetch order data")
        return []
    
def create_dataframe(data):
    normalized_data = []
    for entry in data:
        medicines = "; ".join([f"{med['name']} (Batch: {med['batch']}, Stripe: {med['stripe']})" for med in entry['medicine']])
        user = entry['user']
        normalized_data.append({
            'ID': entry['id'],
            'Created At': entry['created_at'],
            'Medicines': medicines,
            'Priority': entry['priority'],
            'Status': entry['status'],
            'Observation': entry['observation'],
            'User Name': user['name'],
            'User Email': user['email']
        })
    df = pd.DataFrame(normalized_data)
    df['Created At'] = pd.to_datetime(df['Created At'])
    return df