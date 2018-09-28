<template>
  <div id="tctasklist" class="navi">
    <MHeader :title="'调查'" :shadow="true"></MHeader>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll" :data="info">
        <div class="mainContent">
          <div class="top">
            <img class="logo" src="../../assets/image/tc/tctouxiang.png" alt="">
            <div class="person">
              <h2>ID:{{uid}}<img src="../../assets/image/tc/tcgrade.png"></h2>
              <h3>
                <img style="vertical-align: text-bottom" src="../../assets/image/tc/tcmoney.png" alt="">
                {{freeze}}元
              </h3>
            </div>
            <div class="task_tip">
              <img class="tcbanner" src="../../assets/image/tc/tcbanner.png" alt="">
              <p class="tip">轻松三步拿奖金</p>
              <div class="steps">
                <div class="step">
                  <img src="../../assets/image/tc/tc01.png" alt="">
                  <h2>领取任务</h2>
                  <h4>选择感兴趣的任务领取</h4>
                </div>
                <div class="step">
                  <img src="../../assets/image/tc/tc02.png" alt="">
                  <h2>完成任务</h2>
                  <h4>按照奖励规范完成任务</h4>
                </div>
                <div class="step">
                  <img src="../../assets/image/tc/tc03.png" alt="">
                  <h2>领取奖励</h2>
                  <h4>系统审核发放奖励</h4>
                </div>
              </div>
              <p class="task_title" @click="goto()">前往调查大厅</p>
            </div>
          </div>
          <div class="introduce X_paddingbottom">
            <h1 class="gtitle">超强攻略</h1>
            <h2>兑换规则:</h2>
            <p>100积分=1元！</p>
            <h2>想要奖励最大化？</h2>
            <p>你可以这样做:想象自己年龄在35-45岁之间，女性好一些</p>
            <h2>~~问你有车吗?</h2>
            <p>你要说有，并在网上找辆70万左右的车记下车的信息，以备后面他再问!</p>
            <h2>问你住哪里？</h2>
            <p>比如你说上海，后面他再问你时，你要说住在市区，住了5年或更久的时间!</p>
            <h2>问你家里是你主事吗？</h2>
            <p>你一定要说是!</p>
            <h2>问你公司里你的地位？</h2>
            <p>你就往管理层讲，比如采购主管等等!</p>
            <h2>问你家里年收入多少？</h2>
            <p>你一定要填高些，大概在55万以上，并找本本记录下来!</p>
            <h2>问你太阳和地球的距离，请点击第二项？</h2>
            <p>你就去点击第二项!</p>
            <h2>问你2+7=？</h2>
            <p>你一定要选择9!</p>
            <h2>小提示:</h2>
            <ul>
              <li><span>●</span>定要拿个小本本把你填重要的东西，比如：年龄，性别，有车的将车辆信息，等等记下来，不记录在小本本上，也一定要记在电脑的txt文件下,反正一定要记下来；</li>
              <li><span>●</span>绝对不能今天填18岁，明天填20岁，这样随便填，这是大忌；</li>
              <li><span>●</span>每天获利至少10元以上，我说10元其实都是少的，20元，30元打底根本就没有问题；</li>
              <li><span>●</span>也可以粘贴链接在电脑上做，一天做好几百的多的是，真的是很赚钱，不过要认真填写，不能乱写；</li>
              <li><span>●</span>因为有些是法国的服务器，所以加载速度有时会比较慢，请耐心等待，因为钱真的很多；</li>
            </ul>
          </div>
        </div>
      </Scroll>
    </div>
    <Msg :text="msgtitle" ref="msg"></Msg>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Scroll from '@/components/public/scroll'
  import {appfc} from '@/common/js/app'
  import constant from '@/common/js/constant'
  import Msg from "@/components/public/msg";


  export default {
    data() {
      return {
        contentH: 0,
        msgtitle: '',
        rotate: false,
        info:[],
        uid: '',
        freeze: ''
      }
    },
    components: {
      MHeader, Scroll, Msg
    },
    methods: {
      goto() {
        this.$router.push('/tctasklist')
      },
      refreshCash() {
        this.rotate = true;
        appfc('js_netFull', '_tcmainhome', {}, 'home');
      },
      _tcmainsaveData(res) {
        if (res.code == 1) {
          this.msgtitle = '你的余额已刷新';
          this.$refs.msg.show();
        }
      },
      _tcmainhome(res) {
        this.rotate = false;
        if (res.code == 200) {
          appfc('js_saveData', '_tcmainsaveData', res.data, '');
        } else {
          this.msgtitle = res.msg;
          this.$refs.msg.show();
        }
      },
      initData() {
        appfc('js_net', '_tcmainhome', {}, constant.api_getSurveyList);
      }
    },
    mounted() {
      window._tcmainhome = this._tcmainhome;
      window._tcmainsaveData = this._tcmainsaveData;
      this.uid = this.$route.query.uid;
      this.freeze = this.$route.query.freeze;
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #tctasklist
    width 100%

  .main
    background white
    width 100%
    .mainContent
      width 100%
      .top
        width 100%
        .logo
          float left
          display inline-block
          margin-left 50px
          padding-top 55px
          padding-bottom 20px
          padding-right 20px
          width 160px
          height 160px
        .person
          float left
          width 60%
          margin-top 30px
          h2
            padding-top 20px
            height 75px
            line-height 75px
          h3
            display inline-block
            height 75px
            line-height 75px
            color #f8b447
            font-size $font-size-medium-x
        .task_tip
          width 100%
          .tcbanner
            width 100%
            margin-top 20px
          .tip
            text-align center
            font-size $font-size-large-x
            color #616161
            line-height 160px
            background #fafafa
          .steps
            overflow hidden
            background #fafafa
            height 300px
            .step
              width 33.33%
              float left
              text-align center
              img
                width 100px
                height 100px
              h4
                font-size $font-size-medium-x
                margin-top 30px
              h5
                margin-top 30px
                font-size $font-size-small-s
                color $color-text-graydark
          .task_title
            text-align center
            margin-top 50px
            width 70%
            margin-left 15%
            line-height 100px
            font-size $font-size-medium-x
            border-radius 50px
            color white
            background #f3a536

      .introduce
        width 100%
        margin-top 70px
        padding-bottom 30px
        .gtitle
          font-size 48px
          height 100px
          line-height 100px
          text-indent 10px
          width 100%
          color white
          background #f3a536
        h2
          color #db7655
          line-height 60px
          text-indent: 15px
          font-size $font-size-medium
          margin-top 5px
        p
          padding 0 35px
          font-size $font-size-small
          color #616161
        li
          padding 0 35px
          font-size $font-size-small
          color #616161
          margin-top 6px
          line-height 40px
        li span
          color #db7655

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
