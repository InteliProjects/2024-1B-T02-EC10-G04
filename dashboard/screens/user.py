import streamlit as st
import pandas as pd
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode
from logic.user import fetch_users, update_user_role

def user_management_page():
    st.title("User Management")
    users = fetch_users()
    if users:
        user_df = pd.DataFrame(users)
        
        gb = GridOptionsBuilder.from_dataframe(user_df)
        gb.configure_selection('single', use_checkbox=True)
        grid_options = gb.build()
        
        st.write("### Users")
        grid_response = AgGrid(
            user_df, 
            gridOptions=grid_options,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            height=300,
            width='100%'
        )
        
        selected_rows = grid_response.get('selected_rows')
        
        if selected_rows is not None and not selected_rows.empty: 
            selected_user = selected_rows.iloc[0]
            st.write("### Edit Role")
            with st.form(key='edit_role_form'):
                st.write(f"ID: {selected_user['id']}")
                st.write(f"Name: {selected_user['name']}")
                st.write(f"Email: {selected_user['email']}")
                
                new_role = st.selectbox("Select the new role:", ["admin", "user", "collector", "manager"], index=["admin", "user", "collector", "manager"].index(selected_user["role"]))
                
                submit_button = st.form_submit_button(label='Update Role')
                
                if submit_button:
                    if update_user_role(selected_user['id'], new_role):
                        st.success("Role updated successfully!")
                        st.experimental_rerun()
                    else:
                        st.error("Something went wrong while updating the role. Please try again.")
        else:
            st.info("Select a user to edit the role.")