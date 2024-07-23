import streamlit as st
import pandas as pd
from logic.pyxis import fetch_pyxis, delete_pyxis, register_pyxis, fetch_pyxis_medicines, add_medicine_to_pyxis
from st_aggrid import AgGrid, GridOptionsBuilder, GridUpdateMode

def pyxis_page():
    st.title("Pyxis Management")

    medicines = fetch_pyxis()
    if medicines:
        st.write("### Registered Pyxis")
        pyxis_df = pd.DataFrame(medicines)

        gb = GridOptionsBuilder.from_dataframe(pyxis_df)
        gb.configure_selection('single', use_checkbox=True)
        grid_options = gb.build()

        grid_response = AgGrid(
            pyxis_df, 
            gridOptions=grid_options,
            update_mode=GridUpdateMode.SELECTION_CHANGED,
            height=300,
            width='100%'
        )

        selected_rows = grid_response.get('selected_rows')
        if selected_rows is not None and not selected_rows.empty: 
            selected_pyxis = selected_rows.iloc[0]
            with st.form(key='see_medicine_form'):
                st.write("#### Get medicines by pyxis")
                submit_button = st.form_submit_button(label='Get medicines by selected pyxis: ' + selected_pyxis['label'])
                if submit_button:
                    medicines = fetch_pyxis_medicines(selected_pyxis['id'])
                    if medicines:
                        medicines_df = pd.DataFrame(medicines)
                        st.dataframe(medicines_df)
                    else:
                        st.warning("No data available")

            with st.form(key='register_medicine_pyxis_form'):
                st.write("#### Register medicines by pyxis")
                medicine_id = st.text_input("Medicine ID")
                submit_button = st.form_submit_button(label='Register medicines by selected pyxis: ' + selected_pyxis['label'])
                print(medicine_id)
                if submit_button:
                    register = add_medicine_to_pyxis(selected_pyxis['id'], medicine_id)
                    if register:
                        st.success("Medicine registered successfully!")
                    else:
                        st.error("Something went wrong while registering medicine. Please try again.")
                        

            with st.form(key='delete_pyxis_form'):
                st.write("#### Delete Pyxis")
                submit_button = st.form_submit_button(label='Delete selected pyxis: ' + selected_pyxis['label'])
                if submit_button:
                  if delete_pyxis(selected_pyxis['id']):
                      st.success("Pyxis deleted successfully!")
                      st.experimental_rerun()
                  else:
                      st.error("Something went wrong while deleting pyxis. Please try again.")

    else:
        st.warning("No data available")

    st.write("### Register Pyxis")
    with st.form(key='register_pyxis_form'):
        label = st.text_input("Label")
        submit_button = st.form_submit_button(label='Register Pyxis')

        if submit_button:
            result = register_pyxis(label)
            if result:
                st.success("Pyxis registered successfully!")
                st.json(result)  