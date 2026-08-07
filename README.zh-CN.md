# 基于混沌映射的位级图像加密算法密码分析

[English](README.md) | [论文 PDF](docs/paper/cryptanalyzing-bciea-2024.pdf) | [算法说明](docs/ALGORITHM.md) | [项目审计记录](docs/PROJECT_AUDIT.md)

本仓库提供论文《Cryptanalyzing a bit-level image encryption algorithm based on chaotic maps》的 MATLAB 可复现实验实现：

> Heping Wen, Yiting Lin, Zhaoyang Feng. "Cryptanalyzing a bit-level image encryption algorithm based on chaotic maps." *Engineering Science and Technology, an International Journal*, 51, 101634, 2024. https://doi.org/10.1016/j.jestch.2024.101634

## 项目范围

本项目面向 BCIEA（基于混沌映射的位级图像加密算法）的授权密码分析、教学与可复现实验，包含：

- 一个可逆的修正 BCIEA 参考模型：二进制位平面分解、PWLCM 密钥流、相互扩散与动态混淆。
- 论文提出的选择密文攻击：利用全零密文恢复等价扩散密钥，再用与目标密文等位和的查询恢复动态混淆排列。
- 可直接运行的完整示例与确定性回归测试。
- 清理后的统一项目结构，去除历史副本、调试脚本、生成图像和无关实验。

> **研究用途提示：** 论文已经证明 BCIEA 存在结构性安全缺陷。本仓库不是安全加密库，不能用于保护敏感数据；仅可在获得授权的密码分析、教育和复现实验场景中使用。

## 论文攻击结论

对于大小为 `M x N` 的灰度图像，记 `L = 4MN`。在论文的选择密文攻击模型下：

| 项目 | 结果 |
| --- | --- |
| 全零密文查询数 | 1 |
| 等位和查询数 | `2 * ceil(log2(L))` |
| 总查询复杂度 | `1 + 2 * ceil(log2(L))` |
| `256 x 256` 图像示例 | 37 次查询 |

论文中的运行时间只适用于其特定软硬件平台，不能作为本次整理后实现的性能承诺或基准。

## 目录结构

```text
src/        维护中的 MATLAB 实现与攻击基础模块
examples/   自包含的端到端演示
tests/      确定性回归测试
docs/       算法说明、项目审计记录与论文 PDF
LICENSE     适用于软件和仓库文档的 Apache License 2.0
NOTICE      随附论文 PDF 的署名与许可说明
```

主要模块说明：

- `bciea_encrypt.m` 与 `bciea_decrypt.m`：修正 BCIEA 参考模型的加密与解密。
- `bciea_extract_equivalent_diffusion_key.m`：全零密文查询下的等价扩散密钥恢复。
- `bciea_build_chosen_ciphertexts.m`：论文算法 1 的等位和选择密文构造。
- `bciea_recover_permutations.m` 与 `bciea_recover_plaintext.m`：动态排列与目标明文恢复。
- `bciea_attack.m`：通过注入解密预言机完成完整攻击流程。

## 运行环境

- MATLAB R2019b 或更高版本；已使用 MATLAB R2026a 验证。
- 实现、示例和测试均不依赖 MATLAB 工具箱。
- 输入应为二维 8 位灰度图像，像素必须是 `[0, 255]` 范围内的整数。

## 获取与运行

克隆仓库：

```bash
git clone https://github.com/Lucky-YitingLin/Cryptanalyzing-a-bit-level-image-encryption-algorithm-based-on-chaotic-maps.git
cd Cryptanalyzing-a-bit-level-image-encryption-algorithm-based-on-chaotic-maps
```

运行回归测试：

```bash
matlab -batch "addpath('tests'); run_tests"
```

运行端到端演示：

```bash
matlab -batch "addpath('examples'); demo_attack"
```

