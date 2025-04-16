#!/bin/bash

# --- 配置区 ---
ITEM_NAME="countdown" # SketchyBar 项目的名称
# !!! 确保这是你正确的 Obsidian 文件路径 !!!
OBSIDIAN_FILE="/Users/zhijie/Archive/zhijie-ob/Others/Projects Working On.md"
ICON=" | "                # 任务名和时间之间的分隔符图标
DEADLINE_REACHED_MSG="✅ " # 完成消息前缀 (任务名会加在后面)
ERROR_MSG="⚠️ 任务解析错误:"
SED_CMD="sed" # 如果安装了 gnu-sed，可以改为 "gsed"

# --- 滚动配置 ---
MAX_LENGTH=60          # 设置不滚动的最大字符数
SCROLL_SEPARATOR="   " # 滚动时重复文本之间的分隔符
# 状态文件，用于存储当前的滚动偏移量
STATE_FILE_SCROLL_OFFSET="/tmp/sketchybar_countdown_scroll_offset"
# --- 配置区结束 ---

# --- 函数：读取滚动偏移量 ---
get_scroll_offset() {
  if [[ -f "$STATE_FILE_SCROLL_OFFSET" ]]; then
    current_offset=$(cat "$STATE_FILE_SCROLL_OFFSET")
    if [[ "$current_offset" =~ ^[0-9]+$ ]]; then
      echo "$current_offset"
      return
    fi
  fi
  echo 0 # 默认或无效时返回 0
}

# --- 函数：写入滚动偏移量 ---
set_scroll_offset() {
  echo "$1" >"$STATE_FILE_SCROLL_OFFSET"
}

# --- 函数：移除滚动状态 ---
reset_scroll_offset() {
  rm -f "$STATE_FILE_SCROLL_OFFSET"
}

# --- 文件检查 ---
if [[ ! -f "$OBSIDIAN_FILE" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 文件未找到"
  reset_scroll_offset # 清理状态
  exit 1
fi

# --- 解析 Obsidian 文件 ---
TASK_NAME=""
DEADLINE_STR_RAW=""
# 1. 找到第一个二级标题 (##) 所在的行号 (忽略注释不影响此步)
h2_line_num=$(grep -n -m 1 '^## ' "$OBSIDIAN_FILE" | cut -d: -f1)
if [[ -z "$h2_line_num" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 未找到二级标题 (##)"
  reset_scroll_offset
  exit 1
fi

# 2. 从二级标题后开始，过滤掉注释行，然后找到第一个三级标题 (###) 并提取任务名称
#    <--- 修改点: 添加 grep -v ---
TASK_NAME=$(tail -n +$((h2_line_num + 1)) "$OBSIDIAN_FILE" | grep -v '^%%.*%%$' | grep -m 1 '^### ' | $SED_CMD 's/^### //')
if [[ -z "$TASK_NAME" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 未找到三级标题 (###)"
  reset_scroll_offset
  exit 1
fi

# 3. 找到包含任务名称的三级标题的行号 (忽略注释不影响此步，因为 tail 基于原始行号)
h3_line_num=$(grep -n "^### $TASK_NAME" "$OBSIDIAN_FILE" | head -n 1 | cut -d: -f1)
if [[ -z "$h3_line_num" ]]; then
  # 回退逻辑：查找第一个 H3 的相对行号 (也需要过滤注释)
  relative_h3_line=$(tail -n +$((h2_line_num + 1)) "$OBSIDIAN_FILE" | grep -v '^%%.*%%$' | grep -n -m 1 '^### ' | cut -d: -f1)
  if [[ -n "$relative_h3_line" ]]; then
    # 计算绝对行号 (注意：这可能因过滤注释而不精确，但作为回退方案)
    # 这是一个近似值，假设注释行不多
    h3_line_num=$((h2_line_num + relative_h3_line))
  fi
fi
if [[ -z "$h3_line_num" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 无法定位三级标题行号"
  reset_scroll_offset
  exit 1
fi

# 4. 从该三级标题后开始，过滤掉注释行，然后找到第一个 "Due date::" 行并提取日期字符串
#    <--- 修改点: 添加 grep -v ---
DEADLINE_STR_RAW=$(tail -n +$((h3_line_num + 1)) "$OBSIDIAN_FILE" | grep -v '^%%.*%%$' | grep -m 1 'Due date::' | $SED_CMD 's/Due date:: *//')
if [[ -z "$DEADLINE_STR_RAW" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 未找到截止日期 (Due date::)"
  reset_scroll_offset
  exit 1
fi
# --- 解析结束 ---

# --- 日期转换 ---
DEADLINE_STR=$($SED_CMD -e 's/ 年 /-/g' -e 's/ 月 /-/g' -e 's/ 日 / /g' <<<"$DEADLINE_STR_RAW")
if [[ -z "$DEADLINE_STR" ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 日期格式转换失败"
  reset_scroll_offset
  exit 1
fi
# --- 日期转换结束 ---

# --- 计算倒计时 ---
DEADLINE_SEC=$(date -j -f "%Y-%m-%d %H:%M:%S" "$DEADLINE_STR" "+%s" 2>/dev/null)
if ! [[ "$DEADLINE_SEC" =~ ^[0-9]+$ ]]; then
  sketchybar --set $ITEM_NAME label="$ERROR_MSG 无效日期格式 ($DEADLINE_STR)"
  reset_scroll_offset
  exit 1
fi
NOW_SEC=$(date "+%s")
REMAINING_SEC=$((DEADLINE_SEC - NOW_SEC))

# --- 格式化基础标签 ---
BASE_LABEL=""
if [[ "$REMAINING_SEC" -le 0 ]]; then
  BASE_LABEL="$DEADLINE_REACHED_MSG $TASK_NAME"
else
  DAYS=$((REMAINING_SEC / 86400))
  REMAINING_SEC=$((REMAINING_SEC % 86400))
  HOURS=$((REMAINING_SEC / 3600))
  REMAINING_SEC=$((REMAINING_SEC % 3600))
  MINUTES=$((REMAINING_SEC / 60))
  SECONDS=$((REMAINING_SEC % 60))
  TIME_STR=""
  if [[ "$DAYS" -gt 0 ]]; then
    if [[ "$DAYS" -eq 1 ]]; then
      TIME_STR=$(printf "%d day, %02d:%02d:%02d" $DAYS $HOURS $MINUTES $SECONDS)
    else TIME_STR=$(printf "%d days, %02d:%02d:%02d" $DAYS $HOURS $MINUTES $SECONDS); fi
  else TIME_STR=$(printf "%02d:%02d:%02d" $HOURS $MINUTES $SECONDS); fi
  BASE_LABEL="$TASK_NAME$ICON$TIME_STR"
fi

# --- 处理滚动或静态显示 ---
label_length=${#BASE_LABEL}
display_label=""
if [[ "$label_length" -gt "$MAX_LENGTH" ]]; then
  offset=$(get_scroll_offset)
  padded_label="$BASE_LABEL$SCROLL_SEPARATOR$BASE_LABEL"
  original_length_with_padding=$((${#BASE_LABEL} + ${#SCROLL_SEPARATOR}))
  next_offset=$(((offset + 1) % original_length_with_padding))
  display_label="${padded_label:$offset:$MAX_LENGTH}"
  set_scroll_offset "$next_offset"
else
  display_label="$BASE_LABEL"
  reset_scroll_offset
fi

# --- 更新 SketchyBar ---
sketchybar --set $ITEM_NAME label="$display_label"
