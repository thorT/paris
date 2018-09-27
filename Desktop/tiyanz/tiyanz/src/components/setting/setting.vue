<template>
  <div id="setting" class="navi">
    <MHeader :title="'设置'" :shadow="true"></MHeader>
    <ul class="list">
      <li v-for="item, index in lists" @click="goto(index)">
        <h2>{{item.title}}</h2>
        <img class="list_next" src="../../assets/image/user_next_min.png" alt="">
        <h3>{{item.bind ? item.binded : item.nobind}}</h3>
        <h5 v-if="index!=0"></h5>
      </li>
    </ul>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import {appfc} from '@/common/js/app'
  import Msg from "@/components/public/msg"

  export default {
    data() {
      return {
        lists: [
          {title: '绑定手机', bind: 0, binded: '已绑定', nobind: '前往绑定'},
          {title: '绑定提现支付宝', bind: 0, binded: '已绑定', nobind: '前往绑定'},
          {title: '验证设备', bind: 0, binded: '已验证', nobind: '前往验证'},
          {title: '账号找回', bind: 1, binded: '', nobind: ''}
        ],
        getudid:'',
        msgtitle:''
      }
    },
    components: {
      MHeader,Msg
    },
    methods: {
      goto(index) {
        if (index == 0&&this.lists[0].bind == 0) {
          this.$router.push({path: '/verifyphone'});
        } else if (index == 1&&this.lists[1].bind == 0) {
          this.$router.push({path: '/bindalipay'});
        }else if (index == 2&&this.lists[2].bind == 0){
          appfc('js_veriDev', '_settingveriDev', {url:this.getudid}, '');
        }else if(index==3){
          appfc('js_veriDev', '_settingveriDev', {url:this.getudid}, '');
        }
      },
      _settingsaveData(res) {
        this.getudid = res.param.getudid;

        //bindphone
        if(res.param.phone) {
          let str = res.param.phone;
          if((typeof str=='string')&&str.constructor==String&&str.length==11) {
            this.lists[0].bind = 1;
          }else {
            this.lists[0].bind = 0;
          }
        }
        //bindalipay
        if(res.param.alipay) {
          let str = res.param.alipay;
          if((typeof str=='string')&&str.constructor==String&&str.length==11) {
            this.lists[1].bind = 1;
          }else {
            this.lists[1].bind = 0;
          }
        }
        //binddevice
        if(res.param.is_udid==1) {
          this.lists[2].bind = 1;
        }
      },
      _settingveriDev(res){
        //binddevice
        if(res.data.is_udid==1) {
          this.lists[2].bind = 1;
        }else{
          this.msgtitle = '验证失败';
          this.$refs.msg.show()
        }
        appfc('js_saveData', '', res.data, '');
      }
    },
    beforeRouteEnter(to, from, next) {
      next(vm => {
        appfc('js_saveData', '_settingsaveData', {}, '');
      })
    },
    mounted() {
      window._settingsaveData = this._settingsaveData;
      window._settingveriDev = this._settingveriDev;
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #setting
    width 100%
    .naviContainer
      width 100%
      height 128px
      background $color-theme
      text-align center
      h1
        display inline-block
        padding-top 40px
        height 88px
        line-height 88px
        font-size $font-size-large
    .list
      width 100%
      li
        height 120px
        h2
          display inline-block
          float left
          height 60px
          line-height 60px
          margin-left 30px
          padding-top 30px
          font-size $font-size-medium
          color $color-text
        .list_next
          float right
          margin-right 50px
          padding-top 42.5px
          width 28px
          height 35px
        h3
          float right
          display inline-block
          height 60px
          line-height 60px
          margin-right 30px
          padding-top 30px
          font-size $font-size-small
          color $color-text-gray
        h5
          margin-left 30px
          height 1px
          background $color-line-gray
</style>
