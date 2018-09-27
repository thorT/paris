<template>
  <div id="getcrashrecord" class="navi">
    <MHeader :title="'提现记录'" :shadow="true"></MHeader>
    <Loading v-if="initRequst==true"></Loading>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" @scrollToEnd="serachMore" :data="info" :pullUp="true">
        <ul class="list X_paddingbottom">
          <li v-for="item,index in info">
            <h2>恭喜！成功提现{{item.price}}元</h2>
            <h4>{{item.createdAt}}</h4>
            <h5 v-if="index!==0"></h5>
          </li>
          <Loading v-if="loadmore" :title="''"></Loading>
          <p v-if="!loadmore&&ended">已经没有更多数据了~</p>
        </ul>
        <note v-if="!initRequst&&info.length==0" :title="'你还没有任何提现记录'" ></note>
      </Scroll>
    </div>
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
      _getcrashrecord(res) {
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
        appfc('js_net', '_getcrashrecord', {'current_page':this.currentPage,'page_size':20}, constant.api_userWithdrawalRecord);
        this.currentPage = this.currentPage+1;
      }
    },
    mounted() {
      this.initData();
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
      window._getcrashrecord = this._getcrashrecord;
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #getcrashrecord
    width 100%
    .main
      width 100%
    .list
      width 100%
      li
        width 100%
        height 120px
        h2
          float left
          display inline-block
          height 60px
          line-height 60px
          margin-left 30px
          padding-top 30px
          font-size $font-size-small
          color $color-text
        h4
          float right
          display inline-block
          height 60px
          line-height 60px
          margin-right 30px
          padding-top 30px
          font-size $font-size-small-s
          color $color-text-gray
        h5
          margin-left 30px
          height 1px
          background $color-line-gray
  p
    display inline-block
    width 100%
    text-align center
</style>
