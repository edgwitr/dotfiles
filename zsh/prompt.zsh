# ───【1】キャッシュ用のグローバル変数を定義 ────────────────────
# プロンプト用に一度だけ Git 情報を取っておき、そのまま返す仕組みを作る。
typeset -g _git_prompt_cache=""    # キャッシュ文字列（branch + アイコン類）
typeset -g _git_prompt_time=0      # 最終更新時刻 (秒単位のタイムスタンプ)
typeset -g _git_prompt_pwd=""      # 最終更新時にいた PWD

# ───【2】キャッシュを更新する関数を定義 ─────────────────────────
# ここで実際に 'git status --porcelain --branch' を叩いて、
# キャッシュを _git_prompt_cache に入れ直す。必要がなければスキップする。
update_git_cache() {
  # 1. まず「カレントディレクトリが変わったか」を見る
  if [[ "$_git_prompt_pwd" != "$PWD" ]]; then
    _git_prompt_pwd="$PWD"
    _git_prompt_time=0
    _git_prompt_cache=""
  fi

  # 2. 時間差チェック (<1秒ならスキップ)
  local now=$(date +%s)
  if (( now - _git_prompt_time < 1 )) && [[ -n "$_git_prompt_cache" ]]; then
    return
  fi

  # 3. Git リポジトリでないなら即終了
  local gitdir
  gitdir=$(git rev-parse --git-dir 2>/dev/null) || return

  # 4. Git 情報を取得
  local git_status branch icon stash_count remote_status

  git_status=$(git status --porcelain --branch 2>/dev/null)

  # (a) ブランチ名の抽出。コミットがない場合のメッセージにも対応。
  branch=$(echo "$git_status" \
           | head -n1 \
           | sed -E 's/^## ([^\.]+).*$/\1/' \
           | sed 's/No commits yet on //')

  icon=""

  # (b) 作業ツリーの状態に応じてアイコンを付与
  [[ "$git_status" == *$'\n'[MA][MTD\ ]* ]] && icon+="+"
  [[ "$git_status" == *$'\n'[MTARC\ ]M* ]]  && icon+="!"
  [[ "$git_status" == *$'\n'[MTARC\ ]D* ]]  && icon+="d"
  [[ "$git_status" == *$'\n'\?\?* ]]        && icon+="?"
  [[ "$git_status" == *$'\n'D.* ]]          && icon+="D"
  [[ "$git_status" == *$'\n'R.* ]]          && icon+="R"
  [[ "$git_status" == *$'\n'C.* ]]          && icon+="C"
  [[ "$git_status" == *$'\n'UU* ]]          && icon+="="

  # (c) stash の個数を調べてアイコンに追加
  if [[ -f "$gitdir/refs/stash" ]]; then
    stash_count=$(wc -l < "$gitdir/refs/stash")
    icon+="\$${stash_count}"
  fi

  # (d) リモートとの差分(ahead/behind)を検出
  remote_status=$(echo "$git_status" | head -n1)
  if [[ "$remote_status" =~ \[ahead\ ([0-9]+)\] ]]; then
    # BASH の配列マッチではないので、ここは zsh では match 抽出方法が異なる点に注意
    # zsh では `[[ 文字列 =~ 正規表現 ]]` の直後に $match[N] がセットされる
    icon+=">${match[1]}"
  fi
  if [[ "$remote_status" =~ \[behind\ ([0-9]+)\] ]]; then
    icon+="<${match[1]}"
  fi

  # 5. 最終的にキャッシュ文字列を作って保存
  if [[ -n $icon ]]; then
    _git_prompt_cache="${branch} (${icon})"
  else
    _git_prompt_cache="${branch}"
  fi

  _git_prompt_time=$now
}

# ───【3】プロンプトで使う関数は「キャッシュ済み文字列を返すだけ」 ──────
git_prompt_info() {
  # ただ _git_prompt_cache の中身を返すだけ。
  # update_git_cache は precmd フックで必ず走っているので、
  # ここでは余計なロジックは不要。
  [[ -n $_git_prompt_cache ]] && echo "$_git_prompt_cache"
}


# ───【4】precmd フックにキャッシュ更新関数を登録 ────────────────────
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_git_cache


# ───【5】実際のプロンプトを設定 ─────────────────────────────────
setopt PROMPT_SUBST
PROMPT=$'%F{cyan}[%~]%f %F{yellow}$(git_prompt_info)%f\n%F{%(?.green.red)}%L>%f '
