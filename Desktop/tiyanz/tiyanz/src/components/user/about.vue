<template>
  <div id="about" class="navi">
    <MHeader :title="'关于'" :shadow="true"></MHeader>
    <p><i>玩法说明：</i><br>
      --奖励回调后可以<span>'个人中心-》我的账户'</span>中查看<br>
      <i>联盟任务：</i><br>
      --下载app，并符合广告主要求，获得体验奖励;<br>
      <i>市场调查：</i><br>
      -- 分为两种：一种是每日调查，每天都可以到这里领取哦；另一种是正常调查；<br>--请认真对该商品调研，不然可以得不到奖励或者被商家拉入黑名单,
      请如实参与；<span>比如调查需要填写年龄，你第一次填写18岁，第二次填写25岁将导致系统将你的信用度拉低；首次进入较慢，大约需要2分钟左右，但奖励丰厚</span><br>
      <i>闲玩：</i><br>
      --为专业玩家打造的金桶任务<br>
      <i>月结：</i>
      --市场调查金额的结算方式是月结，到时间时会自动转入可提现金额中<br>
      体验赚,是一款以“体验”为核心的的APP。<br>--用户体验商家的app，
      就可以获取一定的现金奖励，奖励由商家提供，通过我方平台转付<br>--古有三国诸葛亮，
      在隆中隐居，而知天下大小事务，运筹帷幄之中，决胜千里之外；
      今有体验赚让你时时知晓市场上主流app走向，
      紧跟时代科技步伐 把握时代脉搏.<br>--我们提供的商家均来自苹果正规渠道 App Store 商店。
      <br>以上，请知悉！！</p>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  export default {
    data () {
      return {
        less: 'about'
      }
    },
    components:{
      MHeader
    },
    methods: {
      goto(){

      }
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #about
    width 100%
    p
      line-height 46px
      margin-left 24px
      margin-right 24px
      margin-top 30px
      span
        color red
      i
        font-weight bold
        color $color-theme

</style>
