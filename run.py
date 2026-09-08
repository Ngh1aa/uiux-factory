import argparse
import asyncio
from pathlib import Path

from core.manager.development_manager import (
    DevelopmentManager,
)


ROOT = Path(__file__).resolve().parent


async def main(goal: str) -> None:
    print()
    print("=" * 64)
    print("UIUX FACTORY")
    print("=" * 64)

    manager = DevelopmentManager(
        root=ROOT
    )

    run_context = await manager.run(
        goal
    )

    print()
    print("=" * 64)

    print(
        f"[Run] {run_context.run_id}"
    )

    print(
        f"[Status] {run_context.status.upper()}"
    )

    print(
        "[Completed Stages] "
        + ", ".join(
            run_context.completed_stages
        )
    )

    print(
        f"[Run State] "
        f"{run_context.state_path}"
    )

    print("=" * 64)
    print()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="UIUX Factory"
    )

    parser.add_argument(
        "goal",
        type=str,
        help="Natural language product goal",
    )

    args = parser.parse_args()

    asyncio.run(
        main(args.goal)
    )