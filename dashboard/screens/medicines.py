import streamlit as st
import pandas as pd
from logic.medicines import register_medicine, fetch_medicines, delete_medication
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode

def register_medicine_page():
    st.title("Medicines Management")

    medicines = fetch_medicines()
    if medicines:
        st.write("### Medicines")
        medicines_df = pd.DataFrame(medicines)

        gb = GridOptionsBuilder.from_dataframe(medicines_df)
        gb.configure_selection('single', use_checkbox=True)
        grid_options = gb.build()

        grid_response = AgGrid(
            medicines_df, 
            gridOptions=grid_options,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            height=300,
            width='100%'
        )

        selected_rows = grid_response.get('selected_rows')
        if selected_rows is not None and not selected_rows.empty: 
            selected_medicine = selected_rows.iloc[0]
            with st.form(key='delete_medicine_form'):
                st.write("#### Delete Medicine")
                submit_button = st.form_submit_button(label='Delete selected medicine')
                if submit_button:
                  if delete_medication(selected_medicine['id']):
                      st.success("Medicine deleted successfully!")
                      st.experimental_rerun()
                  else:
                      st.error("Something went wrong while deleting medicine. Please try again.")

    else:
        st.warning("No data available")

    st.write("### Register Medicine")
    with st.form(key='register_medicine_form'):
        medicine = st.text_input("Medicine Name")
        batch = st.text_input("Batch")
        stripe = st.text_input("Stripe")
        submit_button = st.form_submit_button(label='Register Medicine')

        if submit_button:
            result = register_medicine(medicine, batch, stripe)
            if result:
                st.success("Medicine registered successfully!")
                st.json(result)  