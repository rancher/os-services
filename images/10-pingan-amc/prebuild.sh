#!/bin/bash
set -e

public_cloud_Linux_host_template_production_guide_url=https://obs-cn-shanghai.yun.pingan.com/pacloud/%E5%85%AC%E6%9C%89%E4%BA%91Linux%E4%B8%BB%E6%9C%BA%E6%A8%A1%E6%9D%BF%E5%88%B6%E4%BD%9C%E6%8C%87%E5%AF%BC%E6%89%8B%E5%86%8C.zip?response-content-disposition=attachment%3Bfilename%3D%25E5%2585%25AC%25E6%259C%2589%25E4%25BA%2591Linux%25E4%25B8%25BB%25E6%259C%25BA%25E6%25A8%25A1%25E6%259D%25BF%25E5%2588%25B6%25E4%25BD%259C%25E6%258C%2587%25E5%25AF%25BC%25E6%2589%258B%25E5%2586%258C.zip

client_version=0.0.6

cd $(dirname $0)

rm -rf Linux Temp_Init public_cloud_Linux_host_template_production_guide.zip

wget -O public_cloud_Linux_host_template_production_guide.zip ${public_cloud_Linux_host_template_production_guide_url}

unzip public_cloud_Linux_host_template_production_guide.zip "Linux/Temp_Init.tar"  -d .

tar -xvf Linux/Temp_Init.tar Temp_Init/agent-manager-client-linux-amd64-${client_version}.tar
