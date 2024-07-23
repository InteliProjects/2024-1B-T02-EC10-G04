import streamlit as st
from streamlit_option_menu import option_menu
from screens.orders import order_management_page
from screens.user import user_management_page
from screens.medicines import register_medicine_page
from screens.pyxis import pyxis_page
import requests

API_URL = "http://a22242af3513041118fe96dc96fb0ce7-1985443011.us-east-1.elb.amazonaws.com/api/v1"

def login_page():
    st.title("Login")

    if 'logged_in' not in st.session_state:
        st.session_state.logged_in = False

    if not st.session_state.logged_in:
        email = st.text_input("Email")
        password = st.text_input("Password", type='password')

        login_button = st.button("Login")

        if login_button:
            try:
                response = requests.post(
                    f"{API_URL}/users/login", 
                    json={
                        "email": email,
                        "password": password
                    }
                )

                if response.status_code == 200:
                    st.session_state.logged_in = True
                    st.success("Logged in successfully!")
                else:
                    st.error(f"Failed to login: {response.json()['message']}")
            except requests.exceptions.RequestException as e:
                st.error(f"Failed to connect to server: {e}")

def authenticate():
    logged_in = False
    with st.sidebar:
        login_page()
        logged_in = st.session_state.logged_in

    return logged_in

if authenticate():
    with st.sidebar:
        selected_page = option_menu(
            "Menu",
            ["User Management", "Orders", "Medicines", "Pyxis"],
            icons=["people", "gear", "circle", "box"],
            menu_icon="menu-app",
            default_index=0,
        )

    if selected_page == "User Management":
        user_management_page()
    elif selected_page == "Orders":
        order_management_page()
    elif selected_page == "Medicines":
        register_medicine_page()
    elif selected_page == "Pyxis":
        pyxis_page()