`demo_attack` 会生成一幅确定性合成灰度图像，用参考模型加密后，只向攻击流程提供解密预言机句柄，并断言恢复结果与原图完全一致。示例不依赖仓库中隐藏的中间文件或版权不明的测试图像。

## MATLAB 调用示例

```matlab
addpath('src');

key = bciea_default_key();
plainImage = uint8(randi([0, 255], 32, 32));
cipherImage = bciea_encrypt(plainImage, key);

% 在真实选择密文实验中，此句柄代表已经获得授权的解密预言机。
oracle = @(candidateCipher) bciea_decrypt(candidateCipher, key);
[recoveredImage, report] = bciea_attack(cipherImage, oracle);

assert(isequal(plainImage, recoveredImage));
fprintf('查询次数: %d\n', report.query_count);
```

`bciea_default_key()` 中的参数是公开演示参数，不是安全密钥。修正模型的 `boundary_bits = [0 0]` 对应论文中移除不可逆末位反馈项的处理。攻击还兼容固定的历史边界位变体，因为全零查询会将该影响折叠进等价密钥的首位。

## 复现说明

1. 原始 BCIEA 的首个扩散方程含有末位回馈，无法定义一一对应的解密过程；本实现采用论文第 3.2 节的轻微修正，细节见[算法说明](docs/ALGORITHM.md)。
2. 动态混淆排列由两个 BBD 比特流的总位和决定。要恢复目标排列，选择的查询密文必须与目标密文保持相同的位和。
3. 对极稀疏或极稠密的目标密文，论文的二进制补偿流可能在数学上无法构造。`bciea_build_chosen_ciphertexts` 会明确报告这一前置条件，而不会生成错误查询。
4. 浮点混沌映射仅用于忠实复现实验模型，不代表安全的密钥生成方法。

## 验证内容

`tests/run_tests.m` 会验证：

- 非方形图像的位平面分解与合并往返一致性。
- 修正 BCIEA 参考模型的加解密往返一致性。
- 针对固定历史边界位变体的完整选择密文攻击恢复效果。
- 论文查询复杂度公式及恢复排列的有效性。

## 历史代码整理

仓库历史版本包含 309 个受跟踪文件，其中有 105 个 MATLAB 文件，分布于重叠的加密尝试、局部攻击步骤、生成结果图、LaTeX 归档材料以及与 BCIEA 无关的广度优先图像密码实验。当前维护树只保留 2024 年论文对应的攻击主线，并将手工操作脚本替换为参数化、带测试的函数。具体归并依据见[项目审计记录](docs/PROJECT_AUDIT.md)。

## 引用

若本仓库或其中的方法对你的研究有帮助，请引用对应论文：

```bibtex
@article{wen2024cryptanalyzing,
  title   = {Cryptanalyzing a bit-level image encryption algorithm based on chaotic maps},
  author  = {Wen, Heping and Lin, Yiting and Feng, Zhaoyang},
  journal = {Engineering Science and Technology, an International Journal},
  volume  = {51},
  pages   = {101634},
  year    = {2024},
  doi     = {10.1016/j.jestch.2024.101634}
}
```

可供工具读取的引用元数据见 [CITATION.cff](CITATION.cff)。

## 许可证与第三方资料

维护中的软件和仓库文档使用 [Apache License 2.0](LICENSE)。仓库随附的论文 PDF 是未修改的第三方学术作品，采用 CC BY 4.0 许可，署名信息见 [NOTICE](NOTICE)。原 2016 年目标密码论文及许可状态不明的历史二进制资料未随当前清理后的源码树重新分发。

## 贡献方式

提交修改前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。贡献应保持实验可复现性，为行为变化补充测试，并明确区分“论文忠实复现”和“可选实验扩展”。

## 版本说明

本开源代码受人员变动、实验室搬迁、设备损坏等多种因素影响，代码版本可能存在细微差异，代码可能为早期 Demo 版本或迭代修复过程中的中间版本，但项目对应的核心思想与实现方法保持一致。
