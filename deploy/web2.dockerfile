# 构建阶段
FROM registry.cn-hangzhou.aliyuncs.com/kdmili/dev:node AS builder

# 设置 npm 国内镜像
RUN npm config set registry https://mirrors.huaweicloud.com/repository/npm/
 
RUN npm install -g pnpm
# 设置工作目录
WORKDIR /app
 

RUN echo "node-linker=hoisted" > .npmrc &&     echo "shamefully-hoist=true" >> .npmrc &&     echo "strict-peer-dependencies=false" >> .npmrc


COPY ["apps/readest-app/.next/standalone","."]
# 创建默认的环境文件

RUN pnpm install --prod
 
 

EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# 修改启动命令，确保在正确的目录下执行
CMD ["sh", "-c", "cd /app && pnpm run start-web"]