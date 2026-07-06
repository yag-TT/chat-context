# Qwen3.6-35B-A3B + llama.cpp 移行手順

------------------------------------------------------------------------

# 1. llama.cpp のビルド

``` bash
sudo apt update
sudo apt install -y git cmake build-essential

git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp

cmake -B build -DGGML_CUDA=ON
cmake --build build --config Release -j
```

------------------------------------------------------------------------

# 2. モデル配置

推奨モデル

    unsloth/Qwen3.6-35B-A3B-GGUF

推奨量子化

    UD-Q4_K_M

配置例

``` text
~/models/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf
```

------------------------------------------------------------------------

# 3. llama-server 起動

``` bash
./build/bin/llama-server   -m ~/models/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf   --host 0.0.0.0   --port 8080   --ctx-size 32768   --threads 8   --n-gpu-layers 999   --n-cpu-moe 999   --flash-attn   --parallel 1
```

------------------------------------------------------------------------

# 4. 動作確認

``` bash
curl http://localhost:8080/v1/models
```

------------------------------------------------------------------------

# 5. OpenCode 設定

    Provider : OpenAI Compatible
    BaseURL  : http://127.0.0.1:8080/v1
    API Key  : llama.cpp

モデル設定

-   tool_call: true
-   context: 32768
-   output: 8192

------------------------------------------------------------------------

# 6. n-cpu-moe チューニング

    n-cpu-moe 速度   安定性
  ----------- ------ ----------
          999 低     最高
           32 中     高
           24 高     高
           16 最速   VRAM次第

推奨手順

1.  999で起動確認
2.  32へ変更
3.  24へ変更
4.  16まで下げ、VRAM不足にならない最小値を採用

------------------------------------------------------------------------

# 7. 推奨運用

## 重い処理

-   Qwen3.6-35B-A3B
-   コーディング
-   設計
-   リファクタリング

