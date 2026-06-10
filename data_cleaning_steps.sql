/* - Loại bỏ hàng trả (InvoiceNo có 'C').
- Loại bỏ lỗi nhập liệu (Quantity, UnitPrice <= 0).
- Tạo cột Revenue tính doanh thu */
CREATE TABLE cleaned_data AS 
SELECT *, (Quantity * UnitPrice) AS Revenue
FROM OnlineRetail
WHERE Quantity > 0 
  AND UnitPrice > 0 
  AND InvoiceNo NOT LIKE 'C%';
  
  /* So sánh doanh thu UK với tất cả các quốc gia khác cộng lại.
Tại sao: Để xác định xem đây có phải là doanh nghiệp tập trung nội địa hay không */
SELECT 
    CASE WHEN Country = 'United Kingdom' THEN 'UK' ELSE 'International' END AS Market_Type,
    ROUND(SUM(Revenue), 2) AS Total_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Order_Count
FROM cleaned_data 
GROUP BY Market_Type;

/* - Tổng doanh thu từng nước.
- Bỏ UK để so sánh các thị trường khác. Do UK là thị trường áp đảo nên exclude ra.
- Lấy Top 10 nước cao nhất */
SELECT Country, SUM(Revenue) AS Total_Revenue_By_Country
FROM cleaned_data
WHERE Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Total_Revenue_By_Country DESC
LIMIT 10;

/* - Xếp hạng các quốc gia theo tổng doanh thu.
   - Sử dụng Window Function để tạo bảng xếp hạng.
   - Xác định các thị trường đóng góp doanh thu cao nhất. */

WITH country_revenue AS (
    SELECT
        Country,
        SUM(Revenue) AS Revenue
    FROM cleaned_data
    GROUP BY Country
)

SELECT
    Country,
    Revenue,
    RANK() OVER(
        ORDER BY Revenue DESC
    ) AS Revenue_Rank
FROM country_revenue;

/* - Tổng tiền theo tên hàng.
- Top 5 products by revenue. */
SELECT Description, SUM(Revenue) AS Total_Revenue_By_Product
FROM cleaned_data
GROUP BY Description
ORDER BY Total_Revenue_By_Product DESC
LIMIT 5;


/* - Tách tháng từ cột ngày.
- Xem biến động dòng tiền theo thời gian. */
SELECT STRFTIME('%Y-%m', InvoiceDate) AS Month, 
       SUM(Revenue) AS Monthly_Revenue
FROM cleaned_data
GROUP BY Month
ORDER BY Month;

/* - Tính giá trị trung bình của mỗi đơn hàng (Average Order Value).
   - Gom doanh thu theo từng Invoice trước khi tính trung bình.
   - Đánh giá quy mô chi tiêu điển hình của khách hàng. */

WITH order_revenue AS (
    SELECT
        InvoiceNo,
        SUM(Revenue) AS Order_Value
    FROM cleaned_data
    GROUP BY InvoiceNo
)

SELECT
    ROUND(AVG(Order_Value), 2) AS Average_Order_Value
FROM order_revenue;






















