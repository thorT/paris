<template>
  <div id="inviterecord" class="navi">
    <MHeader :title="'邀请记录'" :shadow="true"></MHeader>
    <Loading v-if="initRequst==true"></Loading>
    <div class="main" v-if="info.length>0" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" @scrollToEnd="serachMore" :data="info" :pullUp="true">
        <ul class="list X_paddingbottom">
          <li v-for="item,index in info">
            <h5 v-if="index!==0"></h5>
            <div class="left">
              <h1>徒弟：{{item.wx_name}}获得收益</h1>
              <h2>{{item.createdAt}}</h2>
            </div>
            <div class="right">
              <h3>你获得{{item.sfuid_get}}元</h3>
            </div>
          </li>
          <Loading v-if="loadmore" :title="''"></Loading>
          <p v-if="!loadmore&&ended">已经没有更多数据了~</p>
        </ul>
      </Scroll>
    </div>
    <note v-if="!initRequst&&info.length<=0" :title="'您还没有任何邀请记录'" ></note>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import {appfc} from '@/common/js/app'
  import Msg from "@/components/public/msg";
  import constant from '@/common/js/constant'
  import Scroll from '@/components/public/scroll'
  import Loading from '@/components/public/loading'
  import note from '@/components/public/note'

  export default {
    data() {
      return {
        info: [],
        msgtitle: '',
        contentH: 0,
        currentPage:1,
        initRequst: true,
        loadmore:false,
        ended:false,
      }
    },
    components: {
      MHeader,Msg,Scroll,Loading,note
    },
    methods: {
      serachMore(){
        if(this.info.length<20){
          return;
        }
        if(!this.ended) {
          this.loadmore = true;
          this.initData();
        }
      },
      _inviteRecord(res) {
        this.initRequst = false;
        this.loadmore = false;
        if (res.code == 200) {
          if(res.data.length>0) {
            this.info = this.info.concat(res.data);
            if (res.data.length < 20 && res.data.length > 0) {
              this.ended = true;
            }
          }

        } else {
          this._switchTip(res.msg);
        }
        this.$nextTick(function () {
          this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
        });
      },
      _switchTip(title) {
        this.msgtitle = title;
        this.$refs.msg.show();
      },
      initData(){
        appfc('js_net', '_inviteRecord', {'current_page':this.currentPage,'page_size':20}, constant.api_invitationSuccessReport);
        this.currentPage = this.currentPage+1;
      }
    },
    mounted() {

      this.initData();
      window._inviteRecord = this._inviteRecord;
      // this.$loading.show();
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #inviterecord
    width 100%
    .main
      width 100%
      li
        width 100%
        background white
        height 181px
        .left
          width 60%
          height 180px
          float left
          text-align left
          background white
        .right
          width 40%
          height 180px
          float right
          text-align right
          background white
        h1
          height 110px
          line-height 120px
          margin-left 30px
          font-size $font-size-medium
          color $color-text
        h2
          height 80px
          line-height 30px
          margin-left 30px
          font-size $font-size-small
          color $color-text-graydark
        h3
          height 180px
          line-height 180px
          margin-right 30px
          font-size $font-size-small
          color $color-text-graydark
        h5
          margin-left 30px
          height 1px
          background $color-line-gray
    p
      display inline-block
      width 100%
      text-align center
</style>
