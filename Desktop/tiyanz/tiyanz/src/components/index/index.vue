<template>
  <div id="index" class="navi">
    <div class="main X_paddingtop" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll">
        <div class="top">
          <router-link to="/user" tag="div">
            <img class="logo" :src="info.wx_headimgurl">
          </router-link>
          <div class="acount">
            <h5>账户余额</h5>
            <h1 @click="refreshCash">{{info.price}}
              <span>+月结:{{info.freeze}} <img :class="[rotate?'rotate':'']" src="../../assets/image/refresh.png"></span>
            </h1>
          </div>
          <router-link to="/apply" tag="div" class="toCash">
            <span>提现</span>
          </router-link>
          <ul class="accountDet">
            <li>
              <h4>今日收入(元)</h4>
              <h2>{{info.today_income}}</h2>
            </li>
            <li class="line_lie"></li>
            <li>
              <h4>累计收入(元)</h4>
              <h2>{{info.total_income}}</h2>
            </li>
          </ul>
        </div>
        <div class="task clearfix">
          <ul>
            <li>
              <router-link to="/tasklist" tag="div">
                <img src="../../assets/image/home1.png" alt="">
                <h2>联盟任务</h2>
                <h4>下载app，试玩得奖励</h4>
              </router-link>
            </li>
            <li>
              <router-link :to="{path:'/tcmain',query:{uid:info.uid,freeze:info.freeze}}" tag="div">
                <img src="../../assets/image/home2.png" alt="">
                <h2>市场调查</h2>
                <h4>每天可领10元</h4>
              </router-link>
            </li>
            <li>
              <router-link to="" tag="div" @click.native='jump'>
                <img src="../../assets/image/home3.png" alt="">
                <h2>玩游戏</h2>
                <h4>日赚100元不是梦</h4>
              </router-link>
            </li>
            <li>
              <router-link to="" tag="div">
                <img src="../../assets/image/home4.png" alt="">
                <h2>高额任务</h2>
                <h4>敬请期待</h4>
              </router-link>
            </li>
            <li>
              <router-link to="" tag="div">
                <img src="../../assets/image/home5.png" alt="">
                <h2>游戏评测</h2>
                <h4>敬请期待</h4>
              </router-link>
            </li>
          </ul>
          <div class="clearbottom"></div>
        </div>
        <div class="banner" ref="sliderWrapper">
          <slider>
            <div v-for="item in bannerArr">
              <a @click="bannerto(item.index)">
                <img :src="item.img">
              </a>
            </div>
          </slider>
        </div>
        <div class="tab" @click="goInvite">
          <img class="tab_logo" src="../../assets/image/index_invite.png" alt="">
          <div class="invite">
            <h2>邀请好友</h2>
            <h3>好友挣钱，你拿返利</h3>
          </div>
          <img class="tab_next" src="../../assets/image/user_next_min.png" alt="">
        </div>
      </Scroll>
    </div>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>

