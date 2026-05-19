# 股典 · 股票术语表

面向股票新手、小白的**概念科普与查询**网站。像查字典一样，30 秒看懂一个术语。

- 纯静态站点，秒开、免注册
- 每个概念一个 Markdown 文件，改文件即更新内容
- 站内全文搜索，SEO 友好

## 本地预览

**方式一（推荐，无需全局安装 Hugo）**

```powershell
cd stock-glossary
.\serve.ps1
```

首次运行会自动下载 Hugo 到 `.tools/`（已加入 `.gitignore`）。

**方式二：已安装 Hugo 时**

```bash
cd stock-glossary
hugo server -D
```

浏览器打开 http://localhost:1313

## 构建与发布

```bash
hugo --minify --baseURL "https://你的正式域名/"
# 输出在 public/ 目录
```

### 阿里云生产环境（推荐国内访问）

完整步骤见 **[docs/DEPLOY_ALIYUN.md](docs/DEPLOY_ALIYUN.md)**（OSS + CDN + 域名 + HTTPS）。

快速上传（需先安装 [ossutil](https://help.aliyun.com/document_detail/120075.html) 并 `ossutil config`）：

```powershell
.\scripts\deploy-oss.ps1 -Bucket "你的bucket" -Endpoint "oss-cn-hangzhou.aliyuncs.com" -BaseUrl "https://你的域名/"
```

### GitHub Pages

1. 将仓库推送到 GitHub
2. 已包含 `.github/workflows/deploy.yml`，推送到 `main` 分支会自动部署
3. 在仓库 Settings → Pages 中选择 **GitHub Actions** 作为来源

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
stock-glossary/
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
