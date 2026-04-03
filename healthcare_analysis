import pandas as pd
import random
from faker import Faker
from datetime import timedelta

fake = Faker()
random.seed(42)

# ----------------------------
# CONFIG
# ----------------------------
NUM_CLAIMS = 3000
NUM_PROVIDERS = 25
NUM_INSURANCE = 10

# ----------------------------
# PROVIDERS TABLE
# ----------------------------
specialties = [
    "Cardiology", "Internal Medicine", "Family Medicine", "Orthopedics",
    "Neurology", "ENT", "Dermatology", "Pediatrics", "Gastroenterology",
    "Pulmonology"
]

clinic_locations = [
    "Irvine", "Newport Beach", "Costa Mesa", "Tustin",
    "Anaheim", "Orange", "Mission Viejo", "Santa Ana"
]

providers = []
for i in range(1, NUM_PROVIDERS + 1):
    providers.append({
        "provider_id": i,
        "provider_name": fake.name(),
        "specialty": random.choice(specialties),
        "clinic_location": random.choice(clinic_locations)
    })

providers_df = pd.DataFrame(providers)

# ----------------------------
# INSURANCE TABLE
# ----------------------------
payer_names = [
    "Blue Shield", "Aetna", "Cigna", "UnitedHealthcare", "Anthem",
    "Medicare", "Medicaid", "Humana", "Molina", "Health Net"
]

payer_type_map = {
    "Blue Shield": "Commercial",
    "Aetna": "Commercial",
    "Cigna": "Commercial",
    "UnitedHealthcare": "Commercial",
    "Anthem": "Commercial",
    "Medicare": "Government",
    "Medicaid": "Government",
    "Humana": "Commercial",
    "Molina": "Government",
    "Health Net": "Commercial"
}

insurance = []
for i, payer in enumerate(payer_names, start=1):
    insurance.append({
        "insurance_id": i,
        "payer_name": payer,
        "payer_type": payer_type_map[payer]
    })

insurance_df = pd.DataFrame(insurance)

# ----------------------------
# CLAIMS TABLE
# ----------------------------
claim_profiles = [
    "Office Visit", "Follow-Up", "Procedure", "Consultation",
    "Imaging", "Lab", "Surgery", "Therapy"
]

claim_statuses = ["Paid", "Pending", "Denied"]


def generate_amounts(profile, payer_type):
    base_map = {
        "Office Visit": (120, 250),
        "Follow-Up": (90, 180),
        "Procedure": (500, 2500),
        "Consultation": (150, 350),
        "Imaging": (250, 1200),
        "Lab": (50, 300),
        "Surgery": (3000, 15000),
        "Therapy": (100, 500)
    }

    billed_min, billed_max = base_map[profile]
    billed = round(random.uniform(billed_min, billed_max), 2)

    # allowed_amount usually lower than billed
    allowed = round(billed * random.uniform(0.65, 0.95), 2)

    # government payers tend to reimburse differently
    if payer_type == "Government":
        paid = round(allowed * random.uniform(0.75, 0.95), 2)
    else:
        paid = round(allowed * random.uniform(0.70, 0.98), 2)

    return billed, allowed, paid


claims = []
start_date = pd.Timestamp("2023-01-01")
end_date = pd.Timestamp("2024-12-31")
date_range_days = (end_date - start_date).days

for claim_id in range(1, NUM_CLAIMS + 1):
    provider = random.choice(providers)
    insurer = random.choice(insurance)
    claim_profile = random.choice(claim_profiles)

    service_date = start_date + \
        timedelta(days=random.randint(0, date_range_days))
    submission_date = service_date + timedelta(days=random.randint(1, 15))

    billed_amount, allowed_amount, paid_amount = generate_amounts(
        claim_profile, insurer["payer_type"]
    )

    # denial logic
    denial_flag = 1 if random.random() < 0.08 else 0

    if denial_flag == 1:
        claim_status = "Denied"
        paid_amount = 0.00
    else:
        claim_status = random.choices(
            ["Paid", "Pending"],
            weights=[0.85, 0.15],
            k=1
        )[0]
        if claim_status == "Pending":
            paid_amount = round(paid_amount * random.uniform(0.0, 0.4), 2)

    claims.append({
        "claim_id": claim_id,
        "patient_id": random.randint(10000, 99999),
        "provider_id": provider["provider_id"],
        "service_date": service_date.date(),
        "submission_date": submission_date.date(),
        "insurance_id": insurer["insurance_id"],
        "claim_profile": claim_profile,
        "billed_amount": billed_amount,
        "allowed_amount": allowed_amount,
        "paid_amount": paid_amount,
        "claim_status": claim_status,
        "denial_flag": denial_flag
    })

claims_df = pd.DataFrame(claims)

# ----------------------------
# SAVE CSV FILES
# ----------------------------
providers_df.to_csv("providers.csv", index=False)
insurance_df.to_csv("insurance.csv", index=False)
claims_df.to_csv("claims.csv", index=False)

print("CSV files created successfully:")
print("- providers.csv")
print("- insurance.csv")
print("- claims.csv")
