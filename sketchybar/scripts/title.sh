#!/bin/bash

# 使用 osascript 获取当前活动应用的名称
FRONT_APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

# 检查是否成功获取到应用名称
if [[ -z "$FRONT_APP_NAME" ]]; then
  # 如果没有获取到活动应用（例如，焦点在桌面上），则清空标题
  # 检查代理项当前值，避免不必要的更新和动画
  if [[ "$(sketchybar --query title_proxy | jq -r '.label.value // ""')" != "" ]]; then
    sketchybar --set title_proxy label=""
    sketchybar --animate circ 15 --set title y_offset=70 # 动画：移出
    sketchybar --set title label=""
  fi
  exit 0
fi

# 尝试获取该应用的第一个窗口标题 (如果窗口不存在或无标题，则返回空)
FRONT_WINDOW_TITLE=$(osascript -e 'tell application "System Events" to tell process "'"$FRONT_APP_NAME"'" try get value of attribute "AXTitle" of window 1 on error "" end try' 2>/dev/null)

# 决定最终显示的标签：优先用窗口标题，如果为空则用应用名称
if [[ -n "$FRONT_WINDOW_TITLE" ]]; then
  FINAL_LABEL="$FRONT_WINDOW_TITLE"
else
  FINAL_LABEL="$FRONT_APP_NAME"
fi

# --- 与 SketchyBar 交互 ---

# 获取代理项当前的标签值 (如果查询失败或标签为空，则默认为空字符串)
CURRENT_PROXY_LABEL=$(sketchybar --query title_proxy | jq -r '.label.value // ""')

# 检查最终标签是否与代理项记录的标签不同
if [[ "$CURRENT_PROXY_LABEL" != "$FINAL_LABEL" ]]; then
  # 如果标签发生变化：
  # 1. 更新代理项，记录新的标签
  sketchybar --set title_proxy label="$FINAL_LABEL"

  # 2. 执行动画 (与你原来的脚本保持一致)
  sketchybar --animate circ 15 --set title y_offset=70 \
    --animate circ 10 --set title y_offset=7 \
    --animate circ 15 --set title y_offset=0

  # 3. 更新实际显示的 title 项的标签
  sketchybar --set title label="$FINAL_LABEL"
fi

exit 0

