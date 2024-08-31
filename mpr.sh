#!/bin/bash

# 使用方法をチェック
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <path> <commit_message> [<repo1> <repo2> ...]"
    echo "Example: $0 .github/dependabot.yml 'Add Dependabot configuration' owner1/repo1 owner2/repo2"
    echo "Example: $0 .github/workflows 'Update GitHub Actions' owner1/repo1 owner2/repo2"
    exit 1
fi

TARGET_PATH="$1"
COMMIT_MESSAGE="$2"
shift 2
REPOS=("$@")

# パスの存在確認
if [ ! -e "$TARGET_PATH" ]; then
    echo "Error: Specified path does not exist."
    exit 1
fi

# 認証状態をチェック
if ! gh auth status &>/dev/null; then
    echo "Error: Not authenticated with GitHub. Please run 'gh auth login' first."
    exit 1
fi

update_repo() {
    local REPO="$1"
    echo "Processing repository: $REPO"

    # 一時ディレクトリの作成
    TEMP_DIR=$(mktemp -d)

    # リポジトリをクローン
    gh repo clone "$REPO" "$TEMP_DIR" || { echo "Failed to clone $REPO"; return 1; }

    # 作業ディレクトリを変更
    cd "$TEMP_DIR" || return 1

    # 新しいブランチを作成
    BRANCH_NAME="update-$(basename "$TARGET_PATH")-$(date +%Y%m%d%H%M%S)"
    git checkout -b "$BRANCH_NAME"

    # ターゲットパスのコピー
    if [ -d "$OLDPWD/$TARGET_PATH" ]; then
        # ディレクトリの場合
        mkdir -p "$TARGET_PATH"
        cp -R "$OLDPWD/$TARGET_PATH"/* "$TARGET_PATH"/ 2>/dev/null
    else
        # ファイルの場合
        mkdir -p "$(dirname "$TARGET_PATH")"
        cp "$OLDPWD/$TARGET_PATH" "$TARGET_PATH"
    fi

    # 変更をコミット
    git add "$TARGET_PATH"
    git commit -m "$COMMIT_MESSAGE"

    # 変更をプッシュ
    git push -u origin "$BRANCH_NAME"

    # プルリクエストを作成
    PR_TITLE="Update $(basename "$TARGET_PATH")"
    PR_BODY="This PR updates the $(basename "$TARGET_PATH") path."
    gh pr create --title "$PR_TITLE" --body "$PR_BODY" --head "$BRANCH_NAME"

    # 一時ディレクトリを削除
    cd "$OLDPWD" || return 1
    rm -rf "$TEMP_DIR"

    echo "Completed processing for $REPO"
    echo "------------------------"
}

for REPO in "${REPOS[@]}"; do
    update_repo "$REPO"
done

echo "All specified repositories processed."
