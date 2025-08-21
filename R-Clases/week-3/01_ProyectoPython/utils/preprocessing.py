import pandas as pd
import numpy as np

# --- Función de limpieza global ---
def clean_columns_global(df):
    df = df.copy()
    if "PaymentMethod" in df.columns:
        df["PaymentMethod"] = df["PaymentMethod"].str.replace(r" \(automatic\)", "", regex=True)
        
    if "TotalCharges" in df.columns:
        df["TotalCharges"] = df["TotalCharges"].replace(" ", np.nan).replace("", np.nan)
        df["TotalCharges"] = df["TotalCharges"].astype(float)
        df["TotalCharges"] = df["TotalCharges"].fillna(df["TotalCharges"].median())
    return df

# --- Transformadores globales ---
mapper_columns_bins = {"Yes": 1, "No": 0, "Male": 1, "Female": 0}

def map_bins(X): 
    return X.applymap(lambda x: mapper_columns_bins.get(x, x) if isinstance(x, str) else x)

def to_numeric(X):
    if isinstance(X, np.ndarray):
        df = pd.DataFrame(X)
        return df.apply(pd.to_numeric, errors='coerce').fillna(0).values
    else:
        return X.apply(pd.to_numeric, errors='coerce').fillna(0)
