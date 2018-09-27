<template>
    <div id="service">
        <i class="icon iconfont">&#xe650;</i>
        <span>客服</span>
    </div>
</template>


<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    #service
      height 60px
      width 60px
      position fixed
      bottom 45px
      right 15px
      background $color-background-content
      border-radius 30px
      text-align center
      box-shadow: 0 2px 7px 0 rgba(0,0,0,0.15);
      font-family: PingFangSC-Semibold,'Helvetica-Light', arial, sans-serif;
      i
       font-size 35px
       display inline-block
       width 100%
       height 30px
       line-height 45px
       float left
      span
       display inline-block
       height 30px
       width 100%
       line-height 30px
       font-size $font-size-medium


</style>