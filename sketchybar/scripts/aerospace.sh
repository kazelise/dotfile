#!/bin/bash

# 定义颜色
INACTIVE_ICON_COLOR=0xFF1E90FF # 非选中时的蓝色（DodgerBlue）
ACTIVE_ICON_COLOR=0xFFFFFFFF   # 选中时的白色

# 判断并只设置图标颜色
if [[ "$1" == "$FOCUSED_WORKSPACE" ]]; then
  # 当前工作区被选中
  sketchybar --set $NAME icon.color=$ACTIVE_ICON_COLOR
else
  # 当前工作区未被选中
  sketchybar --set $NAME icon.color=$INACTIVE_ICON_COLOR
fi

# 注意：所有 background.color, background.drawing, icon.y_offset 的设置都移除了
