# 视频配置说明

概念页支持 **外链嵌入** 与 **自建上传** 两种方式，可只选一种，也可同时展示多个。

## 场景一：外链讲解（B 站 / YouTube 等）

有清晰的外部视频时优先使用，不占用仓库空间。

```yaml
video:
  type: embed
  provider: bilibili    # bilibili | youtube | youku | tencent
  id: "BVxxxxxxxx"      # 平台视频 ID
  title: "MACD 入门讲解"
  duration: "6:20"
  source: "B站 · UP主名称"
  caption: "可选说明文字"
```

或直接填播放器地址：

```yaml
video:
  type: embed
  url: "https://player.bilibili.com/player.html?bvid=BVxxxxxxxx&page=1"
  title: "MACD 入门讲解"
```

## 场景二：股典自制（录制后上传）

外部没有合适讲解时，自行录制并放置视频文件。

```yaml
video:
  type: self
  src: "/videos/indicators/macd.mp4"
  poster: "/videos/indicators/macd-poster.jpg"
  title: "股典 · 2 分钟看懂 MACD"
  duration: "2:00"
  source: "股典自制"
  mime: "video/mp4"
```

文件放在 `static/videos/...`，详见 [static/videos/README.md](../static/videos/README.md)。

生产环境可将 `src` 改为 CDN 完整 URL，或在 `hugo.toml` 配置 `params.video_cdn`。

## 场景三：同一概念多个视频

```yaml
videos:
  - type: embed
    provider: bilibili
    id: "BVxxxxxxxx"
    title: "深度讲解（外链）"
    source: "B站"
  - type: self
    src: "/videos/indicators/macd-short.mp4"
    title: "1 分钟速览（自制）"
    source: "股典自制"
```

## 字段速查

| 字段 | embed | self | 说明 |
|------|:-----:|:----:|------|
| `type` | ✓ | ✓ | `embed` 或 `self` |
| `provider` | ✓ | — | 外链平台 |
| `id` | ✓ | — | 平台视频 ID |
| `url` / `embed_url` | ✓ | — | 完整嵌入地址 |
| `src` / `file` | — | ✓ | 视频路径或文件名 |
| `poster` | — | ✓ | 封面图 |
| `title` | ✓ | ✓ | 视频标题 |
| `caption` | ✓ | ✓ | 说明 |
| `duration` | ✓ | ✓ | 如 `2:30` |
| `source` | ✓ | ✓ | 来源标签 |

未填写有效 `id`/`url`/`src` 时，该条视频不会渲染，页面不会出现空白播放器。
