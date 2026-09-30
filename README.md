# Codex Quota for macOS

菜单栏显示 Codex 5 小时额度剩余比例。点击后可查看每周剩余比例、可用重置次数和两种额度的恢复时间，也可打开置顶浮窗。浮窗用双进度条突出额度比例，并将恢复时间、重置次数和刷新状态分层显示。

## 安装

从本仓库下载 [CodexQuota-macOS.zip](CodexQuota-macOS.zip)，解压后打开 `Codex额度.app`。如果 macOS 首次阻止打开，请在 Finder 中按住 Control 点击应用并选择“打开”。

应用每分钟读取一次额度，也可手动刷新。绿色表示剩余超过 30%，黄色为 11–30%，红色为 0–10%。

## 数据与隐私

应用通过 ChatGPT 桌面应用内置的 Codex CLI 读取当前登录账户的额度，不收集或上传数据，不保存访问令牌，也不发起模型请求。ChatGPT 桌面应用和 Codex 登录状态需已安装并可用。应用使用本地临时签名，尚未经过 Apple 公证。

## 从源码构建

需要 macOS 和 Swift 5.9 或更新版本。运行：

```sh
./build.sh
```

构建脚本生成 `Codex额度.app`，并执行额度解析自检。也可运行 `./.build/debug/CodexQuota --probe` 查询真实额度后退出。
