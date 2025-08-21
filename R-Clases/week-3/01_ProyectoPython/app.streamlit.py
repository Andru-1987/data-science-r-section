# app.py
import streamlit as st
import pandas as pd
import joblib
import os
from utils.preprocessing import clean_columns_global, map_bins,to_numeric

# app.py
import streamlit as st
import pandas as pd
import joblib
import os



def categorize_customer(row):
    tenure = row["tenure"]
    monthly = row["MonthlyCharges"]
    
    # --- Customer Segment ---
    if tenure <= 12:
        customer_segment = "New"
    elif tenure <= 36:
        customer_segment = "Regular"
    else:
        customer_segment = "Loyal"

    # --- Price Segment ---
    if monthly < 35:
        price_segment = "Low"
    elif monthly < 65:
        price_segment = "Medium"
    else:
        price_segment = "High"

    # --- Additional Services ---
    additional_services = sum([
        1 if row["OnlineSecurity"] == "Yes" else 0,
        1 if row["OnlineBackup"] == "Yes" else 0,
        1 if row["DeviceProtection"] == "Yes" else 0,
        1 if row["TechSupport"] == "Yes" else 0,
        1 if row["StreamingTV"] == "Yes" else 0,
        1 if row["StreamingMovies"] == "Yes" else 0
    ])
    
    return pd.Series([customer_segment, price_segment, additional_services])


# --- Título ---
st.title("📊 Churn Prediction App")
st.write("Predicción de churn y propensión al churn en clientes Telco")

# --- Seleccionar modelo ---
st.sidebar.header("⚙️ Configuración")
model_files = [f for f in os.listdir("models") if f.endswith(".pkl") or f.endswith(".joblib")]

if not model_files:
    st.error("⚠️ No se encontraron modelos en la carpeta `models/`")
    st.stop()

selected_model_file = st.sidebar.selectbox("Selecciona un modelo", model_files)

# Cargar pipeline completo
model = joblib.load(os.path.join("models", selected_model_file))

nombre_comercial = " ".join( selected_model_file.split("_") ).upper().replace(".PKL","")
st.sidebar.success(f"✅ Modelo cargado: {nombre_comercial}")

# --- Subida de datos ---
uploaded_file = st.file_uploader("Sube un CSV con datos de clientes", type=["csv"])

if uploaded_file:
    df = pd.read_csv(uploaded_file)
    df[["customer_segment", "price_segment", "additional_services"]] = df.apply(categorize_customer, axis=1)
    
    try:
        preds = model["model"].predict(df)
        proba = model["model"].predict_proba(df)[:, 1]

        df["churn_pred"] = preds
        df["churn_proba"] = proba

        st.subheader("Resultados")
        st.dataframe(df[["churn_pred", "churn_proba"]].head(10))

        # Descarga de resultados
        csv = df.to_csv(index=False).encode("utf-8")
        st.download_button("📥 Descargar resultados", data=csv, file_name="predicciones_churn.csv", mime="text/csv")
    except Exception as e:
        st.error(f"⚠️ Error al predecir: {e}")

# --- Input manual de cliente ---
st.subheader("Predicción manual")
with st.form("manual_form"):
    gender = st.selectbox("Género", ["Male", "Female"])
    senior = st.selectbox("SeniorCitizen", [0, 1])
    partner = st.selectbox("Partner", ["Yes", "No"])
    dependents = st.selectbox("Dependents", ["Yes", "No"])
    tenure = st.number_input("Tenure (meses)", min_value=0, max_value=100, value=12)

    phone_service = st.selectbox("PhoneService", ["Yes", "No"])
    multiple_lines = st.selectbox("MultipleLines", ["Yes", "No", "No phone service"])
    internet_service = st.selectbox("InternetService", ["DSL", "Fiber optic", "No"])
    online_security = st.selectbox("OnlineSecurity", ["Yes", "No", "No internet service"])
    online_backup = st.selectbox("OnlineBackup", ["Yes", "No", "No internet service"])
    device_protection = st.selectbox("DeviceProtection", ["Yes", "No", "No internet service"])
    tech_support = st.selectbox("TechSupport", ["Yes", "No", "No internet service"])
    streaming_tv = st.selectbox("StreamingTV", ["Yes", "No", "No internet service"])
    streaming_movies = st.selectbox("StreamingMovies", ["Yes", "No", "No internet service"])

    monthly = st.number_input("MonthlyCharges", min_value=0.0, value=50.0)
    total = st.number_input("TotalCharges", min_value=0.0, value=600.0)
    contract = st.selectbox("Contract", ["Month-to-month", "One year", "Two year"])
    paperless = st.selectbox("PaperlessBilling", ["Yes", "No"])
    payment = st.selectbox("PaymentMethod", ["Electronic check","Mailed check","Bank transfer","Credit card"])

    submitted = st.form_submit_button("Predecir")

    if submitted:
        # Features derivadas
        customer_segment = "New" if tenure <= 12 else ("Regular" if tenure <= 36 else "Loyal")
        price_segment = "Low" if monthly < 35 else ("Medium" if monthly < 65 else "High")
        additional_services = sum([
            1 if online_security == "Yes" else 0,
            1 if online_backup == "Yes" else 0,
            1 if device_protection == "Yes" else 0,
            1 if tech_support == "Yes" else 0,
            1 if streaming_tv == "Yes" else 0,
            1 if streaming_movies == "Yes" else 0
        ])

        cliente = pd.DataFrame([{
            "gender": gender,
            "SeniorCitizen": senior,
            "Partner": partner,
            "Dependents": dependents,
            "tenure": tenure,
            "PhoneService": phone_service,
            "MultipleLines": multiple_lines,
            "InternetService": internet_service,
            "OnlineSecurity": online_security,
            "OnlineBackup": online_backup,
            "DeviceProtection": device_protection,
            "TechSupport": tech_support,
            "StreamingTV": streaming_tv,
            "StreamingMovies": streaming_movies,
            "MonthlyCharges": monthly,
            "TotalCharges": total,
            "Contract": contract,
            "PaperlessBilling": paperless,
            "PaymentMethod": payment,
            "customer_segment": customer_segment,
            "price_segment": price_segment,
            "additional_services": additional_services
        }])

        # Predicción directa con pipeline
        churn_pred = model["model"].predict(cliente)[0]
        churn_proba = model["model"].predict_proba(cliente)[0, 1]

        st.write("### Resultado")
        st.write(f"🔮 Predicción: **{'Churn' if churn_pred==1 else 'No Churn'}**")
        st.write(f"📈 Propensión al churn: **{churn_proba:.2%}**")
