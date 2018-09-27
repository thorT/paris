<template>
  <div id="taskdetail" class="navi">
    <MHeader :title="'任务详情'" :shadow="true"></MHeader>
    <div class="main" ref="wrape" :style="{height: contentH + 'px'}">
      <Scroll ref="scroll" class="mscroll">
        <ul>
          <li>
            <img class="logo_s" src="../../assets/image/user3.png" alt="">
            <div class="title_content">
              <p class="title">新浪</p>
              <p class="size">28.6mb</p>
            </div>
            <p class="price">+ 1.75</p>
            <p class="tip">必须为首次安装，并三日内不卸载</p>
          </li>
          <li>
            <h3>步骤1</h3>
            <h2>长按右侧虚线框<br>拷贝关键词搜索下载</h2>
            <p class="keyword">拼多多</p>
          </li>
          <li>
            <h3>步骤2</h3>
            <h2>App Store粘贴<br>关键词搜索</h2>
            <img class="desicon" src="../../assets/image/task1.png" alt="">
          </li>
          <li>
            <h3>步骤3</h3>
            <h2>找到右侧图标的软件下载<br>大概排在</h2>
            <h4>第3位</h4>
            <img class="logo_l" src="../../assets/image/user3.png" alt="">
          </li>
          <li>
          </li>
        </ul>
      </Scroll>
    </div>
    <p v-show="false" class="start X_paddingbottom">开始任务</p>
    <p v-show="true" class="submit X_paddingbottom">继续试玩</p>
    <p v-show="true" class="giveup X_paddingbottom">放弃试玩</p>
  </div>
</template>
<script type="text/ecmascript-6">
  import MHeader from '@/components/public/mheader'
  import Scroll from '@/components/public/scroll'

  export default {
    data() {
      return {
        contentH: 0
      }
    },
    components: {
      MHeader, Scroll
    },
    methods: {
      pulldown() {
        console.log('user 下拉刷新')
      },
    },
    mounted() {
      this.$nextTick(function () {
        this.contentH = document.documentElement.clientHeight - this.$refs.wrape.getBoundingClientRect().top;
      });
    }
  }
</script>
<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  #taskdetail
    width 100%

  .main
    font-weight normal
    position relative
    overflow scroll
    width 100%
    bottom 0px
    top 0px

  li:first-child
    height 233px

  li:last-child
    height 100px
    padding-top 10px

  li
    overflow hidden
    height 281px
    position relative
    .logo_s
      float left
      margin-left 50px
      padding-top 26px
      width 110px
      height 110px
    .title_content
      float left
      display inline-block
      padding-top 26px
      margin-left 20px
      .title
        height 55px
        line-height 45px
        font-size $font-size-medium
        padding-top 10px
      .size
        height 55px
        line-height 35px
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
      color $color-text-graydark
      font-size $font-size-small
    h3
      display inline-block
      width 126px
      height 60px
      border 1px solid $color-lightred
      line-height 60px
      text-align center
      color #ea2d2b
      font-size $font-size-medium-x
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
      border 3px dotted #e92d2c
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
  .start
    position fixed
    bottom 0px
    left 0px
    width 100%
    height 90px
    line-height 90px
    text-align center
    color white
    font-size $font-size-large
    background #ffd707
  .submit
    background #ffd707
    position fixed
    bottom 0px
    left 0px
    width 50%
    height 90px
    line-height 90px
    text-align center
    color white
    font-size $font-size-large
  .giveup
    position fixed
    bottom 0px
    left 50%
    width 50%
    height 90px
    line-height 90px
    text-align center
    color white
    font-size $font-size-large
    background #e92d2e
</style>
