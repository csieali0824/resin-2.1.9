FROM openjdk:8-jdk

# 設定 Resin 版本與安裝目錄
ENV RESIN_VERSION=2.1.9
ENV RESIN_HOME=/opt/resin-2.1.9

# 建立 Resin 目錄並切換到該目錄
#WORKDIR /opt

# 複製 Resin 檔案
#COPY ../../../resin/resin-2.1.9 /opt/

# 確保 Resin 腳本有執行權限
#RUN chmod +x /opt/resin-2.1.9/bin/httpd.sh

## 設定 Resin 目錄環境變數
ENV PATH="$RESIN_HOME/bin:$PATH"
#
## 複製 JSP 應用程式到 Resin Webapps 目錄
COPY . /opt/resin-2.1.9/webapps/

# 設定應用程式目錄
RUN mkdir -p /opt/resin-2.1.9/webapps/

# 指定 Resin 運行端口
EXPOSE 8080

# 啟動 Resin
#CMD ["/opt/resin-2.1.9/bin/httpd.sh"]
CMD ["/bin/sh", "-c", "/opt/resin-2.1.9/bin/httpd.sh"]