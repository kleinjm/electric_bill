# frozen_string_literal: true

require "HTTParty"
require "Nokogiri"

class FetchBill
  def call
    require 'net/http'
    require 'uri'
    require 'openssl'

    uri = URI.parse("https://myaccount.xcelenergy.com/oam/user/currentebill.req")
    request = Net::HTTP::Get.new(uri)
    request["Connection"] = "keep-alive"
    request["Upgrade-Insecure-Requests"] = "1"
    request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
    request["Sec-Fetch-Site"] = "same-origin"
    request["Sec-Fetch-Mode"] = "navigate"
    request["Sec-Fetch-User"] = "?1"
    request["Sec-Fetch-Dest"] = "document"
    request["Referer"] = "https://myaccount.xcelenergy.com/oam/user/currentebill.req"
    request["Accept-Language"] = "en-US,en;q=0.9"
    request["Cookie"] = "f5avrbbbbbbbbbbbbbbbb=LEPLDMGCPFLCDHBCIKCGCJHJGPKLDLFEAKBAKFCJLIMNAJBHGDDGLCJEKDNAGAKADFBAJIDJJODDFMCGBBPBEEKLAELAALLGPNFPPGJKBHBBACPJFPDONKAOJNMPOGOH; clientTimeZone=360; clientCurrentDate=06242020192809; JSESSIONID=90f8bc34a3431c80a0bdad878311; TS01130bed=0100fa3b9925d5b29590a5e9115001a41941ea64a224fc408bfade8b78b78b496616d4d914b400c4e0bb8dcc7fecbb25adaea19b1195579bfb809deadbac18d845333a772e; f5avrbbbbbbbbbbbbbbbb=PKEPHDBFMDJCFIADOAGAFDJLKIALCKFJGHNBKCALPFNMKGIMPMKNOLPGDNBHMBMFFAKOLLDHKMGDFJHLDAOLJJHECHCACENBPNOFADFIDECNKKNGFPBKOCJCLIPHJLJE; latitude=39.732; longitude=-104.967; zipcode=80218; GeographicLocation=%2FGeographic%20Location%2FColorado; _gcl_au=1.1.2016047196.1593044572; _ga=GA1.2.1912812285.1593044572; _gid=GA1.2.1814550826.1593044572; mf_user=5d3ad32b18839a0bf10bb0ed48697943|; __qca=P0-1589266904-1593044572334; myaccount_persistance=890168074.20480.0000; _ga=GA1.3.1912812285.1593044572; _gid=GA1.3.1814550826.1593044572; f5avrbbbbbbbbbbbbbbbb=FBIJLECJKPJDDODMBMFPNHBFHIBELBPNJNPDLOJKNCEDDOBPGPMENHFGOOFBOBDELLABHCKBFDNDCIBLNDLOBADJKFKAHMCNJONOOIJCJOPNMAJOBOOPPJPAFFGDHKDD; mcxSurveyQuarantine=mcxSurveyQuarantine; UsageOnlyUser=false; MyAccountLogin=true; _gat_UA-44376724-2=1; McxPageVisit=23; TS01696fed=0100fa3b9956ad32ae4cfe35c19f47e87222662d462f007a4e60e185d47ab5492850c41383c4f402fd19fe92096c5f3f283f116a6035ed368424c5ee203bdd6ac30c0c5e6e6dea8e6813751b447092c57edb24e0dc0536d03ae4d0220c5559fe4868a1c0944a9f1c7b92544807cc09eb09b2eda59f; _uetsid=e496dd4b-5f1e-94d5-ee85-53cd49f0fe8a; _uetvid=778b6e58-c231-3772-a967-6dd052bc8822; mf_16baf42d-5faa-4d31-b967-8cb1b3f1cc56=c6d4bb34b60ef0f41f5c89f1ffaf188a|06240837e4e275c86f84639807182e1c8bca85ae.3682620712.1593047888540$0624212834b199cfcaf40ec92e6e9f8bfcb7a837.9939666298.1593047901230$06243743fa243afe2745b144889468a92cac6e9e.3682620712.1593047977049$0624146549447efc1388a11557abd490958df4de.9939666298.1593048014872$06241054beb4acd1cef0ba7e747feb5a821bd95f.13865935492.1593048490457|1593048499674||24|||0|17.19"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    # response.code
    # response.body

    parsed_page = Nokogiri::HTML(response.body)
  end
end
