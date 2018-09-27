<template>
  <div id="user" class="navi">
    <img class="leftitem" src="../../assets/image/back.png" alt="" @click="goback">
    <!--<img class="leftItem" src="../../assets/image/back.png" @click="goback">-->
    <router-link to="setting" tag="div">
      <img class="rightBtn" src="../../assets/image/user_setting.png">
    </router-link>
    <div class="whitebg"></div>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" :data="[lists]">
        <ul class="list">
          <div class="user_card">
            <div class="user_info">
              <h1>ID:{{info.uid}}</h1>
              <h2>要每天看看呦~</h2>
            </div>
            <img class="logo" :src="info.wx_headimgurl">
            <router-link class="invite" to="/invite" tag="div">
              <img class="invite_icon" src="../../assets/image/user_scan.png" alt="">
              <h3>邀请好友，一起花钱</h3>
              <img class="invite_next" src="../../assets/image/user_next.png" alt="">
            </router-link>
          </div>
          <li v-for="item, index in lists" @click="listAction(item.index)">
            <img class="list_icon" :src="require('../../assets/image/user'+item.index+'.png')" alt="">
            <h3>{{item.title}}</h3>
            <img class="list_next" src="../../assets/image/user_next_min.png" alt="">
            <h5 v-show="index!==0"></h5>
          </li>
        </ul>
      </Scroll>
    </div>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script>
  import Scroll from '@/components/public/scroll'
  import {appfc} from '@/common/js/app'
  import constant from "@/common/js/constant"
  import Msg from "@/components/public/msg";

  export default {
    data() {
      return {
        userInfo:{},
        msgtitle:'',
        lists: [
          {title: '我的账户', index: 1},
          {title: '邀请记录', index: 2},
          {title: '提现记录', index: 3},
          {title: '商务合作', index: 4},
          {title: '客服帮助', index: 5},
          {title: '关于', index: 6},
          {title: '检查更新', index: 7},
        ],
        info: {},
        contentH:0
      }
    },
    components: {
       Scroll,Msg,
    },
    methods: {
      goback() {
        this.$router.go(-1)
      },
      settingPage() {
        this.$router.push({path: 'setting'})
      },
      listAction(index) {
        console.log(index);
        if (index == 1) {
          this.$router.push('/myincome')
        } else if (index == 2) {
          this.$router.push('/inviterecord')
        } else if (index == 3) {
          this.$router.push('/getcrashrecord')
        } else if (index == 4) {
          this.$router.push({path:'/cooperation',query:{qq:this.info.business_qq}});
        } else if (index == 5) {
          let qqurl = 'mqq://im/chat?chat_type=wpa&uin='+this.info.service_qq+'&version=1&src_type=web';
            appfc('js_service','_userQQserver',{'type':1,'url':qqurl},'');
        } else if (index == 6) {
          this.$router.push('/questions')
        } else if (index == 7) {
            appfc('js_netFull','_userUpdate',{},constant.api_is_up)
        }
      },
      _userUpdate(res){
        if(res.code == 200){
          if(res.data.is_up==1){
            this.msgtitle = '版本已过期，请重新下载';
            this.$refs.msg.show();
            let _self = this;
            let timer = window.setInterval(function () {
              appfc('js_openUrl','',{url:res.data.url},'');
              window.clearInterval(timer);
            },1500);
          }else {
            this.msgtitle = '目前已是最新版本';
            this.$refs.msg.show();
          }
        } else {
          this.msgtitle = title;
          this.$refs.msg.show()
        }
      },
      _usersaveData(res){
        this.info = res.param;
      },
      _userQQserver(res){
        if(res.success!==1){
          this.msgtitle=res.msg;
          this.$refs.msg.show();
        }
      },
      pulldown() {
        console.log('user 下拉刷新')
      }
    },
    beforeRouteEnter(to, from, next) {
//      console.log('user beforeRouteInter');
      next(vm => (
        appfc('js_saveData', '_usersaveData', {}, '')
      ));
    },
    mounted() {
      window._userUpdate = this._userUpdate;
      window._userQQserver = this._userQQserver;
      window._usersaveData = this._usersaveData;
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #user
    background white
    width 100%
    height 100%
    position relative
    .leftitem
      position: absolute
      top 62px
      left: 30px
      font-size: 25px
      display: inline-block
      width: 86px
      z-index 999
    .rightBtn
      position absolute
      right 30px
      top 62px
      width 44px
      height 44px
      z-index 999
    .whitebg
      position absolute
      top 0px
      width 100%
      height 300px
      background white
    .main
      font-weight normal
      position fixed
      background white
      overflow scroll
      width 100%
      bottom 0px
      top 138px
      .list
        overflow hidden
      .user_card
        overflow hidden
        width 630px
        height 450px
        margin-top 10px
        margin-bottom 10px
        margin-left 60px
        border-radius 9px
        box-shadow 0px 0px 6px 3px rgba(0, 0, 0, 0.10)
        .user_info
          display inline-block
          padding-top 0px
          margin-left 0px
          h1
            height 50px
            margin-left 44px
            padding-top 107px
            line-height 50px
            font-size $font-size-medium
          h2
            margin-left 44px
            margin-top 5px
            height 50px
            line-height 50px
            color $color-text-gray
            font-size $font-size-medium
        .logo
          display inline-block
          float right
          margin-top 100px
          margin-right 60px
          width 120px
          height 120px
          border-radius 60px
        .invite
          width 542px
          height 100px
          margin-left 44px
          margin-top 60px
          background $color-theme
          border-radius 50px
          .invite_icon
            float left
            width 40px
            height 40px
            margin-top 30px
            margin-left 60px
          h3
            float left
            height 40px
            line-height 40px
            margin-left 16px
            margin-top 30px
            font-size $font-size-small
            color white
          .invite_next
            float right
            margin-right 44px
            margin-top 32.5px
            width 28px
            height 35px
      li
        width 100%
        height 150px
        overflow hidden
        .list_icon
          float left
          width 80px
          height 80px
          margin-top 35px
          margin-left 44px
        h3
          float left
          height 40px
          line-height 40px
          margin-left 44px
          margin-top 55px
          font-size $font-size-medium
          color $color-text
        .list_next
          float right
          margin-right 50px
          margin-top 57.5px
          width 28px
          height 35px
        h5
          width 630px
          height 1px
          margin-left 44px
          background $color-line-gray
  .gap
    width 100%
    height 20px

</style>
