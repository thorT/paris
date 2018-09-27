<template>
  <div id="myincome" class="navi">
    <MHeader :title="'我的账户'" :shadow="true"></MHeader>
    <Loading v-if="initRequst==true"></Loading>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" @scrollToEnd="serachMore" :data="info" :pullUp="true">
        <ul class="list X_paddingbottom">
          <li v-for="item,index in info">
            <h5 v-if="index!==0"></h5>
            <div class="left">
              <div class="title_content">
              <h1>{{item.income_info}}</h1>
              </div>
              <h2>{{item.createdAt}}</h2>
            </div>
            <div class="right">
              <h3>{{item.price.indexOf('-')!=-1?item.price:'+'+item.price}}</h3>
              <h4>{{item.left_money}}<span>+月结:{{item.left_freeze}}</span></h4>
            </div>
          </li>
          <Loading v-if="loadmore" :title="''"></Loading>
          <p v-if="!loadmore&&ended&&info.length>20">已经没有更多数据了~</p>
        </ul>
      </Scroll>
      <note v-if="!initRequst&&info.length<=0" :title="'你还没有任何收入记录'"></note>
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
        currentPage: 1,
        initRequst: true,
        loadmore: false,
        ended: false,
      }
    },
    components: {
      MHeader, Msg, Scroll, Loading, note
    },
    methods: {
      serachMore() {
        if (this.info.length < 20) {
          return;
        }
        if (!this.ended) {
          this.loadmore = true;
          this.initData();
        }
      },
      _getmyincome(res) {
        this.initRequst = false;
        this.loadmore = false;
        if (res.code == 200) {
          this.info = this.info.concat(res.data);
          if (res.data.length < 20) {
            this.ended = true;
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
      initData() {
        appfc('js_net', '_getmyincome', {'current_page': this.currentPage, 'page_size': 20}, constant.api_myincome);
        this.currentPage = this.currentPage + 1;
      }
    },
    mounted() {
      window._getmyincome = this._getmyincome;
      this.initData();
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #myincome
    width 100%
    .list
      width 100%
      li
        width 100%
        height 181px
        background white
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
        .title_content
          position relative
          height 110px
          margin-left 30px
          h1
            font-size $font-size-medium
            color $color-text
            line-height 35px
            position absolute
            top 50%
            transform translateY(-50%)
        h2
          height 80px
          line-height 30px
          margin-left 30px
          font-size $font-size-small
          color $color-text-graydark
        h3
          height 110px
          line-height 120px
          margin-right 30px
          font-size $font-size-medium
          color $color-text
        h4
          height 80px
          line-height 30px
          margin-right 30px
          font-size $font-size-small
          color $color-text-graydark
          span
            font-size $font-size-small-s
        h5
          margin-left 30px
          height 1px
          background $color-line-gray

  p
    text-align center
</style>
