mkdir -p ./tmp

curl -L -o ./tmp/cn_geosite.json "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/cn.json"
curl -L -o ./tmp/cn_geoip.json "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/cn.json"


curl -L -o ./tmp/douyin_geosite.json "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/douyin.json"
curl -L -o ./tmp/tiktok_geosite.json "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/tiktok.json"
curl -L -o ./tmp/tencent_geosite.json "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/tencent.json"


cp ../direct_custom.json ./tmp
cp ../zscaler/zscaler_geoip.json ./tmp
cp ../zscaler/zscaler_geosite.json ./tmp

./sing-box rule-set merge merged.json -C ./tmp/
./sing-box rule-set compile merged.json -o ../gen/in_china_direct.srs

./sing-box rule-set compile ../cloudflare/cloudflare_one_geoip.json -o ../cloudflare/cloudflare_one_geoip.srs
./sing-box rule-set compile ../zscaler/zscaler_geoip.json -o ../zscaler/zscaler_geoip.srs
./sing-box rule-set compile ../zscaler/zscaler_geosite.json -o ../zscaler/zscaler_geosite.srs



rm -rf ./tmp
rm -rf merged.json