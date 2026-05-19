# GitHub Pages 部署教程（一步一步）

本仓库已配置自动部署。按下面顺序操作即可，**无需 ICP 备案**。

线上地址（部署成功后）：

**https://jiuzaoyu.github.io/gudian/**

---

## 第 0 步：你需要准备什么

| 项 | 说明 |
|----|------|
| GitHub 账号 | 例如 `jiuzaoyu` |
| 仓库 | 本仓库：`jiuzaoyu/gudian`（已存在可跳过创建） |
| 本机 Git | 能执行 `git push` |

---

## 第 1 步：把代码推到 GitHub

若你已在本地克隆且远程是 `origin`，在项目根目录执行：

```powershell
cd d:\workspaces\jiuzaoyu\gudian
git status
git add .
git commit -m "配置 GitHub Pages 部署"
git push origin master
```

> 若远程还没有这个仓库：在 GitHub 网页 **New repository** 创建 `gudian`，不要勾选「添加 README」（避免冲突），然后：
>
> ```powershell
> git remote add origin https://github.com/你的用户名/gudian.git
> git push -u origin master
> ```

---

## 第 2 步：在 GitHub 上开启 Pages（只需做一次）

1. 打开 https://github.com/jiuzaoyu/gudian  
2. 点击 **Settings**（设置）  
3. 左侧 **Pages**  
4. **Build and deployment** → **Source** 选 **GitHub Actions**（不要选 “Deploy from a branch”）  
5. 保存即可，无需再选手动上传 `gh-pages` 分支  

---

## 第 3 步：等待自动构建

1. 打开仓库 **Actions** 标签  
2. 应看到 **Deploy to GitHub Pages** 工作流在运行  
3. 全部打绿勾后，点进该次运行，在 **deploy** 任务里可看到 **github-pages** 环境的网址  

首次开启 Pages 后，若 Actions 没自动跑，可手动触发：

- **Actions** → **Deploy to GitHub Pages** → **Run workflow**

---

## 第 4 步：打开网站验证

浏览器访问：

**https://jiuzaoyu.github.io/gudian/**

检查：

- [ ] 首页能打开  
- [ ] 点进任意概念页链接正常  
- [ ] 首页搜索能出结果（依赖 `index.json`）  

若 CSS/图片全挂、页面像纯文字：多半是 `baseURL` 不对，见下方「常见问题」。

---

## 第 5 步：以后如何更新网站

改 `content/` 或主题后：

```powershell
git add .
git commit -m "更新某某概念"
git push origin master
```

推送后 Actions 会自动重新构建，一般 1～3 分钟生效。

---

## 本地预览（改内容时用）

```powershell
cd d:\workspaces\jiuzaoyu\gudian
.\serve.ps1
```

浏览器打开 http://localhost:1313  

本地预览时可在 `hugo.toml` 临时把 `baseURL` 改成 `http://localhost:1313/`，推送到 GitHub 前改回 `https://jiuzaoyu.github.io/gudian/`，或保持不动（CI 会用正确地址构建）。

---

## 常见问题

### 1. Actions 报错 `Error: Get Pages site failed`

说明还没完成 **第 2 步**：Settings → Pages → Source 必须选 **GitHub Actions**。

### 2. 页面样式丢失、链接都 404（最常见）

**原因**：`hugo.toml` 里 `baseURL` 仍是旧域名（如 `stock101.cn`），且工作流未传入 GitHub Pages 地址时，CSS 会生成成 `/css/main.css`，在 `jiuzaoyu.github.io/gudian/` 下会 404。

**处理**：确认本地已是：

- `hugo.toml` → `baseURL = "https://jiuzaoyu.github.io/gudian/"`
- `.github/workflows/deploy.yml` → 含 `configure-pages` 且 `hugo --baseURL "${{ steps.pages.outputs.base_url }}/"`

然后重新 `git push`，等 Actions 跑完，**强制刷新**页面（Ctrl+F5）。

- 仓库名必须是 `gudian`；改名后须同步改 `baseURL` 路径段  

### 3. 想用 `main` 分支而不是 `master`

在 GitHub 把默认分支改成 `main` 后推送即可，工作流已同时监听 `main` 和 `master`。

### 4. 想用自定义域名（可选，仍通常不需大陆备案）

1. 在域名 DNS 添加 CNAME 指向 `jiuzaoyu.github.io`  
2. 仓库 **Settings → Pages → Custom domain** 填写域名  
3. 把 `hugo.toml` 的 `baseURL` 改成 `https://你的域名/` 后推送  

### 5. 国内访问较慢

GitHub Pages 服务器在海外，属正常现象。开源协作、免备案托管通常可接受；内容仍可在 GitHub 上 PR 贡献。
