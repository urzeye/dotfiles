# dotfiles

## 一键配置

with `curl`

```bash
curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap.sh | bash
```

with `wget`

```bash
bash <(wget -qO - https://ghproxy.com/https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap.sh)
```

## 系统换源

```bash
wget -qO - https://raw.githubusercontent.com/urzeye/dotfiles/main/bin/chms | sh
```

## 架构支持

> 部分需要自行编译

| 序号 | 应用名        | 版本   | x86_64 | aarch64 | arm | armv7 |
| ---- | ------------- | ------ | ------ | ------- | --- | ----- |
| 1    | bat           | 0.21.0 | 🚩     | 🚩      | 🚩  |       |
| 2    | exa           | 0.10.1 | 🚩     |         |     | 🚩    |
| 3    | fd            | 8.4.0  | 🚩     | 🚩      | 🚩  |       |
| 4    | fzf           | 0.30.0 | 🚩     | 🚩      | 🚩  | 🚩    |
| 5    | ripgrep       | 13.0.0 | 🚩     |         | 🚩  |       |
| 6    | mcfly         | 0.6.0  | 🚩     |         | 🚩  | 🚩    |
| 6    | diff-so-fancy | 1.4.3  | 🚩     | 🚩      | 🚩  | 🚩    |
