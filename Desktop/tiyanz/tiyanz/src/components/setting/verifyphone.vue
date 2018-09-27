<template>
  <div id="verifyphone" class="navi">
    <MHeader :title="'绑定手机号'" :shadow="true"></MHeader>
    <ul>
      <li>
        <span>手机号</span>
        <input class="phone" type="text" placeholder="请输入手机号" v-model="phone">
      </li>
      <li>
        <input class="vercode" type="text" placeholder="请输入验证码" v-model="vercode">
        <p @click="sendcode" :class="canSend?'':'gray'">{{vertitle}}</p>
      </li>
    </ul>
    <p class="tip">*提交后，如需修改请联系客服。</p>
    <Mbutton class="submit" :title="'确认绑定'" @buttonAction="submit"></Mbutton>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>

<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Mbutton from '@/components/public/mbutton'
  import Msg from '@/components/public/msg'
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'

  export default {
    components:{
      MHeader, Mbutton, Msg,Mbutton
    },
    data (){
      return {
        phone: '',
        vercode: '',
        vertitle: '获取验证码',
        canSend: true,
        msgtitle: '',
        timegap: 59,
        bindphone:false
      }
    },
    methods: {
      showToast(title){
        this.msgtitle = title;
        this.$refs.msg.show()
      },
      sendcode(){ //发送验证码接口
        if(this.canSend){
          if(this.phone.length==11){
            appfc('js_net','_sendCode',{'phone': this.phone},constant.api_sendCode);
          }else{
            this.showToast('请填写正确的手机号');
          }
        }
      },
      _sendCode(res){
        if(res.code == 200){
          this.showToast('发送成功');
          let _self = this;
          _self.canSend = false;
          _self.vertitle = '重新获取(59s)';
          let timer = window.setInterval(function () {
            console.log(_self.timegap);
            _self.timegap--;
            _self.vertitle = '重新获取('+ _self.timegap + 's)';
            if(_self.timegap <= 1){
              _self.canSend = true;
              _self.vertitle = '获取验证码';
              _self.timegap = 59;
              window.clearInterval(timer);
            }
          },1000);
        } else {
          this.showToast(res.msg);
        }
      },
      submit(){     //提交接口
        let codeReg = /^\d{4}$/;
        if (this.phone.length == 0){
          this.showToast("请输入手机号");
        }else if (this.vercode.length == 0) {
          this.showToast("请输入验证码");
        }else if (!codeReg.test(this.vercode)) {
          this.showToast("验证码格式不正确");
        } else if (this.phone.length!=11) {
          this.showToast("手机号格式不正确");
        } else {
          appfc('js_net','_verifyphone',{phone: this.phone,code: this.vercode},constant.api_bindPhone);
        }
      },
      _verifyphone(res){
        if (res.code == 200) {
          appfc('js_saveData', '_phoneSave', {'phone':this.phone}, '');
        } else {
          this.showToast(res.msg);
        }
      },
      _phoneSave(res){
        this.showToast('绑定成功');
        this.bindphone = true;
        this.canSend = false;
        let _self = this;
        let timer = window.setInterval(function () {
          _self.$router.go(-1);
          window.clearInterval(timer);
        },2000);
      }
    },
    mounted(){
      window._sendCode = this._sendCode;
      window._verifyphone = this._verifyphone;
      window._phoneSave = this._phoneSave;
    }
  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #verifyphone
    width 100%
    ul
      width 100%
      li
        width 100%
        background-color white
        span
          display inline-block
          width 130px
          height 120px
          line-height 120px
          margin-left 30px
        .phone
          display inline-block
          width 578px
          height 120px
          line-height 60px
          padding-top 10px
          font-size $font-size-medium
          border-bottom 1px solid $color-text-gray
          background-color transparent
        .vercode
          display inline-block
          margin-left 30px
          width 450px
          height 120px
          line-height 120px
          font-size $font-size-medium
          background-color transparent
        p
          float right
          display inline-block
          width 250px
          height 120px
          text-align center
          line-height 120px
          color $color-theme
        p.gray
          color #999999
    .tip
      display inline-block
      height 80px
      line-height 80px
      font-size $font-size-small-s
      color $color-text-gray
    .submit
      margin-top 370px
</style>
