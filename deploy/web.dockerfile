# 构建阶段
FROM registry.cn-hangzhou.aliyuncs.com/kdmili/dev:node.22.8.0 AS builder

# 设置环境变量
ENV SHELL=/bin/bash
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH

# 设置 npm 国内镜像
RUN npm config set registry https://mirrors.huaweicloud.com/repository/npm/

# 安装 pnpm 和必要的全局依赖
RUN npm install -g pnpm dotenv-cli && \
    mkdir -p $PNPM_HOME

# 设置工作目录
WORKDIR /app
 

# 创建 .npmrc 文件启用 workspace
RUN echo "node-linker=hoisted" > .npmrc && \
    echo "shamefully-hoist=true" >> .npmrc && \
    echo "strict-peer-dependencies=false" >> .npmrc

COPY . . 
RUN rm -rf apps/readest-app/src-tauri

# 创建默认的环境文件
RUN pnpm install 

RUN pnpm build
 

EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# 修改启动命令，确保在正确的目录下执行
CMD ["sh", "-c", "cd /app && pnpm start-web"]