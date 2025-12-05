# immortalwrt-cmcc_rax3000m
```markdown
# GitHub Actions: Build ImmortalWRT (example for rax3000m NAND)

说明
- 这是一个示例 Workflow + 本地脚本，用于在 GitHub Actions 上编译 ImmortalWRT 固件。
- 工作流会：
  - 安装构建依赖
  - 拉取 ImmortalWRT 源码（默认 master）
  - 从仓库中的 `configs/rax3000m_defconfig`（可自定义）复制为 `.config`
  - 更新并安装 feeds
  - 使用 make 并行构建
  - 将 `bin/targets` 与 `bin/packages` 上传为 artifact

如何使用
1. 把 `.github/workflows/build-immortalwrt.yml` 放入你的仓库（如果已有同名 workflow，请合并配置）。
2. 在仓库根目录放置你的设备 defconfig，例如 `configs/rax3000m_defconfig`。推荐的生成 defconfig 方法：
   - 在本地 Clone ImmortalWRT，进入源码目录运行 `make menuconfig` 选择你的设备和选项后运行 `make defconfig`
   - 把生成的 `.config` 文件保存为 `configs/rax3000m_defconfig` 并提交到仓库
3. 手动触发：
   - 到 GitHub Actions → 选择 "Build ImmortalWRT" workflow → Run workflow
   - 你也可以通过 push 到 main 触发（当前 workflow 配置为 push 到 main）
4. 构建完成后，去 Actions 的对应运行页面下载 artifact（名称为 `immortalwrt-build-<run_id>.zip`）

可配置项
- IMMORTAL_BRANCH: 要构建的 ImmortalWRT 分支，默认为 master（可以在 workflow dispatch 输入覆盖）
- DEFCONFIG_PATH: 仓库中 defconfig 的路径（默认 configs/rax3000m_defconfig）
- MAKE_JOBS: make -j 的并行数（默认为 runner 的 CPU 数量）
- 注意：GitHub Actions runner 磁盘和内存有限，若编译过程中 OOM 或失败，请将 MAKE_JOBS 调小或使用自托管 runner。

注意事项
- 如果你有额外补丁或 packages，请把它们放在仓库中并在 workflow 前拷贝到 `${{ github.workspace }}/immortalwrt`（可以在 workflow 中加入 copy/patch 步骤）。
- 缓存能提高重复构建速度，但首次构建仍然耗时很久（通常 30 分钟到数小时，取决于目标和并行数量）。
- 如果设备需要专门的 DTS/target 支持，请先在 ImmortalWRT 源码中确保目标支持或合并补丁。
