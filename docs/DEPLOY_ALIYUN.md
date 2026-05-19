# 阿里云生产环境部署指南

股典是纯静态站点（Hugo 生成 `public/`），**推荐方案：对象存储 OSS + CDN + 域名 + HTTPS**。无需买 ECS 跑后端。

---

## 一、上线前准备清单

| 项 | 说明 |
|----|------|
| 阿里云账号 | 完成实名认证 |
| 域名 | 如 `gudian.example.com`，在阿里云购买或转入 |
| ICP 备案 | 使用**中国大陆节点**且绑定国内域名访问时，通常需要备案（约 1–2 周） |
| SSL 证书 | 在阿里云免费申请 DV 证书，或 CDN 一键 HTTPS |
| 代码仓库 | GitHub / 云效 / 自建 Git，用于协作与自动发布 |

---

## 二、修改项目配置（必做）

### 1. 设置正式域名 `baseURL`

编辑 `hugo.toml`：

```toml
baseURL = "https://stock101.cn/"   # 末尾必须有斜杠
```

构建时 Hugo 会据此生成正确的链接、RSS、搜索索引路径。**每次换域名都要改并重新构建。**

### 2. 自建视频走 CDN（可选）

若 mp4 放在 OSS 且通过 CDN 访问，取消注释：

```toml
[params]
  video_cdn = "https://cdn.你的域名"   # 或 OSS/CDN 的 HTTPS 根地址
```

概念里 `src` 可写 `/videos/xxx.mp4`，会与 `video_cdn` 拼接。

---

## 三、阿里云资源创建（控制台）

### 步骤 1：创建 OSS 存储桶

1. 打开 [对象存储 OSS 控制台](https://oss.console.aliyun.com/)
2. **创建 Bucket**
   - 名称：全局唯一，如 `stock-glossary-prod`
   - 地域：选离用户近的（华东、华北等）
   - 读写权限：**公共读**（仅放静态网站；不要放密钥）
   - 版本控制：可选开启，便于回滚

### 步骤 2：开启静态网站托管

Bucket → **基础设置** → **静态页面**

- 默认首页：`index.html`
- 默认 404 页：`404.html`

### 步骤 3：绑定 CDN（强烈建议）

1. 打开 [CDN 控制台](https://cdn.console.aliyun.com/)
2. 添加域名，源站类型选 **OSS 域名**，指向上面 Bucket
3. 开启 **HTTPS**，上传或申请证书
4. 缓存规则建议：
   - `*.html`：缓存 5–10 分钟（内容更新较快）
   - `*.css`、`*.js`、`/videos/*`：缓存 7–30 天
5. 开启 **Gzip/Brotli** 压缩

### 步骤 4：域名解析

在域名 DNS 添加 CNAME，指向 CDN 分配的加速域名。

### 步骤 5：备案与 HTTPS

- 域名在阿里云备案通过后，再绑定 CDN
- 确保全站 `https://`，在 CDN 开启「强制跳转 HTTPS」

---

## 四、本地构建与上传

### 1. 安装 ossutil

下载：[ossutil 安装文档](https://help.aliyun.com/document_detail/120075.html)

配置访问密钥（RAM 用户仅需 OSS 读写权限，不要用主账号 AK）：

```bash
ossutil config -e oss-cn-hangzhou.aliyuncs.com -i <AccessKeyId> -k <AccessKeySecret>
```

### 2. 构建

```powershell
cd stock-glossary
.\serve.ps1   # 仅本地预览用

# 生产构建（使用正式 baseURL）
.\.tools\hugo\hugo.exe --minify --baseURL "https://你的域名/"
# 或已安装 hugo：hugo --minify --baseURL "https://你的域名/"
```

产物在 `public/` 目录。

### 3. 上传到 OSS

```powershell
.\scripts\deploy-oss.ps1 -Bucket "stock-glossary-prod" -Endpoint "oss-cn-hangzhou.aliyuncs.com"
```

或手动：

```bash
ossutil cp -r public/ oss://stock-glossary-prod/ --update --force
```

上传后访问 Bucket 的**静态网站 Endpoint** 或 CDN 域名验证。

### 4. 刷新 CDN 缓存

内容更新后，在 CDN 控制台 **刷新预热** → **目录刷新**：`https://你的域名/`

---

## 五、自动发布（推荐）

### 方式 A：GitHub Actions → OSS

1. 在阿里云 RAM 创建用户，授权 `AliyunOSSFullAccess`（或自定义最小权限）
2. 在 GitHub 仓库 Settings → Secrets 添加：
   - `ALIYUN_ACCESS_KEY_ID`
   - `ALIYUN_ACCESS_KEY_SECRET`
   - `ALIYUN_OSS_BUCKET`
   - `ALIYUN_OSS_ENDPOINT`（如 `oss-cn-hangzhou.aliyuncs.com`）
   - `HUGO_BASEURL`（如 `https://gudian.example.com/`）
   - `ALIYUN_CDN_DOMAIN`（可选，用于刷新缓存）
3. 启用仓库内 `.github/workflows/deploy-aliyun.yml`（见项目脚本）
4. 推送到 `main` 即自动构建并上传

### 方式 B：云效 Flow

代码托管在阿里云 Codeup，流水线：安装 Hugo → `hugo --minify` → ossutil 上传 → CDN 刷新。

---

## 六、视频与大文件

| 类型 | 建议 |
|------|------|
| 页面、CSS、JS | 随 `public/` 一起上传 OSS |
| 自制 mp4 | 单独目录 `static/videos/`，或上传到 OSS `/videos/`，配置 `video_cdn` |
| 外链 B 站 | 无需上传，只改 Markdown |

单个视频建议 ≤ 20MB；大量视频用**独立 Bucket + CDN**，与网站 Bucket 分离更易管理流量费用。

---

## 七、上线后检查

- [ ] 首页、分类页、概念详情可打开
- [ ] 站内搜索（`/index.json`）能返回结果
- [ ] 手机浏览器样式正常
- [ ] HTTPS 无混合内容警告
- [ ] 有视频的概念页可播放（外链 / 自建）
- [ ] 百度/Google 能收录（可选提交 sitemap，Hugo 可后续加 `sitemap.xml`）
- [ ] 页脚免责声明可见

---

## 八、费用粗算（个人站）

- OSS 存储 + 流量：通常每月几元到几十元（访问量大主要看 CDN 流量）
- CDN：按流量计费，静态站很便宜
- 域名：约 50–80 元/年
- **不需要 ECS** 除非你要自建其它服务

---

## 九、与 GitHub Pages 的关系

仓库里原有 `deploy.yml` 面向 GitHub Pages。上阿里云后可：

- **停用** GitHub Pages，只用阿里云；或
- GitHub Pages 作预览，阿里云作正式环境（`baseURL` 各用各的）

正式环境务必保证 `hugo.toml` 的 `baseURL` 与 CDN 域名一致。
