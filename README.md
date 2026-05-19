# 股典 · 股票术语表

面向股票新手、小白的**概念科普与查询**网站。像查字典一样，30 秒看懂一个术语。

- 纯静态站点，秒开、免注册
- 每个概念一个 Markdown 文件，改文件即更新内容
- 站内全文搜索，SEO 友好

## 本地预览

**方式一（推荐，无需全局安装 Hugo）**

```powershell
cd gudian
.\serve.ps1
```

首次运行会自动下载 Hugo 到 `.tools/`（已加入 `.gitignore`）。

**方式二：已安装 Hugo 时**

```bash
hugo server -D
```

浏览器打开 http://localhost:1313

## 在线站点（GitHub Pages，推荐）

**一步一步教程**：[docs/DEPLOY_GITHUB_PAGES.md](docs/DEPLOY_GITHUB_PAGES.md)

部署成功后访问：**https://jiuzaoyu.github.io/gudian/**

简要步骤：

1. `git push` 到 GitHub 仓库 `jiuzaoyu/gudian`
2. 仓库 **Settings → Pages → Source** 选 **GitHub Actions**
3. 在 **Actions** 里等待 **Deploy to GitHub Pages** 完成

## 其他部署方式

```bash
hugo --minify --baseURL "https://你的域名/"
# 输出在 public/ 目录
```

### 阿里云（需 ICP 备案，可选）

见 [docs/DEPLOY_ALIYUN.md](docs/DEPLOY_ALIYUN.md)。快速上传：

```powershell
.\scripts\deploy-oss.ps1 -Bucket "你的bucket" -Endpoint "oss-cn-hangzhou.aliyuncs.com" -BaseUrl "https://你的域名/"
```

## 视频讲解

支持 **外链嵌入**（B 站、YouTube 等）与 **自制 mp4**（放 `static/videos/` 或 CDN）。配置写在概念文件的 front matter，详见 [docs/VIDEO.md](docs/VIDEO.md)。

## 新增概念

```bash
hugo new basics/你的概念英文名.md
```

或直接在 `content/<分类>/` 下新建 `.md` 文件，参考 `content/indicators/macd.md` 格式。

详细规范见网站内 [贡献指南](content/contributing/_index.md) 或部署后的 `/contributing/` 页面。

## 目录结构

```
gudian/
├── content/           # 所有概念（Markdown）
│   ├── basics/        # 基础交易
│   ├── indicators/    # 技术指标
│   ├── fundamentals/  # 基本面
│   ├── market-structure/
│   ├── strategies/
│   └── risk/
├── themes/stock-glossary/  # 主题
├── hugo.toml
└── archetypes/
```

## 许可

内容默认 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.zh)。代码 MIT。

**免责声明**：本站仅供学习，不构成任何投资建议。
