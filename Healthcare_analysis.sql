CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(100),
    clinic_location VARCHAR(100)
);

CREATE TABLE insurance (
    insurance_id INT PRIMARY KEY,
    payer_name VARCHAR(100),
    payer_type VARCHAR(50)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    service_date DATE,
    submission_date DATE,
    insurance_id INT,
    claim_profile VARCHAR(50),
    billed_amount DECIMAL(10,2),
    allowed_amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    claim_status VARCHAR(30),
    denial_flag INT,
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    FOREIGN KEY (insurance_id) REFERENCES insurance(insurance_id)
);
SELECT * FROM providers
limit 5;
SELECT * 
FROM claims
LIMIT 5;
SELECT COUNT(*) FROM claims;

SELECT
    p.provider_name,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    SUM(c.paid_amount) AS total_paid,
    ROUND(AVG(c.paid_amount), 2) AS avg_paid_per_claim,
    ROUND(SUM(c.denial_flag) / COUNT(c.claim_id), 4) AS denial_rate
FROM claims c
JOIN providers p
    ON c.provider_id = p.provider_id
GROUP BY p.provider_name
ORDER BY total_paid DESC;
    
SELECT
    i.payer_name,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.billed_amount) AS total_billed,
    SUM(c.paid_amount) AS total_paid,
    (SUM(c.paid_amount) / SUM(c.billed_amount))  AS Pymnt_rate,
    ROUND(SUM(c.denial_flag) / COUNT(c.claim_id), 4) AS denial_rate
FROM claims c
JOIN insurance i
    ON c.insurance_id = i.insurance_id
GROUP BY i.payer_name
ORDER BY total_paid DESC;
    
SELECT
    DATE_FORMAT(service_date, '%Y-%m') AS service_month,
    COUNT(claim_id) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(paid_amount) AS total_paid,
    (SUM(paid_amount) / SUM(billed_amount))   AS Pymnt_rate
FROM claims
GROUP BY DATE_FORMAT(service_date, '%Y-%m')
ORDER BY service_month;

SELECT
    claim_profile,
    COUNT(claim_id) AS total_claims,
    SUM(billed_amount) AS total_billed,
    SUM(paid_amount) AS total_paid,
    (SUM(paid_amount) / SUM(billed_amount))  AS Pymnt_rate
FROM claims
GROUP BY claim_profile
ORDER BY total_paid DESC;