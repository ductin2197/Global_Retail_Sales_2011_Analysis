# Global Retail Sales Analysis 2011
![SQL](https://img.shields.io/badge/SQL-00758F?style=for-the-badge&logo=postgresql&logoColor=white) ![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)
## Project Overview
Dự án truy vấn và phân tích hơn 500,000 giao dịch bán lẻ để tìm ra pattern doanh thu, từ đó tìm ra pros & cons, insights & actions.
- **SQL:** Làm sạch dữ liệu và xử lý các giao dịch lỗi.
- **Tableau:** Trực quan hóa dữ liệu với các chỉ số quan trọng (85% doanh thu đến từ UK).

## Preview Dashboard [**Xem thêm trên Tableau Public**](https://public.tableau.com/app/profile/t.n.tr.n8477/viz/Retail_Sales_17762621520820/GLOBALRETAILSALESPERFORMANCEDASHBOARD2011_?publish=yes)
![Dashboard Preview](DEMO.gif)

## SQL 
Quá trình truy vấn và làm sạch dữ liệu được thực hiện bằng SQL.
 [**Xem chi tiết các câu lệnh SQL tại đây**](./data_cleaning_steps.sql)
## SQL Highlights
```sql
/* - Tổng doanh thu từng nước.
- Bỏ UK để so sánh các thị trường khác. Do UK là thị trường áp đảo nên exclude ra.
- Lấy Top 5 nước cao nhất */
SELECT Country, SUM(Revenue) AS Total_Revenue_By_Country
FROM cleaned_data
WHERE Country <> 'United Kingdom'
GROUP BY Country
ORDER BY Total_Revenue_By_Country DESC
LIMIT 5;

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
```

## Architecture Diagram
```mermaid

    subgraph Data_Source [Data Source]
        A[Raw Sales Data]
    end

    subgraph Data_Processing [SQL Analytics Layer]
        B[SQL Transformation]
        C[Aggregations & Segmentation]
    end

    subgraph Visualization [Visualization Layer]
        D[Tableau Dashboard]
    end

    subgraph Decision [Decision Support]
        E[Business Insights]
        F[Strategic Recommendations]
    end

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F

    style A fill:#E3F2FD,stroke:#1E88E5,stroke-width:2px
    style B fill:#FFF3E0,stroke:#FB8C00,stroke-width:2px
    style C fill:#FFF3E0,stroke:#FB8C00,stroke-width:2px
    style D fill:#E8F5E9,stroke:#43A047,stroke-width:2px
    style E fill:#F3E5F5,stroke:#8E24AA,stroke-width:2px
    style F fill:#FCE4EC,stroke:#D81B60,stroke-width:2px
```
## Key Business Insights
Dựa trên kết quả phân tích, rút ra được các insights sau:

### Phân Tích Key Insights
* **Rủi ro thị trường:** **85%** doanh thu tập trung tại **United Kingdom**, cho thấy sự phụ thuộc lớn vào một thị trường duy nhất.
* **Tính mùa vụ:** Doanh thu tăng vọt vào **Tháng 11** (hơn **£1.5M**), do ảnh hưởng từ xu hướng mua sắm cuối năm, các chương trình khuyến mãi Black Friday & chuẩn bị cho mùa lễ hội Halloween, Christmas.
   `Fact-check:` _Khớp với xu hướng mua sắm cuối năm toàn cầu năm 2011. Theo [PR Newswire](https://www.prnewswire.com/news-releases/global-b2c-e-commerce-market-report-2011-136250253.html), tháng 11/2011 ghi nhận mức tăng trưởng kỷ lục nhờ các sự kiện giảm giá._
* **Khung giờ vàng:** **80%** giao dịch diễn ra từ **10:00 sáng - 3:00 chiều**, đây là thời điểm khách hàng hoạt động mạnh nhất.

---
### Đề Xuất Hành Động
* **Đa dạng hóa:** Mở rộng tiếp thị sang các thị trường EU (Pháp, Đức) để giảm bớt sự phụ thuộc vào thị trường Anh.
* **Quản trị nguồn lực:** Tăng cường lượng hàng tồn kho và nhân sự hỗ trợ trong **Quý 4** để khai thác tối đa sức mua cuối năm.
* **Tối ưu quảng cáo:** Tập trung chạy các chiến dịch khuyến mãi và Flash Sale vào **Khung giờ vàng** để tối ưu hóa conversion rates.
