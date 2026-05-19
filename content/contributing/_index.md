---
title: "贡献指南"
type: "docs"
---

## 如何新增或修改概念

每个概念对应 **一个 Markdown 文件**，放在 `content/` 下对应分类目录中。

### 快速步骤（GitHub 网页）

1. 打开仓库，进入 `content/某分类/` 目录
2. 点击 **Add file** → **Create new file**
3. 文件名用英文短横线，如 `macd.md`
4. 按下方模板填写内容并提交
5. 合并后网站会自动重新部署

### 本地开发

```bash
# 安装 Hugo: https://gohugo.io/installation/
cd gudian
hugo server -D
# 浏览器打开 http://localhost:1313
```

### 概念文件模板

```yaml
---
title: "概念中文名（可含英文缩写）"
one_liner: "一句话定义"
tags: ["标签1", "标签2"]
related: ["相关概念文件名", "ma"]
hot: false          # true 则显示在首页热门
weight: 10          # 数字越小排序越靠前
last_updated: "2026-05-19"
contributor: "@你的名字"
---

## 人话解释
...

## 常见误区
| 误区 | 正解 |
|------|------|

## 什么时候有用 / 没用
| 适用场景 | 不适用场景 |
|----------|------------|

## 参考来源
- 
```

### 视频讲解（外链 + 自制）

| 场景 | `type` | 做法 |
|------|--------|------|
| B 站等有优质讲解 | `embed` | 填 `provider` + `id`，或填 `url` |
| 需自己录制 | `self` | 将 mp4 放到 `static/videos/`，填 `src` |
| 两种都要 | — | 使用 `videos` 数组 |

完整示例见项目内 [docs/VIDEO.md](https://github.com/你的仓库/blob/main/docs/VIDEO.md)（本地路径：`docs/VIDEO.md`）。

`K线` 概念页已配置 **自制视频** 示例；填入真实 mp4 后即可播放。

### 编写原则

- **零基础友好**：避免堆砌公式，优先用比喻
- **只讲概念**：不写具体买卖建议、不推荐个股
- **可验证**：重要说法尽量注明参考来源
- **保持中立**：风险提示类内容需客观

### 内容协议

贡献内容默认以 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.zh) 发布，允许他人转载需署名。
