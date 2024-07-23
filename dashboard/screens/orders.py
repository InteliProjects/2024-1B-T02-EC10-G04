import streamlit as st
from logic.orders import fetch_orders, create_dataframe
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode
import pandas as pd


def order_management_page():
    st.title("Orders Management")
    
    data = fetch_orders()
    if data:
        df = create_dataframe(data)
        
        st.sidebar.title("Filters")
        start_date = st.sidebar.date_input("Start Date", value=pd.to_datetime(df['Created At']).min().date())
        end_date = st.sidebar.date_input("End Date", value=pd.to_datetime(df['Created At']).max().date())
        
        filtered_df = df[(df['Created At'].dt.date >= start_date) & 
                         (df['Created At'].dt.date <= end_date)]
        
        gb = GridOptionsBuilder.from_dataframe(filtered_df)
        gb.configure_pagination(paginationAutoPageSize=True)
        gb.configure_side_bar()
        grid_options = gb.build()
        
        st.write("### Registred Orders")
        AgGrid(
            filtered_df, 
            gridOptions=grid_options,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            height=500,
            width='100%'
        )
    else:
        st.warning("No data available")