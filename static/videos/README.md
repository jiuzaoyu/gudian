# 自建视频存放说明

## 目录约定

```
static/videos/
├── basics/           # 与 content/basics 对应
│   └── k-line.mp4
├── indicators/
│   └── macd.mp4
└── ...
```

在概念 Markdown 中引用：

```yaml
video:
  type: self
  src: "/videos/basics/k-line.mp4"
  poster: "/videos/basics/k-line-poster.jpg"   # 可选封面
```

## 体积与部署

- **单个视频建议 ≤ 20MB**（1–3 分钟、720p、H.264）。
- GitHub 仓库不适合堆大量视频，上线时建议：
  1. 上传到对象存储并开启 CDN；
  2. 在 `hugo.toml` 配置 `params.video_cdn`；
  3. 或将 `src` 直接写完整 HTTPS 地址。

## 录制建议

- 横屏 16:9，导出 MP4（H.264 + AAC）
- 片头片尾注明：仅供学习，不构成投资建议
