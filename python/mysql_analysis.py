import os
import matplotlib.pyplot as plt
import mysql.connector
import pandas as pd

# ==========================================
# 1. 数据库连接模块
# ==========================================


def connect_database():
    # 建立与 MySQL 数据库的连接
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Sly041632",
        database="financial_project",
    )
    print("Database connected successfully!")
    return connection


# ==========================================
# 2. 核心业务逻辑与数据处理
# ==========================================


def main():
    # 初始化数据库连接
    connection = connect_database()

    # 编写 SQL 查询语句：计算 2024 年度的股票收益率并关联财务指标 (ROE)
    query = """
    WITH stock_return AS (
        SELECT
            start_price.company_id,
            (end_price.close_price - start_price.close_price) / start_price.close_price AS return_rate
        FROM stock_price AS start_price
        JOIN stock_price AS end_price ON start_price.company_id = end_price.company_id
        WHERE start_price.date = '2024-01-05'
          AND end_price.date = '2024-12-05'
    )
    SELECT
        company.company_name,
        financials.roe,
        financials.revenue,
        stock_return.return_rate
    FROM company
    JOIN financials ON company.company_id = financials.company_id
    JOIN stock_return ON company.company_id = stock_return.company_id
    WHERE financials.year = 2024;
    """

    # 使用 Pandas 读取 SQL 数据并转化为 DataFrame
    df = pd.read_sql(query, connection)

    # 关闭数据库连接
    connection.close()

    # 数据预处理：将收益率转换为百分比形式
    df["return_rate"] = df["return_rate"] * 100

    print("--- 原始数据展示 ---")
    print(df)

    # ==========================================
    # 3. 数据分析与计算
    # ==========================================

    # 按 ROE 从高到低进行排序
    roe_rank = df.sort_values(by="roe", ascending=False)
    print("\n--- ROE 排名 ---")
    print(roe_rank)

    # 按股票收益率从高到低进行排序
    return_rank = df.sort_values(by="return_rate", ascending=False)
    print("\n--- 股票收益率排名 ---")
    print(return_rank)

    # 计算并打印核心指标的行业平均值
    print("\n--- 行业核心指标平均值 ---")
    print(f"平均 ROE: {df['roe'].mean():.2f}%")
    print(f"平均股票收益率: {df['return_rate'].mean():.2f}%")

    # ==========================================
    # 4. 数据可视化模块
    # ==========================================

    # 图表 1：企业 ROE 对比柱状图
    plt.figure(figsize=(8, 5))
    plt.bar(df["company_name"], df["roe"])
    plt.xlabel("Company")
    plt.ylabel("ROE (%)")
    plt.title("ROE Comparison")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

    # 图表 2：企业股票收益率对比柱状图 (按收益率降序排列)
    plt.figure(figsize=(8, 5))
    plt.bar(return_rank["company_name"], return_rank["return_rate"])
    plt.xlabel("Company")
    plt.ylabel("Stock Return (%)")
    plt.title("Stock Return Comparison")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

    # 图表 3：ROE 与股票收益率的交叉散点图 (探索相关性)
    plt.figure(figsize=(6, 5))
    plt.scatter(df["roe"], df["return_rate"])
    plt.xlabel("ROE (%)")
    plt.ylabel("Stock Return (%)")
    plt.title("ROE vs Stock Return")

    # 为散点图中的每个样本点添加公司名称标签 (.iloc 可以确保按位置索引准确对齐)
    for i, name in enumerate(df["company_name"]):
        plt.text(
            df["roe"].iloc[i],
            df["return_rate"].iloc[i],
            name,
            fontsize=9,
        )
    plt.tight_layout()
    plt.show()

    # ==========================================
    # 5. 数据导出模块
    # ==========================================
    output_filename = "financial_analysis.xlsx"
    with pd.ExcelWriter(output_filename) as writer:
        df.to_excel(writer, sheet_name="Financial Data", index=False)
        roe_rank.to_excel(writer, sheet_name="ROE Ranking", index=False)
        return_rank.to_excel(writer, sheet_name="Return Ranking", index=False)

    print("\n==========================================")
    print(f"当前工作目录: {os.getcwd()}")
    print(f"Excel 报表已成功创建，文件名: {output_filename}")
    print("==========================================")


# ==========================================
# 6. 程序主入口
# ==========================================
if __name__ == "__main__":
    print("Financial Analysis Project Started...")
    main()
