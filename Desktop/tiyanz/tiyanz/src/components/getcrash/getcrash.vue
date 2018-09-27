<template>
  <div id="taskdetail" class="navi">
    <MHeader :title="'提现'" :shadow="true"></MHeader>
    <ul>
      <li>
        <h2 class="first_title">提现到</h2>
        <h3 class="first_detail">支付宝</h3>
        <img class="first_img" src="../../assets/image/wechat.png" alt="">
      </li>
      <li>
        <h2>姓名</h2>
        <input class="name" type="text">
        <h5></h5>
      </li>
      <li>
        <h2>提现金额</h2>
        <input class="money" type="text" placeholder="请输入金额">
        <h5></h5>
      </li>
      <li>
        <h2>可提现金额</h2>
        <h3 class="money">500元</h3>
        <h5></h5>
      </li>
      <li>
        <h2>预计到账时间</h2>
        <h3>周末顺延，预计下周一到账</h3>
      </li>
        <h4>*支付宝眉笔提现支付宝眉笔提现<br>
          *支付宝眉笔提现支付宝眉笔提现<br>
          *支付宝眉笔提现支付宝眉笔提现<br>
          *支付宝眉笔提现支付宝眉笔提现<br></h4>
        <MButton :title="'提交'" class="mtop" @buttonAction="sumbit"></MButton>
        <MButton :title="'查看提现记录'" class="record" :bgColor="'white'" :titleColor="'#333333'" @buttonAction="goto('/getcrashrecord')"></MButton>
    </ul>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import MButton from '@/components/public/mbutton'
  export default {
    data() {
      return {}
    },
    components: {
      MHeader, MButton
    },
    methods: {
      goto(path) {
        this.$router.push(path)
      },
      sumbit(){

      }
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #taskdetail
    width 100%
    ul
    overflow hidden
      li
        height 100px
        background white
      li:first-child
        height 140px
        margin-top 20px
        margin-bottom 30px
      li:last-child
        filter Alpha(opacity=0)
        height 500px
        background gray
      .first_title
        display inline-block
        height 80px
        line-height 80px
        padding-top 30px
        margin-left 30px
        font-size $font-size-medium-x
      .first_detail
        float right
        display inline-block
        height 80px
        line-height 80px
        padding-top 30px
        margin-right 30px
        font-size $font-size-medium-x
      .first_img
        float right
        display inline-block
        height 80px
        line-height 80px
        padding-top 30px
        margin-right 30px
      h2
        display inline-block
        height 80px
        line-height 80px
        padding-top 10px
        margin-left 30px
        font-size $font-size-medium-x
      h3
        float right
        display inline-block
        height 80px
        line-height 80px
        padding-top 10px
        margin-right 30px
        font-size $font-size-medium-x
        color $color-text-gray
      h5
        height 1px
        background red
        margin-left 30px
        margin-top 10px
      h4
        display inline-block
        margin-top 40px
        margin-left 30px
        width 690px
        height 190px
        background white
        color $color-text-gray
        font-size $font-size-small
        line-height 40px
      .record
        margin-top 22px




</style>
