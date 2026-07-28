from pathlib import Path

OUTPUT_DIR = Path(__file__).resolve().parent.parent / "output"
OUTPUT_DIR.mkdir(exist_ok=True)

import matplotlib.pyplot as plt


def draw_roe_chart(df):
    plt.figure(figsize=(8, 5))
    plt.bar(df["company_name"], df["roe"])
    plt.xlabel("Company")
    plt.ylabel("ROE (%)")
    plt.title("ROE Comparison")
    plt.xticks(rotation=45)
    plt.tight_layout()

    plt.savefig(OUTPUT_DIR / "ROE Comparison.png", dpi=300, bbox_inches="tight")

    plt.show()


def draw_return_chart(return_rank):
    plt.figure(figsize=(8, 5))
    plt.bar(return_rank["company_name"], return_rank["return_rate"])
    plt.xlabel("Company")
    plt.ylabel("Stock Return (%)")
    plt.title("Stock Return Comparison")
    plt.xticks(rotation=45)
    plt.tight_layout()

    plt.savefig(
        OUTPUT_DIR / "Stock Return Comparison.png", dpi=300, bbox_inches="tight"
    )

    plt.show()


def draw_scatter_chart(df):
    plt.figure(figsize=(6, 5))
    plt.scatter(df["roe"], df["return_rate"])
    plt.xlabel("ROE (%)")
    plt.ylabel("Stock Return (%)")
    plt.title("ROE vs Stock Return")

    for i, name in enumerate(df["company_name"]):
        plt.text(
            df["roe"].iloc[i],
            df["return_rate"].iloc[i],
            name,
            fontsize=9,
        )

    plt.tight_layout()

    plt.savefig(OUTPUT_DIR / "ROE vs Stock Return.png", dpi=300, bbox_inches="tight")

    plt.show()
