#!/usr/bin/with-contenv bashio
bashio::log.info "Copying configuration."

# 定义函数
check_and_replace() {
  local file_a="$1"
  local file_c="$2"
  local string_b="$3"

  # 如果文件A不存在，则创建文件A
  if [ ! -f "$file_a" ]; then
    touch "$file_a"
  fi

  # 如果文件C不存在，则创建文件C
  if [ ! -f "$file_c" ]; then
    touch "$file_c"
  fi

  # 读取文件A的内容
  content_a=$(cat "$file_a")

  # 判断文件A是否为空或内容是否与字符串B不一致
  if [ -z "$content_a" ] || [ "$content_a" != "$string_b" ]; then
    echo "$string_b" > "$file_a"
    echo "$string_b" > "$file_c"
    bashio::log.info "$file_c 配置已更新"
  else
    bashio::log.info "$file_c 无需更新"
  fi
}


# 定义函数
replace_file() {
  local string_a="$1"
  local file_b="$2"

  # 判断字符串A是否为空
  if [ -z "$string_a" ]; then
    # 如果字符串A为空且文件B存在，则删除文件B
    if [ -f "$file_b" ]; then
      rm "$file_b"
    fi
  else
    # 如果字符串A不为空，则将文件B的内容设置为字符串A
    echo "$string_a" > "$file_b"
  fi
}

echo "$(bashio::config 'alipan_token')"

check_and_replace "/data/mytoken.conf" "/data/mytoken.txt" "$(bashio::config 'alipan_token')"
check_and_replace "/data/myopentoken.conf" "/data/myopentoken.txt" "$(bashio::config 'alipan_refresh_token')"
check_and_replace "/data/temp_transfer_folder_id.conf" "/data/temp_transfer_folder_id.txt" "$(bashio::config 'alipan_folder_id')"
replace_file "$(bashio::config 'pikpak_conf')" "/data/pikpak.txt"
replace_file "$(bashio::config 'docker_address')" "/data/docker_address.txt"
replace_file "$(bashio::config 'docker_address_ext')" "/data/docker_address_ext.txt"
replace_file "$(bashio::config 'quark_cookie')" "/data/quark_cookie.txt"

/entrypoint.sh
/opt/alist/alist server --no-prefix