<script type="text/ecmascript-6">
  import {appfc} from '@/common/js/app'
  import slider from '@/components/public/slider'
  import {xianwanLink} from '@/common/js/net'
  import Msg from "@/components/public/msg";
  import Scroll from '@/components/public/scroll'

  export default {
    components: {
      slider, Msg, Scroll
    },
    data() {
      return {
        info: {},
        msgtitle: '',
        bannerArr: [
          {index: 0, img: require('@/assets/image/banner1.png')},
          {index: 1, img: require('@/assets/image/banner2.png')}
        ],
        rotate: false,
        contentH: 0,
      }
    },
    methods: {
      refreshCash() {
        this.rotate = true;
        appfc('js_netFull', '_homeback', {}, 'home');
      },
      jump() {
        appfc('js_localData', '_localData', {}, '');
      },
//      tctask(){
//        var str =  "http://www.tctask.com/index.php?e=index.dclist&coopid=1218&uid=$uid";
//        var newstr = str.replace( '$uid' , this.info.uid );//is_dk
//        appfc('js_openUrl','', {'url':newstr},'');
//      },
      goInvite() {
        this.$router.push('/invite');
      },
      bannerto(index) {
        if (index == 1) {
          this.$router.push('/questions');
        } else {
          this.$router.push({path:'/tcmain',query:{uid:this.info.uid,freeze:this.info.freeze}});
//          var str =  "http://www.tctask.com/index.php?e=index.dclist&coopid=1218&uid=$uid";
//          var newstr = str.replace( '$uid' , this.info.uid );//is_dk
//          appfc('js_openUrl','', {'url':newstr},'');
        }
      },
      _start() {
        // this.$loading.show();
        appfc('js_netFull', '_homeback', {}, 'home');
      },
      _localData(res) {
        let url = xianwanLink({
          ptype: res.param.ptype,
          deviceid: res.param.Device_IDFA,
          appsign: res.param.uid,
        });
        appfc('js_wkWeb', '', {url: url, title: '玩游戏'}, '');
      },
      _savedata(res) {

      },
      _homeback(res) {
        this.$loading.close();
        if (res.code == 200) {
          // alipay business_qq freeze getudid is_udid phone price service_qq
          // today_income total_income uid wx_headimgurl wx_name
          this.info = res.data;
          appfc('js_saveData', '_savedata', res.data, '');

          if (this.rotate) {
            this.msgtitle = '你的余额已刷新';
            this.$refs.msg.show();
            this.rotate = false;
          }
        } else {
          this.msgtitle = res.msg;
          this.$refs.msg.show();
        }
        this.$nextTick(function () {
          this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
        });
      },
    },
    mounted() {
      console.log('index mounted');
      window._homeback = this._homeback;
      window._jsdata = this._jsdata;
      window._localData = this._localData;
      window._savedata = this._savedata;
      this._start();
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
    }
  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #index
    width 100%
    background: linear-gradient(to bottom, $color-theme 0%, $color-theme 40%, #EFEFEF 50%, #EFEFEF 100%);

  .main
    width 100%

  .top
    position relative
    width 100%
    height 340px
    background $color-theme
    .logo
      float left
      width 110px
      height 110px
      margin-top 130px
      margin-left 30px
      box-shadow: 0 1px 16px 0 white
      border-radius 60px
    .acount
      float left
      display inline-block
      margin-top 120px
      margin-left 25px;
      height 120px
      color $color-text-white
      h5
        line-height 60px
        height 60px
        font-size $font-size-small
      h1
        line-height 60px
        height 60px
        font-size $font-size-large-xl
        span
          font-size $font-size-small
          margin-left -15px
          img
            display inline-block
            width 28px
            height 28px
            margin-left -5px
    .toCash
      position absolute
      width 120px
      height 65px
      background $color-text-white
      top 120px
      right 0px
      font-size $font-size-medium
      line-height 65px
      text-align center
      border-top-left-radius 37.5px
      border-bottom-left-radius 37.5px
      box-shadow: 0 1px 9px 0 rgba(0, 0, 0, 0.10)

  .accountDet
    float left
    margin-left 25px
    margin-top 50px
    border-radius 12px;
    overflow hidden
    box-shadow: 0 1px 9px 0 rgba(0, 0, 0, 0.10);
    background white
    li
      float left
      text-align center
      height 150px
      h4
        width 349px
        height 75px
        line-height 75px
        color $color-text-graydark
        font-size $font-size-small
      h2
        width 349px
        height 60px
        line-height 60px
        font-size $font-size-large-x
        color $color-text
    li.line_lie
      display inline-block
      border-right 1px solid #d6d6d6
      width 1px
      height 80px
      margin-top 35px

  .task
    background white
    padding-top 102px
    padding-bottom 75px
    li
      float left
      margin-top 70px
      text-align center
      img
        width 65px
        height 65px
      h2
        margin-top 16px
        width 250px
        height 50px
        line-height 50px
        font-size $font-size-medium
      h4
        width 250px
        height 30px
        line-height 30px
        font-size $font-size-small-s
        color $color-text-gray

  .banner
    position relative
    width 100%
    overflow hidden

  .tab
    height 140px
    width 100%
    background white
    margin-top 15px
    .tab_logo
      display inline-block
      float left
      width 80px
      height 80px
      margin-left 30px
      margin-top 30px
    .invite
      float left
      height 140px
      margin-left 20px
      width 65%
      h2
        height 70px
        line-height 100px
        color $color-text
      h3
        height 70px
        line-height 30px
        color $color-text-graydark
        font-size $font-size-small
    .tab_next
      float right
      margin-right 44px
      margin-top 55px
      width 28px
      height 35px

  .rotate
    transition: 0.5s;
    transform-origin: 14px 14px;
    animation: rotate 1s linear infinite; /*开始动画后无限循环，用来控制rotate*/
    animation-direction false

  @keyframes rotate
    0%
      transform: rotate(0)
    50%
      transform: rotate(180deg)
    100%
      transform: rotate(360deg)

</style>
