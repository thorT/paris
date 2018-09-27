<template>
  <div class="navi bindalipay">
    <Mheader :title="'绑定支付宝'" :shadow="true"></Mheader>
    <ul>
      <li>
        <span class="fm">手机号</span>
        <input type="text" placeholder="请输入手机号码" v-model="phone" class="fm">
      </li>
      <li>
        <span class="fm">姓名</span>
        <input type="text" placeholder="请输入支付宝姓名" v-model="name" class="fm">
      </li>
    </ul>
    <p class="gray fs">*提交后，如需修改请联系客服。</p>
    <Mbutton :title="'确定'" @buttonAction="submit"></Mbutton>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>

<script type="text/ecmascript-6">
  import Mheader from "@/components/public/mheader";
  import Mbutton from "@/components/public/mbutton";
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'
  import Msg from "@/components/public/msg";

  export default {
    components: {
      Mheader, Mbutton,Msg
    },
    data() {
      return {
        phone: '',
        name: '',
        msgtitle:''
      }
    },
    methods: {
      submit(){

         if (this.phone.length!=11) {
          this._switchTip("手机号格式不正确");
        } else if(this.name.length<1||this.name == 'undefined') {
           this._switchTip("请输入支付宝姓名");
         }else {
          appfc('js_net','_bindalipay',{'account':this.phone,'name':this.name},constant.api_bindAlipay);
         }
      },
      _bindalipay(res){
        if (res.code == 200) {
          appfc('js_saveData', '_alipaysave', {alipay:this.phone}, '');
        } else {
          this._switchTip(res.msg);
        }
      },
      _alipaysave(res){
        this._switchTip('绑定成功');
        let _self = this;
        let timer = window.setInterval(function () {
          window.clearInterval(timer);
          _self.$router.go(-1);
        },2000);
      },
      _switchTip(title){
        this.msgtitle = title;
        this.$refs.msg.show();
      }
    },
    mounted(){
      window._bindalipay = this._bindalipay;
      window._alipaysave = this._alipaysave;
    },
  }

</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  .bindalipay
    width 100%
    ul
      width 100%
      background $color-background-content
      li
        width 95%
        height 90px
        line-height 90px
        font-size 0
        margin 0 auto
        box-sizing border-box
        span
          float left
          width 20%
          display inline-block

        input
          float left
          height 90px
          width 50%
          box-sizing border-box
          background $color-background-content
        a
          display inline-block
          width 30%
          float left
          border-left 1px solid #E5E5E5
          box-sizing border-box
          color #FD7049
          height 30px
          line-height 30px
          margin-top 10px
        a.gray
          color #999999
        &:last-child
          border-top 1px solid #E5E5E5
    p
      text-align left
      text-indent 8px
      margin-top 8px
    .mbutton
      margin-top 120px
</style>
