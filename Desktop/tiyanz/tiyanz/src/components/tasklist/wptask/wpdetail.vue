<template>
  <div id="wpdetail" class="navi">
    <MHeader :title="'任务详情'" :shadow="true"></MHeader>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll">
        <ul class="X_paddingbottom">
          <li>
            <img class="logo_s" :src="item.app_icon" alt="">
            <div class="title_content">
              <p class="title">{{item.app_name}}</p>
              <p class="size">{{item.size}}MB</p>
            </div>
            <p class="price">+{{item.bill}}</p>
            <p class="tip">{{item.tip}}</p>
          </li>
          <li v-show="item.searchWord!='undefined'&&item.searchWord!=null&&item.searchWord!=''">
            <h3>步骤1</h3>
            <h2>右侧的关键词<br>已自动复制</h2>
            <p class="keyword">{{item.searchWord}}</p>
          </li>
          <li v-show="item.searchWord!='undefined'&&item.searchWord!=null&&item.searchWord!=''">
            <h3>步骤2</h3>
            <h2>App Store粘贴<br>关键词搜索</h2>
            <img class="desicon" src="../../../assets/image/task1.png" alt="">
          </li>
          <li v-show="item.searchWord!='undefined'&&item.searchWord!=null&&item.searchWord!=''">
            <h3>步骤3</h3>
            <h2>找到右侧图标的软件<br>下载</h2>
            <img class="logo_l" :src="item.app_icon" alt="">
          </li>
          <li>
            <p class="rec_tip" v-html="this.rec_tip">{{this.rec_tip}}</p>
            <p class="start" @click="downUrl">小菜一碟，前往下载</p>
          </li>
        </ul>
      </Scroll>
    </div>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Scroll from '@/components/public/scroll'
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'
  import {decodeUrl} from '@/common/js/api'

  export default {
    data() {
      return {
        contentH: 0,
        item: {},
        rec_tip: '',
        down_tip:'',
      }
    },
    components: {
      MHeader, Scroll
    },
    methods: {
      downUrl() {
        appfc('js_netFull','_startwpDetail',{},constant.api_taskLog_start)
      },
      _startwpDetail(res){
        appfc('js_openUrl','',{url:this.item.click_url},'')
      },
      _start() {
        this.item = this.$route.query.item;
        var str = this.item.rec_tip;
        str = str+'<br>'+'<span style="color:red;">'+this.item.tip+'<br>*请允许目标app使用网络，并切实完成以上要求才能获得推广费' +
          '<br>*奖励可在用户中心的"我的账户"下查看(需要对方审核,可能有延迟,请见谅)'+ '</span>';
        var reg = new RegExp( '\n' , "g" );
        var newstr = str.replace( reg , '<br>' );

        this.rec_tip = newstr;
        this.$nextTick(function () {
          this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
          appfc('js_setPasteboard','',{str:this.item.searchWord},'');
        });
      }
    },
    mounted() {
      window._startwpDetail= this._startwpDetail;
      this._start();
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #wpdetail
    width 100%

  .main
    font-weight normal
    position relative
    overflow scroll
    width 100%
    bottom 0px
    top 0px
    background white
  li:first-child
    overflow hidden
    height 233px
  li:nth-child(2)
    overflow hidden
    height 281px
  li:nth-child(3)
    overflow hidden
    height 281px
  li:nth-child(4)
    overflow hidden
    height 300px
  li:nth-child(5)
    height auto
  li
    position relative
    overflow hidden
    .logo_s
      float left
      display inline-block
      margin-left 50px
      margin-top 26px
      width 110px
      height 110px
      border-radius 12px
    .title_content
      float left
      display inline-block
      padding-top 26px
      margin-left 20px
      .title
        height 55px
        line-height 50px
        font-size $font-size-medium
        padding-top 10px
      .size
        height 55px
        line-height 25px
        margin-top 10px
        color $color-text-gray
    .price
      float right
      padding-top 26px
      margin-right 44px
      height 110px
      line-height 110px
      display inline-block
      font-size $font-size-large-xl
      color red
    .tip
      box-shadow 1px 1px 2px $color-text-gray
      margin-top 164px
      background #fbebe9
      height 70px
      line-height 70px
      text-align center
      color black
      font-size $font-size-small
    h3
      display inline-block
      width 126px
      height 50px
      border 1px solid $color-lighttheme
      line-height 50px
      text-align center
      color $color-theme
      font-size $font-size-small
      border-radius 30px
      margin-top 60px
      margin-left 44px
    h2
      margin-left 45px
      margin-top 28px
      line-height 46px
      color #828282
      font-size $font-size-medium
    .keyword
      display inline-block
      position absolute
      width 233px
      height 66px
      right 44px
      top 130px
      border 3px dotted $color-theme
      border-radius 18px
      line-height 66px
      text-align center
    .desicon
      position absolute
      display inline-block
      width 250px
      height 200px
      right 44px
      top 50px
    h4
      margin-left 45px
      margin-top 1px
      line-height 45px
      color red
      font-size $font-size-large
    .logo_l
      position absolute
      display inline-block
      width 150px
      height 150px
      right 100px
      top 90px
      border-radius 18px

    .rec_tip
      letter-spacing 2px
      margin 25px 45px 60px
      padding 18px 20px
      line-height 40px
      border 3px dotted #e92d2c
      border-radius 18px
    .start
      width 100%
      height 90px
      line-height 90px
      text-align center
      color white
      font-size $font-size-large
      background $color-theme
</style>
