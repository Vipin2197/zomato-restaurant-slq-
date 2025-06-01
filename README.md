🗃️ Data Modeling
Tables Created:

Main

Currency

Country

CalendarTable


Calendar Table Enhancements:

Derived from the Datekey_Opening column, spanning from the minimum to maximum dates.

Added columns:

Year

MonthNo

MonthName

Quarter (Q1–Q4)

YearMonth (YYYY-MMM)

WeekdayNo

WeekdayName

FinancialMonth (April = FM1, ..., March = FM12)

FinancialQuarter

📈 Key Analyses & SQL Queries
Currency Conversion:

Converted Average_Cost_for_two from local currencies to USD using exchange rates from the Currency table.

Restaurant Distribution:

Counted the number of restaurants based on city and country.

Temporal Analysis:

Analyzed the number of restaurant openings based on year, quarter, and month.

Rating Distribution:

Categorized restaurants based on average ratings into buckets (e.g., 0–2, 2–3, etc.).

Price Range Bucketing:

Created buckets based on average price and determined the number of restaurants in each bucket.

Service Availability:

Calculated the percentage of restaurants offering table booking and online delivery services.

Top Performers:

Identified top restaurants based on ratings and votes across different countries.

Cuisine Analysis:

Extracted primary cuisines from the Cuisines column for further analysis.

📊 Dashboard Features
Visualizations:

Geographic Heatmap: Displays restaurant density and average ratings by city/country.

Cuisine Analysis: Pie chart or treemap showing popular cuisines and their average ratings.

Price vs. Rating Scatter Plot: Highlights the relationship between cost and customer satisfaction.

Top Restaurants Table: Ranks restaurants by ratings, votes, or affordability.

Interactivity:

Dynamic filters for country, city, cuisine, and service availability.

Drill-down capabilities for temporal analyses (year → quarter → month).

📌 Business Insights
Menu Optimization: Restaurants can adjust offerings based on cuisine popularity and pricing trends.

Marketing Strategies: Target high-potential locations or underrated cuisines for promotions.

Expansion Planning: Identify cities with high demand but low supply for specific cuisines.

Customer Insights: Understand preferences to improve dining experiences and loyalty programs.

