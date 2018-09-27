<template>
  <div id="invite" class="navi">
    <MHeader :title="'邀请'" :shadow="true"></MHeader>
    <router-link class="invite_record" to="/inviterecord" tag="div">
      <h2>邀请记录</h2>
      <img src="../../assets/image/ico_down.png" alt="">
    </router-link>
    <div class="imagecontent">
      <img class="qrcodebg" src="../../assets/image/invite.png" alt="">
      <img class="qrcode" :src="qr_code" alt="">
    </div>
    <p>**徒弟做任务，您可以获取徒弟收益的50%，最高20元哦！</p>
    <MButton class="mbutton" :title="'邀请好友'" @buttonAction="invite()"></MButton>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import MButton from '@/components/public/mbutton'
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'
  import Msg from "@/components/public/msg";

  export default {
    data() {
      return {
        qr_code: '',
        qr_code_url: '',
        title: '',
        content: '',
        share_img: '',
        msgtitle: ''
      }
    },
    components: {
      MHeader, MButton, Msg
    },
    methods: {
      invite() {
        appfc('js_share', '_invitefriends', {
          'title': this.title,
          'content': this.content,
          'share_img': this.share_img,
          'share_url': this.qr_code_url
        }, '')
      },
      _invitefriends(res) {
        if (res.success == 1) {
          this.msgtitle = res.msg;
          this.$refs.msg.show();
        } else {
          this.msgtitle = res.msg;
          this.$refs.msg.show();
        }
      },
      _inviteinfo(res) {
        this.$loading.close();
        if (res.code == 200) {
          this.qr_code = res.data.qr_code;
          this.qr_code_url = res.data.qr_code_url;
          this.title = res.data.title;
          this.content = res.data.content;
          this.share_img = res.data.share_img;
          this.service_qq = res.data.service_qq;
        } else {
          this.msgtitle = res.msg;
          this.$refs.msg.show();
        }
      },
      _start() {
        appfc('js_net', '_inviteinfo', '', constant.api_qrCodeInvitingFriends);
      },

    },
    mounted() {
      this._start();
      //this.$loading.show();
      window._inviteinfo = this._inviteinfo;
      window._invitefriends = this._invitefriends;
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #invite
    width 100%
    position relative
    .invite_record
      float right
      width 180px
      height 100px
      text-align center
      h2
        display inline-block
        padding-top 25px
        height 35px
        line-height 35px
        font-size $font-size-medium
        color #6d89f4
      img
        width 60px
        height 40px
    .imagecontent
      position relative
      margin-top 44px
      .qrcodebg
        width 450px
        height 471px
        margin-left 150px
      .qrcode
        position absolute
        top 110px
        left 260px
        width 230px
        height 230px

    p
      margin-left 100px
      margin-top 44px
      width 550px
      height 90px
      color $color-text-gray
      font-size $font-size-small
    .mbutton
      margin-top 120px


</style>
