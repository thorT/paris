 import md5 from 'js-md5'

export function xianwanLink(res) {
  let ptype = res.ptype;//机型
  let deviceid= res.deviceid;
  let appid= '2260';
  let appsign= res.appsign;
  let appsecret= 'isk40cmbgtqqdf4g';

  var str = appid+deviceid+ptype+appsign+appsecret;
  let keycode= md5(str);
  var url = 'https://h5.51xianwan.com/try/iOS/try_list_ios.aspx';
  let data =  {
      ptype:ptype,
      deviceid:deviceid,
      appid:appid,
      appsign:appsign,
      keycode:keycode
    };
  url += (url.indexOf('?') < 0 ? '?' : '&') + param(data)
  return url;

  // http.get(url,{params:{
  //   ptype:ptype,
  //   deviceid:deviceid,
  //   appid:appid,
  //   appsign:appsign,
  //   keycode:keycode
  // }}).then(function (response) {
  //   return {code:1,response:response};
  // }).catch(function (error) {
  //   return {code:0,error};
  // });

}



export function param(data) {
  let url = '';
  for (var k in data) {
    let value = data[k] !== undefined ? data[k] : '';
    url += '&' + k + '=' + encodeURIComponent(value)
  }
  return url ? url.substring(1) : '';
}
