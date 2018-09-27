import vuerouter from '@/router'


export function verifyPhoneNumbe(txt) {
  let phoneReg = /^((13|14|15|17|18)[0-9]{1}\d{8})$/;
  if(phoneReg.test(txt)){
    return true;
  }else {
    return false;
  }
}

// js与客户端交互
export function appfc(fn_name,callback,param,path){
  let obj = {
    'callback':callback,
    'param':param,
    'path':path
  }
  if(window.native_android){
    window.native_android[fn_name](JSON.stringify(obj));
  }else if(window.webkit && window.webkit.messageHandlers){
    window.webkit.messageHandlers[fn_name].postMessage(obj || {'key':'test'});
  }else{
    try{
      window.native[fn_name](obj);
    }catch(e){
      console.log("非webview下出现异常属于正常")
    }
  }
}
// js与客户端交互
export function nativeFn(fn_name,obj){
    if(window.native_android){
        window.native_android[fn_name](JSON.stringify(obj));
    }else if(window.webkit && window.webkit.messageHandlers){
        window.webkit.messageHandlers[fn_name].postMessage(obj || {'key':'test'});
    }else{
        try{
            window.native[fn_name](obj);
        }catch(e){
           console.log("非webview下出现异常属于正常")
        }
    }
}

export function _getFromIOS(res){
    let code =res.code;
    if(code=='undefined'||code==undefined){
        let callback=res.callback;
        //IOS没有和后端交互直接返回
        window[callback](res);
        return;
    }
    else if(code ==1005||code==4017||code==2007||code==1013||code==4013){
        let callback=res.callback;
        if(callback){
            window[callback](res);
        }
    }
    else if(code==-1||code==-2){
        vuerouter.push('/error?err='+code);
        return;
    }
    else if(code>1000&&code<5000){
        //内部错误
        vuerouter.push('/error?err='+code);
        return;
    }else{
        let callback=res.callback;
        if(callback){
            window[callback](res);
        }
        // else{
        //     vuerouter.push('/error?err=客户端返回错误');
        //     return;
        // }
    }
}
