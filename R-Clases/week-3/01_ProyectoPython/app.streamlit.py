# app.py
import streamlit as st
import pandas as pd
import joblib
import os

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

# Cargar modelo
modelo_data = joblib.load(os.path.join("models", selected_model_file))
model = modelo_data["model"]
features = modelo_data["features"]

st.sidebar.success(f"✅ Modelo cargado: {selected_model_file}")

# --- Subida de datos ---
uploaded_file = st.file_uploader("Sube un CSV con datos de clientes", type=["csv"])

if uploaded_file:
    df = pd.read_csv(uploaded_file)

    # Validar columnas necesarias
    missing_cols = [col for col in features if col not in df.columns]
    if missing_cols:
        st.error(f"⚠️ El dataset no tiene todas las columnas necesarias. Faltan: {missing_cols}")
    else:
        st.success("✅ Dataset válido, listo para predecir")

        # Predicción
        preds = model.predict(df[features])
        proba = model.predict_proba(df[features])[:, 1]  # prob churn

        df["churn_pred"] = preds
        df["churn_proba"] = proba

        st.subheader("Resultados")
        st.dataframe(df[["churn_pred", "churn_proba"]].head(10))

        # Descarga de resultados
        csv = df.to_csv(index=False).encode("utf-8")
        st.download_button("📥 Descargar resultados", data=csv, file_name="predicciones_churn.csv", mime="text/csv")

# --- Input manual de cliente ---
st.subheader("Predicción manual")
with st.form("manual_form"):
    gender = st.selectbox("Género", ["Male", "Female"])
    senior = st.selectbox("SeniorCitizen", [0, 1])
    partner = st.selectbox("Partner", ["Yes", "No"])
    dependents = st.selectbox("Dependents", ["Yes", "No"])
    tenure = st.number_input("Tenure (meses)", min_value=0, max_value=100, value=12)
    monthly = st.number_input("MonthlyCharges", min_value=0.0, value=50.0)
    total = st.number_input("TotalCharges", min_value=0.0, value=600.0)
    contract = st.selectbox("Contract", ["Month-to-month", "One year", "Two year"])
    paperless = st.selectbox("PaperlessBilling", ["Yes", "No"])
    payment = st.selectbox("PaymentMethod", ["Electronic check","Mailed check","Bank transfer","Credit card"])

    submitted = st.form_submit_button("Predecir")

    if submitted:
        # Generar features derivadas
        if tenure <= 12:
            customer_segment = "New"
        elif tenure <= 36:
            customer_segment = "Regular"
        else:
            customer_segment = "Loyal"

        if monthly < 35:
            price_segment = "Low"
        elif monthly < 65:
            price_segment = "Medium"
        else:
            price_segment = "High"

        # ejemplo simple: additional_services = 0
        additional_services = 0  

        cliente = pd.DataFrame([{
            "gender": gender,
            "SeniorCitizen": senior,
            "Partner": partner,
            "Dependents": dependents,
            "tenure": tenure,
            "MonthlyCharges": monthly,
            "TotalCharges": total,
            "Contract": contract,
            "PaperlessBilling": paperless,
            "PaymentMethod": payment,
            "customer_segment": customer_segment,
            "price_segment": price_segment,
            "additional_services": additional_services
        }])

        # Predicción
        churn_pred = model.predict(cliente[features])[0]
        churn_proba = model.predict_proba(cliente[features])[0, 1]

        st.write("### Resultado")
        st.write(f"🔮 Predicción: **{'Churn' if churn_pred==1 else 'No Churn'}**")
        st.write(f"📈 Propensión al churn: **{churn_proba:.2%}**")
