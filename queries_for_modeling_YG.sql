/* NOTE: we assume users did not change their subscription level after initial purchase */


/* STEP 1. Defining cohorts based on the first month of subscription for each account (account_id). This is done for each product (plan) and each currency. 
Dates are defaulted to the first day of the month for ease of calculation. */




WITH cohort_data AS (
    SELECT
        account_id,
        MIN(DATE_TRUNC('MONTH', start_date)) OVER (PARTITION BY account_id) AS cohort_start_date,
        plan,
        currency
    FROM
        sales
),

/* STEP 2. Calculate number of payments per user */

payments_user AS (
	SELECT 
		account_id,
		count(account_id) as number_of_payments
	FROM 
		sales
	GROUP BY 
		account_id
)
,

/* STEP 3. Merge cohort data with additional user information */

summary_info AS (
SELECT 
	DISTINCT (c.account_id), c.plan, c.currency, c.cohort_start_date, 
	p.number_of_payments, u.gender, u.genre1, u.genre2, u.type, u.games, 
	u.age, u.hours
FROM cohort_data c
INNER JOIN payments_user p --  include only account_ids that have payment information available.
ON p.account_id = c.account_id
LEFT JOIN user_activity u  -- retain all accounts from the above
ON p.account_id = u.account_id
)


/* STEP 4. Define churners and filter based on payment history and cohort start date */

SELECT 
    si.*,
    CASE 
        WHEN number_of_payments >= 7 THEN 0 /* not a churner */
        WHEN
		(cohort_start_date < DATE_TRUNC('MONTH', '2020-12-31'::date - INTERVAL '5' MONTH) AND number_of_payments < 7) /* had sufficient time to make at least 7 payments */
        OR
        (cohort_start_date >= DATE_TRUNC('MONTH', '2020-12-31'::date - INTERVAL '5' MONTH) AND number_of_payments <= EXTRACT(MONTH FROM AGE('2020-12-31'::date, cohort_start_date::date))) THEN 1 /* had sufficient time to all corresponding payments */
        ELSE 2 /* maybe a churner */
    END AS is_churner,
    CASE 
        WHEN number_of_payments < 3 THEN 1 /* number of payments less than 3 */
        ELSE 0 /* number of payments 3 or more */
    END AS one_two_payments
FROM summary_info si;
