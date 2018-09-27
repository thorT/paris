export function compare(prop, order = 'asc') {
  return function (obj1, obj2) {
    var val1 = obj1[prop];
    var val2 = obj2[prop];
    if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
      val1 = Number(val1);
      val2 = Number(val2);
    }
    if (val1 < val2) {
      return order == 'asc' ? -1 : 1;
    } else if (val1 > val2) {
      return order == 'asc' ? 1 : -1;
    } else {
      return 0;
    }
  }
}

//随机打乱数组
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1) + min)
}

export function shuffle(arr) {
  let _arr = arr.slice()
  for (let i = 0; i < _arr.length; i++) {
    let j = getRandomInt(0, i)
    let t = _arr[i]
    _arr[i] = _arr[j]
    _arr[j] = t
  }
  return _arr
}

export function hasClass(el, className) {
  let reg = new RegExp('(^|\\s)' + className + '(\\s|$)')
  return reg.test(el.className)
}

export function addClass(el, className) {
  if (hasClass(el, className)) {
    return
  }

  let newClass = el.className.split(' ')
  newClass.push(className)
  el.className = newClass.join(' ')
}

/*这里开始时UrlEncode和UrlDecode函数*/
export function decodeUrl(url) {
  var decodeStr;
  try {
    var transformUrl = url.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
    decodeStr = URLDecoder.decode(transformUrl, "UTF-8");
  } catch (e) {

  } finally {
    return decodeUrl;
  }
}
